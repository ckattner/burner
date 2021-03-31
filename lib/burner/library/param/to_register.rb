# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Burner
  module Library
    module Param
      # Copy a param key's value into a register.
      #
      # Expected Payload.param(param_key) input: anything.
      # Payload[register] output: whatever value was specified as the param_key's value.
      class ToRegister < Base
        def perform(output, payload)
          output.detail("Pushing value to register: #{register} from param: #{param_key}")

          payload[register] = payload.param(param_key)
        end
      end
    end
  end
end
