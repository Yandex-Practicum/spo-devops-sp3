# Troubleshooting VM для VirtualBox

Этот проект создает образ виртуальной машины для траблшутинга, который можно запускать в VirtualBox.

## Структура проекта

- `ansible/` - Ansible playbook и роли для настройки VM
- `trouble-apps-go/` - Go приложения для создания проблем
- `virtualbox.pkr.hcl` - Конфигурация Packer для VirtualBox
- `http/` - Директория для файлов автоматической установки

## Требования

- Packer
- VirtualBox
- Ansible

## Сборка образа

1. Установите зависимости:
```bash
ansible-galaxy install -r requirements.yml
```

2. Создайте preseed.cfg файл в директории http/ для автоматической установки Ubuntu

3. Запустите сборку:
```bash
packer build virtualbox.pkr.hcl
```

## Использование

После сборки в директории output/ появится .ova файл, который можно импортировать в VirtualBox.
