# 1.3.0 (TBD)

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
