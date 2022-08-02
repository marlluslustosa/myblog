#!/bin/bash

token=$1
api=https://lulucount.goatcounter.com/api/v0
curl() {
    \command curl \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $token" \
        "$@" \
	-k
}

# Start a new export, get ID from response object.
id=$(curl -X POST "$api/export" | jq .id)

# The export is started in the background, so we'll need to wait until it's finished.
while :; do
    sleep 1

    finished=$(curl "$api/export/$id" | jq .finished_at)
    if [ "$finished" != "null" ]; then
        # Download the export.
        curl "$api/export/$id/download" | gzip -d

        break
    fi
done

