require 'octokit'

module Pivot
  module GitHub
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
