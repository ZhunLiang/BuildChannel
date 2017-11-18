#!/bin/perl
#INPUT
#Input order: directory, electrode X_Y_Z, TotalZLong,DeletaRation,Wall_gro,Wall_top,Ion_gro,Ion_top

#$XYZ="5_5_7";
#$TLong="20";
#$Delete="1_1";
$XYZ=$ARGV[1];
$TLong=$ARGV[2];
$Delete=$ARGV[3];
$Dir_code=`pwd`;
chomp($Dir_code);

@Key_Words=("$ARGV[4]*.gro");
$Files = join(",",@Key_Words);

if(-e $ARGV[0]){
  print "$ARGV[0]";
}
else{
  print "#-------ERROR-------#";
  print "$ARGV[0] should be a director";
  print "#--------end--------#";
  exit();
}

system "cp *.sh *.py *.pl *.mdp $ARGV[0]";
chdir $ARGV[0];

@Gro_Files = <{$Files}>;
$Total=@Gro_Files;
#@Gro_Files are Wall_gro
$WallTop=$ARGV[5];
$IonGro=$ARGV[6];
$IonTop=$ARGV[7];

#Need @WallGro @WallTop @IonGro @IonTop
foreach $gro_file(@Gro_Files){
  system "perl main.pl $XYZ $TLong $Delete $gro_file $WallTop $IonGro $IonTop";
  @file_name=split/\.gro/,$gro_file;
  $gro_name=@file_name[0];
  system "mkdir $gro_name";
  system "mv $gro_file Channel.* temp_out/ $gro_name";
  system "cp MSD_charge_para.dat $gro_name";
}

system "rm -f bash.sh bash_multi.sh bash_MoS2.sh main.pl pretreat.sh function.sh build_electrode.sh tune_ion.sh scale_ion.sh combine.sh CalDelNum.py CombineGro.py DelMole3.py GetMSDpara.py GetZmax.py SortMole.py scale-nvt.mdp tune_npt.mdp";


