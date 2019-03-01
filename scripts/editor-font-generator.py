from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, FileType
from jinja2 import Environment, FileSystemLoader, TemplateSyntaxError
from contextlib import ExitStack
from pathlib import Path
import sys
import os

def generate (ctx):
    settings = dict(
        lstrip_blocks=True,
        trim_blocks=True,
        cache_size=0)
    env = Environment(**settings)
    with ctx.template as template, ctx.output as out:
        with ExitStack() as stack:
            files = [stack.enter_context(open(name, mode='rb')) for name in ctx.input]
            content = [file.read() for file in files]
            length = [len(buf) for buf in content]
        template = env.from_string(template.read())
        try:
            stream = template.stream(sources=zip(map(Path, ctx.input), content, length))
            stream.dump(out)
        except TemplateSyntaxError as e:
            raise SystemExit('{e.name}:{e.lineno} {e.message}'.format(e=e))

def main ():
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        '-t', '--template',
        required=True,
        type=FileType('r'),
        help='Jinja2 Template File')
    parser.add_argument(
        '-o', '--output',
        required=True,
        type=FileType('w'),
        help='Output filename')
    parser.add_argument('input',
        nargs='+',
        type=Path,
        help='Font files')
    args = parser.parse_args()
    generate(args)

if __name__ == '__main__': main()

