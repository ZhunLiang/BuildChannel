from optparse import OptionParser

parser = OptionParser()
parser.add_option("-i", dest = "initial_gro", default = "IonMultiDel.gro", help = "input ion start gro file, default scale_start.gro")
parser.add_option("-F", dest = "first_num", default = 19, type = "int", help = "input ion gro, each first type ion atom num")
parser.add_option("-S", dest = "second_num", default = 15, type = "int", help = "input ion gro, each second type ion atom num")
parser.add_option("-n", dest = "ion_pair", default = 216, type = "int", help = "input ion gro pair number, default 216")
parser.add_option("-d", dest = "delete_num", default = 0, type = "int", help = "input ion gro pair number, default 216")
parser.add_option("-o", dest = "output_gro", default = "New.gro", help = "output gro file name, default New.gro")
(options, args) = parser.parse_args()
initial_gro = options.initial_gro
first_num = options.first_num
second_num = options.second_num
ion_pair = options.ion_pair
delete_num = options.delete_num
output_gro = options.output_gro

initial_file = open(initial_gro,'r')
output_file = open(output_gro,'w')
initial_line = initial_file.readlines()
New_TotalNum = int(initial_line[1]) - delete_num*(first_num+second_num)
for i in range(len(initial_line)):
    if i> int(1+first_num*ion_pair-first_num*delete_num) and i <= int(1+first_num*ion_pair+second_num*delete_num):
        continue
    elif i == 1:
        output_file.write(str(New_TotalNum) + '\n')
    else:
        output_file.write(initial_line[i])
initial_file.close()
output_file.close()
