packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "virtualbox-iso" "ubuntu-troubleshooting" {
  iso_url          = "https://old-releases.ubuntu.com/releases/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
  iso_checksum     = "sha256:a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
  
  guest_os_type = "Ubuntu_64"
  vm_name       = "ubuntu-troubleshooting"
  
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
    ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu-troubleshooting"]

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
