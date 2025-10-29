#!/usr/bin/python3

# Calls a Python function with the given args.

import argparse
import ast
import importlib
import sys

parser = argparse.ArgumentParser(
    prog="pyf",
    description="Runs a Python func with given args",
)
parser.add_argument("--kwargs", "-k", action="store_true", help="Args with = are split on = as kwargs")
parser.add_argument("--literal-args", "-l", action="store_true", help="Args and kwargs values are interpreted as Python literals (otherwise strings).")
parser.add_argument("--iterate-result","-i", action="store_true", help="Force iteration of result via list().")
parser.add_argument("--repr", "-r", action="store_true", help="Result is printed with repr() (otherwise as a string).")
parser.add_argument("func_name", help="Qualified function name")
parser.add_argument("func_args", nargs="*")

args = parser.parse_args()

fparts = args.func_name.rsplit(".", maxsplit=1)
fname = fparts[-1]
fpack = fparts[0] if len(fparts) > 1 else "builtins"

m = importlib.import_module(fpack)
f = getattr(m, fname)

fkwargs = {}
if args.kwargs:
    fargs = []
    for a in args.func_args:
        aparts = a.split("=", maxsplit=1)
        if len(aparts) > 1:
            fkwargs[aparts[0]] = aparts[1]
        else:
            fargs = aparts[0]
else:
    fargs = args.func_args

if args.literal_args:
    fargs = (ast.literal_eval(a) for a in fargs)
    fkwargs = {k: ast.literal_eval(v) for k, v in fkwargs.items()}

result = f(*fargs, **fkwargs)
if args.iterate_result:
    result = list(result)
if args.repr:
    result = repr(result)

print(result)
