require 'spec_helper'

RSpec.describe Pivot::PivotalUser do
  describe '.get_cached' do
    it 'returns the user if they are in the cache' do
      id = 1
      username = 'user'

      user = Pivot::PivotalUser.new(id: id, username: username)

      expect(Pivot::PivotalUser.get_cached(id)).to match_user(user)
    end

    it 'returns nil if there is no match' do
      id = 2

      expect(Pivot::PivotalUser.get_cached(id)).to be(nil)
    end
  end

  describe '.get_by_project_and_story_id' do
    let(:project_id) { 1 }
    let(:story_id) { 2 }
    let(:raw_users) {
      [ 
        { 'id' => 10, 'username' => 'user1' }, 
        { 'id' => 11, 'username' => 'user2' } 
      ] 
    }

    before(:each) do
      Pivot::PivotalBase.create_client('token')

      allow_any_instance_of(Pivot::PivotalClient).
        to receive(:get_owners).with(project_id, story_id).and_return(raw_users)
    end

    it 'returns an array of PivotalUsers' do
      expect(Pivot::PivotalUser.get_by_project_and_story_id(project_id, story_id)).
        to all(be_a(Pivot::PivotalUser))
    end

    it 'calls .from_api_user for each raw owner' do
      expect(Pivot::PivotalUser).to receive(:from_api_user).exactly(raw_users.length).times

      Pivot::PivotalUser.get_by_project_and_story_id(project_id, story_id)
    end
  end

  describe '.from_api_user' do
    it 'returns a PivotalUser with the right properties' do
      id = 1
      username = 'user'
      raw_user = { 'id' => id, 'username' => username }

      user = Pivot::PivotalUser.new(id: id, username: username)

      expect(Pivot::PivotalUser.from_api_user(raw_user)).to match_user(user)
    end
  end

  describe '#get_github_username' do
    let(:user) { Pivot::PivotalUser.new(id: 1, username: 'user') } 
    it "gets the user's GitHub username out of the mappings" do
      github_username = 'github_username'
      Pivot::PivotalUser.pivotal_github_mappings = { user.username => github_username }

      expect(user.github_username).to eq(github_username)
    end

    it 'returns nil if there is no match' do
      Pivot::PivotalUser.pivotal_github_mappings = {}

      expect(user.github_username).to be(nil)
    end
  end
end
