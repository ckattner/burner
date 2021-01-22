# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Util
    # Provide helper methods for keys.
    module Keyable
      def make_key(record, keys, resolver, insensitive)
        keys.map do |key|
          value = resolver.get(record, key)

          insensitive ? value.to_s.downcase : value
        end
      end
    end
  end
end
