#!/usr/bin/python3

# Calls a Python function with the given args.

import importlib
import sys

fqname = sys.argv[1]
fparts = fqname.rsplit(".", maxsplit=1)
fname = fparts[-1]
fpack = fparts[0] if len(fparts) > 1 else "builtins"

m = importlib.import_module(fpack)
f = getattr(m, fname)

print(f(*sys.argv[2:]))
