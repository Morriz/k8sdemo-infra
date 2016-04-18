# Infra as code

All infra is hosted by AWS. We use the following stack, and in this particular order:

1. [terraform](http://terraform.io) to create the resources.
2. [coreos](http://coreos.com) to host our containers.
3. [kubernetes](http://kubernetes.io) to schedule and loadbalance our containerized apps.
4. Many open source container apps/pods, mainly to monitor and track what's going on.
5. Fleet, mainly to run cron jobs, as kubernetes runs the rest.

## 1. Infra creation stage

### 1.1 Global search and rename

Since this is a demo application, it is needed to change all references to 'yourcom' and 'your.com' to those of your own choosing.
I suggest to just do a search and replace (also some file names in `ssl/`):

yourcom -> unique name without dots, which will result in S3 bucket creation of ${yourcom}-infra/dev/acc/prod
your.com -> your base domain

### 1.2 Generating certificates, keys and kubeconfig

Now generate certificates and the kubectl config with `sh bin/generate_config.sh`. This creates new certificates and keys for communication with and between the cluster in the `ssl/acc` and `ssl/prod` folders.
While waiting add existing key/cert information to the `ssl/*.your.com*` files, and add public key(s) to `ssl/authorized_keys` to enable direct ssh access to the nodes in the cluster.

### 1.3 Terraform configuration, plan/apply

After that configure the `terraform/variables.tf` file, and go through the other *.tf files to see if it fits your needs.
Special area of interest is `terraform/S3.tf`, as it involves cloudfront distribution ids to give rights to corresponding buckets.
Terraform does not yet provide cloudfront provisioning, so that has to be done by hand.
Then *from that folder* run `terraform plan|apply` to get our infra in the desired state. This will result in a pool of CoreOS nodes that either act as MASTER or WORKER, and some external persistent volumes for Mongo, and possible logging and metrics.

After resource creation Terraform provisions the CoreOS nodes with their `user-data/*` scripts. These contain their consecutive CoreOS cloud-configs, which in turn will retrieve the kubernetes `provisioning/*` artifacts from `S3://yourcom-infra/`. The contents of our `provisioning/` folder can be conveniently synced by executing `bin/sync-S3.sh` from the root of this project (wont't work otherwise!).
The CoreOS nodes will pick up on changes to these upon install/reboot, so you can manipulate and upload the artifacts to S3, reboot the node(s) and see the changes. This is usually a scenario for upgrading kubernetes or their manifests, and should NEVER be done without a failover node on production!
To do this, boot an extra node, wait till it's ready, then signal ETCD to disable the old node, wait till Kubernetes has moved all the apps to the new node, and then terminate the old node. See [Kubernetes docs on upgrading](https://coreos.com/kubernetes/docs/latest/kubernetes-upgrade.html) for details.

## 2. Kubernetes configuration stage

When kubernetes is running we can interact with it through the `kubectl` client. I strongly suggest you install the `lib/aliases` as well, as we will be using them in this readme.
By using the alias `kcg` (I thought of it like _kubectl context get_) you can see what cluster kubectl is currently tied to. It is important to ALWAYS BE AWARE of the cluster you are operating on. 

### 2.1 Install kubectl client

Please check the latest version in the url, as there might be a newer one.

For OSX:

    curl -O https://storage.googleapis.com/kubernetes-release/release/v1.2.2/bin/darwin/amd64/kubectl

For Linux:

    curl -O https://storage.googleapis.com/kubernetes-release/release/v1.2.2/bin/linux/amd64/kubectl

Chown and move it:

    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl

### 2.2 Configure kubectl

To be able to use the k8s/kubeconfig file we just generated, we can use it directly by specifying it on the cli, or we merge it with it's default config file in location `~/.kube/config`.
Test if it works first with the following:

    ka --kubeconfig=k8s/kubeconfig get rc,po,svc,ds,secrets

## 3. Deploying apps

All the kubernetes apps reside in `k8s/` and can be experimented with on a local vagrant setup. When you know what you are doing you can create/replace/delete manifests on the aws clusters.
For now we install the apps manually.

When you know what you are doing you can start all the relevant apps with a oneliner:

    export APP_ENV=acc && kcu $APP_ENV && . k8s/$APP_ENV.env && bin/start.sh
    
Which will select the acc cluster and run all the k8s provisioning scripts for it.    

### 3.1 Essential apps

To boot up our essentials, like dashboard, logging and metrics monitoring, run the following:

    kubectl create -f k8s/dashboard
    kubectl create -f k8s/fluentd-elasticsearch
    kubectl create -f k8s/influxdb

This will take a while if the images are not yet pulled from the registry.
To see which are running and which not check again with the command from step 2.2.
Or, when you have done your homework already, and configured your local `~/.kube/config`, just:

    ka get rc,po,svc,ds,secrets

### 3.2 App suite

Then to get the entire app suite running on acceptance, first create the secrets.
This step assumes the needed vars to be exported beforehand:

    bin/create_api-secrets.yaml.sh
    kubectl create -f k8s/$APP_ENV/api-secrets.yaml

Then boot the app suite itself:

    kubectl create -f k8s/app/$APP_ENV

Notice that kubelet will automatically create AWS loadbalancers for kubernetes services of type `LoadBalancer`.
IMPORTANT: These loadbalancers will not be removed when the nodes are destroyed, so the services either need to be brought down first, of you have to remove the loadbalancers from the AWS console.

## 4. Monitoring & management

These apps are only reachable through a proxy to the cluster, so start one on port 8010 with:

    kubectl-aws proxy 8010 &

(or just `kp` to start one on the default port 8001), and `kk` to kill any running proxy.

IMPORTANT: be aware that the running proxy will either target ACC or PROD, but you will not see that from just looking at the url.
To see what cluster is being targeted, type `kcg`.

### 4.1 Dashboard

We can now see a [kubedash dashboard](http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/) showing all of the running replication controllers.

### 4.2 Logging

For logging we use FluentD > ElasticSearch > Kibana.
To see our unified logs go to the (also proxied) [Kibana dashboard](http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/kibana-logging/).

### 4.3 Metrics

For metrics we use InfluxDB with Grafana. To see metrics on all of the resources (Kube global, or per container), see the [Grafana dashboard](http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/).

If somehow it is not working, heapster needs a restart, since version x has a race condition against the partner apps (influx and grafana). Get an overview of running pods and just delete the pod:

    kubectl --namespace=kube-system delete po heapster-xxxxx

Kubernetes will boot a new pod automatically in a couple of seconds and the app will be running normally :)

### 4.4 Mongo Express

To see the data in mongo we can go to:
* [mongo-express web ui](localhost:8001/api/v1/proxy/namespaces/default/services/mongo-express/)

## 5. Fleet

CoreOS ships with the fleet daemon, enabling us to drop a Unit that will get scheduled. This is a task that can be ran once, or on a timer. See the [Fleet documentation](https://coreos.com/fleet/docs/latest/) for details. We use it to run cron jobs, which are otherwise not able to run on a distributed cluster environment.

To talk to fleet:

    export FLEETCTL_TUNNEL=`nslookup kube.your.com | awk '/^Address: / { print $2 }'`:22
    export FLEETCTL_ENDPOINT=http://127.0.0.1:49111
    fleetctl list-units
