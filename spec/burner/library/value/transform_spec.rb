# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Value::Transform do
  let(:value) do
    [
      { id: 1, name: 'bozo' },
      { id: 2, name: 'rizzo' },
      { id: 3, name: 'dunzo' }
    ]
  end

  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }
  let(:register)   { 'register_a' }

  let(:transformers) do
    [
      {
        type: 'r/collection/at_index',
        index: 1
      },
      {
        type: 'r/format/string_template',
        expression: 'id: {id}, name: {name}'
      },
      {
        type: 'r/format/uppercase'
      },
    ]
  end

  subject do
    described_class.make(
      name: 'test',
      register: register,
      transformers: transformers
    )
  end

  describe '#perform' do
    it 'sets value' do
      subject.perform(output, payload)

      actual   = payload[register]
      expected = 'ID: 2, NAME: RIZZO'

      expect(actual).to eq(expected)
    end
  end
end
