# Currently just some example code to play around with
from debian.copyright import Copyright, FilesParagraph, LicenseParagraph

# TODO: Remove all lines that start with '#'
with open('COPYRIGHT.txt') as f:
    copyright = Copyright(f)

for paragraph in copyright:
    if not isinstance(paragraph, FilesParagraph): continue
    print(paragraph.comment, paragraph.copyright, paragraph.files)
