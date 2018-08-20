module Pivot
  module Pivotal
    # Similar to GitHub::Base, this keeps track of @@client and makes it
    # available to its subclasses (Project, State, Story, and User). Client can
    # be created with a token, and will always be a Pivotal::Client.
    class Base
      class << self
        def client
          @@client
        end

        def create_client(token)
          @@client = Client.new(token)
        end
      end
    end
  end
end
