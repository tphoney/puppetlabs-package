# @summary Provisions machines
#
# Provisions machines from the provision type
#
# @example
#   comply::demo_01_provision_machines
plan package::setup_machines(
) {
  $targets = get_targets('*')
  $apache_targets = get_targets('*').filter |$n| { $n.vars['role'] =~ /apache/ }
  $mysql_targets = get_targets('*').filter |$n| { $n.vars['role'] =~ /mysql/ }
   # install all agents on everything
  run_task('puppet_agent::install', $targets,
    install_options => 'REINSTALLMODE="amus" PUPPET_AGENT_STARTUP_MODE=Manual',
    collection => 'puppet6') 

  run_command('puppet module install puppetlabs-mysql', $mysql_targets)
  run_command("puppet apply -e \"class { 'mysql::server': root_password => 'password' }\"", $mysql_targets, '_catch_errors' => true)
  run_command('puppet module install puppetlabs-apache', $apache_targets)
  run_command("puppet apply -e \"class { 'apache': }\"", $apache_targets, '_catch_errors' => true)
}
