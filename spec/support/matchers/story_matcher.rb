RSpec::Matchers.define :match_story do |expected|
  match do |actual|
    actual.is_a?(Pivot::PivotalStory) &&
      actual.id == expected.id &&
      actual.name == expected.name &&
      actual.status == expected.status &&
      actual.description == expected.description &&
      actual.labels == expected.labels
  end
end
