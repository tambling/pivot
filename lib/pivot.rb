require 'pivot/version'
require 'pivot/clients/pivotal/client'
require 'pivot/models/pivotal/base'
require 'pivot/models/pivotal/project'
require 'pivot/models/pivotal/state'
require 'pivot/models/pivotal/story'
require 'pivot/models/pivotal/user'
require 'pivot/models/github/base'
require 'pivot/models/github/issue'
require 'pivot/models/github/repo'

require 'tty-config'

module Pivot
  # The main controller for the rest of the application. Handles
  # merging/propagating config, coordinating the initialization of issues, and
  # ultimately (in #create_issues!) sending them up to GitHub. Can also be
  # considered a set of utility methods for the CLI.
  class Application
    attr_accessor :pivotal_project_identifier, :github_repo_identifier
    attr_reader :issues

    def initialize(options)
      create_and_merge_config(options)

      if (closure_threshold = @config.fetch(:closure_threshold))
        Pivotal::State.closure_threshold = closure_threshold
      end

      Pivotal::User.pivotal_github_mappings = @config.fetch(:pivotal_github_mappings)

      Pivotal::Base.create_client @config.fetch(:pivotal_token)

      GitHub::Base.create_client(
        login: @config.fetch(:github_login),
        password: @config.fetch(:github_token)
      )
    end

    def prepare_issues
      GitHub::Issue.repo = @github_repo_identifier
      project = Pivotal::Project.get(@pivotal_project_identifier)

      stories = project.stories

      @issues = stories.map(&:to_github_issue)
    end

    def create_issues!
      @issues.each(&:save!)
    end

    def all_project_names
      Pivotal::Project.get_all.map(&:name)
    end

    def all_repo_names
      GitHub::Repo.get_all.map(&:name)
    end

    private

    def create_and_merge_config(options)
      @config = TTY::Config.new
      @config.filename = '.pivot'
      @config.extname = '.json'
      @config.append_path Dir.pwd
      @config.append_path Dir.home
      @config.read if @config.persisted?

      @config.merge(options)
    end
  end
end
