require 'spec_helper'

RSpec.describe Pivot::PivotalProject do
  let (:project_id) { 1 }
  let (:project_name) { "Project #1" }
  let (:raw_project) {
    {
      "id" => project_id,
      "name" => project_name
    }
  }

  let (:pivotal_project) { 
    Pivot::PivotalProject.new(id: project_id, name: project_name) 
  }

  let (:raw_projects) { [raw_project] }

  before(:each) do
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
      expect(Pivot::PivotalProject.get_by_id(project_id)).to eq(pivotal_project)

    end
  end

  describe '.get_by_name' do
    it 'returns the right PivotalProject' do
      expect(Pivot::PivotalProject.get_by_name(project_name)).to eq(pivotal_project)
    end
  end
end
