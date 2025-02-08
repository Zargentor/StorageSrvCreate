# Примечания:
# 1. Параметры crserver.exe:
#    -srvc - запуск как служба
#    -port - указание порта
#    -d    - путь к хранилищу
# 2. После создания службы требуется её ручной старт (Start-Service)

# Установка кодировки консоли для корректного отображения символов
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Проверка прав администратора
# --------------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Перезапуск скрипта с повышенными привилегиями
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "powershell"
    $newProcess.Arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    $newProcess.Verb = "runas"  # Запрос UAC
    [System.Diagnostics.Process]::Start($newProcess)
    exit  # Завершение текущей сессии
}

# Параметры для создания службы
# --------------------------------------------------
$StartPort = "17"  # Базовый номер порта (окончательный порт: 1742)
$RepPath = """C:\1C_Repos"""  # Путь к хранилищу конфигураций (двойные кавычки для пробелов)
$crserverPath = """C:\Program Files\1cv8\8.3.24.1548\bin\crserver.exe"""  # Путь к исполняемому файлу
$SrvcName = "1C:Enterprise 8.3 Configuration Repository Server $($StartPort)42"  # Имя службы
$BinPath = "$crserverPath -srvc -port $($StartPort)42 -d $RepPath"  # Параметры запуска

# Создание службы Windows
# --------------------------------------------------
New-Service `
    -Name $SrvcName `  # Уникальное имя службы
    -BinaryPathName $BinPath `  # Команда для запуска
    -StartupType Automatic  # Тип автозапуска
