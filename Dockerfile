FROM turbot/steampipe
# Setup prerequisites (as root)
EXPOSE 8080
RUN  steampipe plugin install steampipe csv
WORKDIR .
ADD *.sp .
ADD orgs.csv .
ADD config .
CMD ["steampipe", "dashboard", "--dashboard-port", "8080", "--dashboard-listen=network"]