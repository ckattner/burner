# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Data do
  let(:existing) do
    {
      'some_string' => 'Bobo',
      :some_symbol => 'Momo'
    }
  end

  subject { described_class.new(existing) }

  describe '#initialize and #to_h' do
    it 'sets existing data with all top level keys as strings' do
      expected = {
        'some_string' => 'Bobo',
        'some_symbol' => 'Momo'
      }

      expect(subject.to_h).to eq(expected)
    end
  end

  describe '#[]' do
    it 'is type-insensitive' do
      expect(subject[:some_string]).to eq('Bobo')
      expect(subject['some_string']).to eq('Bobo')

      expect(subject[:some_symbol]).to eq('Momo')
      expect(subject['some_symbol']).to eq('Momo')
    end
  end

  describe '#[]=' do
    it 'sets value in type-insensitive manner' do
      value = 'Neo'

      subject[:some_string] = value

      expect(subject[:some_string]).to eq(value)
    end
  end
end
