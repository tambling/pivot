require 'spec_helper'
require 'securerandom'

RSpec.describe Pivot::PivotalClient do
  it 'can be initialized with a token' do
    token = SecureRandom.hex
    client = Pivot::PivotalClient.new(token)
    expect(client.instance_variable_get(:@token)).to eq(token)
  end


  context 'getters' do
    let(:token) { SecureRandom.hex }
    let(:client) { Pivot::PivotalClient.new(token) }
    let(:headers) { { "X-TrackerToken": token } }

    before(:each) do
      allow(JSON).to receive(:parse)
    end

    describe '#get_projects' do
      it "GETs the right URL" do
        expected_url = "#{Pivot::PivotalClient::BASE_ROUTE}/projects"
        expect(RestClient).to receive(:get).with(expected_url, anything)

        client.get_projects
      end

      it "has the right headers" do
        expect(RestClient).to receive(:get).with(anything, headers)

        client.get_projects
      end
    end

    describe '#get_project' do
      let(:project_id) { 1 }

      it "GETs the right URL" do
        expected_url = "#{Pivot::PivotalClient::BASE_ROUTE}/projects/#{project_id}"
        expect(RestClient).to receive(:get).with(expected_url, anything)

        client.get_project(project_id)
      end

      it "has the right headers" do
        expect(RestClient).to receive(:get).with(anything, headers)

        client.get_project(project_id)
      end
    end

    describe '#get_stories' do
      let(:project_id) { 1 }

      it "GETs the right URL" do
        expected_url = "#{Pivot::PivotalClient::BASE_ROUTE}/projects/#{project_id}/stories"
        expect(RestClient).to receive(:get).with(expected_url, anything)

        client.get_stories(project_id)
      end

      it "has the right headers" do
        expect(RestClient).to receive(:get).with(anything, headers)

        client.get_stories(project_id)
      end

    end
  end
end
