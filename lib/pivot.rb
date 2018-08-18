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

    def initialize options 
      create_and_merge_config(options)

      set_up_pivotal_client
      set_up_github_client
    end

    def transfer_stories!
      get_pivotal_project
      GitHub::Issue.repo = @github_repo_identifier

      stories = @project.stories

      stories.map(&:to_github_issue).map(&:save!)
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

    def set_up_pivotal_client
      pivotal_client = PivotalClient.new(@config.fetch(:pivotal_token))
      PivotalBase.client = pivotal_client
    end

    def set_up_github_client
      github_client = Octokit::Client.new(
        login: @config.fetch(:github_login), 
        password: @config.fetch(:github_token),
        per_page: 100
      )

      GitHub::Base.client = github_client
    end

    def get_pivotal_project
      if @pivotal_project_identifier !~ /\D/
        @project = PivotalProject.get_by_id(@pivotal_project_identifier)
      else
        @project = PivotalProject.get_by_name(@pivotal_project_identifier)
      end
    end

  end
end
