#!/bin/bash

set -ea

echo "Starting nostr-rs-relay..."
exec tini -s -- ./nostr-rs-relay --db /usr/src/app/data