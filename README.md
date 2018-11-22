# zeroconf-monkey

A thin wrapper on top of the Python module 'zeroconf' available from https://github.com/jstasiak/python-zeroconf.

## Introduction

This module overrides a small aspect of the service name validation in order to permit over-sized names.

Use of this module is not recommended unless absolutely required for your use case as it breaches a requirement of the mDNS RFC.

## Installation

### Requirements

*   Python 2.7 or 3.3+

### Steps

```bash
# Install from pip
$ pip install zeroconf-monkey

# Inside BBC R&D? You can also do...
$ apt-get install python-zeroconf-monkey

# Or...
$ apt-get install python3-zeroconf-monkey
```

## Usage

```python
from zeroconf_monkey import Zeroconf

...
```

See the original zeroconf library for further documentation.

## Development

### Packaging

```bash
# Debian packaging
$ make deb
```

## License

See [LICENSE](LICENSE)
