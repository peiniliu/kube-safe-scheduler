helm install my-release oci://registry-1.docker.io/bitnamicharts/etcd


** Please be patient while the chart is being deployed **

etcd can be accessed via port 2379 on the following DNS name from within your cluster:

    dl-etcd.default.svc.cluster.local

To create a pod that you can use as a etcd client run the following command:

    kubectl run dl-etcd-client --restart='Never' --image docker.io/bitnami/etcd:3.5.11-debian-11-r0 --env ROOT_PASSWORD=$(kubectl get secret --namespace default dl-etcd -o jsonpath="{.data.etcd-root-password}" | base64 -d) --env ETCDCTL_ENDPOINTS="dl-etcd.default.svc.cluster.local:2379" --namespace default --command -- sleep infinity

Then, you can set/get a key using the commands below:

    kubectl exec --namespace default -it dl-etcd-client -- bash
    etcdctl --user root:$ROOT_PASSWORD put /message Hello
    etcdctl --user root:$ROOT_PASSWORD get /message

To connect to your etcd server from outside the cluster execute the following commands:

    kubectl port-forward --namespace default svc/dl-etcd 2379:2379 &
    echo "etcd URL: http://127.0.0.1:2379"

 * As rbac is enabled you should add the flag `--user root:$ETCD_ROOT_PASSWORD` to the etcdctl commands. Use the command below to export the password:

    export ETCD_ROOT_PASSWORD=$(kubectl get secret --namespace default dl-etcd -o jsonpath="{.data.etcd-root-password}" | base64 -d)


    GXgUQwHFdU
