RSpec::Matchers.define :match_story do |expected|
  match do |actual|
    actual.is_a?(Pivot::Pivotal::Story) &&
      actual.id == expected.id &&
      actual.name == expected.name &&
      actual.state.to_s == expected.state.to_s &&
      actual.description == expected.description &&
      actual.labels == expected.labels
    actual.owners.map(&:id) == expected.owners.map(&:id)
  end
end
