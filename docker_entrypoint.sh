#!/bin/bash

set -ea

echo "Starting nostr-rs-relay..."
exec ls -a 
exec tini -s .nostr-rs-relay/.sh 