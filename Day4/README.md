# Day 4

## Lab - Creating an external LoadBalancer service for nginx deployment

Create a namespace for your use, replace 'jegan' with your name
```
kubectl create namespace jegan
```

Deploy nginx web server in your namespace with 3 pods
```
kubectl create deployment nginx --image=nginx:latest --replicas=3 -n jegan
```

List your deployments,replicaset and pods
```
kubectl get deploy,rs,po
```

In case you wish to see your pods IP address and where they are running
```
kubectl get pods -o wide
```

Finding the Node IPs
```
kubectl get nodes -o wide
```

Let's create an external loadbalancer service for nginx deployment
```
kubectl expose deploy/nginx --type=LoadBalancer --port=80 -n jegan
```

List the service
```
kubectl get services
kubectl describe svc/nginx
```

Accessing the LoadBalancer external service (in the terminal)
```
curl http://<external-ip-of-your-loadbalancer-service>
curl http://192.168.100.50
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/f59b0f59-b9f4-4d5f-8a6a-3ee566986e69" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/2a097b01-078d-4b0c-b3c4-843bac82c548" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/701d50c4-6fc7-4fe7-abef-995b5ec83b4c" />

