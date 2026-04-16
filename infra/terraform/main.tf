resource "virtualbox_vm" "dev-server" {
  name   = "dev-server-01"
  image  = "https://vagrantcloud.com/ubuntu/boxes/bionic64/versions/20230607.0.5/providers/virtualbox/unknown/vagrant.box"
  cpus   = 2
  memory = "2048 mib"

  network_adapter {
    type           = "bridged"
    host_interface = "eno1"
  }
}

output "vm_status" {
  value = virtualbox_vm.dev-server.status
}