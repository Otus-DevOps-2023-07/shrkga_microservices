# Репозиторий shrkga_microservices
Описание выполненных домашних заданий.

## ДЗ #14. Docker образы. Микросервисы
Выполнены все основные и дополнительные пункты ДЗ

#### Основное задание
- Созданы `Dockerfile` для сервисов `post-py`, `comment`, `ui`;
- Собраны образы для всех трех сервисов с тэгом `1.0`;
- Сборка `ui` началась не с первого шага по той причине, что начальные шаги сборки идентичны сервису `comment`, которые уже ранее выполнялись и были закэшированы докером:
- Создана bridge-сеть для контейнеров под названием `reddit`;
- Контейнеры успешно запушены с указанием сетевых алиасов;
- Сервис доступен по адресу `http://<docker-host-ip>:9292/`;
- Т.к. работаем с настолько древним кодом, что уже не существует нужных репозиториев, то для сборки образов на основе ruby:2.2 пришлось подключить архивный репозиторий `deb http://archive.debian.org/debian stretch main`:
```
FROM ruby:2.2

RUN set -x \
 && echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list \
 && apt-get update -qq \
 && apt-get install -y build-essential \
 && apt-get clean
```

#### Задание со ⭐
- Контейнеры запущены с другими сетевыми алиасами;
- Переменные окружения при этом заданы через параметр `--env` без необходимости пересоздания образа:
```
docker run -d --network=reddit \
  --network-alias=post_db_star --network-alias=comment_db_star \
  mongo:4

docker run -d --network=reddit \
  --network-alias=post_star \
  --env POST_DATABASE_HOST=post_db_star \
  shrkga/post:1.0

docker run -d --network=reddit \
  --network-alias=comment_star \
  --env POST_DATABASE_HOST=comment_db_star \
  shrkga/comment:1.0

docker run -d --network=reddit -p 9292:9292 \
  --env POST_SERVICE_HOST=post_star \
  --env COMMENT_SERVICE_HOST=comment_star \
  shrkga/ui:1.0
```

#### Оптимизация образов приложения
- Сервис `ui` пересобран с тэгом `2.0` на базе `ubuntu:16.04`;
- Сборка началась с первого шага, закешированных действий в данном случае нет;
- Размер образа 2.0 составил 487MB, в отличии от 1.0, который был 998MB;

#### Задание со ⭐: сборка образов на основе Alpine Linux
- Сервис `ui` пересобран с тэгом `3.0` на базе `alpine:3.14` (крайний образ, в репозиториях которого есть ruby версии 2);
- Выполнены дополнительные оптимизации с целью сокращения количества слоев UnionFS и удаления лишних данных из образа:
```
# shrkga/ui:3.0

FROM alpine:3.14

WORKDIR /app
COPY Gemfile* ./

RUN set -x \
 && apk --no-cache --update add ruby-full ruby-dev build-base \
 && gem install bundler:1.17.2 --no-document \
 && bundle install \
 && apk del ruby-dev build-base

COPY . ./
ENV POST_SERVICE_HOST=post POST_SERVICE_PORT=5000 COMMENT_SERVICE_HOST=comment COMMENT_SERVICE_PORT=9292

CMD ["puma"]
```
- Сервис `comment` пересобран с тэгом `2.0` на базе `alpine:3.14`, аналогично выполнены дополнительные оптимизации;
```
# shrkga/comment:2.0

FROM alpine:3.14

WORKDIR /app
COPY Gemfile* ./

RUN set -x \
 && apk --no-cache --update add ruby-full ruby-dev build-base \
 && gem install bundler:1.17.2 --no-document \
 && bundle install \
 && apk del ruby-dev build-base

COPY . ./
ENV COMMENT_DATABASE_HOST=comment_db COMMENT_DATABASE=comments

CMD ["puma"]
```
- Пересборка сервиса `post` на базе `alpine:3.9` не принесла результатов, и образ стал даже немного больше. Поэтому оставлен оригинальный образ на базе `python:3.6-alpine`, к которому применены оптимизации с целью сокращения количества слоев UnionFS и удаления лишних данных из образа (см. `src/post-py/Dockerfile`);
- Итоговые размеры разных версий образов:
```
$ docker images

REPOSITORY       TAG       IMAGE ID       CREATED        SIZE
shrkga/ui        3.0       d04bf139a9ce   14 hours ago   92.6MB
shrkga/ui        2.0       51d523797874   15 hours ago   487MB
shrkga/ui        1.0       014be69f7086   16 hours ago   998MB
shrkga/comment   2.0       ee448af09ab0   15 hours ago   89.4MB
shrkga/comment   1.0       7523ae8028e8   16 hours ago   996MB
shrkga/post      2.0       1ea0d0e474ce   15 hours ago   69.8MB
shrkga/post      1.0       658e947326f0   16 hours ago   67.2MB
```

