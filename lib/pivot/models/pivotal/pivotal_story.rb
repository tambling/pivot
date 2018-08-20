module Pivot
  class PivotalStory < PivotalBase
    attr_reader :id, :name, :status, :description, :labels

    class << self
      def get_by_project_id project_id
        client.get_stories(project_id).map do |api_story|
          from_api_story(api_story)
        end
      end

      def from_api_story api_story
        id = api_story['id']
        name = api_story['name']
        status = api_story['current_state']
        description = api_story['description']
        labels = process_labels(api_story['labels'])

        return new(id: id, name: name, status: status, description: description, labels: labels)
      end

      private
      def process_labels raw_labels
        return raw_labels.map do |raw_label|
          raw_label['name']
        end
      end
    end

    def initialize(id:, name:, status: nil, description: nil, labels: [])
      @id = id
      @name = name
      @status = status
      @description = description
      @labels = labels
    end

    def to_github_issue
      GitHub::Issue.new(title: @name, body: @description, labels: @labels)
    end
  end
end
