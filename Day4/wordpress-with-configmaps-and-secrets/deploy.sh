echo "\nDeploying mariadb ..."
kubectl apply -f wordpress-cm.yml
kubectl apply -f wordpress-secrets.yml
#kubectl apply -f mariadb-pv.yml
kubectl apply -f mariadb-pvc.yml
kubectl apply -f mariadb-deploy.yml
kubectl apply -f mariadb-svc.yml

echo "\nDeploying wordpress ..."
#kubectl apply -f wordpress-pv.yml
kubectl apply -f wordpress-pvc.yml
kubectl apply -f wordpress-deploy.yml
kubectl apply -f wordpress-svc.yml
