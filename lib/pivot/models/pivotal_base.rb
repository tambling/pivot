module Pivot
  class PivotalBase
    def self.client= new_client
      @@client = new_client
    end

    def self.client
      @@client
    end
  end
end


