# @summary analysis of a single resource
#
# analysis of a single resource
#
# @example
#   comply::resource_analysis
plan package::resource_analysis(
  String $resource,
) {
  $targets = get_targets('*')
  $resources = run_task('package', $targets, action => 'status', name => $resource)
  # $report = run_task('package::analyse', 'localhost', resources => $resources)
  $bla = analyse($resources)
}
