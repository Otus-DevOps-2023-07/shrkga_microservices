# Репозиторий shrkga_microservices
Описание выполненных домашних заданий.

## ДЗ #21. Ingress-контроллеры и сервисы в Kubernetes

Выполнены все основные и дополнительные пункты ДЗ.

#### Основное задание
- Изучено поведение плагина `kube-dns` при остановке деплойментов `kube-dns-autoscaler` и `coredns`;
- Создан `LoadBalancer` для сервиса `UI`, доступ к приложению успешно заработал по `http`;
- Запущен `Ingress Controller` на базе балансировщика `Nginx` (версия из ДЗ не заработала, использовалась версия `v1.8.2`);
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```
- Создан `Single Service Ingress` для сервиса `UI`, доступ к приложению успешно заработал по `http`;
- Старый балансировщик `LoadBalancer` удален;
- Создан TLS сертификат, на его основе создан `Secret`;
- Ingress настроен на прием только HTTPS трафика;
- Доступ к приложению успешно заработал по `https`;

#### Задание со ⭐. Опишите создаваемый объект Secret в виде Kubernetes-манифеста
- Secret описан в файле [`kubernetes/reddit/ui-secret.yml`](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/kubernetes-3/kubernetes/reddit/ui-secret.yml);

#### Основное задание (продолжение)
- Создан объект `NetworkPolicy` для компонента `mongo`;
- Доступ к подам с MongoDB разрешен от подов с label'ами `comment` и `post`;
- Изучен функционал `PersitentVolume` для хранения данных MongoDB;
- В Yandex Cloud создан диск;
- Создан манифест типа `PersitentVolume` для ресурса дискового в Yandex Cloud;
- Создан манифест типа `PersistentVolumeClaim` для запроса на выдачу места из `PersitentVolume`;
- Выделенный диск примонтирован к поду mongo;
- Протестировано создание поста с последующим удалением и созданием деплоя mongo. Пост остался на месте.

## ДЗ #20. Основные модели безопасности и контроллеры в Kubernetes

Выполнены все основные и дополнительные пункты ДЗ.

#### Запуск кластера и приложения. Модель безопасности
- Используется хостовая машина под управлением Ubuntu 22.04.3;
- Установлена утилита `kubectl`;
- Установлены утилиты `minikube`;
- Успешно запущен Minikube-кластер;
- Изучены формат и содержимое файла `~/.kube/config`;
- Созданы манифесты сущностей приложения Reddit в каталоге [`kubernetes/reddit`](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/kubernetes-2/kubernetes/reddit);
- Компоненты успешно запущены в `minicube`;
```
$ kubectl apply -f ./kubernetes/reddit/
```
- Для связи `ui` с `post` и `comment` созданы объекты типа `Service`;
- Для связи `post` и `comment` с `mongodb` посредством имен `post-db` и `comment-db`, созданы сервисы с соответствующими именами;
- В манифестах деплойментов `post` и `comment` заданы переменные окружения (хост и название БД) для подключения к MongoDB;
- Создан Service для UI-компонента для обеспечения доступа к веб-интерфейсу извне;
- Подключен аддон Minikube `dashboard`;
```
minikube addons enable dashboard
minikube dashboard --url
```
- Dashboard успешно открылся http://127.0.0.1:43723/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
- Изучен функционал Namespaces;
- Создано окружение `dev`, в нём запущено наше приложение;
- Информация об окружении добавлена внутрь контейнера UI;

#### Yandex Cloud Managed Service for Kubernetes
- Создан Kubernetes кластер под названием `test-cluster` через веб-интерфейс консоли Yandex Cloud;
- Создана группа из двух узлов, входящих в кластер;
- Выполнено подключение к кластеру;
```
yc managed-kubernetes cluster get-credentials test-cluster --external
```
- В `test-cluster` создано `dev` namespace, куда задеплоены все компоненты приложения `reddit`;
- Приложение успешно открывается по адресу одной из нод в `test-cluster`;

> [>>> Скриншоты здесь <<<](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/kubernetes-2/kubernetes/screenshots)

#### Задание со ⭐. Развертывание Kubernetes-кластера в Yandex Cloud с помощью Terraform модуля
- В каталоге [`kubernetes/terraform-k8s`](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/kubernetes-2/kubernetes/terraform-k8s) подготовлена конфигурация Terraform для развертывания Kubernetes кластера с использованием ресурсов `yandex_kubernetes_cluster` и `yandex_kubernetes_node_group`;

#### Задание со ⭐. Создание YAML-манифестов для описания созданных сущностей для включения dashboard
- Dashboard UI отсутствует по умолчанию, выполнено его развертывание;
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```
- В каталоге [`kubernetes/dashboard`](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/kubernetes-2/kubernetes/dashboard) подготовлены манифесты для сущностей `ServiceAccount` и `ClusterRoleBinding` для доступа к Dashboard UI;
```
kubectl apply -f ./kubernetes/dashboard/
```
- Получен `Bearer Token` для `ServiceAccount`;
```
kubectl -n kubernetes-dashboard create token admin-user
```
- Запущен `kubectl proxy`;
- Dashboard UI открывается через URL http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
> [Скриншот Dashboard UI](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/raw/kubernetes-2/kubernetes/screenshots/chrome_wHpxVZf0L9.png?raw=true)

