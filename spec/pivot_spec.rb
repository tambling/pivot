RSpec.describe Pivot do
  it "has a version number" do
    expect(Pivot::VERSION).not_to be nil
  end

  describe "clients" do
    it "includes PivotalClient" do
      expect(Pivot::PivotalClient).not_to be nil
    end
  end
end
