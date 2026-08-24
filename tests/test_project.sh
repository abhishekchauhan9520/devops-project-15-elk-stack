#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT" <<'PY'
import sys, yaml
from pathlib import Path
root = Path(sys.argv[1])
compose = yaml.safe_load((root/'docker-compose.yml').read_text())
services = compose['services']
assert set(services) == {'elasticsearch','logstash','kibana'}
assert services['elasticsearch']['environment'][0] == 'discovery.type=single-node'
assert services['logstash']['depends_on']['elasticsearch']['condition'] == 'service_healthy'
assert services['kibana']['depends_on']['elasticsearch']['condition'] == 'service_healthy'
for name in services:
    assert 'healthcheck' in services[name]
pipeline = (root/'logstash/pipeline/logstash.conf').read_text()
for token in ['tcp {','port => 5000','codec => json_lines','elasticsearch {','index => "project15-logs-%{+YYYY.MM.dd}"']:
    assert token in pipeline, token
print('Project 15 structural checks passed.')
PY
bash -n "$ROOT/scripts/send-test-log.sh"
echo 'Project 15 shell checks passed.'
