# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Value
      # This job will nest the current value within a new outer hash.  The specified key
      # passed in will be the corresponding new hash key entry for the existing value.
      #
      # Expected Payload[from_register] input: anything.
      # Payload[to_register] output: hash.
      class Nest < JobWithRegister
        DEFAULT_KEY = 'key'

        attr_reader :key

        def initialize(key: DEFAULT_KEY, name: '', register: Burner::DEFAULT_REGISTER)
          super(name: name, register: register)

          @key = key.to_s

          freeze
        end

        def perform(_output, payload)
          payload[register] = { key => payload[register] }
        end
      end
    end
  end
end
