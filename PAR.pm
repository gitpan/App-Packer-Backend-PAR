package App::Packer::Backend::PAR;

use strict;
use vars '$VERSION';
use Config;
use File::Temp ();
use Archive::Zip;
use FileHandle;
use File::Spec::Functions qw(path catfile);

$VERSION = '0.01';

my $par = _path_search( 'par' )
  or die "Can't find 'par' executable in PATH";

sub new {
  my $ref = shift;
  my $class = ref( $ref ) || $ref;
  my $this = bless {}, $class;

  return $this;
}

sub set_files {
  # todo: -B
  my $this = shift;
  my %data = @_;

  $this->{FILES}{MAIN} =
    $data{main} !~ m/\.pm$/i ? $data{main}{file} : undef;

  # flatten data structure
  my %all_files = 
    map { ( $_->{store_as}, $_->{file} ) }# and get ->{file} for all elems.
      map { @{$data{$_}} }                # flatten the array
        grep { $_ ne 'main' } keys %data; # for all keys != main

  $this->{FILES}{FILES} = \%all_files;
}

sub set_options {
  # -B, pass somehow!
}

sub _path_search {
  my $file = shift;
  $file .= $Config{_exe}
    unless $file =~ m/$Config{_exe}$/oi;

  foreach my $p ( path() ) {
    my $f = catfile( $p, $file );
    return $f if -f $f;
  }

  return;
}

use vars '%files';
sub write {
  my $this = shift;
  my $exe = shift;
  my( $fh, $file ) = File::Temp::tempfile( UNLINK => 0 );
  my $zip = Archive::Zip->new;
  local *files = $this->{FILES}{FILES};

  $zip->addFile( $this->{FILES}{MAIN}, 'script/main.pl' )
    if defined $this->{FILES}{MAIN};

  foreach my $f ( keys %files ) {
    print "Add: lib/$f\n";
    $zip->addFile( $files{$f}, "lib/$f" );
  }

  $zip->writeToFileHandle( $fh, 1 );
  close $fh;

  system( $par, "-q", "-B", "-O$exe", $file );

  unlink $file;
}

1;

__END__

=head1 NAME

App::Packer::Backend::PAR - backend based on PAR (Perl ARchive)

=head1 DESCRIPTION

This is a C<App::Packer> backend based on C<PAR> from
Aurijus Tang (CPAN id: AUTRIJUS).

=head1 AUTHORS

Mattia Barbon (CPAN id: MBARBON), based upon the pp script from C<PAR>,
written by Autrijus Tang (CPAN id: AUTRIJUS).

=cut

# local variables:
# mode: cperl
# end:

