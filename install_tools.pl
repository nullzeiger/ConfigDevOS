#!/usr/bin/env perl
use v5.38;
use feature qw(say);
use POSIX qw(WEXITSTATUS);

sub main {
    my @packages = qw(gcc gdb make valgrind curl git);
    install_packages_apt(@packages);
    say "Package installation complete.";
    run_install_scripts();
}

sub install_packages_apt {
    my @packages = @_;
    my $cmd = "sudo apt update && sudo apt install -y @packages";
    execute_command($cmd);
}

sub run_install_scripts {
    my @scripts = qw(
        install_kitty.sh
        install_nvim.sh
        install_go.sh
        install_lazygit.sh
        install_gh.sh
        install_fzf.sh
    );

    for my $script (@scripts) {
        say "Running $script...";
        my $cmd = "bash ./$script";
        execute_command($cmd, "Error running $script");
    }
}

sub execute_command {
    my ($cmd, $err) = @_;
    $err //= "Error executing command";
    say "Executing: $cmd";
    system($cmd);
    if ($? != 0) {
    	my $exit_status = WEXITSTATUS($?);
        die "$err: exit code $exit_status\n";
    }
}

# Entry point
main();
