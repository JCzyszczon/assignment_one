FROM ubuntu:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git
    
ARG PA_TOKEN

RUN git clone https://${PA_TOKEN}@github.com/JCzyszczon/assignment_one.git

WORKDIR /assignment_one/src/main/java/com/assignment_one/

# RUN apt-get install -y default-jdk

# RUN javac -d . App.java

CMD ["java", "com.assignment_one.App"]
