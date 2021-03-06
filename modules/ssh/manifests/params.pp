class ssh::params {
  case $::osfamily {
    debian: {
      $server_package_name = 'openssh-server'
      $client_package_name = 'openssh-client'
      $sshd_config = '/etc/ssh/sshd_config'
      $ssh_config = '/etc/ssh/ssh_config'
      $ssh_known_hosts = '/etc/ssh/ssh_known_hosts'
      $service_name = 'ssh'
    }
    redhat: {
      $server_package_name = 'openssh-server'
      $client_package_name = 'openssh-clients'
      $sshd_config = '/etc/ssh/sshd_config'
      $ssh_config = '/etc/ssh/ssh_config'
      $ssh_known_hosts = '/etc/ssh/ssh_known_hosts'
      $service_name = 'sshd'
    }
    default: {
      case $::operatingsystem {
        gentoo: {
          $server_package_name = 'openssh'
          $client_package_name = 'openssh'
          $sshd_config = '/etc/ssh/sshd_config'
          $ssh_config = '/etc/ssh/ssh_config'
          $ssh_known_hosts = '/etc/ssh/ssh_known_hosts'
          $service_name = 'sshd'
        }
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }

  $sshd_default_options = {
    'ChallengeResponseAuthentication' => 'no',
    'X11Forwarding'                   => 'yes',
    'PrintMotd'                       => 'no',
    'AcceptEnv'                       => 'LANG LC_*',
    'Subsystem'                       => 'sftp /usr/lib/openssh/sftp-server',
    'UsePAM'                          => 'yes',
  }

  $ssh_default_options = {
    'Host *'                 => {
      'SendEnv'              => 'LANG LC_*',
      'HashKnownHosts'       => 'yes',
      'GSSAPIAuthentication' => 'yes',
    },
  }
}
