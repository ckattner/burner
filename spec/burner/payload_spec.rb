# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Payload do
  let(:params) do
    {
      name: 'Funky',
      __dupe_register: 'I am from paramland'
    }
  end

  let(:registers) do
    {
      name2: 'Chicken',
      dupe: 'I am from registerland'
    }
  end

  subject { described_class.new(params: params, registers: registers) }

  describe '#params_and_registers_hash' do
    let(:actual) { subject.params_and_registers_hash }

    it 'prefixes registers with __ and suffixes registers with _register' do
      expect(actual['__name2_register']).to eq('Chicken')
    end

    it 'contains params verbatim' do
      expect(actual['name']).to eq('Funky')
    end

    context 'when the same key exists in params and registers' do
      # Very unlikely case, but test it to prove which takes precedence.
      it 'prefers registers over params' do
        expect(actual['__dupe_register']).to eq('I am from registerland')
      end
    end
  end
end
