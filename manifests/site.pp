node default {
	include '::ntp'
		
	class { 'ssh::server':
        options => {
		'PasswordAuthentication' => 'yes',
        	'PermitRootLogin'        => 'yes',
        	'Port'                   => [22, 2222],
     		}
	}
    }


node /^www/ inherits default {
		
		class {'nginx':}
		
		nginx::resource::vhost { "$hostname.of" :
			server_name => [$ipaddress, "$hostname.of", '192.168.0.121'],
			ensure   => present,
    			www_root => '/var/www/',
			ssl      => 'true',
			ssl_cert => '/tmp/server.crt',
			ssl_key  => '/tmp/server.pem',
			}
			
		nginx::resource::location { '123':
			ensure => 'present',
			vhost => "$hostname.of",
			location => '~ \.php',
			fastcgi => 'unix:/var/run/php5-fpm.sock',
			www_root => '/var/www/',
			}

		include phpfpm
		
		class { '::mysql::server':
 			root_password    => 'root',
  			}
			
			database {test:
				ensure => present,
				charset => 'utf8',
				require => Class['mysql::server'],
				}
		
	}
