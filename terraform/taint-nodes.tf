resource "null_resource" "configure_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name informa-cluster"
  }

  depends_on = [
    aws_eks_cluster.eks
  ]
}

resource "null_resource" "taint_nodes" {
  provisioner "local-exec" {
    command = "ansible-playbook ansible-taint-k8s-nodes.yml"
  }

  depends_on = [
    null_resource.configure_kubeconfig,
    aws_eks_node_group.node_group
  ]
}


