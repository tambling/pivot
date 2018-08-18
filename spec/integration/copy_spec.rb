RSpec.describe "`pivot copy` command", type: :cli do
  it "executes `pivot help copy` command successfully" do
    output = `pivot help copy`
    expected_output = <<-OUT
Usage:
  pivot copy PIVOTAL_PROJECT GITHUB_REPO

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
