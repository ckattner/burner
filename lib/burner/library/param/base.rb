# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Param
      # Common logic shared across Param job subclasses.
      class Base < JobWithRegister
        attr_reader :param_key

        def initialize(name: BLANK, param_key: BLANK, register: DEFAULT_REGISTER)
          super(name: name, register: register)

          @param_key = param_key.to_s

          freeze
        end
      end
    end
  end
end
