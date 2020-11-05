# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Util::Arrayable do
  let(:nothing_class) { Class.new { extend Burner::Util::Arrayable } }

  describe '#array' do
    it 'should preserve a hash' do
      value = { abc: :def }

      actual = nothing_class.array(value)

      expect(actual).to eq([value])
    end

    it 'treats arrays as arrays' do
      value = [{ abc: :def }]

      actual = nothing_class.array(value)

      expect(actual).to eq(value)
    end

    it 'treats nil as empty array' do
      value = nil

      actual = nothing_class.array(value)

      expect(actual).to eq([])
    end
  end
end
