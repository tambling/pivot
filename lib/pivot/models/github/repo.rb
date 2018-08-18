module Pivot
  module GitHub
    class Repo < Base
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def self.from_octokit_repo repo
        self.new(repo[:full_name])
      end

      def self.get_all
        @@client.repositories.map do |repo|
          self.from_octokit_repo(repo)
        end
      end
    end
  end
end
