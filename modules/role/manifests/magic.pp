class role::magic {
  $roles = hiera_array('roles', ['generic'])

  if $roles == undef {
    $roles = ["generic"]
  }

  include ::base

  add_role { $roles: }

  define add_role() {
    $role_class = "role::${name}"
    include $role_class
    $list_name = regsubst($name, '::', '-', 'G')
  }
}
