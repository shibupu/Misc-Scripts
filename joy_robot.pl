#!/usr/bin/perl -X

use strict;
use Switch;

=head

Joy Robot Simulator

The contest is a simulation of a Joy Robot on a square table top of dimensions 5 X 5 units.

Robot can free to move around the table as there is no other obstacles, but it should not fall down from the table.

We can give commands to the robot like

PLACE X, Y, FACE
MOVE
RIGHT
LEFT
REPORT

Here PLACE should be the first command to place the robot in the table, Other commands should be discarded until get a valid place command

X and Y are the positions and FACE can be NORTH, SOUTH, EAST and WEST

For example, consider (0,0) as the origin which is the SOUTH WEST(bottom left) most corner

MOVE will move the robot one unit forward in the direction currently robot facing.

LEFT and RIGHT will rotate the robot 90 degrees in the specified direction without changing

the position of the robot

REPORT will announce the X, Y and FACE of the robot

Any standard output is acceptable
You can do it in any most comfortable language.

Example Input
PLACE 1, 0, EAST
MOVE
MOVE
LEFT
MOVE
REPORT

OUTPUT
[3, 1, NORTH]

=cut

my %direction = (
    NORTH => {
        LEFT  => 'WEST',
        RIGHT => 'EAST'
    },
    SOUTH => {
        LEFT  => 'EAST',
        RIGHT => 'WEST'
    },
    EAST => {
        LEFT  => 'NORTH',
        RIGHT => 'SOUTH'
    },
    WEST => {
        LEFT  => 'SOUTH',
        RIGHT => 'NORTH'
    }
);

my ($lower_x, $lower_y) = (0, 0);
my ($upper_x, $upper_y) = (5, 5);
my ($x, $y, $face);

print "Input:\n";

my $placed = 0;
while (my $command = <>) {
    chomp $command; # Remove the new line from the end
    $command = uc $command; # In case user provided commands in small letters.
    $command = trim($command);

    if (!$placed && $command !~ /^PLACE.+/) {
        print "First command should be PLACE\n";
    } else {
        if ($command =~ /^PLACE.+/) {
            if (!valid_place_command($command)) {
                print "Invalid PLACE command\n"
            } else {
                place($command);
                $placed = 1;
            }
        } elsif ($command eq 'MOVE') {
            move();
        } elsif ($command ~~ ['LEFT', 'RIGHT']) {
            $face = get_face($face, $command);
        } elsif ($command eq 'REPORT') {
            report();
            last; # Exit the loop
        } else {
            print "Invalid command\n";
        }
    }
}

sub valid_place_command {
    my $command = shift;
    return (
        $command =~ /
            ^PLACE\s+
            [$lower_x-$upper_x],\s*
            [$lower_y-$upper_y],\s*
            (NORTH|SOUTH|EAST|WEST)$
            /x
        )
        ? 1
        : 0;
}

sub place {
    my $command = shift;
    my $args;

    ($command, $args) = map { trim($_) } split / /, $command, 2;
    ($x, $y, $face)   = map { trim($_) } split /,/, $args;
}

sub move {
    if (!valid_coordinates($x, $y)) {
        print "Robot can not move outside of the table.\n";
    } else {
        ($x, $y) = get_coordinates($x, $y, $face);
    }
}

sub report {
    print "Output:\n$x, $y, $face\n";
}

sub get_face {
    my ($face, $direction) = @_;
    return $direction{$face}{$direction};
}

sub get_coordinates {
    my ($x, $y, $face) = @_;

    switch ($face) {
        case 'NORTH' { return ($x, ++$y); }
        case 'SOUTH' { return ($x, --$y); }
        case 'EAST'  { return (++$x, $y); }
        case 'WEST'  { return (--$x, $y); }
    }
}

sub valid_coordinates {
    my ($x, $y)         = @_;
    my ($new_x, $new_y) = get_coordinates($x, $y, $face);

    return (   $new_x < $lower_x
            || $new_x > $upper_x
            || $new_y < $lower_y
            || $new_y > $upper_y) ? 0 : 1;
}

sub trim {
    my $string = shift;
    $string    =~ s/^\s+|\s+$//;
    return $string;
}
