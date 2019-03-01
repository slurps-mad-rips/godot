from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, FileType
from jinja2 import Environment, FileSystemLoader, TemplateSyntaxError
from contextlib import ExitStack
from pathlib import Path
import zlib
import sys
import os

def generate (ctx):
    settings = dict(
        lstrip_blocks=True,
        trim_blocks=True,
        loader=FileSystemLoader(os.fsdecode(ctx.directory)),
        cache_size=0)
    env = Environment(**settings)
    with ctx.template as template, ctx.output as outfile:
        with ExitStack() as stack:
            files = [stack.enter_context(open(name)) for name in ctx.input]
            content = ''.join([file.read() for file in files])
        compressed = zlib.compress(content.encode('utf-8'))
        template = env.from_string(template.read())
        try:
            stream = template.stream(
                uncompressed_size=len(content),
                compressed_size=len(compressed),
                buffer=compressed)
            stream.dump(outfile)
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
        '-d', '--directory',
        type=Path,
        default=Path.cwd(),
        help='Path to templates for loading')
    parser.add_argument(
        '-o', '--output',
        required=True,
        type=FileType('w'),
        help='Output filename')
    parser.add_argument('input',
        nargs='+',
        type=Path,
        help='Documentation files')
    args = parser.parse_args()
    generate(args)


if __name__ == '__main__': main()
