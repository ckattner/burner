# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Collection
      # Convert an array of arrays to an array of objects.  Pass in an array of
      # Burner::Modeling::KeyIndexMapping instances or hashable configurations which specifies
      # the index-to-key mappings to use.
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: An array of hashes.
      #
      # An example using a configuration-first pipeline:
      #
      #   config = {
      #     jobs: [
      #       {
      #         name: 'set',
      #         type: 'b/value/static',
      #         value: [
      #           [1, 'funky']
      #         ]
      #       },
      #       {
      #         name: 'map',
      #         type: 'b/collection/arrays_to_objects',
      #         mappings: [
      #           { index: 0, key: 'id' },
      #           { index: 1, key: 'name' }
      #         ]
      #       },
      #       {
      #         name: 'output',
      #         type: 'b/echo',
      #         message: 'value is currently: {__value}'
      #       },
      #
      #     ],
      #     steps: %w[set map output]
      #   }
      #
      #   Burner::Pipeline.make(config).execute
      #
      # Given the above example, the expected output would be:
      #  [
      #    { 'id' => 1, 'name' => 'funky' }
      #  ]
      class ArraysToObjects < JobWithRegister
        attr_reader :mappings

        def initialize(mappings: [], name: '', register: DEFAULT_REGISTER)
          super(name: name, register: register)

          @mappings = Modeling::KeyIndexMapping.array(mappings)

          freeze
        end

        def perform(_output, payload)
          payload[register] = array(payload[register]).map { |array| index_to_key_map(array) }
        end

        private

        def index_to_key_map(array)
          mappings.each_with_object({}) do |mapping, memo|
            memo[mapping.key] = array[mapping.index]
          end
        end
      end
    end
  end
end
