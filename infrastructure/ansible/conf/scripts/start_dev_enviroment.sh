#!/bin/bash
# Autor: Barckcode
# Description: Script to start flask in development mode

# Env
export FLASK_APP=main.py
export FLASK_ENV=development

# Run
flask run
