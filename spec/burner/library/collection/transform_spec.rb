# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Transform do
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }

  subject do
    described_class.make(
      name: 'test',
      attributes: attributes,
      exclusive: exclusive,
      separator: separator,
      register: register
    )
  end

  describe '#perform' do
    context 'without key path notation (separator)' do
      let(:separator) { '' }

      let(:value) do
        [
          {
            'name' => 'Funky Chicken',
            'dob' => '01/20/1920'
          }
        ]
      end

      let(:attributes) do
        [
          {
            key: 'dob',
            transformers: [
              {
                type: 'r/format/date',
                input_format: '%m/%d/%Y'
              }
            ]
          }
        ]
      end

      context 'when exclusive is false' do
        let(:exclusive) { false }

        it 'returns transformed objects' do
          subject.perform(output, payload)

          expected = [
            {
              'name' => 'Funky Chicken',
              'dob' => '1920-01-20'
            }
          ]

          expect(payload[register]).to eq(expected)
        end
      end

      context 'when exclusive is true' do
        let(:exclusive) { true }

        it 'returns transformed objects' do
          subject.perform(output, payload)

          expected = [
            {
              'dob' => '1920-01-20'
            }
          ]

          expect(payload[register]).to eq(expected)
        end
      end
    end

    context 'with key path notation (separator)' do
      let(:separator) { '.' }
      let(:exclusive) { true }

      let(:value) do
        [
          {
            'name' => {
              'first' => 'Funky',
              'last' => 'Chicken'
            }
          }
        ]
      end

      let(:attributes) do
        [
          {
            key: 'first',
            explicit: true,
            transformers: [
              {
                type: 'r/value/resolve',
                key: 'name.first'
              }
            ]
          },
          {
            key: 'last',
            explicit: true,
            transformers: [
              {
                type: 'r/value/resolve',
                key: 'name.last'
              }
            ]
          }
        ]
      end

      it 'returns transformed objects' do
        subject.perform(output, payload)

        expected = [
          {
            'first' => 'Funky',
            'last' => 'Chicken'
          }
        ]

        expect(payload[register]).to eq(expected)
      end
    end
  end
end
