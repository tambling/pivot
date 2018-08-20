require 'spec_helper'

RSpec.describe Pivot::Pivotal::User do
  describe '.get_cached' do
    it 'returns the user if they are in the cache' do
      id = 1
      username = 'user'

      user = Pivot::Pivotal::User.new(id: id, username: username)

      expect(Pivot::Pivotal::User.get_cached(id)).to match_user(user)
    end

    it 'returns nil if there is no match' do
      id = 2

      expect(Pivot::Pivotal::User.get_cached(id)).to be(nil)
    end
  end

  describe '.get_by_project_and_story_id' do
    let(:project_id) { 1 }
    let(:story_id) { 2 }
    let(:raw_users) do
      [
        { 'id' => 10, 'username' => 'user1' },
        { 'id' => 11, 'username' => 'user2' }
      ]
    end

    before(:each) do
      Pivot::Pivotal::Base.create_client('token')

      allow_any_instance_of(Pivot::Pivotal::Client)
        .to receive(:get_owners).with(project_id, story_id)
                                .and_return(raw_users)
    end

    it 'returns an array of Pivotal::Users' do
      expect(Pivot::Pivotal::User.get_by_project_and_story_id(project_id, story_id))
        .to all(be_a(Pivot::Pivotal::User))
    end

    it 'calls .from_api_user for each raw owner' do
      expect(Pivot::Pivotal::User)
        .to receive(:from_api_user).exactly(raw_users.length).times

      Pivot::Pivotal::User.get_by_project_and_story_id(project_id, story_id)
    end
  end

  describe '.from_api_user' do
    it 'returns a Pivotal::User with the right properties' do
      id = 1
      username = 'user'
      raw_user = { 'id' => id, 'username' => username }

      user = Pivot::Pivotal::User.new(id: id, username: username)

      expect(Pivot::Pivotal::User.from_api_user(raw_user)).to match_user(user)
    end
  end

  describe '#get_github_username' do
    let(:user) { Pivot::Pivotal::User.new(id: 1, username: 'user') }
    it "gets the user's GitHub username out of the mappings" do
      github_username = 'github_username'

      Pivot::Pivotal::User.pivotal_github_mappings = {
        user.username => github_username
      }

      expect(user.github_username).to eq(github_username)
    end

    it 'returns nil if there is no match' do
      Pivot::Pivotal::User.pivotal_github_mappings = {}

      expect(user.github_username).to be(nil)
    end
  end
end