## ДЗ #19. Введение в Kubernetes

Выполнены все основные и дополнительные пункты ДЗ.

#### Основное задание
- Описаны Deployment манифесты приложений `comment`, `mongo`, `post`, `ui`;
- В YC развернуты две ВМ для master и worker нод кластера Kubernetes;
- С помощью команд `kubeadm init` и `kubeadm join` развернут кластер k8s;
- Установлен сетевой плагин `Calico`;
```
wget https://projectcalico.docs.tigera.io/manifests/calico.yaml
sed -i -r -e 's/^(\s*)#\s*(- name: CALICO_IPV4POOL_CIDR)\s*$/\1\2\n\1  value: "10.244.0.0\/16"/g' calico.yaml
kubectl apply -f calico.yaml
```
- Кластер работает, с помощью команды `kubectl apply -f manifest.yaml` задеплоены поды приложений `comment`, `mongo`, `post`, `ui`;

#### Задание со ⭐. Установка кластера k8s с помощью terraform и ansible
- В папке `kubernetes/terraform` подготовлена конфигурация Terraform для развертывания произвольного количества инстансов master и worker нод кластера Kubernetes;
- В папке `kubernetes/ansible` подготовлена конфигурация Ansible для развертывания кластера k8s с автоматическим назначением нодам master и worker ролей;
- Для предварительной конфигурации хостов написаны (скопипащены) таски отключения свопа, конфигурации параметров `sysctl` для k8s, загрузки модуля ядра `br_netfilter`, настройки `iptables`;
- В плейбуке используются роли Ansible `geerlingguy.containerd` и `geerlingguy.kubernetes`, установленные из Ansible-galaxy;
- Для сети настраивается плагин `Calico`;
- После отработки команды `ansible-playbook -i inventory.yml playbooks/k8s.yml` кластер успешно поднимается;
```
$ ssh ubuntu@51.250.70.117 sudo kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
k8s-master-0   Ready    control-plane   3m26s   v1.28.2
k8s-worker-1   Ready    <none>          3m4s    v1.28.2

$ ssh ubuntu@51.250.70.117 sudo kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
kube-system   calico-kube-controllers-7ddc4f45bc-rtpm5   1/1     Running   0          3m21s   10.244.72.3   k8s-master-0   <none>           <none>
kube-system   calico-node-4h49c                          1/1     Running   0          3m16s   10.128.0.10   k8s-worker-1   <none>           <none>
kube-system   calico-node-6b9kp                          1/1     Running   0          3m21s   10.128.0.32   k8s-master-0   <none>           <none>
kube-system   coredns-5dd5756b68-692q4                   1/1     Running   0          3m21s   10.244.72.1   k8s-master-0   <none>           <none>
kube-system   coredns-5dd5756b68-lbs9n                   1/1     Running   0          3m21s   10.244.72.2   k8s-master-0   <none>           <none>
kube-system   etcd-k8s-master-0                          1/1     Running   0          3m34s   10.128.0.32   k8s-master-0   <none>           <none>
kube-system   kube-apiserver-k8s-master-0                1/1     Running   0          3m34s   10.128.0.32   k8s-master-0   <none>           <none>
kube-system   kube-controller-manager-k8s-master-0       1/1     Running   0          3m36s   10.128.0.32   k8s-master-0   <none>           <none>
kube-system   kube-proxy-2pbdg                           1/1     Running   0          3m21s   10.128.0.32   k8s-master-0   <none>           <none>
kube-system   kube-proxy-hd7dd                           1/1     Running   0          3m16s   10.128.0.10   k8s-worker-1   <none>           <none>
```
- Задеплоены поды приложений `comment`, `mongo`, `post`, `ui`, все работает.

