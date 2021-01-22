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
      # This job can iterate over a set of records and sequence them (set the specified key to
      # a sequential index value.)
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: array of objects.
      class Number < JobWithRegister
        BLANK            = ''
        DEFAULT_KEY      = 'number'
        DEFAULT_START_AT = 1

        attr_reader :key, :resolver, :start_at

        def initialize(
          key: DEFAULT_KEY,
          name: BLANK,
          register: Burner::DEFAULT_REGISTER,
          separator: BLANK,
          start_at: DEFAULT_START_AT
        )
          super(name: name, register: register)

          @key      = key.to_s
          @resolver = Objectable.resolver(separator: separator)
          @start_at = start_at.to_i

          freeze
        end

        def perform(output, payload)
          output.detail("Setting '#{key}' for each record with values starting at #{start_at}")

          ensure_array(payload).each.with_index(start_at) do |record, index|
            resolver.set(record, key, index)
          end
        end
      end
    end
  end
end
