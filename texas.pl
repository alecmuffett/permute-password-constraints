#!/usr/bin/perl

@acceptable_lengths = (8); # The password must be exactly 8 characters long.

%charsets = (
    'l' => 'abcdefghijklmnopqrstuvwxyz',
    'd' => '0123456789',
    's' => '@#$',
    );

foreach $charset (keys %charsets) {
    $setsizes{$charset} = length($charsets{$charset});
    warn $charset, ' size ', $setsizes{$charset}, "\n";
}

foreach $charset (keys %charsets) {
    my @x = split(//, $charsets{$charset});
    $characters{$charset} = \@x;
    warn $charset, ' set ', @{$characters{$charset}}, "\n";
}

# ------------------------------------------------------------------

$counter = 0;

sub print_password {
    #my @pw = @_;
    #print @pw, "\n";
    $counter++;
}

sub filter_pattern {
    my $pattern = shift;
    my $element = shift;
    my $limit = shift;
    my @preamble = @_;
    my $charset = substr($pattern, $element, 1);

    if ($element > 0) {
        $tos = $preamble[$#preamble]; # top-of-stack
    } else {
        $tos = undef; # would underflow
    }

    foreach $character (@{$characters{$charset}}) {
        if (defined($tos) && ($character == $tos)) { # No sets (dups) are allowed
            next;
        }
        if ($element == $limit) {
            &print_password(@preamble, $character);
        } else {
            &filter_pattern($pattern, $element+1, $limit, @preamble, $character);
        }
    }
}

sub expand_pattern {
    my $pattern = shift;
    # old maths code:
    # foreach $charset (keys %setsizes) { $pattern =~ s!$charset!$setsizes{$charset}!ge; }
    &filter_pattern($pattern, 0, length($pattern)-1, ());
}

sub filter_permutation {
    my @args = @_;
    my $pattern = join('', @args);
    return unless $pattern =~ /l/; # It must contain at least one letter
    return unless $pattern =~ /d/; # It must contain at least ... one number
    return unless $pattern =~ /s/; # It must contain ... one of the following special characters.
    return if $pattern =~ /^s/; # A special chaacter must not be located in the first ...
    return if $pattern =~ /s$/; # A special chaacter must not be located in the ... last position.
    &expand_pattern($pattern);
}

sub permute_sets {
    my ($depth, @args) = @_;
    foreach my $charset (keys %setsizes) {
        if ($depth) {
            &permute_sets(($depth - 1), @args, $charset);
        } else {
            &filter_permutation(@args, $charset);
        }
    }
}

# ------------------------------------------------------------------

foreach $pwlen (@acceptable_lengths) {
    &permute_sets(($pwlen - 1), ()); # zero-indexed
}

print "total: $counter\n";
