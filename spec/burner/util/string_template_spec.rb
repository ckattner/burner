# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Util::StringTemplate do
  subject { described_class.instance }

  describe '#evaluate' do
    it 'formats with a hash' do
      expression = 'My name is {name}.'
      input      = { name: 'The Jolly Roger' }
      actual     = subject.evaluate(expression, input)
      expected   = 'My name is The Jolly Roger.'

      expect(actual).to eq(expected)
    end
  end
end
