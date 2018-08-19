# frozen_string_literal: true

require 'forwardable'

module Pivot
  class Command
    extend Forwardable

    def_delegators :command, :run

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # @api public
    def prompt(**options)
      require 'tty-prompt'
      TTY::Prompt.new(options)
    end

    def spin(beginning_message, ending_message)
      require 'tty-spinner'
      spinner = TTY::Spinner.new("[:spinner] #{beginning_message}")
      spinner.auto_spin
      yield
      spinner.stop(ending_message)
    end
  end
end
