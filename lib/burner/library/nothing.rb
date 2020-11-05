# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    # Do nothing.
    #
    # Note: this does not use Payload#registers.
    class Nothing < Job
      def perform(_output, _payload); end
    end
  end
end
