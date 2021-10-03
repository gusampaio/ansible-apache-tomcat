FROM tomcat:9-alpine

ENV CATALINA_BASE /usr/local/tomcat

COPY src/sample.war ${CATALINA_BASE}/webapps

EXPOSE 8080

CMD ["catalina.sh", "run"]
