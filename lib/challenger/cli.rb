require 'thor'

module Challenger
  class CLI < Thor
    desc 'rubocop_challenge', 'Run `$ rubocop -a` and create PR to GitHub'
    option :file_path, type: :string, default: '.rubocop_todo.yml'
    option :mode, type: :string, default: 'most_occurrence'
    option :commiter_email, type: :string, default: 'rubocop_challenge@example.com'
    option :commiter_name, type: :string, default: 'Rubocop Challenge'
    option :base_branch, type: :string, default: 'master'
    option :pull_request_labels, type: :array, default: ['rubocop challenge']
    def rubocop_challenge
      target_rule = Rubocop::Challenge.exec(options[:file_path], options[:mode])
      PRDaikou.exec(pr_daikou_options(target_rule), nil)
    end

    private

    def pr_daikou_options(target_rule)
      {
        email:  options[:commiter_email],
        name:   options[:commiter_name],
        title:  target_rule.title,
        labels: options[:pull_request_labels].join(','),
        topic:  "rubocop-challenge/#{target_rule.title.tr('/', '-')}",
        commit: ":robot: #{target_rule.title}"
      }.each_with_object({}) do |(k, v), memo|
        memo[k] = Shellwords.escape(v)
      end
    end
  end
end
