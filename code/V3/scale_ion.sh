#!/bin/perl
#Input para

$RUNSCALE=1;

@ChannelXYZ=split/\s+/,`tail -1 $Channel_gro`;
@ChannelXYZ[3]= $ChannelLong-0.2;
@IonXYZ=split/\s+/,`tail -1 tune_end.gro`;
for($i=0;$i<3;$i=$i+1){
    @InitNumXYZ[$i]=@ChannelXYZ[$i+1]/@IonXYZ[$i+1];
}

$Vc=@ChannelXYZ[1]*@ChannelXYZ[2]*@ChannelXYZ[3];
$Vb=@IonXYZ[1]*@IonXYZ[2]*@IonXYZ[3];
$InitNum=$Vc/$Vb;
$NeedNum=int($InitNum+0.999999);

for($i=0;$i<2;$i=$i+1){
    if(@InitNumXYZ[$i]<1){@TuneNumXYZ[$i]=1;}
    else {@TuneNumXYZ[$i]=int(@InitNumXYZ[$i]+0.5);}
}

@TuneNumXYZ[2]=$NeedNum/@TuneNumXYZ[0]/@TuneNumXYZ[1];
$Err=@TuneNumXYZ[2]-int(@TuneNumXYZ[2]);
if($Err!=0){
    @TuneNumXYZ[2]=int(@TuneNumXYZ[2])+1;
}

$TuneTotalNum=@TuneNumXYZ[0]*@TuneNumXYZ[1]*@TuneNumXYZ[2];
#$ErrNum=$TuneTotalNum-$NeedNum;
#print "$ErrNum \n";
for($i=0;$i<3;$i=$i+1){
    @ScaleXYZ[$i]=(@ChannelXYZ[$i+1]-0.2)/@TuneNumXYZ[$i];
    #print "@ScaleXYZ[$i] \t";
    @ScaleRatio[$i]=@ScaleXYZ[$i]/@IonXYZ[$i+1];
    #print "@IonXYZ[$i+1] \t";
    #print "@ScaleRatio[$i] \t";
}
#print "\n";
for($i=0;$i<3;$i=$i+1){
    if(@ScaleRatio[$i]<1){
        $temp=log (@ScaleRatio[$i])/log (0.95);
    }
    else {
        $temp=log (@ScaleRatio[$i])/log (1.05);        
    }
    @ScaleTime[$i] = int($temp+0.999999);
    if($i==0){
        $MaxTime=@ScaleTime[$i];
        $MaxIndex=$i;
    }
    elsif(@ScaleTime[$i]>=@ScaleTime[$i-1]){
        $MaxTime=@ScaleTime[$i];
        $MaxIndex=$i;
    }
}
#print "$MaxTime, $MaxIndex \n";
for($i=0;$i<$MaxTime;$i=$i+1){
    for($j=0;$j<3;$j=$j+1){
        if($i<@ScaleTime[$j]) {@ScaleValue[$MaxTime*$j+$i]=@ScaleRatio[$j]**(1/@ScaleTime[$j]); }
        else {@ScaleValue[$MaxTime*$j+$i]=1;}
        #print "@ScaleValue[$MaxTime*$j+$i] \t";
    }
    #print "\n";
}


if($RUNSCALE==1){
  system "mkdir scale";
  system "cp *.itp scale-nvt.mdp scale/";
  system "cp tune_end.top scale/scale.top;cp tune_end.gro scale/scale.gro";
  chdir "scale/";
  for($i=0;$i<$MaxTime;$i=$i+1){    
    system "editconf -f scale.gro -scale @ScaleValue[0+$i] @ScaleValue[$MaxTime+$i] @ScaleValue[$MaxTime*2+$i] -o scale_start.gro";
    system "grompp -f scale-nvt.mdp -c scale_start.gro -p scale.top -o scale.tpr";
	system "mdrun -s scale.tpr -v -deffnm scale_end";
    system "echo 0 | trjconv -s scale.tpr -f scale_end.gro -pbc mol -o scale.gro";
  }
  system "cp scale.gro scale.top ../";
  chdir "../";
  system "rm -rf scale/";
}

1;
