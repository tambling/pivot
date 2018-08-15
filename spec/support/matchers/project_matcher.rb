RSpec::Matchers.define :match_project do |expected|
  match do |actual|
    actual.is_a?(Pivot::PivotalProject) &&
      actual.id == expected.id &&
      actual.name == expected.name
  end
end
