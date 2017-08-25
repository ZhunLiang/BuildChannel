#!/bin/perl
#INPUT

#
@GroXYZ= split/\s+/,`tail -1 $Wall_gro`; #GroXYZ[1] [2] [3] is X, Y, Z
#Get the Input gri box size: X, Y, Z
for ($i=0; $i<3; $i=$i+1){
    $temp = @WantedXYZ[$i]/@GroXYZ[$i+1];
    @GroNum[$i] = int($temp);
    if (@GroNum[$i]<=0){
        @GroNum[$i]=1;
    }
}
#Get the needed nbox number
if($BUILDELE==1){
  system "GROMACSgenconf -f $Wall_gro -nbox @GroNum[0] @GroNum[1] @GroNum[2] -o temp_out.gro";
  @TempXYZ= split/\s+/, `tail -1 temp_out.gro`; #[1],[2],[3] is X,Y,Z
  for($i=0; $i<2; $i=$i+1){
    $temp=@TempXYZ[$i+1]*$scale_size;
    $temp=sprintf "%.0f", $temp;
    $temp_scale=$temp/$scale_size/@TempXYZ[$i+1]; #charge 100, charge the new gro X, Y size. 100 means %.2f
    @ScaleSize[$i]=$temp_scale;
  }
  system "GROMACSeditconf -f temp_out.gro -scale @ScaleSize[0] @ScaleSize[1] @ScaleSize[2] -o tempLeft.gro \n";
  @NewGroXYZ=split/\s+/, `tail -1 tempLeft.gro`; #Get the scaled box size: X, Y, Z
  system "rm -f temp_out.gro";
  #Get the scaled gro, the x,y,z is %.3f format
  system "PYTHON GetZmax.py -i tempLeft.gro > LPyOut";
  @ZLMaxMin= split/\s+/,`cat LPyOut`; #Get the LeftGro Zmax[0] and Zmin[1]
  system "GROMACSeditconf -f tempLeft.gro -scale 1 1 -1 -o tempRight.gro";
  system "PYTHON GetZmax.py -i tempRight.gro > RPyOut";
  @ZRMaxMin=split/\s+/,`cat RPyOut`; #Get the RightGro Zmax[0] and Zmin[1]
  $Ztrans=@ZLMaxMin[0]-@ZRMaxMin[1]+$ChannelLong; 
  system "editconf -f tempRight.gro -translate 0 0 $Ztrans -o tempRightT.gro";
  #Translate the left gro as right gro
  @NewGroXYZ[3]=$TotalZLong;
  system "PYTHON CombineGro.py -l tempLeft.gro -r tempRightT.gro -n $channel_name -x @NewGroXYZ[1] -y @NewGroXYZ[2] -z @NewGroXYZ[3] -o output_temp1.gro";
  #Combine these two gro as one total gro
  system "GROMACSeditconf -f output_temp1.gro -c -o $WallGro";
  @SingleWallNum=GetTopNum($Wall_top);
  ChangeTop($Wall_top,$WallTop,2,@GroNum);
  system "rm -f tempLeft.gro tempRight.gro LPyOut RPyOut tempRightT.gro output_temp1.gro";
}
1;
