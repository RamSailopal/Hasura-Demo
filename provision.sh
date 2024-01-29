#!/bin/bash
apt update
apt install -y curl
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
tail -f /dev/null
