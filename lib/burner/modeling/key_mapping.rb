# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Modeling
    # Generic mapping from a key to another key.  The argument 'to' is optional
    # and if it is blank then the 'from' value will be used for the 'to' as well.
    class KeyMapping
      acts_as_hashable

      attr_reader :from, :to

      def initialize(from:, to: '')
        raise ArgumentError, 'from is required' if from.to_s.empty?

        @from = from.to_s
        @to   = to.to_s.empty? ? @from : to.to_s

        freeze
      end
    end
  end
end
