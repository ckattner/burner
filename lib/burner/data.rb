# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # Defines a key value pair data store per our library.  It is basically a composite
  # object around a hash with indifferent key typing.
  class Data
    extend Forwardable

    def_delegators :internal_hash, :transform_keys

    def initialize(hash = {})
      @internal_hash = {}

      (hash || {}).each { |k, v| self[k] = v }
    end

    def []=(key, value)
      internal_hash[key.to_s] = value
    end

    def [](key)
      internal_hash[key.to_s]
    end

    def to_h
      internal_hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        to_h == other.to_h
    end
    alias eql? ==

    private

    attr_reader :internal_hash
  end
end
