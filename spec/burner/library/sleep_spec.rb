# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Sleep do
  let(:seconds)    { 0.2 }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new }

  subject { described_class.make(name: 'test', seconds: seconds) }

  describe '#perform' do
    it 'calls Kernel#sleep' do
      expect(Kernel).to receive(:sleep).with(seconds)

      subject.perform(output, payload)
    end
  end
end
