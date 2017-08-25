#!/bin/perl

if($GRO==1){
  @NewGroXYZ=split/\s+/, `tail -1 $WallGro`;
  @NewGroXYZ[3]=$TotalZLong;
  @IonChannelXYZ=split/\s+/,`tail -1 IonChannel.gro`;
  @IonTrans[0]=(@NewGroXYZ[1]-@IonChannelXYZ[1])/2;
  @IonTrans[1]=(@NewGroXYZ[2]-@IonChannelXYZ[2])/2;
  @IonTrans[2]=$TotalZLong-@IonChannelXYZ[3]/2;
  system "GROMACSeditconf -f IonChannel.gro -translate @IonTrans[0] @IonTrans[1] @IonTrans[2] -o IonTemp.gro";
  system "PYTHON CombineGro.py -l $WallGro -r IonTemp.gro -n EminTf2N_Ti3C2 -x @NewGroXYZ[1] -y @NewGroXYZ[2] -z @NewGroXYZ[3] -o $OutGro";
  system "rm -f IonTemp.gro";
}

if($TOP==1){
  CombineTop($OutTop, "Wall.top", "IonChannel.top");
}

if($SAVETEMP==1){
  system "mkdir temp_out";
  system "cp $Wall_gro $Wall_top $Ion_gro $Ion_top Wall.gro Wall.top IonChannel.top IonChannel.gro tune_end.gro tune_end.top scale.gro scale.top temp_out/";
}

if($DEL==1){
  system "rm -f $Wall_gro $Wall_top $Ion_gro $Ion_top Wall.gro Wall.top IonChannel.top IonChannel.gro tune_end.gro tune_end.top scale.gro scale.top";
  #system "rm -f $Wall_gro $Wall_top $Ion_gro $Ion_top";
}

1;
