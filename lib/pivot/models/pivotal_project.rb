module Pivot
  class PivotalProject < PivotalBase
    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    def == comparison
      return comparison.id == @id && comparison.name == @name
    end

    def self.get_all
      client.get_projects.map do |attributes|
        from_attributes(attributes)
      end
    end

    def self.get_by_id id
      attributes = client.get_project(id)

      from_attributes(attributes)
    end

    def self.get_by_name name
      get_all.find {|project| project.name == name}
    end
    
    def self.from_attributes attributes
      id = attributes['id']
      name = attributes['name']

      return self.new(id: id, name: name)
    end

    private_class_method :from_attributes
  end
end
