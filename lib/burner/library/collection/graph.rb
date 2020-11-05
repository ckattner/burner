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
      # Take an array of (denormalized) objects and create an object hierarchy from them.
      # Under the hood it uses Hashematics: https://github.com/bluemarblepayroll/hashematics.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: An array of objects.
      class Graph < JobWithRegister
        attr_reader :key, :groups

        def initialize(
          name:, key:,
          config: Hashematics::Configuration.new,
          register: DEFAULT_REGISTER
        )
          super(name: name, register: register)

          raise ArgumentError, 'key is required' if key.to_s.empty?

          @groups = Hashematics::Configuration.new(config).groups
          @key    = key.to_s

          freeze
        end

        def perform(output, payload)
          graph = Hashematics::Graph.new(groups).add(array(payload[register]))

          output.detail("Graphing: #{key}")

          payload[register] = graph.data(key)
        end
      end
    end
  end
end
