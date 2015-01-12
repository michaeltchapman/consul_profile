# Use where there are multiple data dependencies
define profile::discovery::consul::multidep (
  $deps,
  $includes   = [],
  $response  = [],
) {
  if sort($deps) == sort($response) {
    include $includes
    notice("Including from multidep: $includes")
  }
}
