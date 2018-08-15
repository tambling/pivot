module Pivot
  class PivotalStory < PivotalBase
    attr_reader :id, :name, :description

    def initialize (id:, name:, description: nil)
      @id = id
      @name = name
      @description = description
    end

    def self.get_by_project_id project_id
      client.get_stories(project_id).map do |attributes|
        from_attributes(attributes)
      end
    end

    def self.from_attributes attributes
      id = attributes['id']
      name = attributes['name']
      description = attributes['description']

      return self.new(id: id, name: name, description: description)
    end
  end
end
