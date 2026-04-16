# Cross-platform cattle VM for students (VirtualBox default).
# Works on Windows/macOS/Linux hosts with Vagrant + VirtualBox installed.

VM_BOX = ENV.fetch("VM_BOX", "generic/debian12")
VM_CPUS = ENV.fetch("VM_CPUS", "2")
VM_MEMORY = ENV.fetch("VM_MEMORY", "2048")
CONTAINER_RUNTIME = ENV.fetch("CONTAINER_RUNTIME", "docker")
BRIDGE_ADAPTER = ENV["BRIDGE_ADAPTER"]

Vagrant.configure("2") do |config|
  config.vm.box = VM_BOX
  config.vm.hostname = "lab-cattle"

  # Keep NAT for reliable internet and predictable behavior across host OSes.
  # Optional bridged NIC can be enabled by setting BRIDGE_ADAPTER.
  if BRIDGE_ADAPTER && !BRIDGE_ADAPTER.strip.empty?
    config.vm.network "public_network", bridge: BRIDGE_ADAPTER
  end

  # API and pgAdmin-forwarded ports (host -> guest).
  config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 5050, host: 5050, auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "lab-cattle"
    vb.memory = VM_MEMORY
    vb.cpus = VM_CPUS.to_i
  end

  config.vm.provision "shell",
    path: "scripts/provision.sh",
    env: {
      "CONTAINER_RUNTIME" => CONTAINER_RUNTIME
    }
end
