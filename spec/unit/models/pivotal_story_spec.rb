require 'spec_helper'

RSpec.describe Pivot::Pivotal::Story do
  describe '.get_by_project_id' do
    let(:project_id) { 1 }
    let(:raw_stories)  do
      [
        { 'id' => 1, 'name' => 'Story #1', 'labels' => [], 'owner_ids' => [] },
        { 'id' => 2, 'name' => 'Story #2', 'labels' => [], 'owner_ids' => [] }
      ]
    end

    before(:each) do
      Pivot::Pivotal::Base.create_client('token')

      allow_any_instance_of(Pivot::Pivotal::Client)
        .to receive(:get_stories)
        .with(project_id)
        .and_return(raw_stories)
    end

    it 'returns an array of Pivotal::Stories' do
      expect(Pivot::Pivotal::Story.get_by_project_id(project_id))
        .to all(be_a Pivot::Pivotal::Story)
    end

    it 'calls .from_api_story for each API object' do
      expect(Pivot::Pivotal::Story).to receive(:from_api_story).exactly(raw_stories.length).times

      Pivot::Pivotal::Story.get_by_project_id(project_id)
    end
  end

  describe '.from_api_story' do
    let(:id) { 1 }
    let(:name) { 'Story' }
    let(:state) { 'started' }
    let(:description) { 'A story' }
    let(:label) { 'label' }
    let(:owner) { Pivot::Pivotal::User.new(id: 1, username: 'user') }

    let(:raw_story) do
      {
        'id' => id,
        'name' => name,
        'current_state' => state,
        'description' => description,
        'labels' => [{ 'name' => label }],
        'owner_ids' =>  [owner.id]
      }
    end

    it 'returns a Pivotal::Story with the right properties' do
      story = Pivot::Pivotal::Story.new(
        id: id,
        name: name,
        state: state,
        description: description,
        labels: [label],
        owners: [owner]
      )

      expect(Pivot::Pivotal::Story.from_api_story(raw_story)).to match_story(story)
    end

    it "gets the story's owners if they aren't in the cache" do
      allow(Pivot::Pivotal::User).to receive(:get_cached)

      expect(Pivot::Pivotal::User).to receive(:get_by_project_and_story_id)

      Pivot::Pivotal::Story.from_api_story(raw_story)
    end
  end

  describe '#to_github_issue' do
    it 'returns a GitHub::Issue with the right properties' do
      title = 'Title'
      body = 'Body'
      labels = ['label']
      story = Pivot::Pivotal::Story.new(id: 1, name: title, description: body, labels: labels, state: 'finished')
      issue = Pivot::GitHub::Issue.new(title: title, body: body, labels: labels, closed: true)

      expect(story.to_github_issue).to match_issue(issue)
    end
  end
end
