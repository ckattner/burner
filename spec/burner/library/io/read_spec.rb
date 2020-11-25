# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::IO::Read do
  let(:path)       { File.join('spec', 'fixtures', 'basic.txt') }
  let(:params)     { { path: path } }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new(params: params) }
  let(:register)   { 'register_a' }

  subject { described_class.make(name: 'test', path: '{path}', register: register) }

  describe '#perform' do
    it "sets payload's value to file contents" do
      subject.perform(output, payload)

      expect(payload[register]).to eq("I was read in from disk.\n")
    end
  end
end
