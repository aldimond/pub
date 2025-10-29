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
parser.add_argument("--one-list", "-o", action="store_true", help="Passes list of args as a single arg instead of starring them.")
parser.add_argument("--iterate-result","-i", action="store_true", help="Force iteration of result via list().")
parser.add_argument("--repr", "-r", action="store_true", help="Result is printed with repr() (otherwise as a string). This happens after --iterate-result but before --join-result.")
joins = parser.add_mutually_exclusive_group()
joins.add_argument("--join-result", "-j", metavar="STR", help="Join result with STR as separator.")
joins.add_argument("--join-nulls", "-0", action="store_true", help="Join result with nulls and suppress trailing newline.")
joins.add_argument("--join-space", "-s", action="store_true", help="Join result with spaces.")
joins.add_argument("--join-empty", "-c", action="store_true", help="Join result with empty-string (concat into one string)")
joins.add_argument("--join-newline", "-n", action="store_true", help="Join result with newlines")
parser.add_argument("func_name", help="Qualified function name")
parser.add_argument("func_args", nargs="*")

args = parser.parse_args()

join_char = " " if args.join_space else "\0" if args.join_nulls else "" if args.join_empty else "\n" if args.join_newline else args.join_result
end_char = "" if args.join_nulls else "\n"

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
    fargs = [ast.literal_eval(a) for a in fargs]
    fkwargs = {k: ast.literal_eval(v) for k, v in fkwargs.items()}

if args.one_list:
    fargs = [fargs]

result = f(*fargs, **fkwargs)

if args.iterate_result:
    result = list(result)

if args.repr and not isinsntance(join_char, str):
    result = repr(result)

if isinstance(join_char, str):
    result = join_char.join((repr(i) if args.repr else str(i) for i in result))

print(result, end=end_char)
