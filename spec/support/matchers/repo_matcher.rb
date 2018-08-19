RSpec::Matchers.define :match_repo do |expected|
  match do |actual|
    actual.is_a?(Pivot::GitHub::Repo) &&
      actual.name == expected.name
  end
end
