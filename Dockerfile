# =============================================================================
# FoodRush Dockerfile - Production Tomcat 10.1 & Java 21 Deployment
# =============================================================================

FROM tomcat:10.1-jdk21

LABEL maintainer="FoodRush <support@foodrush.com>"
LABEL description="FoodRush Online Food Ordering & Logistics Platform"

WORKDIR /usr/local/tomcat

# Clean up default Tomcat webapps
RUN rm -rf webapps/*

# Copy web application sources into Tomcat ROOT
COPY src/main/webapp/ webapps/ROOT/

# Copy resources (templates, configs) into classpath if present
COPY src/main/resources/ /tmp/resources/
RUN mkdir -p webapps/ROOT/WEB-INF/classes && \
    cp -r /tmp/resources/* webapps/ROOT/WEB-INF/classes/ 2>/dev/null || true && \
    rm -rf /tmp/resources && \
    cp webapps/ROOT/WEB-INF/lib/*.jar /usr/local/tomcat/lib/ 2>/dev/null || true

# Copy Java source code into temporary build directory
COPY src/main/java/ /tmp/src/

# Compile all Java sources directly into webapps/ROOT/WEB-INF/classes
RUN javac -encoding UTF-8 \
          -cp "/usr/local/tomcat/lib/*:webapps/ROOT/WEB-INF/lib/*" \
          -d webapps/ROOT/WEB-INF/classes \
          $(find /tmp/src -name "*.java") && \
    rm -rf /tmp/src

# Expose default HTTP port
EXPOSE 8080

# Bind Tomcat to Render's $PORT if provided, otherwise default to 8080
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" conf/server.xml && exec catalina.sh run"]
