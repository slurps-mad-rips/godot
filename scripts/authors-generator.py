from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, FileType
from jinja2 import Environment, FileSystemLoader, TemplateSyntaxError
from importlib import util
from pathlib import Path
import sys
import os
import re

def regex(section):
    options = re.MULTILINE | re.DOTALL
    return re.compile(r'.*## {}$([^##]*)'.format(section), options)

def extract(regex, content):
    return filter(lambda x: x.startswith('    '),
            regex.match(content).group(1).split('\n'))

sections = dict(
    AUTHORS_PROJECT_MANAGERS=regex('Project Manager'),
    AUTHORS_LEAD_DEVELOPERS=regex('Lead Developer'),
    AUTHORS_DEVELOPERS=regex('Developers'),
    AUTHORS_FOUNDERS=regex('Project Founders'))

def quote (item):
    return '"{}"'.format(item.encode('unicode-escape').decode('utf-8'))

def generate(ctx):
    settings = dict(
        lstrip_blocks=True,
        trim_blocks=True,
        cache_size=0)
    env = Environment(**settings)
    env.filters['quote'] = quote
    ctx.output.parent.mkdir(parents=True, exist_ok=True)
    with ctx.authors as authors:
        content = authors.read()

    with ctx.template as template, ctx.output.open('w') as output:
        template = env.from_string(template.read())
        try:
            stream = template.stream(sections={
                name : extract(regex, content) for name, regex in sections.items()})
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
    parser.add_argument('authors',
        type=FileType('r'),
        help='AUTHORS.md file')
    args = parser.parse_args()
    generate(args)

if __name__ == '__main__': main()


