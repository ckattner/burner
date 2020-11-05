# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Modeling
    # Defines a top-level key and the associated transformers for deriving the final value
    # to set the key to.  The transformers that can be passed in can be any Realize::Transformers
    # subclasses.  For more information, see the Realize library at:
    # https://github.com/bluemarblepayroll/realize
    class Attribute
      acts_as_hashable

      attr_reader :key, :transformers

      def initialize(key:, transformers: [])
        raise ArgumentError, 'key is required' if key.to_s.empty?

        @key          = key.to_s
        @transformers = Realize::Transformers.array(transformers)

        freeze
      end
    end
  end
end
