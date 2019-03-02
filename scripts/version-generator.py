from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, FileType
from jinja2 import Environment, FileSystemLoader, TemplateSyntaxError
from importlib import util
from pathlib import Path
import sys
import os

def generate(ctx):
    spec = util.spec_from_file_location('version', ctx.input)    
    version = util.module_from_spec(spec)
    spec.loader.exec_module(version)
    settings = dict(
        lstrip_blocks=True,
        trim_blocks=True,
        cache_size=0)
    env = Environment(**settings)
    ctx.output.parent.mkdir(parents=True, exist_ok=True)
    with ctx.template as template, ctx.output.open('w') as output:
        template = env.from_string(template.read())
        try:
            stream = template.stream(version=version)
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
    parser.add_argument(
        '-i', '--input',
        required=True,
        type=Path,
        help='Version script')
    args = parser.parse_args()
    generate(args)

if __name__ == '__main__': main()
