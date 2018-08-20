require 'rest-client'
require 'json'

module Pivot
  module Pivotal
    # Provides a nice interface for interacting with Pivotal Tracker's API.
    # Basically just a wrapper for RestClient, that feeds it certain paths.
    class Client
      BASE_ROUTE = 'https://www.pivotaltracker.com/services/v5'.freeze

      def initialize(token)
        @token = token
      end

      def get_projects
        get 'projects'
      end

      def get_project(project_id)
        get "projects/#{project_id}"
      end

      def get_stories(project_id)
        get "projects/#{project_id}/stories"
      end

      def get_owners(project_id, story_id)
        get "projects/#{project_id}/stories/#{story_id}/owners"
      end

      private

      def get(path)
        url = "#{BASE_ROUTE}/#{path}"
        JSON.parse(RestClient.get(url, headers))
      end

      def headers
        {
          "X-TrackerToken": @token
        }
      end
    end
  end
end
