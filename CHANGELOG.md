# 1.12.0.pre.alpha (TBD)

Enhanced Job:

* b/collection/flat_file_parse now supports key mappings.

Added Jobs:

* b/collection/prepend (alias for unshift)
* b/collection/unshift

# 1.11.0 (May 17th, 2021)

Added Jobs:

* b/collection/flat_file_parse

# 1.10.0 (May 17th, 2021)

Added Jobs:

* b/collection/only_keys
# 1.9.0 (April 13th, 2021)

Added Jobs:

* b/collection/pivot
# 1.8.0 (March 31st, 2021)

Added Jobs:

* b/param/from_register
* b/param/to_register

Other:

* Payload#param was added to access a param key's value.
* Payload#update_param was added to update a param key's value.

Internal Notes:

Payload#register and Payload#params data stores have been internally consolidated while still maintaining the same public API surface area.

# 1.7.0 (January 22nd, 2021)

Added Jobs:

* b/collection/number
* b/value/nest
* b/value/transform

Enhanced Jobs:

* b/collection/coalesce and b/collection/group now support the notion of case and type-insensitivity (insensitive option).

Changes:

* Job names derived from Burner::Job are now optional.  Pipelines themselves now can handle jobs without names.

# 1.6.0 (December 22nd, 2020)

Additions:

* b/io/write now provides an optional `supress_side_effect` option.
# 1.5.0 (December 21st, 2020)

Added Jobs:

* b/collection/zip
# 1.4.0 (December 17th, 2020)

Additions:

* byte_order_mark option for b/serialize/csv job

Added Jobs:

* b/compress/row_reader
* b/io/row_reader
# 1.3.0 (December 11th, 2020)

Additions:

* Decoupled storage: `Burner::Disks` factory, `Burner::Disks::Local` reference implementation, and `b/io/*` `disk` option for configuring IO jobs to use custom disks.
# 1.2.0 (November 25th, 2020)

#### Enhancements:

* All for a pipeline to be configured with null steps.  When null, just execute all jobs in positional order.
* Allow Collection::Transform job attributes to implicitly start from a resolve transformer.  `explicit: true` can be passed in as an option in case the desire is to begin from the record and not a specific value.

#### Added Jobs:

* b/collection/nested_aggregate
# 1.1.0 (November 16, 2020)

Added Jobs:

* b/collection/coalesce
* b/collection/group

# 1.0.0 (November 5th, 2020)

Initial version publication.

# 0.0.1

Shell
