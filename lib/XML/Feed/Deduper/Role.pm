package XML::Feed::Deduper::Role;
use strict;
use warnings;

use Digest::MD5 ();

use Mouse::Role;

has compare_body => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
);

has ignore_id => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
);

has id_for => (
    is      => 'rw',
    default => 0,
);

# $engine->find_entry($id) => md5hash
requires 'find_entry';
# $engine->create_entry($id, $digest) => undef
requires 'create_entry';

no Mouse::Role;

sub _id_for {
    my ($self, $entry) = @_;

    if ($self->id_for) {
       return $self->id_for->($entry);
    } elsif ($entry->can('id') && !$self->ignore_id) {
        return $entry->id;
    } elsif ($entry->modified) {
        return join ":", $entry->link, $entry->modified;
    } else {
        return $entry->link;
    }
}

sub is_new {
    my ( $self, $entry ) = @_;

    my $exists = $self->find_entry( $self->_id_for($entry) ) or return 1;

    if ( $self->compare_body ) {
        return $exists ne _digest($entry);
    }
    else {
        return 0;
    }
}

sub add {
    my ( $self, $entry ) = @_;
    $self->create_entry( $self->_id_for($entry), _digest($entry) );
}

sub _digest {
    my $entry = shift;
    my $content = ($entry->title||'') . ($entry->content||'');
    utf8::encode($content) if utf8::is_utf8($content);
    my $digest = Digest::MD5::md5_hex($content);
    return $digest;
}

1;
