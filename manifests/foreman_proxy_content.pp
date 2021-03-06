# Prepare the certificates for the node from the parent node
#
# === Parameters:
#
# $parent_fqdn::                    FQDN of the parent node. Does not usually
#                                   need to be set.
#
# $foreman_proxy_fqdn::             FQDN of the foreman proxy
#
# $foreman_proxy_cname::            additional names of the foreman proxy
#
# $certs_tar::                      Path to tar file with certs to generate
#
class certs::foreman_proxy_content (
  String[1] $parent_fqdn = $::fqdn,
  String $foreman_proxy_fqdn = $::certs::params::node_fqdn,
  Array[String] $foreman_proxy_cname = $::certs::params::cname,
  String[1] $certs_tar = $::certs::params::certs_tar,
) inherits certs::params {

  if $foreman_proxy_fqdn == $::fqdn {
    fail('The hostname is the same as the provided hostname for the foreman-proxy')
  }

  class { '::certs::puppet':        hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }
  class { '::certs::foreman':       hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }
  class { '::certs::foreman_proxy': hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }
  class { '::certs::apache':        hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }
  class { '::certs::qpid':          hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }
  class { '::certs::qpid_router':   hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }
  class { '::certs::qpid_client':   hostname => $foreman_proxy_fqdn, cname => $foreman_proxy_cname }

  certs::tar_create { $certs_tar:
    subscribe => Class['certs::puppet', 'certs::foreman', 'certs::foreman_proxy', 'certs::qpid', 'certs::qpid_router', 'certs::apache', 'certs::qpid_client'],
  }
}
