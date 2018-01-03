use Test::More tests => 36;

use FindBin qw($Bin);
use lib "$Bin/../lib";

foreach my $module (
    qw(
    File::Slurp Time::HiRes Pod::Usage FindBin Encode Encoding::FixLatin
    Pod::Usage Carp Getopt::Long JSON::Any JSON::XS Config Date::Parse
    XML::XML2JSON XML::LibXSLT XML::LibXML IO::File Crypt::GpgME Data::Dumper
    LWP::UserAgent LWP::Protocol::https HTTP::Request::Common
    SRS::Client::Comms::XML SRS::Client::Options::SendXML
    SRS::Client::Options::SRSClient SRS::Client::Versions
    SRS::Client::Communications SRS::Client::JSON::Translator
    SRS::Client::URLEncoding SRS::Client::SRSClient SRS::Client::Options
    SRS::Client::XML SRS::Client::Legacy::Translator SRS::Client::Crypt::GpgME
    SRS::Client::Crypt::OpenPGP SRS::Client)
  )
{
    require_ok($module);
}

