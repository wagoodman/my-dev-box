#!/bin/bash
mkdir -p /tmp/userdata/chef
date > /tmp/userdata/starttime
useradd -m vagrant
usermod -s /bin/bash vagrant
wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.2.0-2_amd64.deb
dpkg -i chefdk_0.2.0-2_amd64.deb
apt-get update
apt-get -y install ruby1.9.1-dev
apt-get -y install make
#apt-get -y install build-essential
apt-get -y install git
#\curl -sSL https://get.rvm.io | bash -s stable --ruby
#sleep 15
#source /usr/local/rvm/scripts/rvm
gem install bundler
gem install chef -v 11.4.0
#gem install berkshelf
cat > /tmp/userdata/solo.rb << SOLORB
file_cache_path  '/tmp/userdata/chef/'
cookbook_path    '/tmp/userdata/chef/cookbooks/'
SOLORB
mkdir /root/.ssh/
cat > /root/.ssh/github.pem << GITHUBPEM
-----BEGIN RSA PRIVATE KEY-----

REDACTED:INSERT_KEY

-----END RSA PRIVATE KEY-----
GITHUBPEM
touch /root/.ssh/config
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
eval `ssh-agent -s`
chmod 600 /root/.ssh/github.pem /root/.ssh/config
ssh-add /root/.ssh/github.pem
git clone git@github.com:excellaco/myDevBox.git /tmp/userdata/chef/
cd /tmp/userdata/chef/
berks vendor cookbooks
cat > /tmp/userdata/formattedattributes.json <<CHEFJSON
{
 "run_list": [
 "recipe[build-essential]",
 "recipe[java]",
 "recipe[openssl]",
 "recipe[postgresql::server]",
 "recipe[python]",
 "recipe[yum]",
 "recipe[rvm::system]",
 "recipe[rvm::vagrant]",
 "recipe[passenger_apache2]",
 "recipe[pg_user]"
],

    "java": {
        "install_flavor": "oracle",
        "jdk_version": "8",
        "oracle": {
            "accept_oracle_download_terms": true
        }
    },
    "postgresql": {
        "version": "9.3",
        "enable_pgdg_apt": true,
        "password": {
            "postgres": "password"
        },
        "config": {
            "listen_addresses": "*",
            "log_error_verbosity": "verbose",
            "log_connections": "on",
            "log_min_error_statement": "info",
            "log_min_duration_statement": "0"
        },
        "pg_hba": [
            {
                "type": "local",
                "db": "all",
                "user": "postgres",
                "addr": null,
                "method": "ident"
            },
            {
                "type": "local",
                "db": "all",
                "user": "all",
                "addr": null,
                "method": "ident"
            },
            {
                "type": "host",
                "db": "all",
                "user": "all",
                "addr": "0.0.0.0/0",
                "method": "md5"
            },
            {
                "type": "host",
                "db": "all",
                "user": "all",
                "addr": "::1/128",
                "method": "md5"
            },
            {
                "type": "local",
                "db": "all",
                "user": "all",
                "addr": null,
                "method": "ident"
            }
        ]
    },
    "rvm": {
        "default_ruby": "ruby-2.1.2"
    }
}
CHEFJSON
cat /tmp/userdata/formattedattributes.json | awk '{printf("%s",$0)}' > /tmp/userdata/attributes.json
cd /tmp/userdata/
chef-solo -c /tmp/userdata/solo.rb -j /tmp/userdata/attributes.json
date>/tmp/userdata//stoptime
