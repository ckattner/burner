# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Values do
  let(:objects) do
    [
      {
        'first' => 'captain',
        'id' => '1',
        'last' => 'kangaroo'
      },
      {
        'first' => 'twisted',
        'id' => '2',
        'last' => 'sister'
      }
    ]
  end

  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => objects }) }

  subject { described_class.make(name: 'test', include_keys: include_keys, register: register) }

  describe '#perform' do
    context 'when include_keys is false' do
      let(:include_keys) { false }

      it 'returns mapped array' do
        subject.perform(output, payload)

        expected = [
          %w[captain 1 kangaroo],
          %w[twisted 2 sister]
        ]

        expect(payload[register]).to eq(expected)
      end
    end

    context 'when include_keys is true' do
      let(:include_keys) { true }

      it 'returns mapped array' do
        subject.perform(output, payload)

        expected = [
          %w[first id last],
          %w[captain 1 kangaroo],
          %w[twisted 2 sister]
        ]

        expect(payload[register]).to eq(expected)
      end
    end
  end
end
