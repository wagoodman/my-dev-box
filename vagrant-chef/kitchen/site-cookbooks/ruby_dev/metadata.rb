name "ruby_dev"
maintainer "Excella Consulting"
maintainer_email "jason.blalock@excella.com"
description 'Installs ruby-dev and libpq-dev package'
version '0.1.0'

supports "ubuntu", "~> 14.04.0"

depends 'apt'

recipe "ruby_dev::default", "Installs ruby-dev and libpq-dev package"
