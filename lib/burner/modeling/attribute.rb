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
    #
    # Note that if explicit: true is set then no transformers will be automatically injected.
    # If explicit is not true (default) then it will have a resolve job automatically injected
    # in the beginning of the pipeline.  This is the observed default behavior, with the
    # exception having to be initially cross-mapped using a custom resolve transformation.
    class Attribute
      acts_as_hashable

      RESOLVE_TYPE = 'r/value/resolve'

      attr_reader :key, :transformers

      def initialize(key:, explicit: false, transformers: [])
        raise ArgumentError, 'key is required' if key.to_s.empty?

        @key          = key.to_s
        @transformers = base_transformers(explicit) + Realize::Transformers.array(transformers)

        freeze
      end

      private

      # When explicit, this will return an empty array.
      # When not explicit, this will return an array with a basic transformer that simply
      # gets the key's value.  This establishes a good majority base case.
      def base_transformers(explicit)
        return [] if explicit

        [Realize::Transformers.make(type: RESOLVE_TYPE, key: key)]
      end
    end
  end
end
