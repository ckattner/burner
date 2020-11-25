# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Graph do
  let(:denormalized_objects) do
    [
      {
        'first' => 'captain',
        'id' => 1,
        'last' => 'kangaroo',
        'child_id' => 2,
        'child_first' => 'funky',
        'child_last' => 'chicken'
      },
      {
        'first' => 'captain',
        'id' => 1,
        'last' => 'kangaroo',
        'child_id' => 3,
        'child_first' => 'frank',
        'child_last' => 'rizzo'
      },
    ]
  end

  let(:config) do
    {
      types: {
        person: {
          properties: %w[first id last]
        },
        child: {
          properties: {
            'first' => 'child_first',
            'id' => 'child_id',
            'last' => 'child_last'
          }
        }
      },
      groups: {
        people: {
          by: %w[id],
          type: :person,
          groups: {
            'children' => {
              by: %w[id child_id],
              type: :child
            }
          }
        }
      }
    }
  end

  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => denormalized_objects }) }

  subject do
    described_class.make(
      name: 'test',
      key: :people,
      config: config,
      register: register
    )
  end

  describe '#perform' do
    it 'returns mapped object' do
      subject.perform(output, payload)

      expected = [
        {
          'children' => [
            {
              'first' => 'funky',
              'id' => 2,
              'last' => 'chicken'
            },
            {
              'first' => 'frank',
              'id' => 3,
              'last' => 'rizzo'
            }
          ],
          'first' => 'captain',
          'id' => 1,
          'last' => 'kangaroo'
        }
      ]

      expect(payload[register]).to eq(expected)
    end
  end
end
