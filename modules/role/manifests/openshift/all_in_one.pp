class role::openshift::all_in_one{
  include ::profile::base
  include ::profile::openshift_origin::all_in_one
}
