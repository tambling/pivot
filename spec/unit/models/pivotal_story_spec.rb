require 'spec_helper'

RSpec.describe Pivot::PivotalStory do
  describe '.get_by_project_id' do
    it 'returns an array of PivotalStories' do
      project_id = 1 
      raw_stories = [{"id" => 1, "name" => "Story #1"}, {"id" => 2, "name" => "Story #2"}]
      Pivot::PivotalBase.client = Pivot::PivotalClient.new('token')

      allow_any_instance_of(Pivot::PivotalClient).
        to receive(:get_stories).
        with(project_id).
        and_return(raw_stories)

      expect(Pivot::PivotalStory.get_by_project_id(project_id))
        .to all(be_a Pivot::PivotalStory)
    end
  end

  describe '.from_api_story' do
    it 'returns a PivotalStory with the right properties' do
      id = 1
      name = "Story"
      status = "started"
      description = "A story"

      raw_story = { 
        "id" => id, 
        "name" => name,
        "current_state" => status,
        "description" => description
      }

      story = Pivot::PivotalStory.new(id: id, name: name, status: status, description: description)

      expect(Pivot::PivotalStory.from_api_story(raw_story)).to match_story(story)
    end
  end
end
