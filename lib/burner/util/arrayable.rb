# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Util
    # Provide helper methods for dealing with Arrays.
    module Arrayable
      # Since Ruby's Kernel#Array will properly call #to_a for scalar Hash objects, this could
      # return something funky in the context of this library.  In this library, Hash instances
      # are typically viewed as an atomic key-value-based "object".  This library likes to deal
      # with object-like things, treating Hash, OpenStruct, Struct, or Object subclasses as
      # basically the same thing.  In this vein, this library leverages Objectable to help
      # unify access data from objects.  See the Objectable library for more information:
      # https://github.com/bluemarblepayroll/objectable
      def array(value)
        if value.is_a?(Hash)
          [value]
        else
          Array(value)
        end
      end
    end
  end
end
