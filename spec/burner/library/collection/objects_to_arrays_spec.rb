# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::ObjectsToArrays do
  let(:arrays) do
    [
      %w[1 captain kangaroo],
      %w[2 twisted sister]
    ]
  end

  let(:flat_objects) do
    [
      {
        'name.first' => 'captain',
        'id' => '1',
        'name.last' => 'kangaroo'
      },
      {
        'name.first' => 'twisted',
        'id' => '2',
        'name.last' => 'sister'
      }
    ]
  end

  let(:nested_objects) do
    [
      {
        'name' => {
          'first' => 'captain',
          'last' => 'kangaroo'
        },
        'id' => '1'
      },
      {
        'name' => {
          'first' => 'twisted',
          'last' => 'sister'
        },
        'id' => '2'
      }
    ]
  end

  let(:mappings) do
    [
      { index: 0, key: 'id' },
      { index: 1, key: 'name.first' },
      { index: 2, key: 'name.last' }
    ]
  end

  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:register)   { 'register_a' }

  subject do
    described_class.make(
      name: 'test',
      mappings: mappings,
      separator: separator,
      register: register
    )
  end

  describe '#perform' do
    context 'when separator is empty' do
      let(:separator) { '' }
      let(:payload)   { Burner::Payload.new(registers: { register => flat_objects }) }

      it 'returns mapped array' do
        subject.perform(output, payload)

        expect(payload[register]).to eq(arrays)
      end
    end

    context 'when separator is not empty' do
      let(:separator) { '.' }
      let(:payload)   { Burner::Payload.new(registers: { register => nested_objects }) }

      it 'returns mapped array' do
        subject.perform(output, payload)

        expect(payload[register]).to eq(arrays)
      end
    end
  end
end
