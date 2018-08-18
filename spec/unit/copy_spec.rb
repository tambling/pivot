require 'pivot/commands/copy'

RSpec.describe Pivot::Commands::Copy do
  it "executes `copy` command successfully" do
    output = StringIO.new
    pivotal_project = nil
    github_repo = nil
    options = {}
    command = Pivot::Commands::Copy.new(pivotal_project, github_repo, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
