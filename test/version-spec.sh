#!/usr/bin/env bash

. $(dirname "${BASH_SOURCE[0]}")/common.sh

$DUB add-local "$CURR_DIR/version-spec/newfoo"
$DUB add-local "$CURR_DIR/version-spec/oldfoo"

[[ $($DUB describe foo | grep path | head -n 1) == *"/newfoo/"* ]]
[[ $($DUB describe foo@1.0.0 | grep path | head -n 1) == *"/newfoo/"* ]]
[[ $($DUB describe foo@0.1.0 | grep path | head -n 1) == *"/oldfoo/"* ]]

[[ $($DUB test foo | head -n 1) == *"/newfoo/" ]]
[[ $($DUB test foo@1.0.0 | head -n 1) == *"/newfoo/" ]]
[[ $($DUB test foo@0.1.0 | head -n 1) == *"/oldfoo/" ]]

[[ $($DUB lint foo | tail -n 1) == *"/newfoo/" ]]
[[ $($DUB lint foo@1.0.0 | tail -n 1) == *"/newfoo/" ]]
[[ $($DUB lint foo@0.1.0 | tail -n 1) == *"/oldfoo/" ]]

[[ $($DUB generate cmake foo | head -n 1) == *"/newfoo/" ]]
[[ $($DUB generate cmake foo@1.0.0 | head -n 1) == *"/newfoo/" ]]
[[ $($DUB generate cmake foo@0.1.0 | head -n 1) == *"/oldfoo/" ]]

[[ $($DUB build -n foo | head -n 1) == *"/newfoo/" ]]
[[ $($DUB build -n foo@1.0.0 | head -n 1) == *"/newfoo/" ]]
[[ $($DUB build -n foo@0.1.0 | head -n 1) == *"/oldfoo/" ]]

[[ $($DUB run -n foo | tail -n 1) == 'new-foo' ]]
[[ $($DUB run -n foo@1.0.0 | tail -n 1) == 'new-foo' ]]
[[ $($DUB run -n foo@0.1.0 | tail -n 1) == 'old-foo' ]]

$DUB remove-local "$CURR_DIR/version-spec/newfoo"
$DUB remove-local "$CURR_DIR/version-spec/oldfoo"

$DUB fetch dub@1.9.0 && [ -d $HOME/.dub/packages/dub-1.9.0/dub ]
$DUB fetch dub=1.10.0 && [ -d $HOME/.dub/packages/dub-1.10.0/dub ]
$DUB remove dub@1.9.0
$DUB remove dub=1.10.0
if [ -d $HOME/.dub/packages/dub-1.9.0/dub ] || [ -d $HOME/.dub/packages/dub-1.10.0/dub ]; then
    die $LINENO 'Failed to remove specified versions'
fi
