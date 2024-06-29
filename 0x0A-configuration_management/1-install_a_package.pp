#!/usr/bin/pup
# install a package
exec { 'install_flask':
	command	=> '/usr/bin/pip3 install flask==2.1.0 werkzeug==2.1.1',
	path	=> ['/usr/bin', '/usr/local/bin'],
}
