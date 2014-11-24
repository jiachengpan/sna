#! /usr/bin/env python

import sys
import os

import igraph
import numpy
import yaml

from pprint import pprint

def data_trend():
    cwd = os.getcwd()
    os.chdir('data/ncol/')

    result = dict()

    for graphfile in sorted(os.listdir('.')):
        print "Processing ", graphfile
        dataname = graphfile.split('.')[0].split('-')[1]
        g = igraph.Graph.Read_Ncol(graphfile, weights=True, directed=False)

        result[dataname] = dict()

        result[dataname]['nodes'] = len(g.vs)
        result[dataname]['edges'] = len(g.es)
        result[dataname]['density'] = g.density()
        #result[dataname]['average_path_length'] = g.average_path_length(directed=False)
        #result[dataname]['diameter'] = g.diameter(directed=False, weights='weight')

    os.chdir(cwd)
    yaml.dump(result, open('data_trend.yaml', 'w'))

def data_snapshot(graphfile):
    g = igraph.Graph.Read_Ncol(graphfile, weights=True, directed=False)

    g.vs['degree']  = g.degree()
    g.vs['wdegree'] = g.strength(weights='weight')
    g.vs['between'] = g.betweenness()
    g.vs['wbetween']= g.betweenness(weights='weight')

    top_degree  = g.vs[reversed(numpy.argsort(g.vs['degree'])[-10:].tolist())]
    top_wdegree = g.vs[reversed(numpy.argsort(g.vs['wdegree'])[-10:].tolist())]
    top_between = g.vs[reversed(numpy.argsort(g.vs['between'])[-10:].tolist())]
    top_wbetween= g.vs[reversed(numpy.argsort(g.vs['wbetween'])[-10:].tolist())]

    print "nodes: ", len(g.vs)
    print "edges: ", len(g.es)
    print "average_path_length: ", g.average_path_length(directed=False)

    print "-----"
    pprint(top_degree['name'])
    pprint(top_degree['degree'])
    print "-----"
    pprint(top_wdegree['name'])
    pprint(top_wdegree['wdegree'])
    print "-----"
    pprint(top_between['name'])
    pprint(top_between['between'])
    print "-----"
    pprint(top_wbetween['name'])
    pprint(top_wbetween['wbetween'])
    print "-----"

if __name__ == '__main__':
    if len(sys.argv) > 1:
        data_snapshot(sys.argv[1])
    else:
        data_trend()
