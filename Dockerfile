FROM gradle:7.1.1-jdk8 AS TEMP_BUILD_IMAGE
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
RUN which gradle
RUN which java
#COPY build.gradle settings.gradle $APP_HOME
COPY ./ $APP_HOME/
RUN ls -lart $APP_HOME/
#COPY gradle $APP_HOME/gradle
COPY --chown=gradle:gradle . /home/gradle/src
USER root
RUN chown -R gradle /home/gradle/src
RUN gradle clean build
RUN ls -lart build/
#CMD ["java" "-jar" "/usr/app/gradle/demo-1.jar"]

FROM adoptopenjdk/openjdk11:alpine-jre
ENV ARTIFACT_NAME=demo-0.0.1-SNAPSHOT.jar
ENV APP_HOME=/usr/app/

WORKDIR $APP_HOME
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/build/libs/$ARTIFACT_NAME .

EXPOSE 8080
ENTRYPOINT exec java -jar ${ARTIFACT_NAME}