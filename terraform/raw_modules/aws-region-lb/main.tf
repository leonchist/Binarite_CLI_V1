resource "aws_lb" "quark_nlb" {
  name               = "${var.lb_name}-nlb"
  internal           = false
  load_balancer_type = var.lb_type
  subnets            = var.subnet_ids

  tags = merge(var.env.tags, {
    Name = lower("${var.env.tags.Project}-${var.env.tags.Role}-nlb-${var.env.tags.Owner}")
  })
}

resource "aws_lb_target_group" "quark_tg" {
  name        = "${var.lb_name}-tg"
  port        = var.port_listen
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "TCP"
    port                = var.port_healtcheck
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = var.env.tags

}

resource "aws_lb_target_group_attachment" "quark_tga" {
  count            = length(var.target_ips)
  target_group_arn = aws_lb_target_group.quark_tg.arn
  target_id        = var.target_ips[count.index]
  port             = var.port_listen
}

resource "aws_lb_listener" "quark_listener" {
  load_balancer_arn = aws_lb.quark_nlb.arn
  protocol          = "TCP"
  port              = var.port_listen
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quark_tg.arn
  }

}
