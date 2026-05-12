# adbx-master

Meta-repo that bundles the [adbx](https://github.com/sidferreira/adbx) CLI and its [homebrew tap](https://github.com/sidferreira/homebrew-adbx) as submodules.

## Clone

```sh
git clone --recurse-submodules git@github.com:sidferreira/adbx-master.git
```

If you've already cloned without `--recurse-submodules`:

```sh
git submodule update --init --recursive
```

## Layout

| Path | Repo |
|---|---|
| `adbx/` | [sidferreira/adbx](https://github.com/sidferreira/adbx) — the CLI |
| `homebrew-adbx/` | [sidferreira/homebrew-adbx](https://github.com/sidferreira/homebrew-adbx) — the Homebrew tap |
