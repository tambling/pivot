require 'spec_helper'

RSpec.describe Pivot::PivotalStory do
  describe '.get_by_project_id' do
    let(:project_id) { 1 }
    let(:raw_stories)  { [{"id" => 1, "name" => "Story #1"}, {"id" => 2, "name" => "Story #2"}] }

    before(:each) do
      client =  Pivot::PivotalClient.new('token') 
      Pivot::PivotalBase.client = client

      allow(client).
        to receive(:get_stories).
        with(project_id).
        and_return(raw_stories)
    end

    it 'returns an array of PivotalStories' do
      expect(Pivot::PivotalStory.get_by_project_id(project_id))
        .to all(be_a Pivot::PivotalStory)
    end

    it 'calls .from_api_story for each API object' do
      expect(Pivot::PivotalStory).to receive(:from_api_story).exactly(raw_stories.length).times

      Pivot::PivotalStory.get_by_project_id(project_id)
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

  describe '#to_github_issue' do
    it 'returns a GitHub::Issue with the right properties' do
      title = 'Title'
      body = 'Body'
      story = Pivot::PivotalStory.new(id: 1, name: title, description: body)
      issue = Pivot::GitHub::Issue.new(title: title, body: body)

      expect(story.to_github_issue).to match_issue(issue)

    end
  end
end
