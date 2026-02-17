# Kubectl Sub-commands

Various [kubectl][] sub-commands that I've made and use daily.

## Install

### Fedora

1. Install `kubectl`:

    ```console
    $ sudo dnf install kubernetes1.35-client # Or a version matching the cluster
    ```

2. Then:

    ```console
    $ sudo dnf install make wl-copy fzf getopt jq
    $ make install
    ```

### Ubuntu / Debian

1. Install `kubectl` [from kubernetes.io][kubectl-install]:
2. Then:
    ```console
    $ sudo apt update
    $ sudo apt install make wl-clipboard fzf jq
    $ make install
    ```

**NOTE**: If you install as a regular user you might have to add `~/.local/bin/`
          to your PATH!

## Sub-commands

### `kubectl each`

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

### `kubectl secret`

Lets you list, copy and show fields in secrets. Does auto completion as well.

## Configuration

You might want to make BASH ignore `kubectl-` and `kubectl_` sub-commands when
completing commands by adding the following to your `~/.bashrc`:
```bash
export EXECIGNORE="${EXECIGNORE:+${EXECIGNORE}:}*/kubectl-*:*/kubectl_*"
```

<!----------------------------------------------------------------------------->

[kubectl]: https://kubernetes.io/docs/reference/kubectl/
[kubectl-install]: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
