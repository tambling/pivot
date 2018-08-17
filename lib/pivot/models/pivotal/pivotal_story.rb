module Pivot
  class PivotalStory < PivotalBase
    attr_reader :id, :name, :status, :description

    def initialize (id:, name:, status: nil, description: nil)
      @id = id
      @name = name
      @status = status
      @description = description
    end

    def self.get_by_project_id project_id
      client.get_stories(project_id).map do |api_story|
        from_api_story(api_story)
      end
    end

    def self.from_api_story api_story
      id = api_story['id']
      name = api_story['name']
      status = api_story['current_state']
      description = api_story['description']

      return self.new(id: id, name: name, status: status, description: description)
    end

    def to_github_issue
      GitHub::Issue.new(title: @name, body: @description)
    end
  end
end
