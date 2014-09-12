#!/usr/bin/perl

=head

MARS ROVERS

A squad of robotic rovers are to be landed by NASA on a plateau on
Mars. This plateau, which is curiously rectangular, must be navigated
by the rovers so that their on-board cameras can get a complete view
of the surrounding terrain to send back to Earth.

A rover's position and location is represented by a combination of x
and y co-ordinates and a letter representing one of the four cardinal
compass points. The plateau is divided up into a grid to simplify
navigation. An example position might be 0, 0, N, which means the
rover is in the bottom left corner and facing North.

In order to control a rover, NASA sends a simple string of letters.
The possible letters are 'L', 'R' and 'M'. 'L' and 'R' makes the rover
spin 90 degrees left or right respectively, without moving from its
current spot. 'M' means move forward one grid point, and maintain the
same heading.

Assume that the square directly North from (x, y) is (x, y+1).

INPUT:
The first line of input is the upper-right coordinates of the plateau,
the lower-left coordinates are assumed to be 0,0.

The rest of the input is information pertaining to the rovers that
have been deployed. Each rover has two lines of input. The first line
gives the rover's position, and the second line is a series of
instructions telling the rover how to explore the plateau.

The position is made up of two integers and a letter separated by
spaces, corresponding to the x and y co-ordinates and the rover's
orientation.

Each rover will be finished sequentially, which means that the second
rover won't start to move until the first one has finished moving.

OUTPUT
The output for each rover should be its final co-ordinates and heading.

INPUT AND OUTPUT

Test Input:
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM

Expected Output:
1 3 N
5 1 E

=cut

use Switch;

my %direction = (
    N => {
        L => W,
        R => E
    },
    S => {
        L => E,
        R => W
    },
    E => {
        L => N,
        R => S
    },
    W => {
        L => S,
        R => N
    }
);

print "Input:\n";

my ($lower_x, $lower_y) = (0, 0);

my $upper_right_coordinates = <STDIN>;
chomp $upper_right_coordinates;
my ($upper_x, $upper_y) = split(/ /, $upper_right_coordinates);

my $position1 = <STDIN>;
chomp $position1;

my $instruction1 = <STDIN>;
chomp $instruction1;

my $position2 = <STDIN>;
chomp $position2;

my $instruction2 = <STDIN>;
chomp $instruction2;

print "Output:\n";

my ($x, $y, $orientation);

($x, $y, $orientation) = get_final_position($position1, $instruction1);
if (check_coordinates($x, $y)) {
    print "Rover1 can not move outside of the grid.\n";
}
else {
    print "$x $y $orientation\n";
}

($x, $y, $orientation) = get_final_position($position2, $instruction2);
if (check_coordinates($x, $y)) {
    print "Rover2 can not move outside of the grid.\n";
}
else {
    print "$x $y $orientation\n";
}

sub get_final_position {
    my ($position, $instruction) = @_;

    my ($x, $y, $orientation) = split(/ /, $position);
    my @instruction = split(//, $instruction);

    foreach (@instruction) {
        if ($_ eq 'M') {
            ($x, $y) = get_coordinates($x, $y, $orientation);
        }
        elsif ($_ eq 'L' || $_ eq 'R') {
            $orientation = get_orientation($orientation, $_);
        }
        else {
            next;
        }
    }

    return ($x, $y, $orientation);
}

sub get_orientation {
    my ($orientation, $direction) = @_;
    return $direction{$orientation}{$direction};
}

sub get_coordinates {
    my ($x, $y, $orientation) = @_;

    switch ($orientation) {
        case 'N' {return ($x, ++$y);}
        case 'S' {return ($x, --$y);}
        case 'E' {return (++$x, $y);}
        case 'W' {return (--$x, $y);}
    }
}

sub check_coordinates {
    my ($x, $y) = @_;
    ($x < $lower_x || $x > $upper_x || $y < $lower_y || $y > $upper_y) ? return 1 : return 0;
}
