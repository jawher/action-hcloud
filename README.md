# GitHub Action for hcloud, aka Hetzner CLI

This action enables you to interact with [Hetzner](https://www.hetzner.com/) services via [the `hcloud` command-line client](https://github.com/hetznercloud/cli/).

## Usage

1. Generate an API token from https://console.hetzner.cloud/
2. Configure the action with the required environment variable `HCLOUD_TOKEN`
2. Pass the command to execute using `hcloud`
3. Every step invoking this action writes the stdout to `${GITHUB_WORKSPACE}/hcloud.output`. You can then use this file in later steps. Please note that subsequent calls to this action will overwrite this file, so you might want to copy it to another file if you'll still need it later.

Here's an example which starts a `DEV1-S` instance in the `fr-par-1` region:

```yaml
    - name: Create a new instance
        uses: jawher/action-hcloud@v1.51.0
        env:
          HCLOUD_TOKEN: ${{ secrets.HCLOUD_TOKEN }}
        with:
          args: server create --location=fsn1 --image=ubuntu-22.04 --ssh-key=mine --type=cx11 --name=server0

    - name: Describe new instance
        uses: jawher/action-hcloud@v1.51.0
        env:
          HCLOUD_TOKEN: ${{ secrets.HCLOUD_TOKEN }}
        with:
          args: server describe server0 -o=json

    - name: Expose new server IP in $INSTANCE_IP env var
      run: echo INSTANCE_IP=$(cat "${GITHUB_WORKSPACE}/hcloud.output" | jq -er '.public_net.ipv4.ip') >> $GITHUB_ENV

      - name: Do something with the instance
        run: ...

      - name: Delete instance
        uses: jawher/action-hcloud@v1.51.0
        env:
          HCLOUD_TOKEN: ${{ secrets.HCLOUD_TOKEN }}
        with:
          args: server delete server0
```

### Secrets

- `HCLOUD_TOKEN` – **Required**: a Hetzner API token ([more info](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/)).

## Versioning

This action uses the following versioning scheme:

```
jawher/action-hcloud@v{M.m.p}[-{a}]
```

Where:

* `{M.m.p}` is the `hcloud` CLI version: Major, Minor and patch
* `{a}` is an optional additional version for the action: there may be multiple versions of this action for a single CLI version, e.g. `v1.1.0-2` which would be a second release of the action but still use the same hcloud CLI `1.1.0` as before.

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

## Credits

This action is heavily inspired from [DigitalOcean/action-doctl](https://github.com/digitalocean/action-doctl)

## See Also
I also maintain a similar action but for Scaleway, see [jawher/action-scw](https://github.com/jawher/action-scw)
