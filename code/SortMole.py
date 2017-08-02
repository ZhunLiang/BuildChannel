from optparse import OptionParser

parser = OptionParser()
parser.add_option("-i", dest = "initial_gro", default = "IonMultiDel.gro", help = "input ion start gro file, default IonMultiDel.gro")
parser.add_option("-F", dest = "first_num", default = 19, type = "int", help = "input ion gro, each first type ion atom num")
parser.add_option("-S", dest = "second_num", default = 15, type = "int", help = "input ion gro, each second type ion atom num")
parser.add_option("-s", dest = "SinglePairNum", default = 156, type = "int", help = "input ion gro pair number, default 156")
parser.add_option("-t", dest = "TotalPairNum", default = 468, type = "int", help = "input ion gro pair number, default 468")
parser.add_option("-o", dest = "output_gro", default = "New.gro", help = "output gro file name, default New.gro")
(options, args) = parser.parse_args()

initial_gro = options.initial_gro
first_num = options.first_num
second_num = options.second_num
SPairNum = options.SinglePairNum
TPairNum = options.TotalPairNum
output_gro = options.output_gro

initial_file = open(initial_gro,'r')
output_file = open(output_gro,'w')
initial_line = initial_file.readlines()
output_file.write(initial_line[0])
output_file.write(initial_line[1])
MultiTime=TPairNum/SPairNum
for i in range(MultiTime):
    for j in range(SPairNum*first_num):
        output_file.write(initial_line[i*SPairNum*(first_num+second_num)+j+2])

for i in range(MultiTime):
    for j in range(SPairNum*second_num):
        output_file.write(initial_line[i*SPairNum*(first_num+second_num)+first_num*SPairNum+j+2])

output_file.write(initial_line[-1])
output_file.close()
initial_file.close()