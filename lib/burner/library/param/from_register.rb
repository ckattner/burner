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
      # Copy a register's value into a param key.  Generally speaking you should only be
      # mutating registers, that way the params stay true to the passed in params for the
      # pipeline.  But this job is available in case a param needs to be updated.
      #
      # Expected Payload[register] input: anything.
      # Payload.params(param_key) output: whatever value was specified in the register.
      class FromRegister < Base
        def perform(output, payload)
          output.detail("Pushing value from register: #{register} to param: #{param_key}")

          payload.update_param(param_key, payload[register])
        end
      end
    end
  end
end
