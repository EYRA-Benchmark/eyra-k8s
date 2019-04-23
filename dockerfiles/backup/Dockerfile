# Contains AWS cli & postgres cli to backup
FROM python:3-alpine
RUN apk update && apk add postgresql-client && pip install awscli
COPY backup.sh /backup.sh
RUN chmod a+x /backup.sh
ENTRYPOINT /backup.sh