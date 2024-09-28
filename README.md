# EKS Cluster Setup and Node Inspection

## Prerequisites

Before proceeding with the following steps, ensure that the following tools are installed on your system:

- **kubectl**: The Kubernetes command-line tool used to interact with your cluster.
- **AWS CLI**: The AWS Command Line Interface tool used to manage your AWS services, including EKS.
- **Terraform**: The infrastructure-as-code tool used to provision your EKS cluster.

You can install these tools by following their official documentation:

- [kubectl Installation Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### 1. Configure `kubectl` for EKS Cluster

Run the following command to configure `kubectl` to work with your EKS cluster:

```bash
aws eks --region <region> update-kubeconfig --name <cluster-name>
```

Replace `<region>` with your AWS region (e.g., `us-east-1`) and `<cluster-name>` with your actual cluster name.

### 2. Verify `kubectl` Configuration

Once the configuration is complete, verify the contexts configured in `kubectl`:

```bash
kubectl config get-contexts
```

### 3. Test Access to the EKS Cluster

Ensure that you can access the cluster by listing the nodes:

```bash
kubectl get nodes
```

---

## Switching Context Using the Full ARN

### Steps to Switch Context to Your EKS Cluster

If you need to switch the context to the EKS cluster using the full ARN, use the following command:

```bash
kubectl config use-context arn:aws:eks:<region>:<account-id>:cluster/<cluster-name>
```

Replace `<region>`, `<account-id>`, and `<cluster-name>` with your AWS region, account ID, and cluster name.

### Confirm the Current Context

After switching the context, verify that you're using the correct one:

```bash
kubectl config current-context
```

This should return the full ARN for your cluster:

```bash
arn:aws:eks:<region>:<account-id>:cluster/<cluster-name>
```

---

## Inspecting Nodes and Taints

### Using `kubectl describe` to Check Taints

To inspect a specific node and its taints, use the `kubectl describe` command:

```bash
kubectl describe node <node-name>
```

Replace `<node-name>` with the actual name of the node you want to inspect.

#### Example Output:

```
Name:               <node-name>
Roles:              <role>
Taints:             node.cilium.io/agent-not-ready=true:NoExecute
...
```

---

### Listing Nodes and Taints Using `kubectl get nodes`

To view all nodes along with their taints, use the following command:

```bash
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```

#### Example Output:

```
NAME                          TAINTS
<node-name-1>                 [map[key=node.cilium.io/agent-not-ready,value=true,effect=NoExecute]]
<node-name-2>                 <none>
```

---

## Conclusion

These steps guide you through configuring `kubectl` with your EKS cluster, managing your `kubectl` context, and inspecting nodes and taints to ensure proper cluster operation. Remember to replace placeholders such as `<region>`, `<account-id>`, `<cluster-name>`, and `<node-name>` with actual values for your environment.
