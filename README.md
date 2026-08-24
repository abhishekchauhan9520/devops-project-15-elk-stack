# Project 15 — Centralized Log Management with ELK Stack

A reproducible Docker Compose lab demonstrating centralized log ingestion with Elasticsearch, Logstash, and Kibana.

## Architecture

```text
Application / TCP client
        |
        v
   Logstash :5000
        |
        v
Elasticsearch :9200
        |
        v
  Kibana :5601
```

## Components

- Elasticsearch 9.5.2 — stores and indexes logs.
- Logstash 9.5.2 — receives JSON Lines over TCP and writes daily indexes.
- Kibana 9.5.0 — visualization and exploration UI.

The Elastic Docker registry currently publishes these pinned container tags. citeturn763148search0turn763148search4

## Start

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
curl http://localhost:9200/_cluster/health
curl http://localhost:5601/api/status
```

Send a test event:

```bash
./scripts/send-test-log.sh "Hello from Project 15"
```

Then open Kibana at `http://localhost:5601` and create a data view for:

```text
project15-logs-*
```

## Stop and clean up

```bash
docker compose down
```

Remove the Elasticsearch data volume too:

```bash
docker compose down -v
```

## Testing

```bash
./tests/test_project.sh
docker compose config -q
```

GitHub Actions runs the structural checks and Compose configuration validation.

## Important lab note

This configuration disables Elasticsearch security for local learning and is **not** a production security configuration. Production deployments should enable authentication/TLS, secure secrets, restrict network exposure, and use appropriate resource sizing.
