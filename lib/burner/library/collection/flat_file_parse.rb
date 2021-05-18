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
      # Convert an array of arrays to an array of objects.  The difference between this
      # job and ArraysToObjects is that this one does not take in mappings and instead
      # will use the first entry as the array of keys to positionally map to.
      #
      # For example, if a register had this:
      #
      #   [['id', 'first', 'last'], [1, 'frank', 'rizzo']]
      #
      # Then executing this job would result in this:
      #
      #   [{ 'id' => 1, 'first' => frank, 'last' => rizzo }]
      #
      # As a side-effect, the keys_register would result in this:
      #
      #   ['id', 'first', 'last']
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: An array of hashes.
      class FlatFileParse < JobWithDynamicKeys
        def perform(output, payload)
          objects = array(payload[register])
          keys    = array(objects.shift)
          count   = objects.length

          output.detail("Mapping #{count} array(s) to key(s): #{keys.join(', ')}")

          payload[register]      = objects.map { |object| transform(object, keys) }
          payload[keys_register] = keys
        end

        private

        def transform(object, keys)
          object.each_with_object({}).with_index do |(value, memo), index|
            next if index >= keys.length

            key = keys[index]

            resolver.set(memo, key, value)
          end
        end
      end
    end
  end
end
