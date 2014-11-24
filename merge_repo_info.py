#! /usr/bin/env python

import sys
import csv

nodefile = sys.argv[1]
infofile = sys.argv[2]

repoInfo = dict()

with open(infofile, 'rb') as infofh:
    reader = csv.DictReader(infofh)
    for data in reader:
        repoName = data['repository_url']
        repoLang = data['repository_language']
        repoStar = data['repository_watchers']

        repoInfo[repoName] = "%s,%s" % (repoLang, repoStar)

with open(nodefile, 'rb') as nodefh:
    for node in nodefh.read().split('\n'):
        if node:
            print "%s,%s,%s" % (node[19:], node[19:], repoInfo[node])

