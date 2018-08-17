require 'octokit'

module Pivot
  module GitHub
    class Base
      class << self
        def client 
          @@client
        end

        def client= new_client
          @@client = new_client
        end

        def check_client
          raise InvalidGitHubClientError unless @@client.is_a? Octokit::Client
        end
      end
    end
  end
end

class InvalidGitHubClientError < StandardError; end
