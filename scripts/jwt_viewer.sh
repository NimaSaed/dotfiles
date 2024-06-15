#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

encoded_jwt=${1}

jwt_header="$(echo $encoded_jwt | tr -d '\n' | cut -d . -f 1)"
jwt_payload="$(echo $encoded_jwt | tr -d '\n' | cut -d . -f 2)"

echo $jwt_header | base64 -d | jq .
echo $jwt_payload | base64 -d | jq .

