require 'octokit'

module Pivot
  module GitHub
    # GitHub::Issue and GitHub::Repo both inherit from GitHub::Base, which
    # handles the client for them. @@client is available in all classes, and can
    # be set from here.
    class Base
      class << self
        def client
          @@client
        end

        def create_client(login:, password:)
          @@client = Octokit::Client.new(
            login: login,
            password: password,
            per_page: 100
          )
        end
      end
    end
  end
end
