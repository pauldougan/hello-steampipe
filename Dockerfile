FROM turbot/steampipe
# Setup prerequisites (as root)
RUN  steampipe plugin install steampipe csv
WORKDIR .
ADD *.sp .
ADD orgs.csv .
ADD config .
CMD ["steampipe", "dashboard", "--dashboard-port", "8080", "--dashboard-listen=network"]
