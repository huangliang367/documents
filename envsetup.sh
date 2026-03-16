#!/bin/bash

set -e 

VENV_DIR=".venv"
REQ_TEXT="requirments.txt"

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual enviromnet..."
    python -m venv .venv
    source .venv/bin/activate
    "$VENV_DIR/bin/pip" install -r "$REQ_TEXT"
else
    echo "Virtual environment already exists."
fi


