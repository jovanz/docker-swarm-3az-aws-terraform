##################################################################################
# OUTPUT
##################################################################################
output "subnet_ids" {
  value = aws_subnet.main.*.id
}
output "manager1_public_ip" {
  description = "Public IP address of the manager"
  value       = ["${aws_instance.manager1.public_ip}"]
}
output "manager2_public_ip" {
  description = "Public IP address of the manager"
  value       = ["${aws_instance.manager2.public_ip}"]
}
output "manager3_public_ip" {
  description = "Public IP address of the manager"
  value       = ["${aws_instance.manager3.public_ip}"]
}
output "worker1_public_ip" {
  description = "Public IP address of the worker1"
  value       = ["${aws_instance.worker1.public_ip}"]
}
output "worker2_public_ip" {
  description = "Public IP address of the worker2"
  value       = ["${aws_instance.worker2.public_ip}"]
}
output "worker3_public_ip" {
  description = "Public IP address of the worker2"
  value       = ["${aws_instance.worker3.public_ip}"]
}
