#
define profile::discovery::consul::datadep (
  $key,
  $before    = [],
  $badvalues = [],
  $include   = [],
  $caller    = undef
) {

  $_key = hiera($key, false)

  if (! $_key) or member($badvalues, $_key) {
    $fail = true
  } else {
    include $include

    $fail = false

    if $caller {
      Profile::Discovery::Consul::Multidep<| title == $caller |> {
        response +> $title
      }
    }
  }

  runtime_fail { $title:
    fail    => $fail,
    message => "${title}: ${before} requires ${key}",
    before  => $before
  }
}
