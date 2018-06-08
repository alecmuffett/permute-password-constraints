#!/usr/bin/perl

@charsets = qw( u l d p ); # CARE: DO NOT DOUBLE-COUNT OR OVERLAP THESE SETS

sub filter_and_print {
    my @args = @_;
    my $foo = join('*', @args);
    return unless $foo =~ /u/; # must contain one upper
    return unless $foo =~ /l/; # ...lower
    return unless $foo =~ /d/; # ...digit
    return unless $foo =~ /p/; # ...punct/symbol
    $foo =~ s/u/26/g; # there are 26 uppercase letters...
    $foo =~ s/l/26/g; # etc...
    $foo =~ s/d/10/g; # etc...
    $foo =~ s/p/32/g; # etc...
    print "($foo)+"
}

sub permute {
    my ($depth, @args) = @_;
    foreach my $charset (@charsets) {
        if ($depth) {
            &permute(($depth - 1), @args, $charset);
        } else {
            &filter_and_print(@args, $charset);
        }
    }
}

# ------------------------------------------------------------------

$pwlen = shift || 6;
print "$pwlen\n";
&permute(($pwlen - 1), ()); # zero-indexed
print "0\n\n";
$nchars = 26 + 26 + 10 + 32;
print "$nchars ^ $pwlen\n";
