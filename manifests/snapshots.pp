class zfs::snapshots {

  file { '/usr/local/bin/zfs-snapshot.rb':
    source => 'puppet:///modules/zfs/zfs-snapshot.rb',
    owner  => 'root',
    group  => '0',
    mode   => '0750',
  }

  $env = $operatingsystem ? {
    'freebsd' => 'PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    'solaris' => undef,
    'sunos'   => undef,
    default   => undef,
  }

  cron {
    'zfs hourly snapshot':
      user        => 'root',
      minute      => '5',
      command     => '/usr/local/bin/zfs-snapshot.rb -r -c 25 -s hourly',
      environment => $env,
      require     => File['/usr/local/bin/zfs-snapshot.rb'];
    'zfs daily snapshot':
      user        => 'root',
      minute      => '10',
      hour        => '1',
      command     => '/usr/local/bin/zfs-snapshot.rb -r -c 8 -s daily',
      environment => $env,
      require     => File['/usr/local/bin/zfs-snapshot.rb'];
    'zfs weekly snapshot':
      user        => 'root',
      minute      => '15',
      hour        => '2',
      weekday     => '0',
      command     => '/usr/local/bin/zfs-snapshot.rb -r -c 5 -s weekly',
      environment => $env,
      require     => File['/usr/local/bin/zfs-snapshot.rb'];
  }
}
