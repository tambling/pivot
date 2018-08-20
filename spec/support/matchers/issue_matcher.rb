RSpec::Matchers.define :match_issue do |expected|
  match do |actual|
    actual.is_a?(Pivot::GitHub::Issue) &&
      actual.title == expected.title &&
      actual.body == expected.body &&
      actual.closed == expected.closed &&
      actual.labels == expected.labels &&
      actual.assignees == expected.assignees
  end
end
