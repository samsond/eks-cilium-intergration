resource "null_resource" "taint_nodes" {
  depends_on = [aws_eks_node_group.node_group]

  provisioner "local-exec" {
    command = <<EOT
    # Wait for nodes to be in Ready state before applying taints
    kubectl wait --for=condition=Ready nodes --selector="eks.amazonaws.com/nodegroup=informa-nodes" --timeout=5m

    for node in $(kubectl get nodes --selector="eks.amazonaws.com/nodegroup=informa-nodes" -o name); do
      kubectl taint nodes $node node.cilium.io/agent-not-ready=true:NoExecute
    done
    EOT
  }
}
