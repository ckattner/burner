# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Number do
  let(:value) do
    [
      {},
      { a: 'b' }
    ]
  end

  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }

  subject { described_class.make(register: register) }

  describe '#perform' do
    it 'sets the number key value in sequential order' do
      subject.perform(output, payload)

      expected = [
        { 'number' => 1 },
        { :a => 'b', 'number' => 2 }
      ]

      expect(payload[register]).to eq(expected)
    end
  end

  context 'when nil is an entry' do
    let(:value) do
      [
        {},
        nil,
        { a: 'b' },
        nil,
        { c: 'd' }
      ]
    end

    it 'skips nil entries but numbers the rest' do
      subject.perform(output, payload)

      expected = [
        { 'number' => 1 },
        nil,
        { :a => 'b', 'number' => 3 },
        nil,
        { :c => 'd', 'number' => 5 }
      ]

      expect(payload[register]).to eq(expected)
    end
  end
end
