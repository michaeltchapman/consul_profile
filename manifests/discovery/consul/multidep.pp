# Use where there are multiple data dependencies
define consul_profile::discovery::consul::multidep (
  $deps,
  $includes   = [],
  $response  = [],
) {
  if sort(unique($deps)) == sort(unique($response)) {
    include $includes
  }
}
