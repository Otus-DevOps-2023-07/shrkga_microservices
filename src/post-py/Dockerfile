# shrkga/post:2.0

FROM alpine:3.9

WORKDIR /app
COPY . ./

RUN set -x \
 && apk --no-cache --update add python3 py3-pip python3-dev build-base gcc musl-dev \
 && pip3 install --no-cache-dir -r requirements.txt \
 && apk del python3-dev build-base

ENV POST_DATABASE_HOST=post_db POST_DATABASE=posts

ENTRYPOINT ["python3", "post_app.py"]
