RSpec::Matchers.define :match_story do |expected|
  match do |actual|
    actual.is_a?(Pivot::PivotalStory) &&
      actual.id == expected.id &&
      actual.name == expected.name &&
      actual.state.to_s == expected.state.to_s &&
      actual.description == expected.description &&
      actual.labels == expected.labels
  end
end
