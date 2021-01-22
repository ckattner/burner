# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    # Output a simple message to the output.
    #
    # Note: this does not use Payload#registers.
    class Echo < Job
      attr_reader :message

      def initialize(message: '', name: '')
        super(name: name)

        @message = message.to_s

        freeze
      end

      def perform(output, payload)
        compiled_message = job_string_template(message, output, payload)

        output.detail(compiled_message)
      end
    end
  end
end
