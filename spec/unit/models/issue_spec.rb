require 'spec_helper'

RSpec.describe Pivot::GitHub::Issue do
  let(:repo) { 'user/repository' }

  describe '.repo=' do
    it 'sets the repo on the Issue class' do
      Pivot::GitHub::Issue.repo = repo
      expect(Pivot::GitHub::Issue.repo).to eq(repo)
    end
  end

  describe '#save!' do
    let(:title) { 'Issue' }
    let(:body) { 'Body' }
    let(:labels) { %w[A Label] }
    let(:assignees) { ['user'] }

    let(:issue) do
      Pivot::GitHub::Issue.new(
        title: title,
        body: body,
        labels: labels,
        assignees: assignees
      )
    end

    before(:each) do
      Pivot::GitHub::Base.create_client(login: 'user', password: 'password')
      Pivot::GitHub::Issue.repo = repo
    end

    it 'sends the right parameters to Octokit' do
      expect_any_instance_of(Octokit::Client)
        .to receive(:create_issue)
        .with(
          repo,
          title,
          body,
          labels: labels, assignees: assignees
        )
        .and_return(number: 1)

      issue.save!
    end

    it "stores the created issue's number" do
      allow_any_instance_of(Octokit::Client)
        .to receive(:create_issue)
        .with(
          repo,
          title,
          body,
          labels: labels, assignees: assignees
        )
        .and_return(number: 1)

      issue.save!

      expect(issue.instance_variable_get(:@number)).to eq(1)
    end

    it "closes the issue if its status is 'closed'" do
      closed_issue = Pivot::GitHub::Issue.new(title: title, closed: true)
      allow_any_instance_of(Octokit::Client)
        .to receive(:create_issue)
        .with(
          repo,
          title,
          nil,
          labels: [], assignees: []
        )
        .and_return(number: 1)

      expect_any_instance_of(Octokit::Client)
        .to receive(:close_issue).with(repo, 1)

      closed_issue.save!
    end
  end
end
