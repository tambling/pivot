require 'spec_helper'
require 'pivot/commands/copy'
require 'tty-prompt'
require 'tty-spinner'

RSpec.describe Pivot::Commands::Copy do
  let(:project_name) { 'Project' }
  let(:repo_name) { 'user/repo' }
  let(:options) do
    {
      'pivotal_project' => project_name,
      'github_repo' => repo_name
    }
  end

  before(:each) do
    allow_any_instance_of(TTY::Spinner).to receive(:auto_spin)
    allow_any_instance_of(TTY::Spinner).to receive(:stop)
  end

  describe '.new' do
    let(:app) { Pivot::Application.new({}) }

    before(:each) do
      allow(app).to receive(:prepare_issues)
      allow(app).to receive(:all_project_names).and_return([project_name])
      allow(app).to receive(:all_repo_names).and_return([repo_name])
    end

    it 'creates a new Pivot::Application with the passed options' do
      expect(Pivot::Application)
        .to receive(:new).with(options.transform_keys(&:to_sym))
                         .and_return(app)

      Pivot::Commands::Copy.new(options)
    end

    it 'tells the Pivot::Application to prepare its issues' do
      allow(Pivot::Application).to receive(:new).and_return(app)

      expect(app).to receive(:prepare_issues)

      Pivot::Commands::Copy.new(options)
    end

    it 'sets the pivotal_project_identifier if it was provided' do
      allow(Pivot::Application).to receive(:new).and_return(app)

      Pivot::Commands::Copy.new(options)

      expect(app.pivotal_project_identifier).to eq(project_name)
    end

    it "prompts the user to select a project if one wasn't provided" do
      allow(Pivot::Application).to receive(:new).and_return(app)
      expect_any_instance_of(TTY::Prompt).to receive(:select)

      Pivot::Commands::Copy.new('github_repo' => repo_name)
    end

    it 'sets the github_repo_identifier if it was provided' do
      allow(Pivot::Application).to receive(:new).and_return(app)

      Pivot::Commands::Copy.new(options)

      expect(app.github_repo_identifier).to eq(repo_name)
    end

    it "prompts the user to select a repo if one wasn't provided" do
      allow(Pivot::Application).to receive(:new).and_return(app)
      expect_any_instance_of(TTY::Prompt).to receive(:select)

      Pivot::Commands::Copy.new('pivotal_project' => project_name)
    end
  end

  describe '#execute' do
    it 'calls Pivot::Application#create_issues!' do
      allow_any_instance_of(Pivot::Application).to receive(:prepare_issues)
      expect_any_instance_of(Pivot::Application).to receive(:create_issues!)

      Pivot::Commands::Copy.new(options).execute
    end
  end
end
