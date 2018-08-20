module Pivot
  class PivotalStory < PivotalBase
    class << self
      def get_by_project_id project_id
        client.get_stories(project_id).map do |api_story|
          from_api_story(api_story)
        end
      end

      def from_api_story api_story
        id = api_story['id']
        name = api_story['name']
        state = api_story['current_state']
        description = api_story['description']
        labels = process_labels(api_story['labels'])
        owners = process_owners(api_story)

        return new(
          id: id, 
          name: name, 
          state: state, 
          description: description, 
          labels: labels, 
          owners: owners
        )
      end

      private
      def process_labels raw_labels
        return raw_labels.map do |raw_label|
          raw_label['name']
        end
      end

      def process_owners api_story
        owner_ids = api_story['owner_ids']

        cached_owners = owner_ids.map do |owner_id|
          PivotalUser.get_cached(owner_id)
        end

        if cached_owners.none?(&:nil?)
          return cached_owners
        else
          project_id = api_story['project_id']
          story_id = api_story['id']
          return PivotalUser.get_by_project_and_story_id(project_id, story_id)
        end
      end
    end

    attr_reader :id, :name, :state, :description, :labels, :owners

    def initialize(id:, name:, state:, description: nil, labels: [], owners: [])
      @id = id
      @name = name
      @state = Pivot::PivotalState.new(state)
      @description = description
      @labels = labels
      @owners = owners
    end

    def to_github_issue
      assignees = @owners.map(&:github_username).compact
      
      GitHub::Issue.new(
        title: @name, 
        body: @description, 
        labels: @labels, 
        closed: @state.closed?,
        assignees: assignees
      )
    end
  end
end
