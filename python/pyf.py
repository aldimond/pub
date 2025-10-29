#!/usr/bin/python3

# Calls a Python function with the given args.

import argparse
import ast
import importlib
import sys

parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description="""\
Runs a Python func with given args and prints the result.

The main point of this is to bring the enormous Python stdlib into shell
scripts. The initial motivating example was that I wanted to urlencode a string
in a shell script.

This is slightly inspired by perl's ability to fit into shell scripts, but it's
not made to be a filtering processor like perl is.
""",
    epilog="""\
Examples:

    - urlencode a string
        $ %(prog)s urllib.parse.quote_plus 'a/b c'
        a%%2Fb+c

    - reverse a string (needs -c to iterate/concat the reversed() obj)
        $ %(prog)s -c reversed aoeu
        ueoa

    - reverse a list of strings (needs -o to put args in a single list, -s to
      iterate result)
        $ %(prog)s -os reversed aoeu htns gcrl
        gcrl htns aoeu

    - ... as above, but with different output formatting
        $ %(prog)s -oi reversed fghi cde ab
        ['ab', 'cde', 'fghi']

        $ %(prog)s -oc reversed fghi cde ab
        abcdefghi

    - Work with numbers (-l to evaluate args as literals, -n for newline
      separation, -- to hide negative number from option parser)
        $ %(prog)s -lon -- itertools.accumulate 1 5 20 -2 3
        1
        6
        26
        24
        27

    - ... Add -k to allow kwargs
        $ %(prog)s -lkon -- itertools.accumulate 1 5 20 -2 3 initial=100
        100
        101
        106
        126
        124
        127

    - Null-separate output with -0 to work with tools that want that
        $ %(prog)s -0o reversed 'my hat' 'has' 'three corners' | xargs -0 printf '-> %%s\\n'
        -> three corners
        -> has
        -> my hat

    - Do floating-point math (needs -l to evaluate args as numbers)
        $ %(prog)s -l math.pow 2.5 3.6
        27.07597043574791o
""",
)

arg_opts = parser.add_argument_group("Argument handling")
arg_opts.add_argument("--kwargs", "-k", action="store_true", help="Args with = are split on = as kwargs")
arg_opts.add_argument("--literal-args", "-l", action="store_true", help="Args and kwargs values are interpreted as Python literals (otherwise strings).")
arg_opts.add_argument("--one-list", "-o", action="store_true", help="Passes list of args as a single arg instead of starring them.")

res_opts = parser.add_argument_group("Result handling")
res_opts.add_argument("--iterate-result","-i", action="store_true", help="Force iteration of result via list(). Typically with --join-* options below this is not needed.")
res_opts.add_argument("--repr", "-r", action="store_true", help="Result is formatted with repr() (otherwise with str()). This happens after --iterate-result but before --join-result.")
joins = res_opts.add_mutually_exclusive_group()
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
            fargs.append(aparts[0])
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
