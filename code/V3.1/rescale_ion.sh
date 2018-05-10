#!/bin/perl
#Input para

@ChannelXYZ=split/\s+/,`tail -1 $WallGro`;
@ChannelXYZ[3]= $ChannelLong-0.2;
@IonXYZ=split/\s+/,`tail -1 IonChannel.gro`;


for($i=0;$i<3;$i=$i+1){
    @ScaleXYZ[$i]=@ChannelXYZ[$i+1]-0.2;
    @ScaleRatio[$i]=@ScaleXYZ[$i]/@IonXYZ[$i+1];
}
for($i=0;$i<3;$i=$i+1){
    if(@ScaleRatio[$i]<1){
        $temp=log (@ScaleRatio[$i])/log (0.9);
    }
    else {
        $temp=0;
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


for($i=0;$i<$MaxTime;$i=$i+1){
    for($j=0;$j<3;$j=$j+1){
        if($i<@ScaleTime[$j]) {@ScaleValue[$MaxTime*$j+$i]=@ScaleRatio[$j]**(1/@ScaleTime[$j]); }
        else {@ScaleValue[$MaxTime*$j+$i]=1;}
    }
    #print("@ScaleValue[0+$i],@ScaleValue[$MaxTime+$i],@ScaleValue[$MaxTime*2+$i]\n");
}

if($RESCALE==1){
    system "mkdir rescale";
    system "cp *.itp IonChannel.gro IonChannel.top scale-nvt.mdp rescale/";
    chdir "rescale/";
    system "cp IonChannel.gro scale.gro;cp IonChannel.top scale.top";
    
    for($i=0;$i<$MaxTime;$i=$i+1){    
      RunScale("scale.gro","scale.top",@ScaleValue[0+$i],@ScaleValue[$MaxTime+$i],@ScaleValue[$MaxTime*2+$i]);
    }
    system "cp scale.gro ../IonChannel.gro;cp scale.top ../IonChannel.top";
    chdir "../";
    system "rm -rf rescale/";
}

1;
