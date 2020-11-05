# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Validate do
  let(:valid)            { { 'id' => '1', 'name' => nil } }
  let(:invalid)          { { 'id' => '', 'name' => 'funky' } }
  let(:all)              { [valid, invalid] }
  let(:string_out)       { StringOut.new }
  let(:output)           { Burner::Output.new(outs: string_out) }
  let(:register)         { 'register_a' }
  let(:invalid_register) { 'register_b' }
  let(:payload)          { Burner::Payload.new(registers: { register => all }) }
  let(:message_key)      { 'problems' }
  let(:join_char)        { '; ' }

  let(:validations) do
    [
      {
        type: :present,
        key: :id
      },
      {
        type: :blank,
        key: :name
      },
    ]
  end

  subject do
    described_class.make(
      name: 'test',
      message_key: message_key,
      invalid_register: invalid_register,
      register: register,
      validations: validations,
      join_char: join_char
    )
  end

  describe '#perform' do
    before(:each) { subject.perform(output, payload) }

    it 'executes all validations and splits collection' do
      expect(payload[register]).to         eq([valid])
      expect(payload[invalid_register]).to eq([invalid])
    end

    it 'adds messages to invalid' do
      expected = 'id is required; name must be blank'

      expect(payload[invalid_register][0]['problems']).to eq(expected)
    end
  end
end
