packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "virtualbox-iso" "ubuntu-troubleshooting-arm64" {
  iso_url          = "https://cdimage.ubuntu.com/releases/22.04.3/release/ubuntu-22.04.3-live-server-arm64.iso"
  iso_checksum     = "sha256:5b3c86348f2f7afbdd1c0f25ac3d10911fe02d8f35bd4a9d57152c255c8bce60"
  
  guest_os_type = "Ubuntu_64"
  vm_name       = "ubuntu-troubleshooting-arm64"
  
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "30m"
  shutdown_command = "echo 'ubuntu' | sudo -S shutdown -P now"
  
  disk_size = 20480
  memory    = 2048
  cpus      = 2
  
  output_directory = "output"
  format          = "ova"
  
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--firmware", "bios"],
    ["modifyvm", "{{.Name}}", "--boot1", "dvd"],
    ["modifyvm", "{{.Name}}", "--boot2", "disk"]
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu-troubleshooting-arm64"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-pip",
      "sudo ln -sf /usr/bin/python3 /usr/bin/python"
    ]
  }

  provisioner "ansible" {
    playbook_file = "playbook.yml"
    user          = "ubuntu"
    use_proxy     = "false"
    galaxy_file   = "requirements.yml"
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3"
    ]
  }
}
