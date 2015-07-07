
name "imagemagick"
maintainer "Excella Consulting"
maintainer_email "jason.blalock@excella.com"
description 'Installs imagemagick package'
version '0.1.0'

supports "ubuntu", "~> 14.04.0"

depends 'apt'

recipe "imagemagick::default", "Installs imagemagick package"
