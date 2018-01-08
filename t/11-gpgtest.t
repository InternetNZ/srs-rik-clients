use Test::More tests => 4;
use List::MoreUtils 'none';

use FindBin qw($Bin);
use lib "$Bin/../lib";

BEGIN {
    use_ok('SRS::Client::Options::SRSClient')
      or BAIL_OUT "Can't load SRSClient module";
    use_ok('SRS::Client::Crypt::GpgME') or BAIL_OUT "Can't load GpgME module";
}

my $optionParser = SRS::Client::Options->new();
my $option       = $optionParser->getOptions( \@ARGV );

SKIP: {
    # Check that at least one required variable has been specified
    if ( none { $option->{$_} }
        qw(gpg_id gpg_public gpg_secret gpg_passphrase gpg_passphrase_file) )
    {
        skip 'no variables defined', 2;
    }

    # Try and create the object
    my $obj = new_ok(
        'SRS::Client::Crypt::GpgME',
        [
            secretKeyRing => $option->{gpg_secret},
            publicKeyRing => $option->{gpg_public},
            passphrase    => $option->{gpg_passphrase},
            uid           => $option->{gpg_id},
        ],
        'Create GpgME object'
    ) or BAIL_OUT "Can't create GpgME object";

    # Try and sign the object
    my $sig = $obj->sign( Data => 'Test string' );
    like( $sig, qr'-----BEGIN PGP SIGNATURE-----', 'Can sign a message' );
}

use Data::Dumper;
