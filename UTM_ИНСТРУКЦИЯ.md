# Создание VM в UTM для обучения системных администраторов

## Шаг 1: Создание VM в UTM

1. **Откройте UTM** (установлен в Applications)

2. **Нажмите "Create a New Virtual Machine"**

3. **Выберите "Virtualize"** → **"Linux"**

4. **Настройки VM:**
   - **Name:** `ubuntu-troubleshooting`
   - **Architecture:** `ARM64 (aarch64)`
   - **System:** `Generic`
   - **Memory:** `2048 MB`
   - **CPU Cores:** `2`

5. **Настройки диска:**
   - **Storage:** `20 GB`
   - **Interface:** `VirtIO`

6. **Настройки сети:**
   - **Network:** `Shared Network`

7. **Настройки загрузки:**
   - **Boot ISO:** Скачайте Ubuntu Server 22.04.3 ARM64
   - **URL:** `https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-arm64.iso`

## Шаг 2: Установка Ubuntu Server

1. **Запустите VM**

2. **При установке используйте настройки:**
   - **Language:** English
   - **Keyboard:** US
   - **Network:** DHCP (автоматически)
   - **Hostname:** `ubuntu`
   - **User:** `ubuntu`
   - **Password:** `ubuntu`
   - **Disk partitioning:** Use entire disk (LVM)
   - **Install OpenSSH server:** ✅ Да
   - **Install additional packages:** Оставить пустым

## Шаг 3: Настройка после установки

После установки и перезагрузки:

```bash
# Войдите в систему (ubuntu/ubuntu)

# Обновите систему
sudo apt update && sudo apt upgrade -y

# Установите необходимые пакеты
sudo apt install -y python3 python3-pip git curl wget vim htop

# Настройте sudo без пароля
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ubuntu
sudo chmod 440 /etc/sudoers.d/ubuntu

# Перезагрузитесь
sudo reboot
```

## Шаг 4: Применение Ansible playbook

1. **Скопируйте файлы проекта на VM** (через SCP или git clone)

2. **Установите зависимости Ansible:**
   ```bash
   ansible-galaxy install -r requirements.yml
   ```

3. **Запустите playbook:**
   ```bash
   ansible-playbook -i localhost, -c local playbook.yml
   ```

## Шаг 5: Экспорт образа

1. **Остановите VM**

2. **В UTM выберите VM** → **"Export"**

3. **Выберите формат:** `UTM Package (.utm)`

4. **Сохраните файл**

## Альтернативный способ: Конвертация в VirtualBox

После создания образа в UTM можно конвертировать его в формат VirtualBox:

1. **Экспортируйте VM из UTM**
2. **Используйте qemu-img для конвертации:**
   ```bash
   qemu-img convert -O vdi ubuntu-troubleshooting.qcow2 ubuntu-troubleshooting.vdi
   ```
3. **Создайте новую VM в VirtualBox и подключите .vdi файл**

## Преимущества этого подхода:

- ✅ Работает на Apple Silicon
- ✅ Создает полноценный Ubuntu Server
- ✅ Подходит для обучения системных администраторов
- ✅ Можно экспортировать и поделиться с другими
- ✅ Бесплатно
