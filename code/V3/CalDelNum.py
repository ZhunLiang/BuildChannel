from optparse import OptionParser
import numpy as np

parser = OptionParser()
parser.add_option("-m", dest = "mole_mass", default = " 28 36", help = "molecular mole mass")
parser.add_option("-n", dest = "mole_num", default = " 216 216", help = "input ion gro pair number, default 216")
parser.add_option("-d", dest = "delete_ratio", default = "1 1", help = "shan chu de ge shu bi, x:y:z:..., shan x ge diyizhong, shan y ge dierzhong")
parser.add_option("--Vo", dest = "origin_v", default = 91.2,type=float, help = "origin volume")
parser.add_option("--Vw", dest = "wanted_v", default = 90.0, type=float,help = "wanted volume")

(options, args) = parser.parse_args()
Mass = options.mole_mass
Num = options.mole_num
Ration = options.delete_ratio
Vo = options.origin_v
Vw = options.wanted_v


Mass = np.array([float(Mass.split()[i]) for i in range(len(Mass.split()))])
Num = np.array([int(Num.split()[i]) for i in range(len(Num.split()))])
Ration = np.array([int(Ration.split()[i]) for i in range(len(Ration.split()))])


Delete_Type = Ration>0
Var1 = (1-Vw/Vo)
Var2 = np.sum(Mass*Num*Delete_Type)
Var3 = np.sum(Mass*Ration*Delete_Type)
Var4 = abs(Var1*Var2/Var3)
Delete_Num = np.floor(Var4*Ration)
Delete_str = [str(int(Delete_Num[i])) for i in range(len(Mass))]
OutPut = "\t".join(Delete_str)
print OutPut
