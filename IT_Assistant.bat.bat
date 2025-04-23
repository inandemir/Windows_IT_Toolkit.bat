@echo off
chcp 65001
cls
color 0A

:: Yönetici kontrolü
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Bu scripti YÖNETİCİ olarak çalıştırmanız gerekiyor.
    pause
    exit /b
)

:: Güncellenmiş Başlık
echo ****************************************
echo    GELİŞMİŞ IT DESTEK OTOMASYONU
echo ****************************************
echo.

:MENU
echo [SİSTEM BİLGİLERİ]
echo 1. Bilgisayar Seri Numarasını, Adını, Marka ve Modelini Göster
echo 2. IP Adresini Görüntüle
echo 3. Windows Lisans Durumunu Göster
echo 4. Sistem Bilgilerini Görüntüle
echo 5. Windows Sürüm Bilgisi (winver)
echo 6. Son Format Tarihini Göster
echo 7. Disk Durumunu Kontrol Et
echo 8. Windows Güncelleme Durumunu Göster
echo 9. CPU Bilgilerini Göster
echo 10. Bellek (RAM) Kullanımını Göster
echo.
echo [AĞ YÖNETİMİ]
echo 11. Grup Politikalarını Güncelle (gpupdate /force)
echo 12. Kullanıcı Hesaplarını Listele
echo 13. Depolama Alanı Durumunu Göster
echo 14. Sabit Diski Tarama (chkdsk)
echo 15. Güvenlik Duvarını Kapat/Aç
echo 16. Windows Sistem Dosyalarını Onar
echo 17. Disk Temizliği Başlat
echo 18. Ağ DNS Önbelleğini Temizle
echo 19. Gereksiz Dosyaları Temizle
echo 20. WiFi Şifrelerini Göster
echo.
echo [GELİŞMİŞ ARAÇLAR]
echo 21. Başlangıç Programlarını Yönet
echo 22. Sistem Önyükleme Onarımı
echo 23. BitLocker Durumunu Göster
echo 24. Hosts Dosyasını Düzenle
echo 25. Uzak Masaüstü Ayarlarını Yap
echo.
echo 26. Çıkış
echo.

set /p choice=Bir seçenek girin (1-26): 

if "%choice%"=="1" goto COMPUTER_INFO
if "%choice%"=="2" goto IP
if "%choice%"=="3" goto LICENSE
if "%choice%"=="4" goto SYSINFO
if "%choice%"=="5" goto WINVER
if "%choice%"=="6" goto LAST_FORMAT_DATE
if "%choice%"=="7" goto DISK
if "%choice%"=="8" goto WINDOWSUPDATE
if "%choice%"=="9" goto CPUINFO
if "%choice%"=="10" goto MEMORY
if "%choice%"=="11" goto GPUPDATE
if "%choice%"=="12" goto USERS
if "%choice%"=="13" goto STORAGE
if "%choice%"=="14" goto CHKDSK
if "%choice%"=="15" goto FIREWALL_TOGGLE
if "%choice%"=="16" goto SFC
if "%choice%"=="17" goto CLEANUP
if "%choice%"=="18" goto CLEAR_DNS
if "%choice%"=="19" goto CLEAN_TEMP_FILES
if "%choice%"=="20" goto WIFI_PASSWORD
if "%choice%"=="21" goto STARTUP_APPS
if "%choice%"=="22" goto BOOT_REPAIR
if "%choice%"=="23" goto BITLOCKER_STATUS
if "%choice%"=="24" goto EDIT_HOSTS
if "%choice%"=="25" goto RDP_SETTINGS
if "%choice%"=="26" exit
goto MENU

:: [SİSTEM BİLGİLERİ]
:COMPUTER_INFO
cls
echo [BİLGİSAYAR BİLGİLERİ]
echo =====================
echo Seri Numarası: 
wmic bios get serialnumber /value
echo.
echo Bilgisayar Adı: 
hostname
echo.
echo Donanım Bilgileri:
wmic computersystem get manufacturer,model,name /format:list
wmic os get caption,version /format:list
pause
goto MENU

:IP
cls
echo [AĞ BİLGİLERİ]
echo =============
ipconfig /all | more
pause
goto MENU

:LICENSE
cls
echo [LİSANS DURUMU]
echo ==============
echo Windows Lisans:
cscript //nologo %windir%\system32\slmgr.vbs /xpr
echo.
echo Office Lisans (varsa):
for /f %%x in ('dir /b /s "%ProgramFiles%\Microsoft Office\Office*\ospp.vbs"') do (
    cscript //nologo "%%x" /dstatus
)
pause
goto MENU

:SYSINFO
cls
echo [SİSTEM BİLGİLERİ]
echo ================
systeminfo | more
pause
goto MENU

:WINVER
start winver
goto MENU

