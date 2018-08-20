require 'spec_helper'

RSpec.describe Pivot::Pivotal::Project do
  describe 'getters' do
    let(:project_id) { 1 }
    let(:project_name) { 'Project #1' }
    let(:project) { Pivot::Pivotal::Project.new(id: project_id, name: project_name) }

    before(:each) do
      raw_project = {
        'id' => project_id,
        'name' => project_name
      }

      raw_projects = [raw_project]

      allow_any_instance_of(Pivot::Pivotal::Client)
        .to receive(:get_projects).and_return(raw_projects)

      allow_any_instance_of(Pivot::Pivotal::Client).to receive(:get_project)
        .with(project_id)
        .and_return(raw_project)

      Pivot::Pivotal::Base.create_client('token')
    end

    describe '.get_all' do
      it 'returns an array of Pivotal::Projects' do
        expect(Pivot::Pivotal::Project.get_all)
          .to all(be_a Pivot::Pivotal::Project)
      end
    end

    describe '.get' do
      it 'calls .get_by_id with a numeric identifier' do
        id = '12345'

        expect(Pivot::Pivotal::Project).to receive(:get_by_id).with(id)

        Pivot::Pivotal::Project.get(id)
      end

      it 'calls .get_by_name with a non-numeric identifier' do
        id = 'project'

        expect(Pivot::Pivotal::Project).to receive(:get_by_name).with(id)

        Pivot::Pivotal::Project.get(id)
      end
    end

    describe '.get_by_id' do
      it 'returns the right Pivotal::Project' do
        expect(Pivot::Pivotal::Project.get_by_id(project_id))
          .to match_project(project)
      end
    end

    describe '.get_by_name' do
      it 'returns the right Pivotal::Project' do
        expect(Pivot::Pivotal::Project.get_by_name(project_name))
          .to match_project(project)
      end
    end
  end

  describe '.from_api_project' do
    it 'returns a Pivotal::Project with the right properties' do
      id = 1
      name = 'Project'

      raw_project = { 'id' => id, 'name' => name }
      project = Pivot::Pivotal::Project.new(id: id, name: name)

      expect(Pivot::Pivotal::Project.from_api_project(raw_project))
        .to match_project(project)
    end
  end

  describe '#stories' do
    it 'calls Pivotal::Story.get_by_project_id' do
      id = 1
      name = 'Project'

      expect(Pivot::Pivotal::Story).to receive(:get_by_project_id).with(id)

      Pivot::Pivotal::Project.new(id: id, name: name).stories
    end
  end
end
