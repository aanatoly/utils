# `mk-venv`

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Linter](https://img.shields.io/badge/linter-Ruff-green)
![Pyright](https://img.shields.io/badge/linter-pyright-green)
![Formatter](https://img.shields.io/badge/formatter-Black-000000)

`mk-venv`: fast, cached, offline Python venv creation.

`mk-venv` is a Python virtual environment creation script that focuses on speed, utilizing cached data to significantly reduce setup time. It supports offline virtual environment (venv) creation once the necessary bootstrap files are downloaded.

## Features

- **Fast Virtual Environment Creation**:

  - Initial venv setup (using `get-pip.py`) takes 3-4 seconds.
  - Subsequent venvs are created in under 1 second using a cached template.

- **Offline Mode**:

  - After downloading `get-pip.py` and system wheels, the script enables offline venv creation without needing to fetch files from the internet.

- **Cached Wheels**:

  - Builds wheels before installing packages and caches them for reuse.
  - Packages are downloaded only once and reused in future installs.

## Usage

Create venv at `venv/`

```
mk-venv -c install -v venv -- -r requirements.txt
```
