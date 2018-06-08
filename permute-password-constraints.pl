#!/usr/bin/perl
@types = qw( u l d p );

sub filter_and_print {
    my @args = @_;
    my $foo = join('*', @args);
    return unless $foo =~ /u/;
    return unless $foo =~ /l/;
    return unless $foo =~ /d/;
    return unless $foo =~ /p/;
    $foo =~ s/u/26/g;
    $foo =~ s/l/26/g;
    $foo =~ s/d/10/g;
    $foo =~ s/p/32/g;
    print "($foo)+"
}

sub permute {
    my ($depth, @args) = @_;
    foreach my $t (@types) {
        if ($depth) {
            &permute(($depth - 1), @args, $t);
        } else {
            &filter_and_print(@args, $t);
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
