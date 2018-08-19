require "pivot/version"
require "pivot/clients/pivotal_client"
require "pivot/models/pivotal/pivotal_base"
require "pivot/models/pivotal/pivotal_project"
require "pivot/models/pivotal/pivotal_story"
require "pivot/models/github/base"
require "pivot/models/github/issue"
require "pivot/models/github/repo"

require 'tty-config'

module Pivot
  class Application
    attr_accessor :pivotal_project_identifier, :github_repo_identifier
    attr_reader :issues

    def initialize options 
      create_and_merge_config(options)

      PivotalBase.create_client @config.fetch(:pivotal_token)

      GitHub::Base.create_client(
        login: @config.fetch(:github_login), 
        password: @config.fetch(:github_token)
      )
    end

    def prepare_issues
      GitHub::Issue.repo = @github_repo_identifier
      project = PivotalProject.get(@pivotal_project_identifier)

      stories = project.stories

      @issues = stories.map(&:to_github_issue)
    end

    def create_issues!
      @issues.each(&:save!)
    end

    def all_project_names
      PivotalProject.get_all.map(&:name)
    end

    def all_repo_names
      GitHub::Repo.get_all.map(&:name)
    end

    private
    def create_and_merge_config options
      @config = TTY::Config.new
      @config.filename = '.pivot'
      @config.extname = '.json'
      @config.append_path Dir.pwd
      @config.append_path Dir.home 
      @config.read

      @config.merge(options)
    end
  end
end
