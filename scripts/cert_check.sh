#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

url=${1}
port=${2:-443}

openssl s_client -showcerts \
    -connect ${url}:${port} 2>/dev/null < /dev/null | \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | \
    sed -e ':a;N;$!ba;s/-\n-/-$-/g' -e 's/\n/***/g' -e 's/\$/\n/g' | \
    xargs -d $'\n' -I % bash -c 'echo % | sed -e "s/\*\*\*/\n/g" | openssl x509 -noout -text' | \
    grep -P '(Issuer:|After|IP)'
