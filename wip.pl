#!/usr/bin/perl

@charsets = qw( u l d ); # CARE: DO NOT DOUBLE-COUNT OR OVERLAP THESE SETS

$nchars = 26 + 26 + 10 ;

sub do_count {
    my $char = shift;
    my $string = shift;
    my $do_count = $string =~ tr/d//;
    return $do_count;
}

sub filter_and_print {
    my @args = @_;
    my $foo = join('*', @args);
    return unless $foo =~ /^[ul]/;
    return unless $foo =~ /[ul]$/;
    return unless (&do_count('d', $foo) == 1);
    $foo =~ s/u/26/g; # there are 26 uppercase letters...
    $foo =~ s/l/26/g; # etc...
    $foo =~ s/d/10/g; # etc...
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

foreach $pwlen (6,7,8) {
    &permute(($pwlen - 1), ()); # zero-indexed
}
print "0\n\n";


foreach $pwlen (6,7,8) {
    print "($nchars ^ $pwlen)+";
}
print "0\n\n";
