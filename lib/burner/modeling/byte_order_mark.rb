# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Modeling
    # Define all acceptable byte order mark values.
    module ByteOrderMark
      UTF_8    = "\xEF\xBB\xBF"
      UTF_16BE = "\xFE\xFF"
      UTF_16LE = "\xFF\xFE"
      UTF_32BE = "\x00\x00\xFE\xFF"
      UTF_32LE = "\xFE\xFF\x00\x00"

      class << self
        def resolve(value)
          value ? const_get(value.to_s.upcase.to_sym) : nil
        end
      end
    end
  end
end
