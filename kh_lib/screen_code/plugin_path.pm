package screen_code::plugin_path;
use strict;

use File::Path;
use File::Spec;
use Encode qw/encode decode/;

my $rde_name = File::Spec->catfile('screen', 'MonkinCleanser', 'MonkinCleanser.exe');
my $assistant_name = File::Spec->catfile('screen', 'MonkinReport', 'MonkinReport.exe');
my $negationchecker_name = File::Spec->catfile('screen', 'MonkinNegationChecker', 'MonkinNegationChecker.exe');
my $inifile_name = File::Spec->catfile('screen', 'plugin.ini');

sub rde_path{
	return encoding($rde_name);
}

sub assistant_path{
	return encoding($assistant_name);
}

sub negationchecker_path{
	return encoding($negationchecker_name);
}

#System関数に渡す時にOSによって文字コードを変える必要がある
sub encoding{
	my $plugin_name = shift;
	my $encode;
	if ($::config_obj->os eq 'win32') {
		$encode = 'cp932';
	} else {
		$encode = 'utf8';
	}
	return encode($encode, $plugin_name);
}

#オプションファイルを出力するフォルダのパス=プラグインのパス
sub assistant_option_folder{
	return $::config_obj->cwd."/screen/temp/";
}

sub read_inifile{
	my $item = shift;
	my $default = shift;
	my $ret = $default;
	
	my $INI;
	if (-f $inifile_name) {
		open($INI, "<:encoding(utf8)", $inifile_name);
		while (my $line = <$INI>) {
			my @splited = split(/\t/, $line);
			my $temp = $splited[1];
			chomp($temp);
			if ($splited[0] eq $item) {
				$ret = $temp;
				last;
			}
		}
		close($INI);
	}
	
	return $ret;
}

sub save_inifile{
	my $item = shift;
	my $para = shift;
	
	my $INI;
	my @ini_data;
	if (-f $inifile_name) {
		open($INI, "<:encoding(utf8)", $inifile_name);
		while (my $line = <$INI>) {
			my @splited = split(/\t/, $line);
			if ($splited[0] ne $item) {
				push @ini_data, $line;
			}
		}
		close($INI);
	}
	
	open($INI, ">:encoding(utf8)", $inifile_name);
	foreach my $line (@ini_data) {
		print $INI $line;
	}
	print $INI "$item\t$para\n";
	close($INI);
}

1;