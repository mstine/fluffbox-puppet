class tomcat {
	package { "tomcat6":
		ensure => present,
	}
	
	package { "tomcat6-admin":
		ensure => present,
		require => Package["tomcat6"],
	}
	
	service { "tomcat6":
		ensure => running,
		require => Package["tomcat6-admin"],
	}
}