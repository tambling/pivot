RSpec::Matchers.define :match_project do |expected|
  match do |actual|
    actual.is_a?(Pivot::Pivotal::Project) &&
      actual.id == expected.id &&
      actual.name == expected.name
  end
end
