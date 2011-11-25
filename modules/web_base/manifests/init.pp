class web_base {
	
	group { "admin":
		ensure => present,
	}

	user { "fluffbox":
		comment => "Fluffbox Deployer",
		home => "/home/fluffbox",
		shell => "/bin/bash",
		password => '$1$Z4H/cwr8$AAUjbPhfUy6xpObPKMNQX.',
		groups => ['tomcat6', 'admin'],
		ensure => present,
		require => Package["tomcat6"],
	}
	
	file { "/home/fluffbox":
		owner => "fluffbox",
		group => "fluffbox",
		mode => 755,
		ensure => directory,
		require => User["fluffbox"],
	}
	
	file { "/home/fluffbox/.ssh":
		owner => "fluffbox",
		group => "fluffbox",
		mode => 755,
		ensure => directory,
		require => File["/home/fluffbox"],
	}
	
	file { "/u":
		owner => "fluffbox",
		group => "fluffbox",
		mode => 755,
		ensure => directory,
		require => User["fluffbox"],
	}
	
	file { "/home/fluffbox/.ssh/authorized_keys":
		owner => "fluffbox",
		group => "fluffbox",
		mode => 644,
		source => "puppet://$puppetserver/modules/web_base/fluffbox/authorized_keys",
		require => File["/home/fluffbox/.ssh"],
	}
	
	file { "/etc/sudoers":
		owner => "root",
		group => "root",
		mode => 440,
		source => "puppet://$puppetserver/modules/web_base/etc/sudoers",
	}
	
	
	
}
