#!/usr/bin/perl -w

use File::Temp qw ( tempfile );
use POSIX qw ( strftime );
use Getopt::Long;

use strict;

my $script_dir; BEGIN { use Cwd qw/ abs_path /; use File::Basename; $script_dir = dirname(abs_path($0)); push @INC, $script_dir; }
my $main_dir=dirname(${script_dir});

use IrstLMRegressionTesting;

my $data_dir;
my $test_dir = ${main_dir} . "/tests";
my $results_dir;
my $BIN_TEST = $script_dir;

if (!defined $ENV{HOST}){
my $host=`hostname`;
chomp($host);
$ENV{HOST}=$host;
}

my $test_list=0;
GetOptions("data-dir=s" => \$data_dir,
           "test-dir=s" => \$test_dir,
           "results-dir=s" => \$results_dir,
           "list" => \$test_list,
          ) or exit 1;

$data_dir = IrstLMRegressionTesting::find_data_directory($main_dir, $data_dir);

opendir(D, "$test_dir") || die "Can't open directory $test_dir: $!\n";
my @tests = grep(!/^\.\.?$/, readdir(D));
closedir(D);

my @qsubtests = grep (/qsub$/, @tests);
@tests = grep(!/qsub$/,@tests);

if (@qsubtests){
  my $cmd=&getQsubCmd();
  if (!defined($cmd)){
    print STDERR "Regression tests (@qsubtests) can not run on $ENV{HOST}\nbecause SGE is not installed\n\n";
  }else{
    push @tests, @qsubtests;
  }
}

if ($test_list){
  print STDOUT "List of the available regression tests\n";
  foreach my $test (@tests) {
    print STDOUT "$test\n";
  }
  exit;
}

my $test_run = "$BIN_TEST/run-single-test.pl --data-dir=$data_dir";
$test_run .= " --test-dir=$test_dir" if $test_dir;
$test_run .= " --results-dir=$test_dir" if $results_dir;

print STDOUT "Data directory: $data_dir\n" if $data_dir;
print STDOUT "Test directory: $test_dir\n" if $test_dir;
print STDOUT "Result directory: $results_dir\n\n" if $results_dir;

print STDOUT "Running tests: @tests\n\n";

print STDOUT "TEST NAME\tSTATUS\tPATH TO RESULTS\n";
my $lb = "---------------------------------------------------------------------------------------------------------\n";
print STDOUT $lb;

my $fail = 0;
my @failed;
foreach my $test (@tests) {
  my $cmd = "$test_run --test=$test";
  my ($res, $output, $results_path) = do_test($cmd);

  print STDOUT "$test\t$res\t$results_path\n";

  if ($res eq 'FAIL') {
    print STDOUT "$lb$output";
    print STDOUT "PATH to RESULTS: $results_path\n";
    print STDOUT "$lb";
    $fail++;
    push @failed, $test;
  } else {
    if ($output =~ /TOTAL_WALLTIME\s+result\s*=\s*([^\n]+)/o) {
      print STDOUT "\t\tTiming statistics: $1\n";
    }
  }
}

my $total = scalar @tests;
my $fail_percentage = int(100 * $fail / $total);
my $pass_percentage = int(100 * ($total-$fail) / $total);
print STDOUT "\n$pass_percentage% (".($total-$fail)."/$total) of the tests passed.\n";
print STDOUT "$fail_percentage% ($fail/$total) of the tests failed.\n";
if ($fail_percentage>0) { print STDOUT "\nPLEASE INVESTIGATE THESE FAILED TESTS: @failed\n"; }

sub do_test {
  my ($test) = @_;
  my $o = `$test 2>&1`;
  my $res = 'PASS';
  $res = 'FAIL' if ($? > 0);
  my $od = '';
  if ($o =~ /RESULTS AVAILABLE IN: (.*)$/m) {
    $od = $1;
    $o =~ s/^RESULTS AVAIL.*$//mo;
  }
  return ($res, $o, $od);
}

sub getQsubCmd {
        my $a =`which qsub | head -1 | awk '{print \$1}'`;
        chomp($a);
        if ($a && -e $a){ return $a; }
        else{ return undef; }
}

