#!/bin/perl
@IonBoxXYZ=split/\s+/,`tail -1 $Ion_gro`;
$NewGroIonV=@NewGroXYZ[1]*@NewGroXYZ[2]*($ChannelLong-0.2); #0.2 means the surface 0.1 nm each side don't have ion
$IonV=@IonBoxXYZ[1]*@IonBoxXYZ[2]*@IonBoxXYZ[3];

my $tune_gro="tune.gro";
my $tune_top="tune.top";

my $Tnum1 = $NewGroIonV/$IonV;
my $Tnum2 = int($Tnum1)+1;
my $Tnum3;
if($Tnum2<=$Tnum1*$Kmin){
  $Tnum3=$NewGroIonV*($Kmin+($Kmax-$Kmin)/2)/($Tnum2+1);
}
elsif($Tnum2>$Tnum1*$Kmax){
  $Tnum3=$NewGroIonV*($Kmax-($Kmax-$Kmin)/2)/$Tnum2;
}
else{
  $Tnum3=$IonV;
}

($TTop_Name,$TTop_Num,$TTop_Mass,$TTop_Top) = GetTopMSD($Ion_top);
@TTop_Name=@$TTop_Name;@TTop_Num=@$TTop_Num;@TTop_Mass=@$TTop_Mass;@TTop_Top=@$TTop_Top;
$TStrMass=StrPara(@TTop_Mass);$TStrTop=StrPara(@TTop_Top);$TStrRatio=StrPara(@DeletaRation);
`PYTHON CalDelNum.py -m $TStrMass -n $TStrTop -d $TStrRatio --Vo $IonV --Vw $Tnum3 >> tune_out`;
my $temp=`cat tune_out`;
@TDelNum=split/\s+/,$temp;
system "rm -f tune_out";
if($DELETE==1){
  $TStrNum=StrPara(@TTop_Num);
  $TStrDel=StrPara(@TDelNum);
  system "PYTHON DelMole3.py -i $Ion_gro -a $TStrNum -n $TStrTop -d $TStrDel -o $tune_gro";  
  TChangeTop($Ion_top,$tune_top);
  #system "rm -f $tune_gro $tune_top";
}

if($RUN==1){
  system "mkdir tune_bulk; cp *.itp tune_npt.mdp tune_bulk/; mv $tune_gro tune_bulk/;mv $tune_top tune_bulk/";
  chdir "tune_bulk/";
  system "GROMACSgrompp -f tune_npt.mdp -c $tune_gro -p $tune_top -o tune.tpr";
  system "GROMACSmdrun -s tune.tpr -v -deffnm tune_run -ntmpi 8";
  #system "mv tune_run.gro tune_end.gro";
  system "echo 0 | GROMACStrjconv -f tune_run.gro -s tune.tpr -pbc mol -o tune_end.gro";
  system "mv tune_end.gro ../;mv $tune_top ../tune_end.top";
  chdir "../";
  system "rm -rf tune_bulk";
}

1;
