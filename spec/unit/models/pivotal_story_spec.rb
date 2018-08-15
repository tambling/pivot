require 'spec_helper'

RSpec.describe Pivot::PivotalStory do
  let(:raw_story_with_description) {
    {
      "id" => 1,
      "name" => "Story #1",
      "description" => "This one has a description"
    }
  }

  let(:raw_story_without_description) {
    {"id" => 2, "name" => "Story #2"}
  }

  let(:raw_stories) {[raw_story_with_description, raw_story_without_description]}

  describe '.get_by_project_id' do
    it 'returns an array of PivotalStories' do
      project_id = 1

      Pivot::PivotalBase.client = Pivot::PivotalClient.new('token')

      allow_any_instance_of(Pivot::PivotalClient).
        to receive(:get_stories).
        with(project_id).
        and_return(raw_stories)

      expect(Pivot::PivotalStory.get_by_project_id(project_id))
        .to all(be_a Pivot::PivotalStory)
    end
  end
end
