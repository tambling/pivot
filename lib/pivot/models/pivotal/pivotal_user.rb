module Pivot
  class PivotalUser < PivotalBase
    class << self
      def cache
        @cache ||= {}
      end

      def pivotal_github_mappings
        @mappings ||= {}
      end

      def pivotal_github_mappings= mappings
        @mappings = mappings
      end

      def get_cached id
        if username = self.cache[id]
          self.new(id: id, username: username)
        else
          nil
        end
      end

      def get_by_project_and_story_id project_id, story_id
        self.client.get_owners(project_id, story_id).map do |api_user|
          self.from_api_user(api_user)
        end
      end

      def from_api_user api_user
        id = api_user['id']
        username = api_user['username']

        self.new(id: id, username: username)
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
