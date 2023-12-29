# Install gitlab via helm
```
$ helm repo add gitlab https://charts.gitlab.io/
$ helm repo update
$ helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab --create-namespace \
  --timeout 600s \
  --set global.hosts.domain=otus.kga.spb.ru \
  --set global.hosts.https=true \
  --set global.ingress.configureCertmanager=true \
  --set certmanager-issuer.email=shr@kga.spb.ru \
  --set global.kas.enabled=true \
  --set global.edition=ce \
  --set global.time_zone=Europe/Moscow \
  --set postgresql.image.tag=13.6.0
```
