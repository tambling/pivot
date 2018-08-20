RSpec::Matchers.define :match_user do |expected|
  match do |actual|
    actual.is_a?(Pivot::PivotalUser) &&
      actual.id == expected.id &&
      actual.username == expected.username 
  end
end
