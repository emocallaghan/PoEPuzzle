# -*- coding: utf-8 -*-
"""
Created on Tue Oct 21 11:45:44 2014

@author: eocallaghan

This document contains the class declarations for the piece and edge classes.

"""

class solver():
    """This class contains the ablity to compare a set of pieces, and a set
    of edges"""
    
    def __init__(self):
        pass
    
    def compareAllPieces(self):
        pass
    
    def listMatches(self):
        pass
    
    def solve(self):
        pass

class piece():
    """This is the class for puzzle pieces. Each puzzle piece contains four
    edges which will be instastiated in the constructor"""
    
    def __init__(self):
        """constructor the piece class. Should create for instance of edge
        and store the instances in a list"""
        pass
    
    def comparePieceOutLines(self, otherPiece):
        """takes a piece object and compares all the edges of both pieces"""        
        pass
 
class edge():
    """This is the class for puzzle piece edges. Each edge will be stored as
    a *************HOW ARE WE STORING EDGES*************************. There
    will be the ability to compare edges and return the probability that two
    edges fit together. Each edge will also have a list of probabibilites of
    how compatiable it is which other edges"""
    
    def __init__(self, identification):
        """constructor for the edge class. Each edge has an identification"""
        pass
    
    def compareEdgeOutLine(self, otherEdge):
        """takes an edge object and compares if the two are compatiable"""
        pass

    
    def addProbability(self, otherId, probabiltiy):
        """given an Id and probability adds this to own set of probabilities"""
        pass
    