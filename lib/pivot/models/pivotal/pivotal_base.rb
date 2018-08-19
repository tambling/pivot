module Pivot
  class PivotalBase
    class << self
      def client
        @@client
      end

      def create_client token
        @@client = PivotalClient.new(token)
      end
    end
  end
end


