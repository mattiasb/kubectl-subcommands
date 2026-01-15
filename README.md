# Kubectl Subcommands

Various [kubectl][] sub-commands that I've made and use daily.

## Install

Just run `make install`.

## Configuration

You might want to make BASH ignore `kubectl-` and `kubectl_` sub-commands when
completing commands by adding the following to your `~/.bashrc`:
```bash
export EXECIGNORE="${EXECIGNORE:+${EXECIGNORE}:}*/kubectl-*:*/kubectl_*"
```

## Available commands

## `kubectl each`

Run a `kubectl` command on each context in your Kubernetes configuration. 

#### Caveats

- Will pipe the output to `sed 's/^/ /'` to indent by 4 which means this won't
  work for interactive commands!
- BASH completion doesn't work!

### `kubectl context`

A more ergonomic way of switching `kubectl` context than manual calls to
`kubectl config use-context`.

### `kubectl namespace`

A more ergonomic way of switching `kubectl` namespace than manual calls to
`kubectl config set-context --current --namespace=<NAMESPACE>`.

<!----------------------------------------------------------------------------->

[kubectl]: https://kubernetes.io/docs/reference/kubectl/
