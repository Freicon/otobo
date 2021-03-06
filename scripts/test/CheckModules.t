# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home = $ConfigObject->Get('Home');
my $TmpSumString;

if ( open( $TmpSumString, '-|', "$^X $Home/bin/otobo.CheckModules.pl --all NoColors" ) )    ## no critic qw(InputOutput::RequireBriefOpen)
{

    LINE:
    while (<$TmpSumString>) {
        my $TmpLine = $_;
        $TmpLine =~ s/\n//g;

        next LINE if !$TmpLine;
        next LINE if $TmpLine !~ /^\s*o\s\w\w/;

        if ( $TmpLine =~ m{ok|optional}ismx ) {
            $Self->True(
                $TmpLine,
                "$TmpLine",
            );
        }
        else {
            $Self->False(
                $TmpLine,
                "Error in your installed perl modules: $TmpLine",
            );
        }
    }
    close $TmpSumString;
}
else {
    $Self->False(
        1,
        'Unable to check Perl modules',
    );
}

$Self->DoneTesting();
