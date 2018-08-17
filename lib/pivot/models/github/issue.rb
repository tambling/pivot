module Pivot
  module GitHub
    class Issue < Base
      class << self
        attr_accessor :repo
      end

      attr_reader :title, :body, :state, :labels, :assignees

      def initialize(title:, body: nil, state: 'open', labels: [], assignees: [])
        @title = title
        @body = body
        @state = state
        @labels = labels
        @assignees = assignees
      end

      def save!
        self.class.check_client

        response = @@client.create_issue(self.class.repo, @title, @body, {labels: @labels, assignees: @assignees})

        @number = response[:number]
      end
    end
  end
end
