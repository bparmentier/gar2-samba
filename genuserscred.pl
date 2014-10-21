#!/usr/bin/env perl

# Generate login, group, password for each user contained in the given file and
# print them to stdout.

if ($#ARGV + 1 != 1) {
    print "Usage: ./genuserscred.pl users.txt\n";
    print "<users.txt> being a CSV file where each line is structured as follows:\n";
    print "    last name,first name\n";
    exit;
}

use strict;
use warnings;

my $file = $ARGV[0];
my $id = 10000;
my $pwdlength = 8;
my @pwdchars = ("A".."Z", "a".."z", 0..9);
my @groups = ("dev", "system");

open my $info, $file or die "Could not open $file: $!";

# Example: G12345,group,randompwd,Last Name,First Name
while (my $line = <$info>)  {
	print "G" . $id . ",";
    print $groups[rand @groups] . ","; # randomly choose a group
    print $pwdchars[rand @pwdchars] for 1..$pwdlength;
	print "," . $line;
	$id++;
}

close $info;
