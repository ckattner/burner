# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Param::FromRegister do
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:param_key)  { 'name' }

  let(:payload) do
    Burner::Payload.new(
      params: { param_key => 'frodo' },
      registers: { register => 'bobo' }
    )
  end

  subject do
    described_class.make(
      name: 'test',
      param_key: param_key,
      register: register
    )
  end

  describe '#perform' do
    before do
      subject.perform(output, payload)
    end

    it 'sets the param key to the specified registers value' do
      expect(payload.param(param_key)).to eq('bobo')
    end

    it 'outputs the register name' do
      expect(string_out.string).to include(register)
    end

    it 'outputs the param name' do
      expect(string_out.string).to include(param_key)
    end
  end
end
