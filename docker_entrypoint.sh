#!/bin/bash

set -ea

echo "Starting nostr-rs-relay..."
exec ./nostr-rs-relay --db ${APP_DATA}