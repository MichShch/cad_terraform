# cad_terraform

Terraform-конфигурация для автоматизированного создания рабочих виртуальных машин `DCWorker` в Proxmox VE.

## Назначение

Сабмодуль используется для масштабирования вычислительной среды без ручного создания каждой ВМ через веб-интерфейс Proxmox. Основной сценарий:

1. В Proxmox уже есть базовый шаблон worker-ВМ.
2. Terraform создаёт полный клон шаблона на каждой целевой физической ноде.
3. Из локального шаблона на каждой ноде создаются linked clone рабочие ВМ.
4. ВМ получают сетевые параметры через cloud-init.
5. Рабочие ВМ автоматически запускаются.

Такой подход уменьшает количество ручных действий при добавлении новых worker-нод для распределённых вычислений.

## Структура

```text
envirnoments/lab/              # лабораторное окружение Terraform
modules/dcworker_pool/         # модуль создания пула DCWorker
modules/vm/                    # простой универсальный модуль ВМ
providers-cache/               # локальный cache провайдера
providers-mirror/              # локальный mirror провайдера bpg/proxmox
```

Каталог `envirnoments` назван именно так в текущей структуре репозитория.

## Используемый провайдер

Конфигурация использует Terraform provider:

```text
bpg/proxmox
```

Версия:

```text
~> 0.103
```

Минимальная версия Terraform для лабораторного окружения:

```text
>= 1.5.0
```

## Лабораторное окружение

Основная конфигурация находится в:

```text
envirnoments/lab
```

В `main.tf` подключён модуль:

```hcl
module "dcworker_pool" {
  source = "../../modules/dcworker_pool"
}
```

Текущие параметры:

| Параметр | Значение |
|---|---:|
| Исходный шаблон | VMID `3000` |
| Нода исходного шаблона | `pve1` |
| Целевые ноды | `pve1` - `pve11` |
| Worker на `pve1` и `pve3` | `1` |
| Worker на остальных нодах | `3` |
| VMID шаблонов на нодах | с `3001` |
| VMID worker-ВМ | отдельный диапазон на ноду: `3100`, `3200`, ..., `4100` |
| Адресация worker-ВМ | DHCP через cloud-init |
| Datastore | `local-zfs` |
| Bridge | `virt2` |

## Модуль `dcworker_pool`

Модуль создаёт два типа ресурсов:

1. `proxmox_virtual_environment_vm.node_template`
   Полный клон исходного шаблона на каждой целевой ноде. Эти ВМ помечаются как template.

2. `proxmox_virtual_environment_vm.worker`
   Linked clone рабочей ВМ из локального шаблона на той же ноде.

Для worker-ВМ используется cloud-init:

- IPv4-адрес запрашивается по DHCP;
- пользователь можно переопределить через `user_account`;
- если `user_account = null`, настройки наследуются из исходного шаблона.

## Значения по умолчанию

| Параметр | Значение |
|---|---:|
| CPU sockets | `2` |
| CPU cores | `4` |
| CPU type | `x86-64-v2-AES` |
| RAM | `20480` МБ |
| Floating memory | `2048` МБ |
| Bridge | `virt2` |
| VLAN ID | `0` |
| Tags | `distributed_computing`, `quartus` |

## Подготовка Proxmox

Перед запуском Terraform нужно:

1. Создать базовую worker-ВМ.
2. Установить в неё гостевую ОС и нужный набор программ.
3. Установить QEMU guest agent.
4. Настроить cloud-init.
5. Преобразовать ВМ в template.
6. Убедиться, что VMID шаблона совпадает с `source_template_vm_id`.
7. Создать API token для Terraform.

Минимальные права API token должны позволять читать кластер и создавать/изменять ВМ. В учебной среде часто используют роль с широкими правами, но для постоянной эксплуатации лучше выдать отдельную роль только под нужные действия.

## Переменные доступа к Proxmox

В `variables.tf` ожидаются:

```hcl
variable "proxmox_api_url" {}
variable "proxmox_api_token_id" {}
variable "proxmox_api_token_secret" {}
```

Реальный `terraform.tfvars` не хранится в git, потому что `.gitignore` исключает `*.tfvars`. Для старта можно скопировать пример:

```bash
cp terraform.tfvars.example terraform.tfvars
```

В примере задан URL API:

```hcl
proxmox_api_url = "https://10.18.164.185:8006/api2/json"
```

Секреты лучше не хранить в файлах. Передавайте их через переменные окружения.

Linux/macOS:

```bash
export TF_VAR_proxmox_api_token_id='terraform@pve!iac'
export TF_VAR_proxmox_api_token_secret='token-secret'
```

Windows PowerShell:

```powershell
$env:TF_VAR_proxmox_api_token_id='terraform@pve!iac'
$env:TF_VAR_proxmox_api_token_secret='token-secret'
```

## Запуск

Перейти в окружение:

```bash
cd envirnoments/lab
```

Инициализировать Terraform:

```bash
terraform init
```

Посмотреть план:

```bash
terraform plan
```

Применить:

```bash
terraform apply
```

Посмотреть созданные ресурсы:

```bash
terraform output
```

## Изменение числа worker-ВМ

Количество worker на ноду задаётся в `workers_per_node`:

```hcl
workers_per_node = {
  pve1 = 1
  pve2 = 3
  pve3 = 1
}
```

Например, чтобы создать по 3 worker на каждой ноде:

```hcl
workers_per_node = {
  pve1 = 3
  pve2 = 3
  pve3 = 3
}
```

Для каждой ноды из `node_names` также должен быть задан стартовый VMID в `worker_vmid_start_by_node`:

```hcl
worker_vmid_start_by_node = {
  pve1 = 3100
  pve2 = 3200
  pve3 = 3300
}
```

После изменения:

```bash
terraform plan
terraform apply
```

## Добавление новой Proxmox-ноды

Чтобы добавить новую ноду, например `pve4`:

1. Убедиться, что нода уже добавлена в Proxmox-кластер.
2. Убедиться, что на ней доступен datastore `local-zfs`.
3. Убедиться, что bridge `virt2` существует или создаётся SDN.
4. Добавить ноду в `node_names`.
5. Добавить количество worker в `workers_per_node`.

Пример:

```hcl
node_names = ["pve1", "pve2", "pve3", "pve4"]

workers_per_node = {
  pve1 = 1
  pve2 = 1
  pve3 = 1
  pve4 = 1
}
```

После этого Terraform создаст локальный template на `pve4` и worker-ВМ из него.

## Проверка после применения

В Proxmox:

```text
Datacenter -> Search
```

Проверить:

- появились шаблоны `DCWorker-template-pve1`, `DCWorker-template-pve2`, ...;
- появились worker-ВМ `DCWorker-pve1-01`, `DCWorker-pve2-01`, ...;
- worker-ВМ запущены;
- ВМ подключены к bridge `virt2`;
- IP-адреса соответствуют сети `10.10.1.0/24`.

Через CLI Proxmox:

```bash
qm list
```

Внутри worker-ВМ:

```bash
ip addr
ping 10.10.1.1
ping pve1.cad.internal
```

## Важные замечания

- Не храните API token secret в git.
- Перед изменением VMID-диапазонов проверьте, что они не заняты.
- Если используется локальное хранилище, шаблон должен быть доступен на исходной ноде, а Terraform сам создаст per-node templates.
- Bridge `virt2` должен существовать на целевых нодах или быть создан через Proxmox SDN.
- При изменении сети нужно синхронно обновлять Terraform, DHCP и DNS.
