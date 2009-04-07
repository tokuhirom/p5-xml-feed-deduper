package XML::Feed::Deduped;
use Any::Moose;
use XML::Feed;
our $VERSION = '0.01';

sub BUILD {
    my ($self, $args) = @_;
    my $engine = delete $args->{engine} || 'DB_File';
    $engine = $engine =~ s/^\+// ? $engine : "@{[ __PACKAGE__ ]}::${engine}";
    Any::Moose::load_class($engine);
    my $instance = $engine->new($args) or die 'wtf?';
    $self->{engine} = $instance;
}

sub dedup {
    my ($self, @entries) = @_;
    my $engine = $self->{engine} or die 'wtf?';

    my @res;
    for my $entry (@entries) {
        next unless $engine->is_new($entry);
        push @res, $entry;
        $engine->add($entry);
    }
    return @res;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

XML::Feed::Deduped - dedup entries from feed

=head1 SYNOPSIS

    use XML::Feed;
    use XML::Feed::Deduped;
    my $feed = XML::Feed->parse($content);
    my $deduper = XML::Feed::Deduped->new(
        path => '/tmp/foo.db',
    );
    for my $entry ($deduper->dedup($feed->entries)) {
        # only new entries come here!
    }

=head1 DESCRIPTION

XML::Feed::Deduped is deduper for XML::Feed.

You can easy to write the aggregator more easily :)

The concept is stolen from L<Plagger::Rule::Deduped>.

Enjoy!

=head1 CAUTION

This module is still in its beta quality.

your base are belongs to us!

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

L<Plagger::Rule::Deduped>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
