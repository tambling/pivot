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
    map %w(--version -v) => :version

    desc 'copy PIVOTAL_PROJECT GITHUB_REPO', 'Copy all stories from Pivotal project to GitHub repo'
    method_option :pivotal_project, type: :string
    method_option :github_repo, type: :string
    method_option :pivotal_token, type: :string
    method_option :github_login, type: :string
    method_option :github_token, type: :string
    method_option :open_all, type: :boolean
    method_option :close_all, type: :boolean
    method_option :close_threshold, type: :string
    method_option :skip_assignees, type: :boolean
    method_option :add_label, type: :array
    method_option :skip_labels, type: :boolean

    def copy
      require_relative 'commands/copy'
      Pivot::Commands::Copy.new(options).execute
    end

    default_task :copy
  end
end
