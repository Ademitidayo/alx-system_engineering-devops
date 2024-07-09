# Setup New Ubuntu server with nginx
# and add a custom HTTP header
# Ensure system is updated before proceeding

exec { 'check update':
  command => '/usr/bin/apt-get update -qq',
  unless  => '/usr/bin/apt-get update -qq',
}

# Ensure the nginx package is installed
package { 'nginx':
  ensure  => installed,
  require => Exec['check update'],
}

# Create and manage the nginx site configuration file
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => @(END),
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    add_header X-Served-By <%= @hostname %>;

    location / {
        try_files \$uri \$uri/ =404;
    }

    if (\$request_filename ~ redirect_me) {
        rewrite ^/redirect_me https://th3-gr00t.tk/ permanent;
    }

    error_page 404 /error_404.html;
    location = /error_404.html {
        internal;
    }
}
END
  notify  => Service['nginx'],
}

# Ensure the nginx site configuration is linked to sites-enabled
file { '/etc/nginx/sites-enabled/default':
  ensure  => link,
  target  => '/etc/nginx/sites-available/default',
  notify  => Service['nginx'],
}

# Allow nginx through the firewall
exec { 'allow-nginx-http':
  command => 'ufw allow "Nginx HTTP"',
  unless  => 'ufw status | grep -q "Nginx HTTP"',
}

# Create index.html file
file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
}

# Ensure the nginx service is running and enabled
service { 'nginx':
  ensure     => running,
  enable     => true,
  require    => Package['nginx'],
  subscribe  => File['/etc/nginx/sites-available/default'],
}
