# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'job_with_register'

module Burner
  # Add on a register attribute to the configuration for a job.  This indicates that a job
  # either accesses and/or mutates the payload's registers.
  class JobWithDynamicKeys < JobWithRegister
    attr_reader :keys_register,
                :resolver

    def initialize(
      keys_register:,
      name: '',
      register: DEFAULT_REGISTER,
      separator: BLANK
    )
      super(name: name, register: register)

      @keys_register = keys_register.to_s
      @resolver      = Objectable.resolver(separator: separator)
    end
  end
end
