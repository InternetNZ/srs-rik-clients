# SRS::Client::Crypt::GnuPG interface
#
#--------------------------------------------------------------------------------------------------
#
# Copyright 2002-2004 NZ Registry Services
#
# This file is part of the Shared Registry System
#
# The Shared Registry System is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# The Shared Registry System is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the Shared Registry System; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
#--------------------------------------------------------------------------------------------------

package SRS::Client::Crypt::GnuPG;

use strict;
use warnings;

use Carp;

use IO::File;
use GnuPG;
use FindBin;
use File::Slurp;

sub new {
    my ($class, %args) = @_;

    my $self = {
        'ctx'        => GnuPG->new(),
        'public_key' => $args{'publicKeyRing'},
        'secret'     => $args{'passphrase'}
    };

    if (defined $args{'publicKeyRing'} ) {
        $self->{'ctx'}->import_keys( keys => [ qw( $args{'publicKeyRing'} ) ] );
        print "Added public key '$args{'publicKeyRing'}' to keyring.";
    }

    if ( defined $args{'secretKeyRing'} ) {
        $self->{'ctx'}->import_keys( keys => [ qw( $args{'secretKeyRing'} ) ] );
        print "Added secret key '$args{'secretKeyRing'}' to keyring.";
    }

    bless $self, $class;

    return $self;

}

sub verify {
    my ($self, %params) = @_;
    
    print "Verify: Primary Key - $FindBin::Bin/../etc/reg.key\n";
    
    print "Verify: Data - $params{'Data'}\n";
    
    my $sig = $self->{'ctx'}->verify( file => "$FindBin::Bin/../etc/reg.key",
                                      signature => "$FindBin::Bin/../etc/reg.key"
    );

    return defined $sig ? 1 : 0;

}

sub sign {
    my ($self, %params) = @_;
    
    print "Sign: Data - $params{'Data'}\n";

    $self->{'ctx'}->sign(  plaintext   => "/home/vagrant/srs-rik-clients/waihi.xml",
                           output      => "/home/vagrant/srs-rik-clients/file.gpg",
                           armor       => 1,
                           sign        => 1,
                           passphrase  => $self->{'passphrase'}
    );

    my $request = read_file('/home/vagrant/srs-rik-clients/waihi.xml');
    my $signature = read_file('/home/vagrant/srs-rik-clients/file.gpg');

    return $request;

}

1;

__END__
