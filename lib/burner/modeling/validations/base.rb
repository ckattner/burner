# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Modeling
    class Validations
      # Common logic shared among all Validation subclasses.
      # This class is an abstract class, make sure to implement:
      # - #valid?(object, resolver)
      # - #default_message
      class Base
        acts_as_hashable

        attr_reader :key

        def initialize(key:, message: '')
          raise ArgumentError, 'key is required' if key.to_s.empty?

          @key     = key.to_s
          @message = message.to_s
        end

        def message
          @message.to_s.empty? ? "#{key} #{default_message}" : @message.to_s
        end
      end
    end
  end
end
