# ####  Create routes for worker-nodes
//////////////// Pod network route 0 ///////////////////////
resource "aws_route" "k8s-pod-worker-0" {
  route_table_id         = var.route_table_id  
  destination_cidr_block = "172.20.0.0/24"
  instance_id            = var.worker-0_instance_id
  depends_on             = [var.route_table]
}


/////////////// Pod network route 1 /////////////////////////
resource "aws_route" "k8s-pod-worker-1" {
  route_table_id         = var.route_table_id  
  destination_cidr_block = "172.20.1.0/24"
  instance_id            = var.worker-1_instance_id
  depends_on             = [var.route_table] 
}


///////////////////// Pod network route 2 ///////////////////////////
resource "aws_route" "k8s-pod-worker-2" {
  route_table_id         = var.route_table_id  
  destination_cidr_block = "172.20.2.0/24"
  instance_id            = var.worker-2_instance_id
  depends_on             = [var.route_table]  
}


# resource "aws_route" "k8s-pod-worker" {
#   # count                  = var.no_of_routes
#   route_table_id         = var.route_table_id  
#   destination_cidr_block = var.pod_routes
#   instance_id            = var.instance_id
#   depends_on             = [var.route_table]  
# }


