# frozen_string_literal: true

module RubocopChallenger
  module Github
    class PrTemplate
      def initialize(rule, template_path = nil)
        template_path ||= './lib/templates/default.md.erb'
        @template = File.read(template_path)
        @rule = rule
      end

      def generate_pullrequest_markdown
        <<~TEMPLATE
          #{ERB.new(template, nil, '-').result(binding)}
          Auto generated by [rubocop_challenger](https://github.com/ryz310/rubocop_challenger)
        TEMPLATE
      end

      private

      attr_reader :template, :rule

      def title
        rule.title
      end

      def rubydoc_url
        rule.rubydoc_url
      end

      def description
        rule.description
      end
    end
  end
end
