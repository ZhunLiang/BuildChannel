import numpy as np
import re
import sys
import shutil
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-i", dest = "gro_file", default = "temp.gro", help = "input gro file, default temp.gro")
(options, args) = parser.parse_args()
gro_file = options.gro_file
coor_match = r"-?\d+\.\d+" #match coordinate
re_match = re.compile(coor_match)
file = open(gro_file,'r')
lines = file.readlines()
rows = len(lines)
Atom_num = int(lines[1])
Coordinate = np.zeros([3,Atom_num])
for i in range(Atom_num):
    Coordinate[0, i] = np.array(float(re_match.findall(lines[i + 2])[0]))
    Coordinate[1, i] = np.array(float(re_match.findall(lines[i + 2])[1]))
    Coordinate[2, i] = np.array(float(re_match.findall(lines[i + 2])[2]))
file.close()
Zmax = np.max(Coordinate[2,:])
Zmin = np.min(Coordinate[2,:])

print Zmax,Zmin