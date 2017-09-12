#!/bin/bash

echo "
Setting Nginx sever ..."
########################################################################
### create upstream
sudo mkdir /etc/nginx/upstream

sudo tee /etc/nginx/upstream/notebook <<EOF
    upstream notebook {
        server 127.0.0.1:${NOTEBOOK_PORT};
    }
EOF

sudo tee /etc/nginx/upstream/rstudio <<EOF
    upstream rstudio {
        server 127.0.0.1:${RSTUDIO_PORT};
    }
EOF

########################################################################
### create locations
sudo mkdir /etc/nginx/location

sudo tee /etc/nginx/location/notebook <<EOF
        location /notebook {
            $ACCESS_NOTEBOOK
            proxy_pass http://notebook;
            include proxy_params;
        }
EOF

sudo tee /etc/nginx/location/rstudio <<EOF
        location /rstudio {
            $ACCESS_RSTUDIO
            rewrite ^/rstudio/(.*) /\$1 break;
            proxy_pass http://rstudio/;
            include proxy_params;
        }
EOF

if [ -f /etc/nginx/proxy_params ] && ! [ -f /etc/nginx/proxy_params.orig ]; then
    sudo mv /etc/nginx/proxy_params /etc/nginx/proxy_params.orig
fi
sudo tee /etc/nginx/proxy_params <<EOF
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header Host \$http_host;
proxy_cache_bypass \$http_upgrade;
# proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto \$scheme;
add_header Front-End-Https on;

proxy_set_header X-NginX-Proxy true;

### WebSocket support
proxy_http_version 1.1;
proxy_set_header Upgrade \$http_upgrade;
proxy_set_header Connection 'upgrade';

proxy_redirect off;
proxy_ssl_session_reuse off;
EOF

if [ -f /etc/nginx/nginx.conf ] && ! [ -f /etc/nginx/nginx.conf.orig ]; then
    sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
fi
sudo tee /etc/nginx/nginx.conf <<EOF
user $USER;

worker_processes 4;
pid /var/run/nginx.pid;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    # server_tokens off;

    # server_names_hash_bucket_size 64;
    # server_name_in_redirect off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_comp_level 6;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_proxied any;
    gzip_types text/plain text/css text/csv application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_buffers 16 8k;

    large_client_header_buffers 4 16k;

    map \$http_upgrade \$connection_upgrade {
        default upgrade;
        '' close;
    }

    include upstream/*;
    include /etc/nginx/conf.d/*;
    include /etc/nginx/sites-enabled/*;
}
EOF

sudo rm /etc/nginx/sites-enabled/*
sudo tee /etc/nginx/sites-available/dev <<EOF
    server {
        #reai_ip_header X-Forwarded-For;
        #set_real_ip_from 127.0.0.1;

        server_name $NODEIP localhost;

        listen 80;
        #listen [::]:80;

        include location/*;
    }
EOF
sudo ln -s /etc/nginx/sites-available/dev /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
