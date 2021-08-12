##################################################################################
# OUTPUT
##################################################################################
output "subnet_ids" {
  value = aws_subnet.main.*.id
}
output "master1_public_ip" {
  description = "Public IP address of the master"
  value       = ["${aws_instance.master1.public_ip}"]
}
output "master2_public_ip" {
  description = "Public IP address of the master"
  value       = ["${aws_instance.master2.public_ip}"]
}
output "master3_public_ip" {
  description = "Public IP address of the master"
  value       = ["${aws_instance.master3.public_ip}"]
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
