module Pivot
  module GitHub
    # A very thin wrapper for GitHub repos, mostly used to extract the name of a
    # repo (so that a user can select one if one wasn't passed in as an option).
    class Repo < Base
      class << self
        def from_octokit_repo(repo)
          new(repo[:full_name])
        end

        def get_all
          client.repositories.map do |repo|
            from_octokit_repo(repo)
          end
        end
      end

      attr_reader :name

      def initialize(name)
        @name = name
      end

    end
  end
end
