#!/bin/perl
#INPUT
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

sub TChangeTop{
  my $topnum=@TTop_Name;
  system "cp $_[0] $_[1]";
  for(my $i=0;$i<$topnum;$i+=1){
    my $Ttemp_match="@TTopName[$i]\\s\\+\\([0-9]\\+\\)";
    my $Tnum=@TTop_Top[$i]-@TDelNum[$i];
    my $Ttemp_re="@TTopName[$i]\\t$Tnum";
    system "sed -i 's/$Ttemp_match/$Ttemp_re/g' $_[1]";
  }
}

sub CombineTop{
  my $Num = @_;
  my $i,$j;
  system "cp @_[1] $_[0]";
  for($i=2;$i<$Num;$i+=1){
    for($j=0;$j<$TotalNum;$j+=1){
       `grep -w @MoleName[$j] @_[$i] >> @_[0]`;
    }
  }
}

sub RunScale{
  system "GROMACSeditconf -f $_[0] -scale $_[2] $_[3] $_[4] -o $_[0]";
  ####!!!!!!!!ATENSTION!!!!!!!!THE NEXT TWO LINE MAYBY WRONG !!!!#####
  system "GROMACSgrompp -f scale-nvt.mdp -c $_[0] -p $_[1] -o run.tpr";
  system "GROMACSmdrun -s run.tpr -v -deffnm run -ntmpi 1 -ntomp 32 ";
  system "echo 0 | GROMACStrjconv -s run.tpr -f run.gro -pbc mol -o $_[0]";
}

1;

