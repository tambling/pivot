module Pivot
  class PivotalProject < PivotalBase
    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    def self.get_all
      client.get_projects.map do |api_project|
        self.from_api_project(api_project)
      end
    end

    def self.get_by_id id
      api_project = client.get_project(id)

      self.from_api_project(api_project)
    end

    def self.get_by_name name
      get_all.find {|project| project.name == name}
    end
    
    def self.from_api_project api_project
      id = api_project['id']
      name = api_project['name']

      return self.new(id: id, name: name)
    end
  end
end
