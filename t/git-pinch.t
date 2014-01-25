use strict;
use warnings;

use Test::More tests => 1;

use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Spec qw();
use Git::Repository qw(File Gerrit Hooks Log);
use IO::File qw();
use Test::Git qw(test_repository);

setup_path();

subtest 'single pinch' => sub {
    plan tests => 5;

    my $r = test_repository();
    my @change_ids = setup($r);

    is(scalar(@change_ids), 5, 'count of @change_ids');

    my $upstream = $r->find_change($change_ids[0])->commit;
    $r->run('branch', 'before');

    my ($start, $end) = (1, $#change_ids);
    for my $index ($start..$end) {
        my $name = $change_ids[$index];
        subtest "pinch at $name" => sub {
            plan tests => 10;

            $r->run('reset', '--hard', 'before');

            diag 'Initial graph:';
            diag join("\n", $r->run('log', '--oneline', '--graph')), "\n";

            # safeguard to verify we reset correctly
            is($r->find_change($change_ids[-1])->commit, $r->run('rev-parse', 'HEAD'),
                'last change is HEAD');

            my $commit = $r->find_change($change_ids[$index])->commit;
            $r->run('pinch', '--upstream', $upstream, $commit);

            for my $change_id (@change_ids[0..$index]) {
                my $before = $r->find_change($change_id, 'refs/heads/before');
                my $after  = $r->find_change($change_id, 'refs/heads/master');
                is($after->commit, $before->commit, "commits match for $change_id");
            }

            for my $change_id (@change_ids[($index + 1)..$end]) {
                my $before = $r->find_change($change_id, 'refs/heads/before');
                my $after  = $r->find_change($change_id, 'refs/heads/master');
                isnt($after->commit, $before->commit, "commits do not match for $change_id");
            }

            my @before = $r->log('refs/heads/before');
            my @master = $r->log('refs/heads/master');
            is(scalar(@before), scalar(@change_ids), 'before has correct number of commits');
            is(scalar(@master), scalar(@change_ids) + 1, 'master has an extra commit (merge)');

            my @merge = grep { !$_->change_id } @master;
            is(scalar(@merge), 1, 'found one merge commit');
            my @parents = $merge[0]->parent;
            my @expected_parents = ($upstream, $commit);
            is_deeply(\@parents, \@expected_parents, 'merge commit has correct parents');

            diag 'Final graph:';
            diag join("\n", $r->run('log', '--oneline', '--graph')), "\n";
        };
    }
};

sub git_state {
    my $repo = shift;
    my $state = [];
    my $log_iterator = $repo->log();
    while (my $log = $log_iterator->next) {
        my @attrs = qw(commit parent tree change_id);
        push @{$state}, { map { $_ => $log->$_ } @attrs };
    }
    return $state;
}

sub setup_path {
    my $t_dir = dirname(__FILE__);
    my $parent_dir = abs_path(File::Spec->join($t_dir, '..'));
    unless (-x File::Spec->join($parent_dir, 'git-pinch')) {
        die "Failed to locate git-pinch in parent directory: $parent_dir";
    }
    my @PATH = split(/:/, $ENV{PATH});
    unshift @PATH, $parent_dir;
    $ENV{PATH} = join(':', @PATH);
}

sub setup {
    my $repo = shift;
    my $source = File::Spec->join(dirname(__FILE__), 'commit-msg');
    $repo->install_hook($source, 'commit-msg');
    my @change_ids;
    cwrite($repo, 'README.md', 'w', 'This is a readme.');
    push @change_ids, $repo->log('-1')->next->change_id;
    cwrite($repo, 'README.md', 'a', 'Line two.');
    push @change_ids, $repo->log('-1')->next->change_id;
    cwrite($repo, 'INSTALL.md', 'w', 'This is an install file.');
    push @change_ids, $repo->log('-1')->next->change_id;
    cwrite($repo, 'INSTALL.md', 'w', 'Line two.');
    push @change_ids, $repo->log('-1')->next->change_id;
    cwrite($repo, 'TODO', 'w', 'This is a TODO.');
    push @change_ids, $repo->log('-1')->next->change_id;
    return @change_ids;
}

sub cwrite {
    my ($repo, $filename, $mode, @content) = @_;
    my $path = File::Spec->join($repo->work_tree, $filename);
    my $file = IO::File->new($path, $mode);
    chomp @content;
    $file->say($_) for @content;
    $file->close();
    $repo->run('add', $path);
    my $verb = {'w' => 'add', 'a' => 'update'}->{$mode};
    $repo->run('commit', '-m', "$verb $filename", '--', $path);
}
