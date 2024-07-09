# Setup New Ubuntu server with nginx
# and add a custom HTTP header
# Ensure system is updated before proceeding

exec { 'check update':
  command => '/usr/bin/apt-get update -qq',
  unless  => '/usr/bin/apt-get update -qq',
}

package { 'nginx':
  ensure  => installed,
  require => Exec['check update'],
}

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

file { '/etc/nginx/sites-enabled/default':
  ensure  => link,
  target  => '/etc/nginx/sites-available/default',
  notify  => Service['nginx'],
}

exec { 'allow-nginx-http':
  command => 'ufw allow "Nginx HTTP"',
  unless  => 'ufw status | grep -q "Nginx HTTP"',
}

file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
}

service { 'nginx':
  ensure     => running,
  enable     => true,
  require    => Package['nginx'],
  subscribe  => File['/etc/nginx/sites-available/default'],
}
