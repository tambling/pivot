# frozen_string_literal: true

require 'thor'

module Pivot
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'pivot version'
    def version
      require_relative 'version'
      puts "v#{Pivot::VERSION}"
    end
    map %w[--version -v] => :version

    desc 'copy', 'Copy all stories from Pivotal project to GitHub repo'
    method_option :pivotal_project, type: :string, 
      desc: 'The name or ID of the Pivotal project to copy from'
    method_option :github_repo, type: :string,
      desc: 'The name or ID of the GitHub repository to copy from'
    method_option :pivotal_token, type: :string,
      desc: 'Your Pivotal Tracker API key, found in your user profile'
    method_option :github_login, type: :string,
      desc: 'Your GitHub username'
    method_option :github_token, type: :string,
      desc: 'Your GitHub API token, found in developer settings'
    method_option :closure_threshold, type: :string, 
      enum: %w[unscheduled unstarted planned rejected started finished delivered accepted],
      desc: 'The story state above which the corresponding issue should be closed'
    method_option :pivotal_github_mappings, type: :hash,
      desc: 'A hash mapping Pivotal usernames to GitHub usernames'

    def copy
      require_relative 'commands/copy'
      Pivot::Commands::Copy.new(options).execute
    end

    default_task :copy
  end
end
