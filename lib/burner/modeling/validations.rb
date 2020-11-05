# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'validations/blank'
require_relative 'validations/present'

module Burner
  module Modeling
    # Factory for building sub-classes that can validate an individual object and field value.
    class Validations
      acts_as_hashable_factory

      register 'blank',   Validations::Blank
      register 'present', Validations::Present
    end
  end
end
