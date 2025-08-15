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
  
  # Отключаем EFI для избежания проблем с загрузкой
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--firmware", "bios"],
    ["modifyvm", "{{.Name}}", "--boot1", "dvd"],
    ["modifyvm", "{{.Name}}", "--boot2", "disk"],
    ["modifyvm", "{{.Name}}", "--boot3", "none"],
    ["modifyvm", "{{.Name}}", "--boot4", "none"]
  ]
  
  # Не используем автоматическую установку
  headless = false
  disable_shutdown = true
}

build {
  sources = ["source.virtualbox-iso.ubuntu-troubleshooting"]

  # Пропускаем автоматическую установку, создаем только базовую VM
  provisioner "shell-local" {
    inline = [
      "echo 'VM создана успешно!'",
      "echo 'Теперь нужно вручную установить Ubuntu:'",
      "echo '1. Запустите VM'",
      "echo '2. Установите Ubuntu с настройками:'",
      "echo '   - Пользователь: ubuntu'",
      "echo '   - Пароль: ubuntu'",
      "echo '   - Установить OpenSSH server: Да'",
      "echo '3. После установки запустите Ansible playbook'"
    ]
  }
}
