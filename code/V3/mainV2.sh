#!/bin/perl
#INPUT
$file=$ARGV[0]; #SingleWall.gro
$channel_topfile=$ARGV[1];  #SingleWall.top
$IonFile=$ARGV[2]; #bulk npt equilibrated at same temperature with wanted channel temperature.
$IonTop=$ARGV[3]; # the ion gro file corresponding top file
$ChannelLong=8;  #$ARGV[4]
$TotalZLong=30;  #$ARGV[5
@WantedXYZ= (5,5,-1); #$ARGV[6]
@MSDorder=(0 ,1, 1); #$ARGV[7]. Ion type order in MSD file
#@MoleName=("Emi","f2N");#Ion type name, same with .top
@DeleteRatio=(1,1);

$channel_grofile="ElectroWall.gro";
$channel_name="Wall";
$Kmax=1.1; #the maxmiun density of channel ion compare with bulk
$Kmin=1.02; #the mimnium density of channel ion compare with bulk
$channel_grofile="Ti3C2-ele.gro";
$channel_name="Ti3C2_ele";
$scale_size=100; #scale size means the decimal point number, 100 means %.2f, 1000 means %.3f]

@GroXYZ= split/\s+/,`tail -1 $file`; #GroXYZ[1] [2] [3] is X, Y, Z
#Get the Input gri box size: X, Y, Z
for ($i=0; $i<3; $i=$i+1){
    $temp = @WantedXYZ[$i]/@GroXYZ[$i+1];
    @GroNum[$i] = int($temp);
    if (@GroNum[$i]<1){
        @GroNum[$i]=1;
    }
}
system "genconf -f $file -nbox @GroNum[0] @GroNum[1] @GroNum[2] -o temp_out.gro";
@TempXYZ= split/\s+/, `tail -1 temp_out.gro`; #[1],[2],[3] is X,Y,Z
for ($i=0; $i<2; $i=$i+1){
    $temp=@TempXYZ[$i+1]*$scale_size;
    $temp=sprintf "%.0f", $temp;
    $temp_scale=$temp/$scale_size/@TempXYZ[$i+1]; #charge 100, charge the new gro X, Y size. 100 means %.2f
    @ScaleSize[$i]=$temp_scale;
}
system "editconf -f temp_out.gro -scale @ScaleSize[0] @ScaleSize[1] 1 -o tempLeft.gro \n";
@NewGroXYZ=split/\s+/, `tail -1 tempLeft.gro`; #Get the scaled box size: X, Y, Z
system "rm -f temp_out.gro";
#Get the scaled gro, the x,y,z is %.3f format
system "/opt/python/bin/python ~/bin/GetZmax.py -i tempLeft.gro > LPyOut";
@ZLMaxMin= split/\s+/,`cat LPyOut`; #Get the LeftGro Zmax[0] and Zmin[1]
system "editconf -f tempLeft.gro -scale 1 1 -1 -o tempRight.gro";
system "/opt/python/bin/python ~/bin/GetZmax.py -i tempRight.gro > RPyOut";
@ZRMaxMin=split/\s+/,`cat RPyOut`; #Get the RightGro Zmax[0] and Zmin[1]
$Ztrans=@ZLMaxMin[0]-@ZRMaxMin[1]+$ChannelLong; 
system "editconf -f tempRight.gro -translate 0 0 $Ztrans -o tempRightT.gro";
#Translate the left gro as right gro
@NewGroXYZ[3]=$TotalZLong;
system "/opt/python/bin/python ~/bin/CombineGro.py -l tempLeft.gro -r tempRightT.gro -n $channel_name -x @NewGroXYZ[1] -y @NewGroXYZ[2] -z @NewGroXYZ[3] -o output_temp1.gro";
#Combine these two gro as one total gro
system "editconf -f output_temp1.gro -c -o $channel_grofile";
@SingleWallNum=split/\s+/,`grep -w @MoleName[0] $channel_topfile`;
