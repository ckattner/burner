# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Group do
  let(:statuses) do
    [
      {
        'status_id' => 1,
        'code1' => 'A',
        'code2' => 'z',
        'priority' => 100
      },
      {
        'status_id' => 2,
        'code1' => :b,
        'code2' => 'y',
        'priority' => 200
      }
    ]
  end

  let(:keys)       { %w[code1 code2] }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_b' }
  let(:insensitive) { false }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        register => statuses
      }
    )
  end

  subject do
    described_class.make(
      insensitive: insensitive,
      keys: keys,
      name: 'test',
      register: register
    )
  end

  describe '#perform' do
    before(:each) do
      subject.perform(output, payload)
    end

    it 'groups by keys' do
      expected = {
        %w[A z] => {
          'status_id' => 1,
          'code1' => 'A',
          'code2' => 'z',
          'priority' => 100
        },
        [:b, 'y'] => {
          'status_id' => 2,
          'code1' => :b,
          'code2' => 'y',
          'priority' => 200
        }
      }

      expect(payload[register]).to eq(expected)
    end

    context 'when insensitive' do
      let(:insensitive) { true }

      specify 'all keys are arrays of downcased strings' do
        expected = {
          %w[a z] => {
            'status_id' => 1,
            'code1' => 'A',
            'code2' => 'z',
            'priority' => 100
          },
          %w[b y] => {
            'status_id' => 2,
            'code1' => :b,
            'code2' => 'y',
            'priority' => 200
          }
        }

        expect(payload[register]).to eq(expected)
      end
    end
  end
end
