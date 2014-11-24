#! /usr/bin/env python

template = open('repo-star.sql.template').read()
repo_template = open('repo-info.sql.template').read()

last = "'2012-01-01 00:00:00'"
current = "'2012-01-01 00:00:00'"

for year in (12, 13, 14):
    for i in range(0, 4):
        month = 1 + 3 * i
        last = current
        current = "'20%d-%02d-01 00:00:00'" % (year, month)

        if last == current:
            continue

        fh = open('Y%dQ%d.sql' % (year, i), 'w')
        fmt = (last, current) * 4
        fh.write(template % fmt)
        fh.close()

        fh = open('repo.Y%dQ%d.sql' % (year, i), 'w')
        fmt = (last, current)
        fh.write(repo_template % fmt)
        fh.close()