```
# kubectl get pods -o wide
NAME                                  READY   STATUS    RESTARTS   AGE     IP             NODE           NOMINATED NODE   READINESS GATES
comment-deployment-687bccf5fd-hzs5h   1/1     Running   0          2m17s   10.244.230.2   k8s-worker-1   <none>           <none>
mongo-deployment-79d69f4666-l6pnm     1/1     Running   0          2m43s   10.244.230.1   k8s-worker-1   <none>           <none>
post-deployment-68db465f9c-84dwr      1/1     Running   0          2m12s   10.244.230.3   k8s-worker-1   <none>           <none>
ui-deployment-7d84b9f894-8k4dk        1/1     Running   0          2m8s    10.244.230.4   k8s-worker-1   <none>           <none>
```

## ДЗ #18. Применение системы логирования в инфраструктуре на основе Docker

Выполнены все основные и дополнительные пункты ДЗ.

#### Логирование и распределенная трассировка
- Подготовлено окружение:
  - Скачана новая ветка reddit;
  - Выполнена сборка logging-enabled образов с тэгами `logging`;
  - В YC создана docker-machine;
- Создан compose-файл для системы логирования ElasticSearch + Fluentd + Kibana;
- Созданы Dockerfile и конфигурации для Fluentd, выполнена сборка образа;

#### Cбор логов, визуализация
- Изучен сбор структурированных логов с использованием сервиса `post`;
- Изучен сбор неструктурированных логов с использованием сервиса `ui`;
- Изучены Grok-шаблоны;

#### Задание со ⭐. Разбор ещё одного формата логов
- Составлена конфигурация Fluentd для разборки формата логов UI-сервиса с `path`, `remote_addr`, `method`, `response_status`;
```
$ cat logging/fluentd/fluent.conf

...
<filter service.ui>
  @type parser
  <parse>
    @type grok
    <grok>
      pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{GREEDYDATA:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IPV4:remote_addr} \| method= %{WORD:method} \| response_status=%{INT:response_status}
    </grok>
  </parse>
  key_name message
  # reserve_data true
</filter>
...
```

#### Распределенный трейсинг
- В compose-файл для сервисов логирования добавлен сервис распределенного трейсинга Zipkin;
- Сервисы настроены на использование Zipkin;
- Изучен функционал трейсов через web-интерфейс Zipkin;

#### Задание со ⭐. Траблшутинг UI-экспириенса
- Загружен репозиторий со сломанным кодом приложения в каталог `src-bugged`;
- В процессе билда багнутого кода снова посыпались проблемы с тем, что все устарело и ничего не собирается 😡
- Поэтому буду краток: тормоза при посте из-за того, что в багнутом коде присутствует команда `time.sleep(3)`;
```
$ cat src-bugged/post-py/post_app.py

...
    else:
        stop_time = time.time()  # + 0.3
        resp_time = stop_time - start_time
        app.post_read_db_seconds.observe(resp_time)

        time.sleep(3) # <<<<<<<<<<<<<<< BUG <<<<<<<<<<<<<<<

        log_event('info', 'post_find',
                  'Successfully found the post information',
                  {'post_id': id})
        return dumps(post)
...
```

