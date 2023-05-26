# Kubernetes cheatsheet

When using [Microk8s](https://microk8s.io/) put this alias in your `~/.bash_aliases` / `~/.bashrc` / `~/.bash_profile`:

```bash
alias kubectl='microk8s kubectl'
```

## Commands

### Show all pods

```bash
sudo microk8s kubectl get pods
```

with watch (runs the command every 2 seconds) - useful when you want to see the state evolve:

```bash
watch sudo microk8s kubectl get pods
```

### Show all services

```bash
sudo microk8s kubectl get service
```

### Start a deployment from a config

```bash
sudo microk8s kubectl apply -f app-deployment.yaml
```

### Stop a deployment from a config

```bash
sudo microk8s kubectl delete -f app-deployment.yaml
```
