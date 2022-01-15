# Create an External(Internet-Facing) Load Balancer
resource "aws_lb" "k8s-cluster-from-ground-up" {
  name               = "k8s-cluster-from-ground-up"
  load_balancer_type = "network"
  internal           = false
  #   security_groups = [aws_security_group.k8s-sg.id]
  subnets = [var.subnet_id]
  tags = {
    Name = var.resource_tag
  }
}

# Create a Target Group
resource "aws_lb_target_group" "k8s-tg" {
  health_check {
    interval = 30
    port     = 6443
    protocol = "TCP"
  }

  name        = "k8s-tg"
  port        = 6443
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}



# Register Target IPs
resource "aws_lb_target_group_attachment" "k8s-lb-tg" {
  target_group_arn = aws_lb_target_group.k8s-tg.arn
  count            = length(var.master_ip_list)
  target_id        = element(var.master_ip_list, count.index)
  port             = 6443
}


# Create Listener for Target Group
resource "aws_lb_listener" "k8s-listener" {
  load_balancer_arn = aws_lb.k8s-cluster-from-ground-up.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s-tg.arn
  }
}
