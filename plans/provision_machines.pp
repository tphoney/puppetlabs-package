# @summary Provisions machines
#
# Provisions machines from the provision type
#
# @example
#   comply::demo_01_provision_machines
plan package::provision_machines(
    Optional[Enum['abs', 'vmpooler']] $provision_type = 'abs',
) {
  # provision agents  agent_linux agent_windows
  run_task("provision::${provision_type}", 'localhost',
    action => 'provision', platform => {
      'centos-7-x86_64'    => 1,
      'centos-6-x86_64'    => 1,
    }, inventory => './', vars => 'role: mysql')
   
  run_task("provision::${provision_type}", 'localhost',
    action => 'provision', platform => {
      'centos-7-x86_64'    => 1,
      'centos-6-x86_64'    => 1,
    }, inventory => './', vars => 'role: apache')
  run_task("provision::${provision_type}", 'localhost',
    action => 'provision', platform => {
      'centos-7-x86_64'    => 1,
    }, inventory => './', vars => 'role: apache mysql')
}
