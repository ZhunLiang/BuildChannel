#!/bin/perl
#Bash_code directory
sub GetMSD{
    @TEMP = split/\s+/,`grep $_[0] MSD_out.dat`;
    $TEMP_num = @TEMP;
    for($i=1;$i<$TEMP_num;$i=$i+1){
        $j=$i-1;
        @Out[$j] = @TEMP[$i];
    }
    return @Out;
}

system "python GetMSDpara.py";
@MoleName = GetMSD("NAME");
@MoleMass = GetMSD("MASS");
@MoleNum = GetMSD("NUM");
$TypeNum = @MoleName;
for($i=0;$i<$TypeNum;$i=$i+1){
    print "@MoleName[$i]\t@MoleMass[$i]\t@MoleNum[$i]\n";
}
system "rm -f MSD_out.dat";
