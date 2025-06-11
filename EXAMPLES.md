# Examples

This file contains some illustrated examples of calling an app API.

<details>
<summary><code>./scripts/init-clusters.sh</code> - starting local clusters</summary>

![init-clusters](docs/image.png)

</details>

<details>
<summary><code>flux get all -A</code> on EU cluster</summary>

![flux components](docs/image-2.png)

</details>

<details>
<summary><code>k get all -n apps</code> on US cluster</summary>

See the `foobar` deployment.

![foobar deployment](docs/image-1.png)

</details>

<details>
<summary>
<code>curl -k https://foobar.cloud.local</code>
</summary>

This endpoint should load balance between EU and US.
Right now, it doesn't for technical reasons. (DNS and network issues)

![lb foobar](docs/image-3.png)

</details>

<details>
<summary>
<code>curl -k https://foobar-eu.cloud.local</code>
</summary>

This endpoint only returns EU responses.

![foobar EU](docs/image-4.png)

</details>

<details>
<summary>
<code>curl -k https://foobar-us.cloud.local</code>
</summary>

This endpoint only returns US responses.

![foobar US](docs/image-5.png)

</details>

<details>
<summary>
Visit <a href="https://localhost/dashboard/">https://localhost/dashboard/</a> or <a href="https://localhost:444/dashboard/">https://localhost:444/dashboard/</a>
</summary>

EU Dashboard
![EU Traefik dashboard](docs/image-6.png)

US Dashboard:
![US Traefik dashboard](docs/image-7.png)
</details>
