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

# Copy Java source code into temporary build directory
COPY src/main/java/ /tmp/src/

# Compile all Java sources directly into webapps/ROOT/WEB-INF/classes
RUN mkdir -p webapps/ROOT/WEB-INF/classes && \
    javac -encoding UTF-8 \
          -cp "/usr/local/tomcat/lib/*:webapps/ROOT/WEB-INF/lib/*" \
          -d webapps/ROOT/WEB-INF/classes \
          $(find /tmp/src -name "*.java") && \
    rm -rf /tmp/src

# Expose default Tomcat HTTP port
EXPOSE 8080

# Start Tomcat Server
CMD ["catalina.sh", "run"]
