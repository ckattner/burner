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
      # Iterate over all objects and return a new set of transformed objects.  The object is
      # transformed per the "transformers" attribute for its attributes.  An attribute defines
      # the ultimate key to place the value in and then the transformer pipeline to use to
      # derive the value.  Under the hood this uses the Realize library:
      #   https://github.com/bluemarblepayroll/realize
      # For more information on the specific contract for attributes, see the
      # Burner::Modeling::Attribute class.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: An array of objects.
      class Transform < JobWithRegister
        attr_reader :attribute_renderers,
                    :exclusive,
                    :resolver

        def initialize(
          attributes: [],
          exclusive: false,
          name: '',
          register: DEFAULT_REGISTER,
          separator: BLANK
        )
          super(name: name, register: register)

          @resolver  = Objectable.resolver(separator: separator)
          @exclusive = exclusive || false

          @attribute_renderers =
            Modeling::Attribute.array(attributes)
                               .map { |a| Modeling::AttributeRenderer.new(a, resolver) }

          freeze
        end

        def perform(output, payload)
          payload[register] = array(payload[register]).map { |row| transform(row, payload.time) }

          attr_count = attribute_renderers.length
          row_count  = payload[register].length

          output.detail("Transformed #{attr_count} attributes(s) for #{row_count} row(s)")
        end

        private

        def transform(row, time)
          outgoing_row = exclusive ? {} : row

          attribute_renderers.each_with_object(outgoing_row) do |attribute_renderer, memo|
            value = attribute_renderer.transform(row, time)

            resolver.set(memo, attribute_renderer.key, value)
          end
        end
      end
    end
  end
end
