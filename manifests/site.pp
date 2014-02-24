node default {
	include '::ntp'
		class {"ssh::server":port => 22,}
		}

node www inherits default {
	class {'nginx':}
		nginx::resource::vhost { 'debian.of':
			server_name => ['10.0.1.121', 'debian.of'],
			ensure   => present,
    			www_root => '/var/www/',
			ssl      => 'true',
			ssl_cert => '/tmp/server.crt',
			ssl_key  => '/tmp/server.pem',
			}
		nginx::resource::location { '123':
			ensure => 'present',
			vhost => 'debian.of',
			location => '~ \.php',
			fastcgi => 'unix:/var/run/php5-fpm.sock',
			www_root => '/var/www/',
			}

	include phpfpm
	}
