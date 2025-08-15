#!/bin/bash

# Скрипт для создания VM в UTM для обучения системных администраторов

echo "Создание VM для обучения системных администраторов..."

# Скачиваем Ubuntu Server 22.04.3 ARM64
echo "Скачивание Ubuntu Server 22.04.3 ARM64..."
ISO_URL="https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-arm64.iso"
ISO_FILE="ubuntu-22.04.3-live-server-arm64.iso"

if [ ! -f "$ISO_FILE" ]; then
    curl -L -o "$ISO_FILE" "$ISO_URL"
fi

# Создаем VM через UTM CLI
echo "Создание VM в UTM..."
VM_NAME="ubuntu-troubleshooting"

# Удаляем существующую VM если есть
utmctl delete "$VM_NAME" 2>/dev/null || true

# Создаем новую VM
utmctl create \
    --name "$VM_NAME" \
    --architecture arm64 \
    --memory 2048 \
    --cpu-count 2 \
    --disk-size 20 \
    --iso "$ISO_FILE"

echo "VM создана успешно!"
echo "Теперь нужно:"
echo "1. Открыть UTM"
echo "2. Запустить VM '$VM_NAME'"
echo "3. Установить Ubuntu Server с настройками:"
echo "   - Пользователь: ubuntu"
echo "   - Пароль: ubuntu"
echo "   - Установить OpenSSH server: Да"
echo "4. После установки применить Ansible playbook"
