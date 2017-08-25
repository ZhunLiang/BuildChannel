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
  system "PYTHON GetZmax.py -i temp_out.gro > TempOut";
  @TempLayer=split/\s+/,`cat TempOut`;
  $templayer=@TempLayer[0]-@TempLayer[1];
  @TempXYZ= split/\s+/, `tail -1 temp_out.gro`; #[1],[2],[3] is X,Y,Z
  for($i=0; $i<3; $i=$i+1){
    if($i<2){
    $temp=@TempXYZ[$i+1]*$scale_size;
    $temp=sprintf "%.0f", $temp;
    $temp_scale=$temp/$scale_size/@TempXYZ[$i+1];} #charge 100, charge the new gro X, Y size. 100 means %.2f
    else{
    $temp=$templayer*$scale_size;
    $temp=sprintf "%.0f",$temp;
    $temp_scale=$temp/$scale_size/$templayer;
    }
    @ScaleSize[$i]=$temp_scale;
  }
  #@ScaleSize[2]=1;
  #print "@ScaleSize/n";
  system "GROMACSeditconf -f temp_out.gro -scale @ScaleSize[0] @ScaleSize[1] @ScaleSize[2] -o tempLeft.gro \n";
  @NewGroXYZ=split/\s+/, `tail -1 tempLeft.gro`; #Get the scaled box size: X, Y, Z
  system "rm -f temp_out.gro TempOut";
  #Get the scaled gro, the x,y,z is %.3f format
  system "PYTHON GetZmax.py -i tempLeft.gro > LPyOut";
  @ZLMaxMin= split/\s+/,`cat LPyOut`; #Get the LeftGro Zmax[0] and Zmin[1] 
  #$BoxZ=$ChannelLong+@NewGroXYZ[3];
  #$Ztrans=$ChannelLong/2-@NewGroXYZ[3]/2;
  system "editconf -f tempLeft.gro -box @NewGroXYZ[1] @NewGroXYZ[2] $TotalZLong -c -o $WallGro";
  #Translate the left gro as right gro
  our $ChannelLong=$TotalZLong-(@ZLMaxMin[0]-@ZLMaxMin[1]);
  @SingleWallNum=GetTopNum($Wall_top);
  ChangeTop($Wall_top,$WallTop,1,@GroNum);
  system "rm -f tempLeft.gro LPyOut";
  #print "$ChannelLong\n";
}
1;
