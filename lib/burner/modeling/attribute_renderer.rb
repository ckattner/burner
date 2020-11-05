# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Modeling
    # Composed of an Attribute instance and a Pipeline instance.  It knows how to
    # render/transform an Attribute.  Since this library is data-first, these intermediary
    # objects are necessary for non-data-centric modeling.
    class AttributeRenderer
      extend Forwardable

      attr_reader :attribute, :pipeline

      def_delegators :attribute, :key

      def_delegators :pipeline, :transform

      def initialize(attribute, resolver)
        @attribute = attribute
        @pipeline  = Realize::Pipeline.new(attribute.transformers, resolver: resolver)

        freeze
      end
    end
  end
end
