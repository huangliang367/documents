#!/bin/bash

set -e

VENV_DIR=".venv"
REQ_TEXT="requirements.txt"

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    "$VENV_DIR/bin/pip" install -r "$REQ_TEXT"
    echo ""
    echo "Virtual environment created. Activate it with:"
    echo "  source $VENV_DIR/bin/activate"
else
    echo "Virtual environment already exists."
    echo "Activate it with: source $VENV_DIR/bin/activate"
fi
