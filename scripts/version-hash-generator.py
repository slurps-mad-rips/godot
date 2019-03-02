from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, FileType
from jinja2 import Environment, FileSystemLoader, TemplateSyntaxError
from importlib import util
from pathlib import Path
import subprocess
import sys
import os

def generate(ctx):
    settings = dict(
        lstrip_blocks=True,
        trim_blocks=True,
        cache_size=0)
    env = Environment(**settings)
    result = subprocess.run(
        [os.fsdecode(ctx.git), 'rev-parse', 'HEAD'],
        stdout=subprocess.PIPE,
        universal_newlines=True)
    ctx.output.parent.mkdir(parents=True, exist_ok=True)
    with ctx.template as template, ctx.output.open('w') as output:
        template = env.from_string(template.read())
        try:
            stream = template.stream(hash=result.stdout.rstrip())
            stream.dump(output)
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
        type=Path,
        help='Output filename')
    parser.add_argument('--git', required=True, type=Path, help='Git executable')
    args = parser.parse_args()
    generate(args)

if __name__ == '__main__': main()
