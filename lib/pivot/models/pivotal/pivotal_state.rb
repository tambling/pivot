module Pivot
  class PivotalState
    PIVOTAL_STATES = %w(unscheduled unstarted planned rejected started finished delivered accepted)

    class << self
      def closure_threshold
        @closure_threshold ||= 'finished'
      end

      def closure_threshold= new_threshold
        raise InvalidClosureThresholdError unless PIVOTAL_STATES.include?(new_threshold)

        @closure_threshold = new_threshold
      end
    end

    def initialize(state)
      @state = state
    end

    def to_s
      @state
    end

    def closed?
      PIVOTAL_STATES.index(@state) >= PIVOTAL_STATES.index(self.class.closure_threshold)
    end
  end
end

class InvalidClosureThresholdError < StandardError; end
