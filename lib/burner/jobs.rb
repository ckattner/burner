# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'library'

module Burner
  # Main library of jobs.  This file contains all the basic/default jobs.  All other consumer
  # libraries/applications can register their own, for example:
  #   Burner::Jobs.register('your_class', YourClass)
  class Jobs
    acts_as_hashable_factory

    # Nothing is the default as noted by the ''.  This means if a type is omitted, nil, or blank
    # string then the nothing job will be used.
    register 'b/echo',                         Library::Echo
    register 'b/nothing', '',                  Library::Nothing
    register 'b/sleep',                        Library::Sleep

    register 'b/collection/arrays_to_objects', Library::Collection::ArraysToObjects
    register 'b/collection/coalesce',          Library::Collection::Coalesce
    register 'b/collection/concatenate',       Library::Collection::Concatenate
    register 'b/collection/group',             Library::Collection::Group
    register 'b/collection/flat_file_parse',   Library::Collection::FlatFileParse
    register 'b/collection/graph',             Library::Collection::Graph
    register 'b/collection/nested_aggregate',  Library::Collection::NestedAggregate
    register 'b/collection/number',            Library::Collection::Number
    register 'b/collection/objects_to_arrays', Library::Collection::ObjectsToArrays
    register 'b/collection/only_keys',         Library::Collection::OnlyKeys
    register 'b/collection/pivot',             Library::Collection::Pivot
    register 'b/collection/shift',             Library::Collection::Shift
    register 'b/collection/transform',         Library::Collection::Transform
    register 'b/collection/unpivot',           Library::Collection::Unpivot
    register 'b/collection/values',            Library::Collection::Values
    register 'b/collection/validate',          Library::Collection::Validate
    register 'b/collection/zip',               Library::Collection::Zip

    register 'b/compress/row_reader',          Library::Compress::RowReader

    register 'b/deserialize/csv',              Library::Deserialize::Csv
    register 'b/deserialize/json',             Library::Deserialize::Json
    register 'b/deserialize/yaml',             Library::Deserialize::Yaml

    register 'b/io/exist',                     Library::IO::Exist
    register 'b/io/read',                      Library::IO::Read
    register 'b/io/row_reader',                Library::IO::RowReader
    register 'b/io/write',                     Library::IO::Write

    register 'b/param/from_register',          Library::Param::FromRegister
    register 'b/param/to_register',            Library::Param::ToRegister

    register 'b/serialize/csv',                Library::Serialize::Csv
    register 'b/serialize/json',               Library::Serialize::Json
    register 'b/serialize/yaml',               Library::Serialize::Yaml

    register 'b/value/copy',                   Library::Value::Copy
    register 'b/value/nest',                   Library::Value::Nest
    register 'b/value/static',                 Library::Value::Static
    register 'b/value/transform',              Library::Value::Transform
  end
end
