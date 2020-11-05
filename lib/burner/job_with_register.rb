# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'job'

module Burner
  # Add on a register attribute to the configuration for a job.  This indicates that a job
  # either accesses and/or mutates the payload's registers.
  class JobWithRegister < Job
    attr_reader :register

    def initialize(name:, register: DEFAULT_REGISTER)
      super(name: name)

      @register = register.to_s
    end
  end
end
