#!/bin/bash

set -e

VENV_DIR=".venv"
REQ_TEXT="requirements.txt"

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    "$VENV_DIR/bin/pip" install -r "$REQ_TEXT"
else
    echo "Updating dependencies..."
    "$VENV_DIR/bin/pip" install -q --upgrade -r "$REQ_TEXT"
fi

echo ""
echo "Activate with: source $VENV_DIR/bin/activate"
