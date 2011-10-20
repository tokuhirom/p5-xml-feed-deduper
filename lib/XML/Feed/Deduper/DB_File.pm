package XML::Feed::Deduper::DB_File;
use strict;
use warnings;
use Any::Moose;
with 'XML::Feed::Deduper::Role';
use DB_File;

has path => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has db => (
    is => 'rw',
    isa => 'DB_File',
    lazy => 1,
    default => sub {
        my $self = shift;
        ## no critic.
        my $obj = tie my %cache, 'DB_File', $self->path, O_RDWR|O_CREAT, 0666, $DB_HASH or die "cannot open @{[ $self->path ]}";
        $obj;
    }
);

sub find_entry {
    my ( $self, $url ) = @_;

    my $status = $self->db->get( $url, my $value );
    return if $status == 1;    # not found

    return $value;
}

sub create_entry {
    my ( $self, $id, $digest ) = @_;
    $self->db->put( $id, $digest );
    $self->db->sync;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
