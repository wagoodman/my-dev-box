directory '/var/lib/sauce_connect' do
  owner 'vagrant'
  mode '0755'
  action :create
end

cookbook_file '/var/lib/sauce_connect/sc-4.3.8-linux.tar.gz' do
  source 'sc-4.3.8-linux.tar.gz'
  owner 'vagrant'
  mode '0755'
  action :create
end

execute 'extract sauce connect tar' do
  command "tar -xzvf /var/lib/sauce_connect/sc-4.3.8-linux.tar.gz"
  cwd '/var/lib/sauce_connect'
  not_if { File.exists?('/var/lib/sauce_connect/sc-4.3.8-linux/bin/sc')}
end

execute 'add sauce-connect alias' do
  command "echo 'alias sauce-connect=/var/lib/sauce_connect/sc-4.3.8-linux/bin/sc' >> /home/vagrant/.bashrc"
end

log 'add sauce connect api keys' do
  message 'You must set these values in .bashrc!!!! export SAUCE_USERNAME=VALUE export SAUCE_ACCESS_KEY=SOMETHING-SECRET'
  level :info
end
