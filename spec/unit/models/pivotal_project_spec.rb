require 'spec_helper'

RSpec.describe Pivot::PivotalProject do
  describe 'getters' do
    let (:project_id) { 1 }
    let (:project_name) { "Project #1" }
    let (:project) { Pivot::PivotalProject.new(id: project_id, name: project_name) }

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

      Pivot::PivotalBase.create_client('token')
    end

    describe '.get_all' do
      it 'returns an array of PivotalProjects' do
        expect(Pivot::PivotalProject.get_all).to all(be_a Pivot::PivotalProject)
      end
    end

    describe '.get' do
      it 'calls .get_by_id with a numeric identifier' do
        id = '12345'

        expect(Pivot::PivotalProject).to receive(:get_by_id).with(id)
        
        Pivot::PivotalProject.get(id)
      end

      it 'calls .get_by_name with a non-numeric identifier' do
        id = 'project'

        expect(Pivot::PivotalProject).to receive(:get_by_name).with(id)
        
        Pivot::PivotalProject.get(id)

      end
    end

    describe '.get_by_id' do 
      it 'returns the right PivotalProject' do
        expect(Pivot::PivotalProject.get_by_id(project_id)).to match_project(project)
      end
    end

    describe '.get_by_name' do
      it 'returns the right PivotalProject' do
        expect(Pivot::PivotalProject.get_by_name(project_name)).to match_project(project)
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

  describe '#stories' do
    it 'calls PivotalStory.get_by_project_id' do
      id = 1
      name = "Project"

      expect(Pivot::PivotalStory).to receive(:get_by_project_id).with(id)

      Pivot::PivotalProject.new(id: id, name: name).stories
    end
  end
end
