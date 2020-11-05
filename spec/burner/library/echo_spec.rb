# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Echo do
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new(params: params, registers: registers) }

  subject { described_class.make(name: 'test', message: message) }

  describe '#perform' do
    context 'param templating' do
      let(:message)   { 'Hello, {name}!' }
      let(:params)    { { name: 'McBoaty' } }
      let(:registers) { {} }

      it 'outputs templated message' do
        subject.perform(output, payload)

        expect(string_out.read).to include('Hello, McBoaty!')
      end
    end

    context 'register templating' do
      let(:message) { 'Hello, {__first_name_register} {__last_name_register}!' }
      let(:params)  { {} }
      let(:registers) do
        {
          'first_name' => 'Boaty',
          'last_name' => 'FaceMcBoat'
        }
      end

      it 'can access and string-template registers' do
        subject.perform(output, payload)

        expect(string_out.read).to include('Hello, Boaty FaceMcBoat!')
      end
    end
  end
end
