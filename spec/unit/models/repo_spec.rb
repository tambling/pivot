require 'spec_helper'

RSpec.describe Pivot::GitHub::Repo do
  describe '.from_octokit_repo' do
    it 'creates a GitHub repo with the right properties' do
      name = 'user/repo'
      raw_repo = { full_name: name }
      repo = Pivot::GitHub::Repo.new(name)

      expect(Pivot::GitHub::Repo.from_octokit_repo(raw_repo)).to match_repo(repo)
    end
  end

  describe '.get_all' do
    let(:raw_repos) { [ {full_name: 'Repo #1'}, {full_name: 'Repo #2'} ] }

    before(:each) do
      Pivot::GitHub::Base.create_client(login: 'user', password: 'password')
    end

    it 'gets repositories from Octokit' do
      expect_any_instance_of(Octokit::Client).to receive(:repositories).and_return(raw_repos)

      Pivot::GitHub::Repo.get_all
    end

    it 'calls .from_octokit_repo for every raw repository' do
      allow_any_instance_of(Octokit::Client).to receive(:repositories).and_return(raw_repos)

      expect(Pivot::GitHub::Repo).to receive(:from_octokit_repo).exactly(raw_repos.length).times

      Pivot::GitHub::Repo.get_all
    end
  end
end
