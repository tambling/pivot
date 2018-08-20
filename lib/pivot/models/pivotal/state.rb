module Pivot
  module Pivotal
    # Abstracts a Pivotal Tracker story's "current_state," including keeping
    # track of the states in sequence, and determining whether the state is
    # before or after the threshold defined by the user for closing a GitHub
    # issue.
    class State
      PIVOTAL_STATES = %w[unscheduled unstarted planned rejected started finished delivered accepted].freeze

      class << self
        def closure_threshold
          @closure_threshold ||= 'finished'
        end

        def closure_threshold=(new_threshold)
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
end

class InvalidClosureThresholdError < StandardError; end
