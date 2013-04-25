requires 'perl', 'v5.8.8';

requires 'Any::Moose', '0.1';
requires 'DB_File';
requires 'XML::Feed', '0.41';
requires 'Digest::MD5';

on test => sub {
    requires 'Test::More', '0.98';
    requires 'File::Temp';
    requires 'URI';
};
