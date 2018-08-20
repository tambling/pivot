module Pivot
  module GitHub
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

      def save!
        response = self.class.client.create_issue(self.class.repo, @title, @body, {labels: @labels, assignees: @assignees})

        @number = response[:number]

        if @closed
          self.class.client.close_issue(self.class.repo, @number)
        end
      end
    end
  end
end
