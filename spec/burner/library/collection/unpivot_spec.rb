# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Unpivot do
  let(:patients) do
    [
      {
        'patient_id' => 2,
        'first_exam_date' => '2020-01-03',
        'last_exam_date' => '2020-04-05',
        'consent_date' => '2020-01-02'
      }
    ]
  end

  let(:pivot_set) do
    {
      pivots: [
        {
          keys: %w[first_exam_date last_exam_date consent_date],
          coalesce_key: 'field',
          coalesce_key_value: 'value'
        }
      ]
    }
  end

  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => patients }) }

  subject { described_class.make(name: 'test', pivot_set: pivot_set, register: register) }

  describe '#perform' do
    it 'returns mapped object' do
      subject.perform(output, payload)

      expected = [
        {
          'field' => 'first_exam_date',
          'patient_id' => 2,
          'value' => '2020-01-03'
        },
        {
          'field' => 'last_exam_date',
          'patient_id' => 2,
          'value' => '2020-04-05'
        },
        {
          'field' => 'consent_date',
          'patient_id' => 2,
          'value' => '2020-01-02'
        }
      ]

      expect(payload[register]).to eq(expected)
    end
  end
end
