module Pivot
  class PivotalState
    PIVOTAL_STATES = %w(unscheduled unstarted planned rejected started finished delivered accepted)

    class << self
      def completion_threshold
        @completion_threshold ||= 'finished'
      end

      def completion_threshold= new_threshold
        raise InvalidCompletionThresholdError unless PIVOTAL_STATES.include?(new_threshold)

        @completion_threshold = new_threshold
      end
    end

    def initialize(state)
      @state = state
    end

    def to_s
      @state
    end

    def closed?
      PIVOTAL_STATES.index(@state) >= PIVOTAL_STATES.index(self.class.completion_threshold)
    end
  end
end

class InvalidCompletionThresholdError < StandardError; end
