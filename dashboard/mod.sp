mod "cf-hello-steampipe" {
  title = "Cloud Foundry hosted steampipe dashboard"
  description = "a minimal steampipe dashboard on Cloud Foundry"
  categories = ["cf", "steampipe"]
  
  require {
    steampipe = "0.16.4"
    plugin "csv" {
      version = "0.4.0"
    }
  }
}
