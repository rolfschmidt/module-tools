#!/usr/bin/perl -w
# --
# bin/CodeInstall.pl - to install the packagesetup CodeInstall()
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CodeInstall.pl,v 1.1 2010-05-17 19:32:42 ub Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Getopt::Std;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::XML;

# call the script with the module name as first argument
my $Module = shift;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix    => "OTRS-$Module",
    ConfigObject => $CommonObject{ConfigObject},
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{XMLObject}  = Kernel::System::XML->new(%CommonObject);

# create the package name
my $CodeModule = 'var::packagesetup::' . $Module;

# load the module
if ( $CommonObject{MainObject}->Require($CodeModule) ) {

    # create new instance
    $CommonObject{CodeObject} = $CodeModule->new(%CommonObject);
}

print "Run CodeInstall()\n";
$CommonObject{CodeObject}->CodeInstall();
print "... done\n"
