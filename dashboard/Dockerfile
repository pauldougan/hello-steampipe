FROM turbot/steampipe
EXPOSE 8080
RUN  steampipe plugin install steampipe csv
WORKDIR .
ADD *.sp .
ADD config .
ADD data .
CMD ["steampipe", "dashboard", "--dashboard-port", "8080", "--dashboard-listen=network"]
