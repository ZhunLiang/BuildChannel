from optparse import OptionParser
import numpy as np

parser = OptionParser()
parser.add_option("-i", dest = "initial_gro", default = "IonMultiDel.gro", help = "input ion start gro file, default IonMultiDel.gro")
parser.add_option("-a", dest = "mole_atom_num", default = " 19 15", help = "molecular atom number in single gro")
parser.add_option("-n", dest = "mole_num", default = " 197 197",  help = "molecular number in single gro")
parser.add_option("-t", dest = "tune_num", default = 3, type = int , help = "input ion gro pair number, default 216")
parser.add_option("-o", dest = "output_gro", default = "New.gro", help = "output gro file name, default New.gro")
(options, args) = parser.parse_args()

initial_gro = options.initial_gro
atom_num = options.mole_atom_num
mole_num = options.mole_num
MultiTime = options.tune_num
output_gro = options.output_gro

Atom_Num = np.array([int(float(atom_num.split()[i])) for i in range(len(atom_num.split()))])
Mole_Num = np.array([int(float(mole_num.split()[i])) for i in range(len(mole_num.split()))])
Mole_Type = len(Atom_Num)
One_total = np.sum(Atom_Num*Mole_Num)
Each_total = Atom_Num*Mole_Num

initial_file = open(initial_gro,'r')
output_file = open(output_gro,'w')
initial_line = initial_file.readlines()
output_file.write(initial_line[0])
output_file.write(initial_line[1])

for i in range(Mole_Type):
    if(i>0):
        above = np.sum(Each_total[0:i])
    else:
        above = 0
    for j in range(MultiTime):
        begin = One_total*j + 2 +above
        end = One_total*j +2 + Each_total[i] + above
        #print begin,\t,end,\n
        for k in range(begin,end):
            output_file.write(initial_line[k])

output_file.write(initial_line[-1])
output_file.close()
initial_file.close()
