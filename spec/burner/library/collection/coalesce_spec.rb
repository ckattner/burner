# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Coalesce do
  let(:patients) do
    [
      {
        'first' => 'captain',
        'id' => 10_000,
        'last' => 'kangaroo',
        'status_code1' => 'A',
        'status_code2' => 'z'
      },
      {
        'first' => 'captain',
        'id' => 10_001,
        'last' => 'kangaroo',
        'status_code1' => :b,
        'status_code2' => 'y'
      },
      {
        'first' => 'captain',
        'id' => 10_001,
        'last' => 'kangaroo',
        'status_code1' => 'c',
        'status_code2' => 'x'
      },
    ]
  end

  let(:key_mappings) do
    [
      {
        from: 'id',
        to: 'status_id'
      }
    ]
  end

  let(:keys)              { %w[status_code1 status_code2] }
  let(:string_out)        { StringIO.new }
  let(:output)            { Burner::Output.new(outs: [string_out]) }
  let(:patients_register) { 'register_a' }
  let(:statuses_register) { 'register_b' }
  let(:insensitive) { false }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        patients_register => patients,
        statuses_register => statuses_by_codes
      }
    )
  end

  subject do
    described_class.make(
      insensitive: insensitive,
      key_mappings: key_mappings,
      keys: keys,
      name: 'test',
      register: patients_register,
      grouped_register: statuses_register
    )
  end

  describe '#perform' do
    before(:each) do
      subject.perform(output, payload)
    end

    context 'with hydrated grouped register' do
      let(:statuses_by_codes) do
        {
          %w[A z] => {
            'id' => 1,
            'code1' => 'a',
            'code2' => 'z',
            'priority' => 100
          },
          [:b, 'y'] => {
            'id' => 2,
            'code1' => 'b',
            'code2' => 'y',
            'priority' => 200
          }
        }
      end

      it 'finds grouped record by keys and sets key mappings' do
        actual_status_ids = payload[patients_register].map { |r| r['status_id'] }

        expect(actual_status_ids).to eq([1, 2, nil])
      end
    end

    context 'when grouped_register is null' do
      let(:statuses_by_codes) { nil }

      it 'sets key mappings to null' do
        actual_status_ids = payload[patients_register].map { |r| r['status_id'] }

        expect(actual_status_ids).to eq([nil, nil, nil])
      end
    end

    context 'when insensitive is true' do
      let(:insensitive) { true }

      let(:statuses_by_codes) do
        {
          %w[a z] => {
            'id' => 1,
            'code1' => 'a',
            'code2' => 'z',
            'priority' => 100
          },
          %w[b y] => {
            'id' => 2,
            'code1' => 'b',
            'code2' => 'y',
            'priority' => 200
          }
        }
      end

      specify 'keys will be looked up by their lowercase string representations' do
        actual_status_ids = payload[patients_register].map { |r| r['status_id'] }

        expect(actual_status_ids).to eq([1, 2, nil])
      end
    end
  end
end
