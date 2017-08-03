#!/bin/perl
#INPUT
@WantedXYZ= (5,5,-1);
$ChannelLong=8;
$TotalZLong=30;
@ScaleSize= (0,0,1);
@DeletaRation=(1,1);

$Wall_gro="SingleWall.gro";
$Wall_top="SingleWall.top";
$Ion_gro="Ion.gro"; #bulk npt equilibrated at same temperature with wanted channel temperature.
$Ion_top="Ion.top"; # the ion gro file corresponding top file
$OutWallTop="Wall.top";
$OutPutChannel="Channel.gro";
$Channel_gro="Channel_temp.gro";
$channel_name="MILTIION";
$scale_size=100; #scale size means the decimal point number, 100 means %.2f, 1000 means %.3f
$Kmax=1.1; #the maxmiun density of channel ion compare with bulk
$Kmin=1.02; #the mimnium density of channel ion compare with bulk

sub GetMSD{
    my @TEMP = split/\s+/,`grep $_[0] MSD_out.dat`;
    my $TEMP_num = @TEMP;
    my @Out;
    for($i=1;$i<$TEMP_num;$i=$i+1){
        $j=$i-1;
        @Out[$j] = @TEMP[$i];
    }
    return @Out;
}

sub GetTopNum{
  my $count = 0;
  my ($temp,@temp2,@Out);
  for(my $i=0;$i<$TotalNum;$i+=1){
    $temp = `grep -w @MoleName[$i] $_[0]`;
    if($temp){
      @temp2 = split/\s+/,$temp;
      @Out[$count] = @temp2[1];
      $count += 1;
    }
  }
  return @Out;
}

sub ChangeTop{
  my $temp;
  my (@temp_all,$temp_name,$temp_num);
  my ($temp_re,$temp_match);
  system "cp @_[0] @_[1]";
  for(my $i=0;$i<$TotalNum;$i+=1){
    $temp = `grep -w @MoleName[$i] @_[1]`;
    if($temp){
      @temp_all = split/\s+/,$temp;
      $temp_name = @temp_all[0];
      $temp_num = @temp_all[1]*@_[3]*@_[4]*@_[5]*@_[2];
      $temp_match = "$temp_name\\s\\+\\([0-9]\\+\\)";
      $temp_re = "$temp_name\\t$temp_num";
      #print "$temp_match\n$temp_re\n";
      system "sed -i 's/$temp_match/$temp_re/g' @_[1]";
    }
  }
}

sub GetTopMSD{
  my $temp;
  my $count = 0;
  my $i;
  my (@temp,@Name_Out,@Num_Out,@Mass_Out,@Top_Num);
  for($i=0;$i<$TotalNum;$i+=1){
    $temp = `grep -w @MoleName[$i] $_[0]`;
	if($temp){
	  @Name_Out[$count] = @MoleName[$i];
	  @Num_Out[$count] = @MoleNum[$i];
	  @Mass_Out[$count] = @MoleMass[$i];
          @temp=split/\s+/,$temp;
          @Top_Num[$count] = @temp[1];
	  $count += 1;
	}
  }
  return \@Name_Out,\@Num_Out,\@Mass_Out,\@Top_Num;
}

sub StrPara{
  my $temp="";
  my $n=@_;
  for(my $i=0;$i<$n;$i+=1){
    $temp="$temp @_[$i]";
  }
  my $pre='"';
  my $out="$pre$temp$pre";
  return $out;
}

system "PYTHON GetMSDpara.py";
@MoleName = GetMSD("NAME");
@MoleMass = GetMSD("MASS");
@MoleNum = GetMSD("NUM");
$TotalNum = @MoleName;
system "rm -f MSD_out.dat";
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
system "genconf -f $Wall_gro -nbox @GroNum[0] @GroNum[1] @GroNum[2] -o temp_out.gro";
@TempXYZ= split/\s+/, `tail -1 temp_out.gro`; #[1],[2],[3] is X,Y,Z
for ($i=0; $i<2; $i=$i+1){
    $temp=@TempXYZ[$i+1]*$scale_size;
    $temp=sprintf "%.0f", $temp;
    $temp_scale=$temp/$scale_size/@TempXYZ[$i+1]; #charge 100, charge the new gro X, Y size. 100 means %.2f
    @ScaleSize[$i]=$temp_scale;
}
system "editconf -f temp_out.gro -scale @ScaleSize[0] @ScaleSize[1] @ScaleSize[2] -o tempLeft.gro \n";
@NewGroXYZ=split/\s+/, `tail -1 tempLeft.gro`; #Get the scaled box size: X, Y, Z
system "rm -f temp_out.gro";
#Get the scaled gro, the x,y,z is %.3f format
system "PYTHON GetZmax.py -i tempLeft.gro > LPyOut";
@ZLMaxMin= split/\s+/,`cat LPyOut`; #Get the LeftGro Zmax[0] and Zmin[1]
system "editconf -f tempLeft.gro -scale 1 1 -1 -o tempRight.gro";
system "PYTHON GetZmax.py -i tempRight.gro > RPyOut";
@ZRMaxMin=split/\s+/,`cat RPyOut`; #Get the RightGro Zmax[0] and Zmin[1]
$Ztrans=@ZLMaxMin[0]-@ZRMaxMin[1]+$ChannelLong; 
system "editconf -f tempRight.gro -translate 0 0 $Ztrans -o tempRightT.gro";
#Translate the left gro as right gro
@NewGroXYZ[3]=$TotalZLong;
system "PYTHON CombineGro.py -l tempLeft.gro -r tempRightT.gro -n $channel_name -x @NewGroXYZ[1] -y @NewGroXYZ[2] -z @NewGroXYZ[3] -o output_temp1.gro";
#Combine these two gro as one total gro
system "editconf -f output_temp1.gro -c -o $Channel_gro";
@SingleWallNum=GetTopNum($Wall_top);
ChangeTop($Wall_top,$OutWallTop,2,@GroNum);
system "rm -f tempLeft.gro tempRight.gro LPyOut RPyOut tempRightT.gro output_temp1.gro";

################Tune Bulk Ion gro###########################
require('tune_bulk.sh');

