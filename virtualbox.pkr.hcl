source "virtualbox-iso" "ubuntu-troubleshooting" {
  iso_url          = "https://old-releases.ubuntu.com/releases/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
  iso_checksum     = "sha256:a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
  iso_checksum_type = "sha256"
  
  guest_os_type = "Ubuntu_64"
  vm_name       = "ubuntu-troubleshooting"
  
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "30m"
  
  http_directory = "http"
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz",
    " auto=true",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    " debian-installer=en_US locale=en_US keymap=us",
    " hostname=ubuntu",
    " fb=false",
    " debconf/frontend=noninteractive",
    " keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA",
    " keyboard-configuration/variant=USA console-setup/ask_detect=false",
    " initrd=/install/initrd.gz",
    "<enter>"
  ]
  
  disk_size = 20480
  memory    = 2048
  cpus      = 2
  
  output_directory = "output"
  format          = "ova"
  
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]
  
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"]
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
    playbook_file = "ansible/playbook.yml"
    user          = "ubuntu"
    use_proxy     = "false"
    galaxy_file   = "requirements.yml"
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3"
    ]
  }
}
