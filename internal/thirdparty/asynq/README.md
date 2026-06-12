# Patched copy of github.com/hibiken/asynq v0.24.1

This is a local copy of the `github.com/hibiken/asynq` v0.24.1 source, trimmed
to only the packages needed to build asynqmon (no `_test.go` files, no docs,
no CLI tooling), wired in via the `replace` directive in [go.mod](../../../go.mod).

## Why this exists

`internal/rdb/inspect.go`'s `memoryUsageCmd` Lua script (used by
`Inspector.GetQueueInfo`, which powers the `/api/queues` endpoint / dashboard
queue list) crashes with:

```
ERR user_script:30: attempt to perform arithmetic on local 'bytes' (a boolean value)
```

whenever `MEMORY USAGE` is called on a sampled task key that has already
expired/been deleted from Redis (`MEMORY USAGE` returns `nil` -> `false` in
Lua, and the script does arithmetic on it).

This is fixed upstream by https://github.com/hibiken/asynq/pull/1092, merged to
`master` on 2026-04-09 - but no asynq release since v0.26.0 (2026-02-03) has
shipped it, and v0.26.0+ requires Go 1.24 / go-redis v9.14, which would force a
much larger toolchain, Dockerfile, and CI upgrade just to get this one-file fix.

So instead, this directory carries v0.24.1 (the version asynqmon already
depends on, requires only Go 1.14) with PR #1092's patch applied directly to
`internal/rdb/inspect.go`.

## Removal

Once asynqmon upgrades to an asynq release that includes PR #1092 (anything
after v0.26.0, once tagged), delete this directory and the corresponding
`replace` directive in go.mod, and bump the `github.com/hibiken/asynq`
requirement to that release.
