require 'spec_helper'

RSpec.describe Pivot::PivotalProject do
  describe 'getters' do
    let (:project_id) { 1 }
    let (:project_name) { "Project #1" }

    before(:each) do
      raw_project = {
        "id" => project_id,
        "name" => project_name
      }

      raw_projects = [ raw_project ]

      allow_any_instance_of(Pivot::PivotalClient).to receive(:get_projects).and_return(raw_projects)

      allow_any_instance_of(Pivot::PivotalClient).to receive(:get_project).
        with(project_id).
        and_return(raw_project)

      Pivot::PivotalBase.client = Pivot::PivotalClient.new('token')
    end

    describe '.get_all' do
      it 'returns an array of PivotalProjects' do
        expect(Pivot::PivotalProject.get_all).to all(be_a Pivot::PivotalProject)
      end
    end

    describe '.get_by_id' do 
      it 'returns the right PivotalProject' do
        expect(Pivot::PivotalProject.get_by_id(project_id).id).to eq(project_id)
      end
    end

    describe '.get_by_name' do
      it 'returns the right PivotalProject' do
        expect(Pivot::PivotalProject.get_by_name(project_name).name).to eq(project_name)
      end
    end
  end

  describe '.from_api_project' do
    it 'returns a PivotalProject with the right properties' do
      id = 1
      name = "Project"

      raw_project = { "id" => id, "name" => name }
      project = Pivot::PivotalProject.new(id: id, name: name)

      expect(Pivot::PivotalProject.from_api_project(raw_project)).to match_project(project)
    end
  end
end
