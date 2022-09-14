dashboard "dashboard-hello" {
  title = "Hello steampipe"

  container {
    title = "Orgs"

    card {
      type = "info"
      icon = "hashtag"
      label = "organisation count"
      sql = "select count(*) from orgs"
      width = "2"
    }
  
  } # container

} # dashboard
