#-*-perl-*-

use Test::More tests => 9;
use Test::Exception;
use Test::Warn;

use subs qw(R_DUP O_CREAT);
BEGIN {
    @AnyDBM_File::ISA = qw( DB_File SQLite_File SDBM_File );
    use_ok('AnyDBM_File');
    use AnyDBM_File::Importer undef;
}

SKIP : {
    skip "An exporting DBM is not available", 8 unless $AnyDBM_File::ISA[0] ne 'SDBM_File' ;
    warning_like { AnyDBM_File::Importer->import(()) } qr/no symbols/i;
    AnyDBM_File::Importer::import('', qw(:db));
    ok( ref($DB_BTREE) =~ /INFO$/, "import sigils" );
    AnyDBM_File::Importer::import('', qw(:R) );
    is (R_DUP, 32768, "import R_ constants");
    AnyDBM_File::Importer::import('', qw(:O));
    is(O_CREAT, Fcntl::O_CREAT, "import O_ constants");
    undef $DB_BTREE;
    ok( AnyDBM_File::Importer::import('', qw(:bdb)) );
    ok( ref($DB_BTREE) =~ /INFO$/, "import BDB symbols" );
    ok( AnyDBM_File::Importer::import('', qw(:other)), "import other symbols (stub test)" );
    ok( AnyDBM_File::Importer::import('', qw(:all)), "import all symbols (stub test)");

}