## ДЗ #17. Введение в мониторинг. Модели и принципы работы систем мониторинга

Выполнены все основные и дополнительные пункты ДЗ.

#### Основное задание
- Создан Docker хост в Yandex Cloud, локальное окружение настроено на работу с ним;
- Prometheus запущен из образа `prom/prometheus`;
- Изучены метрики по умолчанию;
- Изучен раздел Targets (цели) и формат собираемых метрик, доступных по адресу `host:port/metrics`;
- Создан кастомный Docker образ Prometheus на основе собственного файла конфигурации `prometheus.yml`;
- Создан `docker-compose.yml` файл для поднятия Prometheus совместно с микросервисами `ui`, `post`, `comment`, `mongo_db`;
- Изучен функционал Prometheus на основе новых целей и Endpoint'ов наших микросервисов;
- Добавлен сбор метрик Docker хоста при помощи Node exporter:
  - Добавлен новый сервис в `docker-compose.yml`;
  - Добавлен новый Job в `prometheus.yml`;
- Изучено изменение динамики нагрузки хоста на графике при повышении загруженности CPU

#### Собранные образы запушены на DockerHub
> https://hub.docker.com/u/shrkga

#### Задание со ⭐. Мониторинг MongoDB в Prometheus
- В Prometheus добавлен мониторинг MongoDB с использованием экспортера `percona/mongodb_exporter`;
```
$ cat docker/docker-compose.yml
...
  mongodb_exporter:
    image: percona/mongodb_exporter:0.40
    command:
      - '--mongodb.uri=mongodb://mongo_db:27017'
      - '--compatible-mode'
      - '--mongodb.direct-connect=true'
    # ports:
    #   - 9216:9216/tcp
    networks:
      - back_net
      - front_net
    depends_on:
      - mongo_db
...
```
```
$ cat monitoring/prometheus/prometheus.yml
...
  - job_name: 'mongodb'
    static_configs:
    - targets:
      - 'mongodb_exporter:9216'
...
```

#### Задание со ⭐. Мониторинг сервисов comment, post, ui в Prometheus с помощью Blackbox exporter
- В Prometheus добавлен мониторинг сервисов comment, post, ui с использованием экспортера `prom/blackbox-exporter`;
- Собран и запушен на DockerHub кастомный образ с измененным файлом конфигурации `config.yml`;
```
$ cat monitoring/blackbox/Dockerfile

FROM prom/blackbox-exporter:latest
ADD config.yml /etc/blackbox_exporter/
```
```
$ cat monitoring/blackbox/config.yml

modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: []
      method: GET
      follow_redirects: false
```
```
$ cat docker/docker-compose.yml
...
  blackbox-exporter:
    image: ${USERNAME}/blackbox-exporter
    # ports:
    #   - 9115:9115/tcp
    networks:
      - front_net
    depends_on:
      - ui
      - post
      - comment
...
```
```
$ cat monitoring/prometheus/prometheus.yml
...
  - job_name: 'blackbox'
    metrics_path: /metrics
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://ui:9292
        - http://comment:9292
        - http://post:9292
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115
...
```

Итоговый список целей выглядит так:

![Prometheus Targets](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/monitoring-1/monitoring/img/prom.png?raw=true)

