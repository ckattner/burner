# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Modeling::Validations::Present do
  let(:key)      { :name }
  let(:message)  { ' should be present!' }
  let(:resolver) { Objectable.resolver }

  subject { described_class.new(key: key, message: message) }

  describe '#valid?' do
    {
      'nil' => nil,
      '' => '',
      'space' => ' ',
      'tab' => "\t",
      'newline' => "\n",
      'carriage return and newline' => "\r\n",
      'unicode whitespace' => "\u00a0"
    }.each do |name, value|
      it "returns false when #{name}" do
        actual = subject.valid?({ name: value }, resolver)

        expect(actual).to be false
      end
    end

    it 'returns true when populated string' do
      actual = subject.valid?({ name: 'ABC' }, resolver)

      expect(actual).to be true
    end
  end

  specify '#message contains right copy' do
    actual = subject.message

    expect(actual).to eq(message)
  end
end
