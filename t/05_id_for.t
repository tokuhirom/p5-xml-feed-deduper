use strict;
use warnings;
use Test::More tests => 2;
use XML::Feed::Deduper;
use File::Temp;
use FindBin;
use URI;

my $tmp = File::Temp->new(UNLINK => 1);

sub foo {
}

my $deduper = XML::Feed::Deduper->new(
    path => $tmp->filename,
    id_for => sub {
        my $entry = shift;
        $entry->link;
    },
);

{
    my $feed = XML::Feed->parse( URI->new("file://$FindBin::Bin/samples/02.rss") )
    or die XML::Feed->errstr;
    my @entries = $deduper->dedup($feed->entries);
    is(join(' ', map { $_->link } @entries), 'http://example.com/entry/1 http://example.com/entry/2');
}

{
    my $feed = XML::Feed->parse( URI->new("file://$FindBin::Bin/samples/05.rss") )
    or die XML::Feed->errstr;
    my @entries = $deduper->dedup($feed->entries);
    is(join(' ', map { $_->link } @entries), '');
}

