# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Nothing do
  let(:payload) { Burner::Payload.new }

  subject { described_class.make(name: 'test') }

  describe '#perform' do
    it "does not change payload's value" do
      subject.perform(nil, payload)

      expect(payload.registers).to eq({})
    end
  end
end
