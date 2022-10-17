dashboard "dashboard-hello" {
  title = "Hello steampipe"

  container {
    title = "Orgs"

    text {
      width = 12
      value = <<-EOM
        # About

        this is a trivial test dashboard to test how we might deploy a steampipe dashboard using AWS Copilot to ECS/Fargate

        The code is from [pauldougan/hello-steampipe](https://github.com/pauldougan/hello-steampipe)
      
      EOM
    }
    card {
      type = "info"
      icon = "hashtag"
      label = "organisation count"
      sql = "select count(*) from orgs"
      width = "2"
    }
    table {
      # 
      title = "Orgs"
      sql = "select owner,region,org_name, org_guid, created, suspended from orgs order by owner"
      width = "12"
    }
  
  } # container

} # dashboard
