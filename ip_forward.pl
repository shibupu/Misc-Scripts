#!/usr/bin/perl -w
use strict;

print 'Enter Source IP: ';
my $YourIP = <STDIN>;
chomp $YourIP;
print "No Source IP given.\n\n" and exit if !$YourIP;
print "Not a valid Source IP.\n\n" and exit if !valid_ip($YourIP);

print 'Enter Target IP: ';
my $TargetIP = <STDIN>;
chomp $TargetIP;
print "No Target IP given.\n\n" and exit if !$TargetIP;
print "Not a valid Target IP.\n\n" and exit if !valid_ip($TargetIP);

print 'Do you want the rules to write to a file (y/n): ';
my $write_file = <STDIN>;
chomp $write_file;
$write_file = 1 if grep { lc $write_file eq $_ } qw(y yes);

my $file_name = 'rules.txt';
open my $out, '>', $file_name or die "Unable to open file : $!"
    if $write_file == 1;

for (qw(30000 30100 30200 30300 30400 30500 30600 30700 30800 30900 31000 31100
31200 31300 31400 31500 31600 31700 31800 31900 32000 32100 32200 32300 32400
32500 32600 32700 32800 32900 33000 33100 33200 33300 33400 33500 33600 33700
33800 33900 34000 34100)) {
    for (my $port = $_; $port <= $_ + 20; $port++) {
        my $rule =
"iptables -t nat -A PREROUTING --dst $YourIP -p tcp --dport $port -j DNAT \
A
dport
--to-destination $TargetIP:$port
destination
iptables -t nat -A POSTROUTING -p tcp --dst $TargetIP --dport $port -j SNAT \
A
port
--to-source $YourIP
iptables -t nat -A OUTPUT --dst $YourIP -p tcp --dport $port -j DNAT \
A
j
--to-destination $TargetIP:$port
destination";

        if ($write_file == 1) {
            print $out "$rule\n\n";
        } else {
            system $rule;
        }
    }
}

if ($write_file == 1) {
    close $out;
    print "Rules have been written to file $file_name.\n";
} else {
    print "iptables updated.\n";
}

sub valid_ip {
    my $ip = shift;
    return $ip =~ /^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$/;
}
