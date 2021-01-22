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
      # Process each object in an array and see if its attribute values match a given set
      # of validations.  The main register will include the valid objects and the invalid_register
      # will contain the invalid objects.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: An array of objects that are valid.
      # Payload[invalid_register] output: An array of objects that are invalid.
      class Validate < JobWithRegister
        DEFAULT_INVALID_REGISTER = 'invalid'
        DEFAULT_JOIN_CHAR        = ', '
        DEFAULT_MESSAGE_KEY      = 'errors'

        attr_reader :invalid_register,
                    :join_char,
                    :message_key,
                    :resolver,
                    :validations

        def initialize(
          invalid_register: DEFAULT_INVALID_REGISTER,
          join_char: DEFAULT_JOIN_CHAR,
          message_key: DEFAULT_MESSAGE_KEY,
          name: '',
          register: DEFAULT_REGISTER,
          separator: '',
          validations: []
        )
          super(name: name, register: register)

          @invalid_register = invalid_register.to_s
          @join_char        = join_char.to_s
          @message_key      = message_key.to_s
          @resolver         = Objectable.resolver(separator: separator)
          @validations      = Modeling::Validations.array(validations)

          freeze
        end

        def perform(output, payload)
          valid   = []
          invalid = []

          (payload[register] || []).each do |object|
            errors = validate(object)

            if errors.empty?
              valid << object
            else
              invalid << make_in_error(object, errors)
            end
          end

          output.detail("Valid count: #{valid.length}")
          output.detail("Invalid count: #{invalid.length}")

          payload[register]         = valid
          payload[invalid_register] = invalid

          nil
        end

        private

        def validate(object)
          validations.each_with_object([]) do |validation, memo|
            next if validation.valid?(object, resolver)

            memo << validation.message
          end
        end

        def make_in_error(object, errors)
          resolver.set(object, message_key, errors.join(join_char))
        end
      end
    end
  end
end
