# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Modeling
    # Generic relationship between a numeric index and a key.
    class KeyIndexMapping
      acts_as_hashable

      attr_reader :index, :key

      def initialize(index:, key:)
        raise ArgumentError, 'index is required' if index.to_s.empty?
        raise ArgumentError, 'key is required'   if key.to_s.empty?

        @index = index.to_i
        @key   = key.to_s

        freeze
      end
    end
  end
end
