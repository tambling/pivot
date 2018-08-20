module Pivot
  module Pivotal
    # Handles the searching and caching of Pivotal Tracker users. Because we
    # don't want to hit Pivotal Tracker's API unnecessarily, we cache usernames
    # by ID on initialization. Also handles the mapping between Pivotal and
    # GitHub usernames, exposing #github_username, which just returns any
    # mapping corresponding to that User's @username.
    class User < Base
      class << self
        attr_writer :pivotal_github_mappings

        def cache
          @cache ||= {}
        end

        def pivotal_github_mappings
          @pivotal_github_mappings ||= {}
        end

        def get_cached(id)
          return nil unless (username = cache[id])

          new(id: id, username: username)
        end

        def get_by_project_and_story_id(project_id, story_id)
          client.get_owners(project_id, story_id).map do |api_user|
            from_api_user(api_user)
          end
        end

        def from_api_user(api_user)
          id = api_user['id']
          username = api_user['username']

          new(id: id, username: username)
        end
      end

      attr_reader :id, :username

      def initialize(id:, username:)
        @id = id
        @username = username

        self.class.cache[@id] = @username unless self.class.cache[@id]
      end

      def github_username
        self.class.pivotal_github_mappings[@username]
      end
    end
  end
end
