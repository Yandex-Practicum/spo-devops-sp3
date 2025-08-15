packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "virtualbox-iso" "ubuntu-troubleshooting-arm64" {
  iso_url          = "ubuntu-22.04.3-live-server-arm64.iso"
  iso_checksum     = "sha256:5702372d25111e24d59596de62ae24daef873018cbf63c9dd9ff12292a57aca9"
  
  guest_os_type = "Ubuntu_arm64"
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
  
  # Настройки для ARM64
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--firmware", "bios"],
    ["modifyvm", "{{.Name}}", "--boot1", "dvd"],
    ["modifyvm", "{{.Name}}", "--boot2", "disk"],
    ["modifyvm", "{{.Name}}", "--boot3", "none"],
    ["modifyvm", "{{.Name}}", "--boot4", "none"],
    ["modifyvm", "{{.Name}}", "--uart1", "0x3F8", "4"],
    ["modifyvm", "{{.Name}}", "--uartmode1", "disconnected"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "none"],
    ["modifyvm", "{{.Name}}", "--vram", "1"]
  ]
  
  # Не используем автоматическую установку
  headless = false
  disable_shutdown = true
}

build {
  sources = ["source.virtualbox-iso.ubuntu-troubleshooting-arm64"]

  # Пропускаем автоматическую установку
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
