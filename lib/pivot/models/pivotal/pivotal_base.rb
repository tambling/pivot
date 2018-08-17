module Pivot
  class PivotalBase
    class << self
      def client
        @@client
      end

      def client= new_client
        @@client = new_client
      end
    end
  end
end


