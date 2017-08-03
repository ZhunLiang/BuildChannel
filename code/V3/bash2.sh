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

system "/opt/python/bin/python GetMSDpara.py";
@MoleName = GetMSD("NAME");
@MoleMass = GetMSD("MASS");
@MoleNum = GetMSD("NUM");
$TotalNum = @MoleName;
system "rm -f MSD_out.dat";
#
################Build electrode#############################
require('build_electrode.sh');

################Tune Bulk Ion gro###########################
require('tune_bulk.sh');

