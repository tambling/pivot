require 'spec_helper'

RSpec.describe Pivot::PivotalStory do
  describe '.get_by_project_id' do
    let(:project_id) { 1 }
    let(:raw_stories)  { 
      [
        {"id" => 1, "name" => "Story #1", "labels" => []}, 
        {"id" => 2, "name" => "Story #2", "labels" => []}
      ] 
    }

    before(:each) do
      Pivot::PivotalBase.create_client('token')

      allow_any_instance_of(Pivot::PivotalClient).
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
      label = 'label'

      raw_story = { 
        "id" => id, 
        "name" => name,
        "current_state" => status,
        "description" => description,
        "labels" => [{'name' => label}]
      }

      story = Pivot::PivotalStory.new(
        id: id, 
        name: name, 
        status: status, 
        description: description,
        labels: [label]
      )

      expect(Pivot::PivotalStory.from_api_story(raw_story)).to match_story(story)
    end
  end

  describe '#to_github_issue' do
    it 'returns a GitHub::Issue with the right properties' do
      title = 'Title'
      body = 'Body'
      labels = ['label']
      story = Pivot::PivotalStory.new(id: 1, name: title, description: body, labels: labels)
      issue = Pivot::GitHub::Issue.new(title: title, body: body, labels: labels)

      expect(story.to_github_issue).to match_issue(issue)
    end
  end
end
