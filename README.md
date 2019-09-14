# kopf-mysql-backup-operator


Создаем cr.yml:

```
apiVersion: otus.homework/v1
kind: MySQL
metadata:
  name: mysql-instance
spec:
  image: mysql:5.7
  database: operator-db
  password: otuspassword
dasnlsadn: adsda
```

Создаем crd.yml

```
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: mysqls.otus.homework
spec:
  scope: Namespaced
  group: otus.homework
  versions:
    - name: v1
      served: true
      storage: true
  names:
    kind: MySQL
    plural: mysqls
    singular: mysql
    shortNames:
      - ms
```

Данный crd принимает на вход любые объекты, предлагаю это исправить и добавить  validation в custom resource definition:

```
  validation:
    openAPIV3Schema:
      type: object
      properties:
        apiVersion:
          type: string
        kind:
          type: string
        metadata:
          type: object
          properties:
            name:
              type: string
        spec:
          type: object
          properties:
            image: 
              type: string
            database:
              type: string
            password:
              type: string
```

Делаем:
```
kubectl delete -f deploy/cr.yml
kubectl apply -f deploy/crd.yml
kubectl apply -f deploy/cr.yml
```

Видим ошибку:
```
error: error validating "deploy/cr.yml": error validating data: ValidationError(MySQL): unknown field "dasnlsadn" in homework.otus.v1.MySQL; if you choose to ignore these errors, turn validation off with --validate=false
```
Убираем `dasnlsadn: adsda` из описания Custom Resource и снова применяем манифест:

```
kubectl apply -f deploy/cr.yml
```
Получаем:

```
mysql.otus.homework/mysql-instance configured
```

Необязательное задание:
Если сейчас мы удалим практические любую строчку из манифеста CR, то наш манифест будет создан и принят на стадии валидации в API сервере.  Необходимо задать обязательные поля в манифестах для всех объектов  типа kind: MySQL. 
> Примечание: Для этого можно описать required поля в CRD. Пример есть в лекции.



```
export MYSQLPOD=$(kubectl get pods -l app=mysql-instance -o jsonpath="{.items[*].metadata.name}")
kubectl exec -it $MYSQLPOD -- mysql -u root  -potuspassword -e "CREATE TABLE test ( id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );" otus-database

kubectl exec -it $MYSQLPOD -- mysql -potuspassword  -e "INSERT INTO test ( id, name ) VALUES ( null, 'some data' );" otus-database

kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "INSERT INTO test ( id, name ) VALUES ( null, 'some data-2' );" otus-database
```

```
export MYSQLPOD=$(kubectl get pods -l app=mysql-instance -o jsonpath="{.items[*].metadata.name}")
kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "select * from test;" otus-database
``
