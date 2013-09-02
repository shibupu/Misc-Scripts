#!/usr/bin/perl

use strict;

use DateTime;

print 'Enter the subtitle file name: ';
my $file = <STDIN>;
chomp $file;

print "No file name given.\n\n" and exit if !$file;
print "No file exists.\n\n" and exit if !-e $file;

print 'Enter the time diff to add in seconds: ';
my $delta = <STDIN>;
chomp $delta;

print "No time diff given.\n\n" and exit if !$delta;
print "Not a valid time diff.\n\n" and exit if $delta !~ /^ \d+ $/x;

print 'Enter 1 to add or 2 to subtract: ';
my $option = <STDIN>;
chomp $option;

print "No option given.\n\n" and exit if !$option;
print "Not a valid option.\n\n" and exit if $option != 1 && $option != 2;

my $op = ($option == 1) ? '+' : '-';

my @splits = split /\//, $file;
my ($file_name, $extension) = split /\./, $splits[-1];
my $new_file = "${file_name}_new.$extension";

open my $in,  '<', $file     or die "Unable to open $file : $!";
open my $out, '>', $new_file or die "Unable to open $new_file : $!";

while (my $line = <$in>) {
    if ($line
        =~ / (\d{2}) : (\d{2}) : (\d{2}) , (\d{3}) \s --> \s (\d{2}) : (\d{2}) : (\d{2}) , (\d{3}) /x
        )
    {
        my ($start_hour, $start_minute, $start_second, $start_millisecond,
            $end_hour, $end_minute, $end_second, $end_millisecond)
            = ($1, $2, $3, $4, $5, $6, $7, $8);

        my $start_time = DateTime->new(
            year       => 2013,
            hour       => $start_hour,
            minute     => $start_minute,
            second     => $start_second,
            nanosecond => $start_millisecond
        );
        my $end_time = DateTime->new(
            year       => 2013,
            hour       => $end_hour,
            minute     => $end_minute,
            second     => $end_second,
            nanosecond => $end_millisecond
        );

        my $start_time_new = $start_time->add(seconds => "$op$delta");
        my $end_time_new   = $end_time->add(seconds => "$op$delta");

        print $out sprintf "%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d\n",
            $start_time_new->hour,   $start_time_new->minute,
            $start_time_new->second, $start_time_new->nanosecond,
            $end_time_new->hour, $end_time_new->minute, $end_time_new->second,
            $end_time_new->nanosecond;
    } else {
        print $out $line;
    }
}

close $in;
close $out;

print "New subtitle file $new_file created in the current directory.\n\n";

