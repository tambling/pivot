require 'spec_helper'

RSpec.describe Pivot do
  it 'has a version number' do
    expect(Pivot::VERSION).not_to be nil
  end

  describe '::Application' do
    describe '.new' do
      let(:config_file) { { foo: 'bar' } }

      before(:each) do
        config = TTY::Config.new(config_file)

        allow(TTY::Config).to receive(:new).and_return(config)
        allow(config).to receive(:persisted?).and_return(true)
        allow(config).to receive(:read)
      end

      it 'sets the client for Pivotal::Base' do
        pivotal_token = 'token'

        expect(Pivot::Pivotal::Base).to receive(:create_client).with(pivotal_token)

        Pivot::Application.new(pivotal_token: pivotal_token)
      end

      it 'sets the client for GitHub::Base' do
        login = 'user'
        password = 'password'

        expect(Pivot::GitHub::Base)
          .to receive(:create_client).with(login: login, password: password)

        Pivot::Application.new(github_login: login, github_token: password)
      end

      it 'sets the closure threshold if provided' do
        closure_threshold = 'started'
        Pivot::Application.new(closure_threshold: closure_threshold)

        expect(Pivot::Pivotal::State.closure_threshold).to eq(closure_threshold)

        Pivot::Pivotal::State.closure_threshold = 'finished'
      end

      it 'gets and merges the configs' do
        options = { pivotal_token: 'token' }

        app = Pivot::Application.new(options)

        expect(app.instance_variable_get(:@config).fetch(:foo)).to eq('bar')
      end
    end

    describe 'issues' do
      let(:identifier) { '12345' }
      let(:app) { Pivot::Application.new({}) }
      let(:project) { Pivot::Pivotal::Project.new(id: 1, name: 'Project') }
      let(:story) { Pivot::Pivotal::Story.new(id: 1, name: 'Story', state: 'finished') }
      let(:issue) { story.to_github_issue }

      before(:each) do
        app.pivotal_project_identifier = identifier
        app.github_repo_identifier = 'user/repo'

        allow(project).to receive(:stories).and_return([story])
      end

      describe '#prepare_issues' do
        it 'gets the right Pivotal::Project' do
          expect(Pivot::Pivotal::Project)
            .to receive(:get).with(identifier).and_return(project)

          app.prepare_issues
        end

        it "sets the app's issues correctly" do
          allow(Pivot::Pivotal::Project)
            .to receive(:get).with(identifier).and_return(project)

          app.prepare_issues

          expect(app.instance_variable_get(:@issues))
            .to all(be_a(Pivot::GitHub::Issue))
        end
      end

      describe '#create_issues!' do
        it 'calls #save! on every issue' do
          allow(Pivot::Pivotal::Project)
            .to receive(:get).with(identifier).and_return(project)

          app.prepare_issues

          expect_any_instance_of(Pivot::GitHub::Issue).to receive(:save!).once

          app.create_issues!
        end
      end
    end

    describe '#all_project_names' do
      it 'returns the names of every available project' do
        project_name = 'Project'
        project = Pivot::Pivotal::Project.new(id: 1, name: project_name)

        allow(Pivot::Pivotal::Project).to receive(:get_all).and_return([project])

        app = Pivot::Application.new({})

        expect(app.all_project_names).to eq([project_name])
      end
    end

    describe '#all_repo_names' do
      it 'returns the names of every available repository' do
        repo_name = 'user/repo'
        repo = Pivot::GitHub::Repo.new(repo_name)

        allow(Pivot::GitHub::Repo).to receive(:get_all).and_return([repo])

        app = Pivot::Application.new({})

        expect(app.all_repo_names).to eq([repo_name])
      end
    end
  end
end
