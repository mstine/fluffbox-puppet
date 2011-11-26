node 'web' {
	include java, tomcat, web_base
}

node 'db' {
	$mysql_password = "sup3rs3cr3t"
	
	include mysql::server
}