#### Задание со ⭐. Автоматизация при помощи `Makefile`
- Реализованы сценарии билда и пуша в DockerHub любого, или всех сразу, образов;
- Автоматическая генерация справки при запуске `make help`, либо просто `make` без аргументов.
```
$ cd monitoring/
$ make help

build-all        Build all images
build-blackbox   Build Blackbox exporter image
build-comment    Build Comment image
build-post       Build Post image
build-prometheus Build Prometheus exporter image
build-ui         Build UI image
help             Display this help screen
push-all         Push all images to Docker Hub
push-blackbox    Push Blackbox exporter image to Docker Hub
push-comment     Push Comment image to Docker Hub
push-post        Push Post image to Docker Hub
push-prometheus  Push Prometheus image to Docker Hub
push-ui          Push UI image to Docker Hub
```
> **[Makefile здесь](https://github.com/Otus-DevOps-2023-07/shrkga_microservices/blob/monitoring-1/monitoring/Makefile)**


## ДЗ #16. Устройство Gitlab CI. Построение процесса непрерывной интеграции

Выполнены все основные и дополнительные пункты ДЗ.

#### Основное задание
- Облачная инфраструктура описана с использованием подхода IaC;
- В папке `gitlab-ci/infra/terraform` подготовлена конфигурация Terraform для развертывания ВМ в YC;
- В папке `gitlab-ci/infra/ansible` подготовлена конфигурация Ansible для установки на ВМ `Docker`, `GitLab CE` и `GitLab Runner`:
  - `playbooks/docker.yml` -- плейбук для установки докера;
  - `playbooks/gitlab-ce.yml` -- плейбук для omnibus-установки гитлаба;
  - `playbooks/gitlab-runner.yml` -- пелйбук для установки гитлаб раннера;
  - `playbooks/site.yml` -- плейбук для установки всех вышеперечисленных компонентов;
- В файле `gitlab-ci/docker-compose.yml` описана установка gitlab-ce через `docker compose`;
- Запуск через `docker compose up -d` отработал успешно, GitLab поднялся по адресу http://yc-vm-ip/;

#### Задание со ⭐. Автоматизация развёртывания GitLab
- Выполнена автоматизация развёртывания GitLab с помощью модуля Ansible `docker_container` (см. плейбук `gitlab-ci/infra/ansible/playbooks/gitlab-ce.yml`);

#### Проект в GitLab
- В GitLab созданы группа `homework` и проект `example`;
- В файле `.gitlab-ci.yml` описан CI/CD Pipeline;
- Установлен и зарегистрирован GitLab Runner;
- Пайплайн успешно отработал;
- Тесты в пайплайне изменены в соответствии с ДЗ;
- Определены окружения `dev`, `beta` и `production`;
- Определены окружения `stage` и `production` для выкатывания кода с явно зафиксированной версией (помеченного с помощью тэга в git);
- Добавлены динамические окружения для каждой ветки в репозитории, кроме ветки master;

#### Задание со ⭐. Запуск reddit в контейнере
- В этап пайплайна `build` добавлен запуск контейнера с приложением `reddit`;
- Контейнер с reddit деплоится на окружение, динамически создаваемое для каждой ветки в GitLab;

```
build_job:
  stage: build
  image: docker:latest
  environment:
    name: branch/${CI_COMMIT_REF_NAME}
  script:
    - echo 'Building'
    - docker build -t reddit:${CI_ENVIRONMENT_SLUG} docker-monolith/
    - docker rm -f reddit-${CI_ENVIRONMENT_SLUG}
    - docker run --name reddit-${CI_ENVIRONMENT_SLUG} --publish-all --detach reddit:${CI_ENVIRONMENT_SLUG}
    - REDDIT_PORT=$(docker port reddit-${CI_ENVIRONMENT_SLUG} 9292/tcp | head -n 1 | awk -F ':' '{print $2}')
    - echo "Application URL -- http://${CI_SERVER_HOST}:${REDDIT_PORT}/"
```

#### Задание со ⭐. Автоматизация развёртывания GitLab Runner
- Выполнена автоматизация развёртывания GitLab Runner с помощью модуля Ansible `docker_container` (см. плейбук `gitlab-ci/infra/ansible/playbooks/gitlab-runner.yml`);

### Выполнение команд `terraform` и `ansible`

```
$ cd gitlab-ci/infra/terraform/
$ terraform apply -auto-approve=true

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_docker = [
  "51.250.7.91",
]
```

```
$ cd ../ansible/
$ ansible-playbook playbooks/site.yml

PLAY [Install Docker] *****************************************************************

TASK [Gathering Facts] ****************************************************************
ok: [51.250.7.91]

TASK [Add Docker GPG apt Key] *********************************************************
changed: [51.250.7.91]

TASK [Add Docker Repository] **********************************************************
changed: [51.250.7.91]

TASK [Update apt and install packages] ************************************************
changed: [51.250.7.91]

TASK [Install Docker Module for Python] ***********************************************
changed: [51.250.7.91]

PLAY [Install GitLab CE] **************************************************************

TASK [Gathering Facts] ****************************************************************
ok: [51.250.7.91]

TASK [Create gitlab-ce container] *****************************************************
changed: [51.250.7.91]

PLAY [Install GitLab Runner] **********************************************************

TASK [Gathering Facts] ****************************************************************
ok: [51.250.7.91]

TASK [Create gitlab-runner container] *************************************************
changed: [51.250.7.91]

PLAY RECAP ****************************************************************************
51.250.7.91 : ok=9  changed=6  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
```

```
$ ssh ubuntu@51.250.7.91 sudo docker ps -a
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS                   PORTS                                                            NAMES
07eca80677fb   gitlab/gitlab-runner:latest   "/usr/bin/dumb-init …"   5 minutes ago   Up 5 minutes                                                                              gitlab-runner
6ee1bedadbce   gitlab/gitlab-ce:latest       "/assets/wrapper"        5 minutes ago   Up 5 minutes (healthy)   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp   gitlab-ce
```

## ДЗ #15. Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов

Выполнены все основные и дополнительные пункты ДЗ.

#### Основное задание
- Изучена работа контейнера с сетевыми драйверами `none`, `host`, `bridge`;
- Проанализирован вывод команды `ifconfig` при запуске контейнера в сетевом пространстве docker-хоста:
  - Команда выводит состояние активных интерфейсов хостовой машины, т.к. в случае драйвера `host` устраняется сетевая изолированность между контейнером и хостом docker и напрямую используются сетевые ресурсы хоста;
- Проведен эксперимент многократного запуска контейнера `nginx` с сетью `host`:
  - `docker ps` вывел активное состояние только первого запущенного контейнера. Это связано с тем, что остальные контейнеры не смогли сделать bind на 80 порт, т.к. его занял первый контейнер. Остальные nginx контейнеры выдали ошибку:
```
nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
```
- Исследовано поведение net-namespaces при запуске контейнеров с драйверами `none` и `host`;
- Изучен функционал сетевых алиасов при запуске проекта reddit с использованием bridge-сети;
- Изучена работа контейнеров одновременно в нескольких сетях;
- Исследовано поведение сетевого стека Linux при запуске контейнеров с `bridge` сетями;
- Исследовано изменение цепочек `iptables` при запуске контейнеров с `bridge` сетями;

#### Работа с Docker-compose
- Проект reddit описан в файле `docker-compose.yml`;
- Файл изменен под кейс с множеством сетей, сетевых алиасов;
- `docker-compose.yml` параметризирован с помощью переменных окружения, описанных в файле `.env`:
```
COMPOSE_PROJECT_NAME=reddit
UI_PORT=9292
DB_TAG=4
UI_TAG=3.0
COMMENT_TAG=2.0
POST_TAG=1.0
DB_PATH=/data/db/
USERNAME=shrkga
```
- Базовое имя проекта изменено при помощи переменной `COMPOSE_PROJECT_NAME=reddit`;
- Создан файл `docker-compose.override.yml` с целью переопределения инструкции `command` контейнеров `comment` и `ui`, а также пробрасывания папки с кодом с хоста внутрь контейнеров:
```
version: '3.3'
services:

  ui:
    volumes:
      - ./ui/:/app/
    command: ["puma", "--debug", "-w", "2"]

  comment:
    volumes:
      - ./comment/:/app/
    command: ["puma", "--debug", "-w", "2"]

  post:
    volumes:
      - ./post-py/:/app/
```

## ДЗ #14. Docker образы. Микросервисы
Выполнены все основные и дополнительные пункты ДЗ.

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
EXPOSE 9292/tcp

CMD ["puma"]
```
- Сервис `comment` пересобран с тэгом `2.0` на базе `alpine:3.14`, аналогично выполнены дополнительные оптимизации (см. `src/comment/Dockerfile`);
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
Выполнены все основные и дополнительные пункты ДЗ.

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
