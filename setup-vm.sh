#!/bin/bash

# Скрипт для настройки VM после установки Ubuntu Server
# Запускать внутри VM после установки Ubuntu

echo "Настройка VM для обучения системных администраторов..."

# Обновляем систему
echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

# Устанавливаем необходимые пакеты
echo "Установка необходимых пакетов..."
sudo apt install -y python3 python3-pip git curl wget vim htop tree

# Настраиваем sudo без пароля
echo "Настройка sudo без пароля..."
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ubuntu
sudo chmod 440 /etc/sudoers.d/ubuntu

# Создаем символическую ссылку для python
sudo ln -sf /usr/bin/python3 /usr/bin/python

# Устанавливаем Ansible
echo "Установка Ansible..."
sudo apt install -y ansible

# Клонируем репозиторий (если есть доступ к интернету)
echo "Клонирование репозитория..."
if [ -d "/tmp/spo-devops-sp3" ]; then
    rm -rf /tmp/spo-devops-sp3
fi

# Создаем директорию для проекта
mkdir -p /home/ubuntu/troubleshoot-vm
cd /home/ubuntu/troubleshoot-vm

# Копируем файлы проекта (если они есть)
if [ -f "/tmp/playbook.yml" ]; then
    cp /tmp/playbook.yml .
    cp -r /tmp/roles .
    cp -r /tmp/trouble-apps-go .
    cp requirements.yml .
fi

# Устанавливаем зависимости Ansible
echo "Установка зависимостей Ansible..."
ansible-galaxy install -r requirements.yml

# Запускаем playbook
echo "Запуск Ansible playbook..."
ansible-playbook -i localhost, -c local playbook.yml

echo "Настройка завершена!"
echo "VM готова для обучения системных администраторов."
