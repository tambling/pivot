# frozen_string_literal: true

require_relative '../command'
require_relative '../../pivot'


module Pivot
  module Commands
    class Copy < Pivot::Command
      def initialize(options)
        @options = options.transform_keys(&:to_sym)
        @app = Pivot::Application.new(@options)

        populate_or_select_project
        populate_or_select_repo
      end

      def execute(input: $stdin, output: $stdout)
        spin 'Transferring issues...', 'Done transferring issues!' do
          @app.transfer_stories!
        end
      end

      private
      def populate_or_select_project
        if pivotal_project = @options.delete(:pivotal_project)
          @app.pivotal_project_identifer = pivotal_project
        else
          all_projects = []
          spin 'Loading all Pivotal projects...', 'All projects loaded!' do
            all_projects = @app.all_project_names
          end

          @app.pivotal_project_identifier = prompt.select("Please select the Pivotal project you'd like to copy from:", all_projects)
        end
      end
      def populate_or_select_repo
        if github_repo = @options.delete(:github_repo)
          @app.github_repo_identifer = github_repo
        else
          all_repos = []
          spin 'Loading all GitHub repositories...', 'All repositories loaded!' do
            all_repos = @app.all_repo_names
          end

          @app.github_repo_identifier = prompt.select("Please select the GitHub repo you'd like to copy to:", all_repos)
        end
      end
    end
  end
end
