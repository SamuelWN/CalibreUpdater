#!/bin/bash


calibre-debug -c "
import urllib.request;
import ssl;
from calibre.constants import numeric_version;
ctx=ssl._create_unverified_context();


latest_version=urllib.request.urlopen('http://calibre-ebook.com/downloads/latest_version', context=ctx).read().decode(encoding = 'UTF-8')

print('Latest version: %s, Current version: %s' % (
        latest_version,
        '.'.join(map(str, numeric_version))
    )
)

raise SystemExit(
    int(
        numeric_version  < (
            tuple(map(int, latest_version.split('.')))
        )
    )
)
"

let EXIT_STATUS="$?"

SCRIPT_DIR="$(realpath "$(dirname "$0")")"

if [[ "${EXIT_STATUS}" -eq 0 ]]; then
    echo "Calibre is up-to-date."
else
    echo "An update for Calibre is available."
    sudo sh "${SCRIPT_DIR}/calibre-installer.sh"
fi