#### Перезапуск приложения с volume
- Создан Docker volume `reddit_db` и подключен в контейнер с MongoDB по пути `/data/db`;
- После перезапуска контейнеров написанный пост остался на месте;
- Финальный набор команд такой:
```
docker rm -f $(docker ps -aq)

docker build -t shrkga/post:1.0 ./post-py
docker build -t shrkga/comment:2.0 ./comment
docker build -t shrkga/ui:3.0 ./ui

docker network create reddit

docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db \
  -v reddit_db:/data/db \
  mongo:4
docker run -d --network=reddit --network-alias=post shrkga/post:1.0
docker run -d --network=reddit --network-alias=comment shrkga/comment:2.0
docker run -d --network=reddit -p 9292:9292 shrkga/ui:3.0
```

## ДЗ #13. Docker контейнеры. Docker под капотом
Выполнены все основные и дополнительные пункты ДЗ

#### Основное задание
- Установлены Docker, docker-compose, docker-machine;
- Запущен контейнер `hello-world`;
- Изучены и выполнены основные команды docker;

#### Задание со ⭐: сравнение docker inspect контейнера и образа
- На основе вывода команд описаны отличия контейнера от образа в файле `/docker-monolith/docker-1.log`;

#### Docker-контейнеры
- Установлен и инициализирован Yandex Cloud CLI;
- Создан инстанс в YC;
- Инициализировано окружение Docker через `docker-machine`;
- Повторена практика из демо на лекции;
- Создана требуемая структура репозитория;
- Выполнена сборка образа `reddit:latest`;
- На инстансе в YC запущен контейнер `reddit`;
- По ссылке http://<IP_адрес_инстанса>:9292 успешно открылось приложение;
- Выполнена регистрация в Docker Hub;
- Выполнена docker аутентификация на Docker Hub;
- Созданный образ загружен на Docker Hub с тэгом `shrkga/otus-reddit:1.0`;
- Выполнена проверка запуска контейнера в локальном докере на другом хосте;
- Выполнены все дополнительные проверки, указанные в ДЗ;

#### Задание со ⭐: автоматизация поднятие нескольких инстансов в Yandex Cloud, установка на них докера и запуск там образа shrkga/otus-reddit:1.0
- Задача реализована в виде прототипа в директории `/docker-monolith/infra/`;
- Создан шаблон Packer, который делает образ с уже установленным Docker;
    - Используется провеженер `ansible`, для установки докера и модуля python написан плейбук `ansible/playbooks/packer_docker.yml`;
    - Данный плейбук может использоваться для развертывания с помощью ansible, если необходимо сделать это не при помощи packer;
- Инстансы поднимаются с помощью Terraform, их количество задается переменной `docker_count`;
    - Развертывание инстансов реализовано через модуль `terraform/modules/docker`;
- Написаны несколько плейбуков Ansible с использованием динамического инвентори для установки докера и запуска там образа приложения;
- Приложение успешно поднимается в инстансах и доступно по адресу http://<IP_адрес_инстанса>:9292
