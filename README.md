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
        uses: jawher/action-hcloud@v1.30.4
        env:
          HCLOUD_TOKEN: ${{ secrets.HCLOUD_TOKEN }}
        with:
          args: instance server create image=ubuntu_bionic type=DEV1-S name=workhorse tags.0=temp tags.1=workhorse --wait -o=json

      - name: Get instance id and expose it in INSTANCE_ID env var
        run: echo ::set-env name=INSTANCE_ID::$(cat "${GITHUB_WORKSPACE}/hcloud.output" | jq -r '.id')

      - name: Do something with the instance
        run: ...

      - name: Delete instance
        uses: jawher/action-hcloud@v1.30.4
        env:
          HCLOUD_TOKEN: ${{ secrets.HCLOUD_TOKEN }}
        with:
          args: instance server delete server-id=${{ env.INSTANCE_ID }} with-ip=true force-shutdown=true
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
* `{a}` is the action single version number: there may be multiple versions of this action for a single CLI version, e.g. `v2.6.2` uses the same hcloud CLI `2.4.4` as before, but adds support for the newly added region parameter.

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

## Credits

This action is heavily inspired from [DigitalOcean/action-doctl](https://github.com/digitalocean/action-doctl)
