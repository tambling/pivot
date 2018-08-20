require 'spec_helper'
require 'securerandom'

def fixture_file(title)
  filename = "#{title}.json"
  spec_root = '../../..'
  relative_fixture_path = File.join(spec_root, 'fixtures', 'input', filename)
  absolute_fixture_path = File.expand_path(relative_fixture_path, __FILE__)

  File.new(absolute_fixture_path)
end

def pivotal_path(path)
  "#{Pivot::Pivotal::Client::BASE_ROUTE}/#{path}"
end

RSpec.describe Pivot::Pivotal::Client do
  it 'can be initialized with a token' do
    token = SecureRandom.hex
    client = Pivot::Pivotal::Client.new(token)
    expect(client.instance_variable_get(:@token)).to eq(token)
  end

  context 'getters' do
    let(:token) { SecureRandom.hex }
    let(:client) { Pivot::Pivotal::Client.new(token) }
    let(:headers) { { "X-TrackerToken": token } }

    describe '#get_projects' do
      let(:projects_url) { pivotal_path('projects') }

      it 'GETs the right URL' do
        expect(RestClient)
          .to receive(:get).with(projects_url, anything).and_return('[]')

        client.get_projects
      end

      it 'has the right headers' do
        expect(RestClient)
          .to receive(:get).with(anything, headers).and_return('[]')

        client.get_projects
      end

      it 'returns an array of hashes' do
        stub_request(:get, projects_url)
          .to_return(body: fixture_file('projects'), status: 200)

        expect(client.get_projects).to all(be_a Hash)
      end
    end

    describe '#get_project' do
      let(:project_id) { 1 }
      let(:project_url) do
        Addressable::Template.new(pivotal_path('projects/{id}'))
      end

      it 'GETs the right URL' do
        expected_url = project_url.expand(id: project_id)
        expect(RestClient)
          .to receive(:get).with(expected_url, anything).and_return('[]')

        client.get_project(project_id)
      end

      it 'has the right headers' do
        expect(RestClient)
          .to receive(:get).with(anything, headers).and_return('[]')

        client.get_project(project_id)
      end

      it 'returns a hash' do
        stub_request(:get, project_url)
          .to_return(body: fixture_file('project'), status: 200)

        expect(client.get_project(project_id)).to be_a(Hash)
      end
    end

    describe '#get_stories' do
      let(:project_id) { 1 }
      let(:stories_url) do
        Addressable::Template.new(pivotal_path('projects/{id}/stories'))
      end

      it 'GETs the right URL' do
        expected_url = stories_url.expand(id: project_id)
        expect(RestClient)
          .to receive(:get).with(expected_url, anything).and_return('[]')

        client.get_stories(project_id)
      end

      it 'has the right headers' do
        expect(RestClient)
          .to receive(:get).with(anything, headers).and_return('[]')

        client.get_stories(project_id)
      end

      it 'returns an array of hashes' do
        stub_request(:get, stories_url)
          .to_return(body: fixture_file('stories'), status: 200)

        expect(client.get_stories(project_id)).to all(be_a Hash)
      end
    end

    describe '#get_owners' do
      let(:project_id) { 1 }
      let(:story_id) { 2 }
      let(:owners_url) do
        Addressable::Template.new(pivotal_path('projects/{project_id}/stories/{story_id}/owners'))
      end

      it 'GETs the right URL' do
        expected_url = owners_url
                       .expand(project_id: project_id, story_id: story_id)

        expect(RestClient)
          .to receive(:get).with(expected_url, anything).and_return('[]')

        client.get_owners(project_id, story_id)
      end

      it 'has the right headers' do
        expect(RestClient)
          .to receive(:get).with(anything, headers).and_return('[]')

        client.get_owners(project_id, story_id)
      end

      it 'returns an array of hashes' do
        stub_request(:get, owners_url)
          .to_return(body: fixture_file('owners'), status: 200)

        expect(client.get_owners(project_id, story_id)).to all(be_a Hash)
      end
    end
  end
end
