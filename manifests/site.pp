node default {
	include '::ntp'
		class {"ssh::server":port => 22,}
		}

node www inherits default {
		class {'nginx':}
		nginx::resource::vhost { "$hostname.of" :
			server_name => [$ipaddress, "$hostname.of"],
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
  			override_options => { 'mysqld' => { 'max_connections' => '1024' } }
}
	}
