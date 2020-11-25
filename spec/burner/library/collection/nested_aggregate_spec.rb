# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::NestedAggregate do
  let(:patients) do
    [
      {
        'id' => 'p1',
        'first_name' => 'Bozo',
        'notes' => [
          { 'id' => 'n1', 'contents' => 'Hello World 1!' },
          { 'id' => 'n2', 'contents' => 'Hello World 2!' }
        ]
      },
      {
        'id' => 'p2',
        'first_name' => 'Frank',
        'notes' => [
          { 'id' => 'n3', 'contents' => 'Hello World 3!' },
          { 'id' => 'n4', 'contents' => 'Hello World 4!' }
        ]
      },
      {
        'id' => 'p3',
        'first_name' => 'Hops',
        'notes' => nil
      },
      {
        'id' => 'p4',
        'first_name' => 'Matt',
        'notes' => { 'id' => 'n5', 'contents' => 'Hello World 5!' }
      }
    ]
  end

  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => patients }) }
  let(:key)        { 'notes' }

  let(:key_mappings) do
    [
      {
        from: :id,
        to: :patient_id
      },
      {
        from: :first_name
      }
    ]
  end

  subject do
    described_class.make(
      name: 'test',
      key: key,
      key_mappings: key_mappings,
      register: register
    )
  end

  describe '#perform' do
    before(:each) { subject.perform(output, payload) }

    it 'collects and copies down objects' do
      expected = [
        {
          'patient_id' => 'p1',
          'first_name' => 'Bozo',
          'id' => 'n1',
          'contents' => 'Hello World 1!'
        },
        {
          'patient_id' => 'p1',
          'first_name' => 'Bozo',
          'id' => 'n2',
          'contents' => 'Hello World 2!'
        },
        {
          'patient_id' => 'p2',
          'first_name' => 'Frank',
          'id' => 'n3',
          'contents' => 'Hello World 3!'
        },
        {
          'patient_id' => 'p2',
          'first_name' => 'Frank',
          'id' => 'n4',
          'contents' => 'Hello World 4!'
        },
        {
          'patient_id' => 'p4',
          'first_name' => 'Matt',
          'id' => 'n5',
          'contents' => 'Hello World 5!'
        }
      ]

      expect(payload[register]).to eq(expected)
    end
  end
end
