# Traefik PE trailer (local)

This repo contains the GitOps config for the Platform Engineer job trailer @ Traefik Labs.

## Tools

For tackling this problem, I'll be using the following tools:

- [k3s](https://k3s.io) for local k8s
- [k3d](https://k3d.io) for local [k3s](https://k3s.io) in Docker
- [FluxCD](https://fluxcd.io) for GitOps management of clusters
- [Traefik Proxy](https://traefik.io) for load balancing and routing
- [Foobar API](https://github.com/LBF38/foobar-api) - the app to deploy and expose on both clusters
- [Cert-manager](https://cert-manager.io) / [Let's Encrypt](https://letsencrypt.org) for TLS certs and ACME to protect traffic

## Prerequisites

- Please fork or clone this repo in your own remote git server. (GitHub, GitLab, ...)
- Install necessary CLIs (`k3d`, `flux`, `kubectl`)
- Create a PAT for FluxCD with at least `repo` permissions. See [FluxCD bootstrap installation documentation](https://fluxcd.io/flux/installation/bootstrap/) for more info for your setup.

## Steps

1. I first deployed two local clusters (`EU` and `US`) for simulating region-based clusters.
   Run the following command:

   ```bash
   ./scripts/init-clusters.sh
   ```

2. Once ready, install FluxCD using the `bootstrap` cmd.

   ```bash
   GITHUB_TOKEN=<yourtoken>
   GITHUB_USER=LBF38
   flux bootstrap github \
    --owner=$GITHUB_USER \
    --repository=traefik-pe-trailer \
    --branch=main \
    --path=./clusters/eu \
    --personal
   ```

3. You should see some outputs on your console. You can check that everything is ready with the cmd:

   `flux get all -A`

4. You can test that apps are exposed by calling these endpoints:

   ```bash
   curl -k https://foobar-eu.cloud.local
   curl -k https://foobar-us.cloud.local
   curl -k https://foobar.cloud.local
   ```

5. You can browse the Traefik Dashboard by visiting <https://localhost/dashboard/>.

## Bugs

### Load balancing across clusters

> [!WARNING]
>
> This feature isn't ready yet.
> The Traefik dynamic configuration is defined [in this file](./infrastructure/eu/traefik-proxy/traefik-proxy-configs.yaml) for load balancing across clusters but there are some issues with DNS resolving and network connectivity between clusters.

## Enhancements

### Distributed ACME

> [!TIP]
>
> Currently, the certificates are independantly managed by each cluster.
> A better solution would be to have shared certificates across all clusters.
>
> This is possible by using shared storage across both clusters, or by using [HashiCorp Vault](https://developer.hashicorp.com/vault), or a mechanism to share/sync data across multiple clusters like [Longhorn](https://longhorn.io).
>
> Traefik can offer this distributed ACME with Traefik Hub. [See the configuration in the documentation](https://doc.traefik.io/traefik-hub/api-gateway/secure/tls/letsencrypt#configuring-distributed-acme).

### ClusterAPI

> [!TIP]
>
> Make use of [ClusterAPI](https://cluster-api.sigs.k8s.io/) to have Kubernetes Clusters as a Service.
>

### Security

> [!TIP]
>
> Enhance pod and cluster security by fine-tuning each k8s component to have least-priviledges.

### Observability

> [!TIP]
>
> Instrument and monitor apps, infra and cluster telemetry to better manage cloud resources.
>
> This can be implemented using [OpenTelemetry](https://opentelemetry.io) and stored in tools like [Grafana](https://grafana.com), [Jaeger](https://jaegertracing.io) and [Prometheus](https://prometheus.io) among others.

## Usage examples

See some results of this configuration with images [in the examples file](./EXAMPLES.md).

## Notes

### FluxCD

Created this repo using the `flux bootstrap` CLI:

Before running the command, we need to export the following env vars:

```bash
export GITHUB_TOKEN=<your PAT>
export GITHUB_USER=<your username>
```

```bash
GITHUB_USER=LBF38
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=traefik-pe-trailer \
  --branch=main \
  --path=./clusters/eu \
  --personal
```

Then, use the `flux create` command to add configs in the repo.
For example, to add a git source, we can use the following:

```bash
flux create source git <name> --url=<git url> --export > gitrepo.yml
```

Then, commit the file to be processed by `FluxCD`.

See more options on the [FluxCD CLI documentation](https://fluxcd.io/flux/cmd).

### Traefik Proxy Dashboard

Expose the Traefik Dashboard with the following command:

```bash
NAMESPACE=traefik-system
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n $NAMESPACE) 8080:8080 -n $NAMESPACE
```

## Author

[@LBF38](https://github.com/LBF38)