:LAST_FORMAT_DATE
cls
echo [KURULUM TARİHİ]
echo ===============
wmic os get installdate /value
pause
goto MENU

:DISK
cls
echo [DİSK DURUMU]
echo ===========
wmic diskdrive get model,status,size /format:list
echo.
wmic logicaldisk get caption,freespace,size /format:list
pause
goto MENU

:WINDOWSUPDATE
cls
echo [GÜNCELLEME GEÇMİŞİ]
echo ==================
wmic qfe list brief /format:table
pause
goto MENU

:CPUINFO
cls
echo [İŞLEMCİ BİLGİLERİ]
echo =================
wmic cpu get name,numberofcores,numberoflogicalprocessors,maxclockspeed /format:list
pause
goto MENU

:MEMORY
cls
echo [BELLEK BİLGİLERİ]
echo ================
wmic memorychip get capacity,speed,manufacturer,partnumber /format:list
echo.
echo Kullanım:
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value
pause
goto MENU

:: [AĞ YÖNETİMİ]
:GPUPDATE
cls
echo [GRUP POLİTİKALARI]
echo =================
gpupdate /force
pause
goto MENU

:USERS
cls
echo [KULLANICILAR]
echo ============
net user
echo.
echo Yöneticiler:
net localgroup administrators
pause
goto MENU

:STORAGE
cls
echo [DEPOLAMA]
echo ========
wmic logicaldisk get caption,description,freespace,size /format:table
pause
goto MENU

:CHKDSK
cls
echo [DİSK KONTROLÜ]
echo =============
echo Tarama yapılacak sürücüyü girin (örn: C): 
set /p drive=Drive: 
chkdsk %drive% /f /r
echo.
echo Bir sonraki başlangıçta tarama yapılacak.
pause
goto MENU

:FIREWALL_TOGGLE
cls
echo [GÜVENLİK DUVARI]
echo ===============
netsh advfirewall show allprofiles state
echo.
echo 1. Aç | 2. Kapat | 3. İptal
set /p fwchoice=Seçiminiz: 
if "%fwchoice%"=="1" (
    netsh advfirewall set allprofiles state on
    echo Açıldı.
) else if "%fwchoice%"=="2" (
    netsh advfirewall set allprofiles state off
    echo Kapatıldı.
)
pause
goto MENU

:SFC
cls
echo [SİSTEM DOSYA KONTROLÜ]
echo =====================
sfc /scannow
pause
goto MENU

:CLEANUP
cls
echo [DİSK TEMİZLİĞİ]
echo ==============
cleanmgr /sagerun:1
echo Temizleyici başlatıldı.
pause
goto MENU

:CLEAR_DNS
cls
echo [DNS TEMİZLİĞİ]
echo =============
ipconfig /flushdns
echo DNS önbelleği temizlendi.
pause
goto MENU

:CLEAN_TEMP_FILES
cls
echo [GEÇİCİ DOSYA TEMİZLİĞİ]
echo ======================
echo Boyut öncesi: 
dir %temp% /s | find "File(s)"
del /q /f /s %temp%\*.*
echo.
echo Boyut sonrası: 
dir %temp% /s | find "File(s)"
pause
goto MENU

:WIFI_PASSWORD
cls
echo [WİFİ ŞİFRELERİ]
echo ==============
for /f "skip=3 tokens=2 delims=:" %%a in ('netsh wlan show profiles') do (
    for /f "tokens=*" %%b in ("%%a") do (
        echo WiFi: %%b
        netsh wlan show profile name="%%b" key=clear | findstr "Key Content"
        echo.
    )
)
pause
goto MENU

:: [GELİŞMİŞ ARAÇLAR]
:STARTUP_APPS
cls
echo [BAŞLANGIÇ UYGULAMALARI]
echo ======================
wmic startup get caption,command,location /format:list
pause
goto MENU

:BOOT_REPAIR
cls
echo [ÖNYÜKLEME ONARIMI]
echo =================
echo Bilgisayar onarım modunda başlatılacak...
shutdown /r /o /f /t 10
echo 10 saniye içinde yeniden başlatılıyor...
pause
goto MENU

:BITLOCKER_STATUS
cls
echo [BİTLOCKER DURUMU]
echo ================
manage-bde -status
pause
goto MENU

:EDIT_HOSTS
cls
echo [HOSTS DOSYASI]
echo =============
notepad %windir%\system32\drivers\etc\hosts
goto MENU

:RDP_SETTINGS
cls
echo [UZAK MASAÜSTÜ AYARLARI]
echo ======================
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections
echo.
echo 1. Aç | 2. Kapat | 3. İptal
set /p rdpchoice=Seçiminiz: 
if "%rdpchoice%"=="1" (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    echo Uzak Masaüstü açıldı.
) else if "%rdpchoice%"=="2" (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
    echo Uzak Masaüstü kapatıldı.
)
pause
goto MENU