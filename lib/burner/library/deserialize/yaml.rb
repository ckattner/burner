# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Deserialize
      # Take a YAML string and deserialize into object(s).  It uses YAML#safe_load by default,
      # which ensures only a limited number of Ruby object constants can be hydrated by the
      # YAML.  If you wish to ease this restriction, for example if you have custom serialization
      # for custom classes, then you can pass in safe: false.
      #
      # Expected Payload[register] input: string of YAML data.
      # Payload[register]output: anything as specified by the YAML de-serializer.
      class Yaml < JobWithRegister
        attr_reader :safe

        def initialize(name:, register: DEFAULT_REGISTER, safe: true)
          super(name: name, register: register)

          @safe = safe

          freeze
        end

        # The YAML cop was disabled because the consumer may want to actually load unsafe
        # YAML, which can load pretty much any type of class instead of putting the loader
        # in a sandbox.  By default, though, we will try and drive them towards using it
        # in the safer alternative.
        # rubocop:disable Security/YAMLLoad
        def perform(output, payload)
          output.detail('Warning: loading YAML not using safe_load.') unless safe

          value = payload[register]

          payload[register] = safe ? YAML.safe_load(value) : YAML.load(value)
        end
        # rubocop:enable Security/YAMLLoad
      end
    end
  end
end
