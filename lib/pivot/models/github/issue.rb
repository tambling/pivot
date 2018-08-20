module Pivot
  module GitHub
    # Abstracts a GitHub issue, storing and eventually persisting its
    # attributes.
    class Issue < Base
      class << self
        attr_accessor :repo
      end

      attr_reader :title, :body, :labels, :assignees, :closed

      def initialize(title:, body: nil, closed: false, labels: [], assignees: [])
        @title = title
        @body = body
        @labels = labels
        @assignees = assignees
        @closed = closed
      end

      # Sends this Issue's attributes to an Octokit::Client, which handles the
      # actual API call. Additionally calls Octokit::Client#close_issue if
      # needed, because open/closed status is not accepted on creation.
      def save!
        response = self.class.client.
          create_issue(self.class.repo, @title, @body, labels: @labels, assignees: @assignees)

        @number = response[:number]

        self.class.client.close_issue(self.class.repo, @number) if @closed
      end
    end
  end
end
