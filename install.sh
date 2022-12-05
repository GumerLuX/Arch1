#!/bin/bash

#version: 0.4
# https://github.com/GumerLuX/arch.git
#shellcheck disable=

#Colores
Green="\e[0;32m\033[1m"
Red="\e[0;31m\033[1m"
Blue="\e[0;34m\033[1m"
Yellow="\e[0;33m\033[1m"
Cyan="\e[0;36m\033[1m"
Light="\e[96m\033[1m"
Gray="\e[0;37m\033[1m"
fin="\e[0m"

# Estilos
print_line(){
    printf "\e[1;34m%$(tput cols)s\n\e[0m"|tr ' ' '-'
}

print_line1(){
    printf "\e[1;34m%$(tput cols)s\n\e[0m"|tr ' ' '='
}

write_header(){
    clear
    print_line1
    echo -e "${Blue}#${fin} ${Gray}$1${fin}"
    print_line1
    echo ""
}

print_info(){
    echo -e $"${Green}$1${fin}\n"
}

escribe(){
    echo -e Escribe: $"${Yellow}$1${fin}\n"
}

escribe2(){
    echo -e Escribe: $"${Yellow}$1${fin}" $"${Gray}$2${fin}\n"
}

pause_function(){
    echo
    print_line
      read -p "Presiona enter para continuar..."
  }

# 1 INTRO
write_header "Bienvenido al instalador de ${Cyan}ARCHLINUX${fin} Creado por ${Green}GumerLuX${fin}"
echo
print_info   "Este escript funciona de esta manera:

      1- Te muestra por pantalla el ${Yellow} comando de este color  ${fin} que tienes que escribir
      2- Te abre el terminal de bash
      3- Introduces el comando + enter
      4- Introduce ${Yellow} exit ${fin} y el script continuara.

      Recuerda escribe ${Yellow} exit ${fin} para continuar el script"
pause_function

# TECLADO ESPAÑOL
write_header "TECLADO ESPAÑOL - AÑADIMOS MEMORIA - CONFIGURANDO BASH"
echo
print_info    "Configuramos nuestro teclado"
echo
escribe "loadkeys es"
escribe "mount -o remount,size=2G /run/archiso/cowspace}"
escribe "cp bashrc /root/.bashrc"
echo
echo -e   Recuerda escribe "${Yellow} exit ${fin}" para continuar el script
bash

clear
# ACTUALIZAR REPOSITORIOS Y KEYS E INSTALAMOS EL RATON DE CONSOLA
write_header " ACTUALIZAR REPOSITORIOS Y KEYS E INSTALAMOS EL RATON DE CONSOLA"
print_info  "Actualizamos los KEYS, repositorios e instalmos el mousse para la consola"
echo
escribe "pacman -Sy archlinux-keyring gpm"
bash

# ACTIVAMOS EL MOUSSE EN LA CONSOL
write_header "ACTIVAMOS EL MOUSSE EN LA CONSOLA"
print_info   "Activamos los servicios del mousse en systemctl"
escribe  "systemctl start gpm.service"
bash

# PARTICIONAR EL DISCO MANUALMENTE
write_header "PARTICIONAR EL DISCO MANUALMENTE"
print_info "      Como hacemos una instalacion con Windows en modo UEFI
      Solo crearemos una particion swap y una para el sistema root/
      Utilizaremos la particion boot de Windows existente
      Lanzamos el commando cfdisk"
escribe  "cfdisk"
bash
clear

# cremos la variable $disco
print_line
print_info "Una vez creadas las particiones anotamos nuestro disco (ej: sda)"
read disco
pause_function

# COMPROVAR DISCO Y ANOTAMOS
write_header "COMPROBAMOS LAS PARTICIONES DE NUESTRO DISCO"
print_info "Verificamos la configuracion del disco creado."
sleep 2s
fdisk -l /dev/$disco
print_info "anotaremos por variable el nombre de nuestras particiones
        Para Formatealas y montarlas: boot, swap, /root"
pause_function
clear
fdisk -l /dev/$disco
# cremos la variable $boot
print_info "Seleccionamos la particion boot de windows con el nombre (EFI System)(ej: sda1)"
read boot
# cremos la variable $swap
print_info "Seleccionamos la particion swap (ej: sda4)"
read swap
# cremos la variable $root
print_info "Seleccionamos la particion root / (ej: sda5)"
read root

# FORMATEAR LA PARTICION ROOT Y MONTAMOS
write_header "FORMATEAR LA PARTICION ROOT Y MONTAMOS"
print_info "Formateamos y montamos la particion root/"
escribe "mkfs.ext4 /dev/$root ${Cyan}Si queremos el LABEL ${fin} mkfs.ext4 -L KDE /dev/$root"
print_info "Montamos las particion del sistema en: /mnt"
escribe "mount /dev/$root /mnt"
bash

# FORMATEAR PARTICION SWAP Y ACTIVAMOS
write_header "FORMATEAR PARTICION SWAP Y ACTIVAMOS"
print_info "Formateamos la particion swap y activamos"
escribe  "mkswap /dev/$swap ${Cyan}Si queremos el LABEL ${fin}mkswap -L swap /dev/$swap"
escribe  "swapon /dev/$swap"
bash

# CREAR DIRECTORIOS {BOOT} MONTAMOS
write_header "CREAR DIRECTORIO {BOOT} Y MONTAMOS"
print_info "Creamos el directorio boot y montamos en /mnt"
escribe "mkdir /mnt/boot /mnt"
print_info "Mantamos la particion boot de windows"
escribe "mount /dev/$boot /mnt/boot"
bash

#INSTALANDO EL SISTEMA BASE
write_header "INSTALANDO SISTEMA BASE"
print_info "  Elegimos el sistema base a instalar. Tenemos 4º opciones para elegir:"
echo
echo -e "   1.La${Yellow} Estable ${fin}— Versión vainilla.${Blue} Recomendado${fin}"
echo -e "   2.La${Yellow} Hardened ${fin}— Enfocado en la seguridad"
echo -e "   3.La${Yellow} LTS ${fin}— De larga duración,${Blue} para PCs. antiguos${fin}"
echo -e "   4.La${Yellow} Kernel ZEN ${fin}— Kernel mejorado, por hackers.${Blue} Recomendado ${fin}"
echo
echo -e "${Gray} Eleja una opción ej: '1'${fin}"
echo
read sistema
echo

write_header "INSTALANDO SISTEMA BASE"
if [ "$sistema" = "1" ] 
    then
        escribe "pacstrap /mnt base base-devel linux linux-headers linux-firmware"
        bash
elif [ "$sistema" = "2" ]
    then
        escribe "pacstrap /mnt base base-devel linux linux-hardened linux-hardened-headers linux-firmware"
        bash
elif [ "$sistema" = "3" ]
    then
        escribe "pacstrap /mnt base base-devel linux linux-lts linux-lts-headers linux-firmware"
        bash
elif [ "$sistema" = "4" ]
    then
        escribe "pacstrap /mnt base base-devel linux linux-zen linux-zen-headers linux-firmwar"
fi

# AFINANDO EL SISTEMA {EXTRAS}
write_header "AFINANDO EL SISTEMA {EXTRAS}"
print_info "Afinando el sistema, instalando extras y utilidades"
echo -e "${Gray}UTILIDADES SISTEMA:${fin}"
escribe "f2fs-tool ntfs-3g gvfs gvfs-afc gvfs-mtp espeakup"
echo -e "${Gray}UTILIDADES RED:${fin}"
escribe "networkmanager dhcpcd netctl s-nail openresolv"
echo -e "${Gray}UTILIDADES USUARIO:${fin}"
escribe "xdg-user-dirs nano vi"
echo -e "${Gray}UTILIDADES tols:${fin}"
escribe "jfsutils logrotate usbutils neofetch"
echo -e "${Gray}Si ponemos al final --noconfirm NO nos pide confirmacion${fin}"
escribe "pacstrap /mnt X --noconfirm   ${Gray}X = comandos${fin}"
bash

# GENERAR EL FSTAB
write_header "GENERAR EL FSTAB"
print_info "Instalando el Sistema Base: 'Generar fstab'"
escribe "genfstab -pU /mnt >> /mnt/etc/fstab"
bash

## Entrar en el sistema base #########################
# CREANDO EL HOSTNAME
write_header "CREANDO EL HOSTNAME Entrar en el sistema base"
print_info "Creando nombre del sistema 'hostname'"
print_info "Cual es el nombre de tu PC (ej: sinlux)"
#cremos la variable $PC
read PC
escribe "echo $PC > /mnt/etc/hostname"
print_line
bash

# ESTABLECER LA ZONA HORARIA
write_header "ESTABLECER LA ZONA HORARIA"
print_info "Configurando el sistema con arch-chroot:"
print_info "Establecer la zona horaria 'Creamos un link de nuestra zona horaria'"
escribe "arch-chroot /mnt ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime"
print_line
bash

# borrar el # en el siguiente enunciado es_ES.UTF-8 UTF-8
# EDITANDO LOCALES
write_header "EDITANDO LOCALES"
print_info "Configurando el sistema Locales"
print_info ' Borrar el hashtag "#" en el siguiente enunciado es_ES.UTF-8 UTF-8' 
escribe "nano /mnt/etc/locale.gen"
print_info  " Guardar el archivo (Ctrl+o), Para salir (Ctrl+x)"
print_info  ' Podemos hacerlo directamente con el comando set:'
escribe "sed -i '/es_ES.UTF/s/^#//g' /mnt/etc/locale.gen"
bash

# DEFINIENDO EL IDIOMA
write_header "DEFINIENDO EL IDIOMA"
print_info "Configurando el sistema: Difiniendo el lenguaje = idioma PC"
escribe "echo LANG=es_ES.UTF-8 > /mnt/etc/locale.conf"
bash

# GENERANDO LOCALES
write_header "GENERANDO LOCALES"
print_info "Configurando el sistema: Generando locales"
escribe "arch-chroot /mnt locale-gen"
bash

# CONFIGURAR EL RELOJ DE HARDWARE
write_header "CONFIGURAR EL RELOJ DE HARDWARE"
print_info "Configurando el sistema: Configurar el reloj de hardware"
escribe "arch-chroot /mnt hwclock -w"
bash

# CONFIGURAR EL TECLADO
write_header "CONFIGURAR EL TECLADO"
print_info "Configurando el sistema: Configurar el teclado 'keyboard'"
escribe "echo KEYMAP=es > /mnt/etc/vconsole.conf"
bash

# INSTALAR systemd-boot:
write_header "INSTALACION systen-boot - UEFI"
print_info "
        Vamos a instalar el cargador de arranque bootctl.
        Instalamos el bootctl y Creamos el archivo de configuracion 'loader.conf'
        Pues vamos a ello y continuemos."
escribe "bootctl --path=/boot install"
echo -E 'Escribe: echo -e "default  arch\ntimeout  5\neditor  0" > /boot/loader/loader.conf'
escribe2 "cat /boot/loader/loader.conf" "==> Para comprobar el archivo"
bash

write_header "INSTALACION systen-boot - UEFI"
print_info "
        Editando el partuuid creando una variable
        Y creamos el archivo de configuracion arch.conf"
echo -E "Escribe: partuuid=\$(blkid -s PARTUUID -o value /dev/"$root")"
echo -E 'Escribe: echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/initramfs-linux.img\noptions\troot=PARTUUID=${partuuid} rw" > /boot/loader/entries/arch.conf'
escribe2 "cat /boot/loader/entries/arch.conf" "==> Para comprobar el archivo"
bash

# STABLECER CONTRASEÑA DE ADMINISTRADOR (root)
write_header "ESTABLECER CONTRASEÑA DE ADMINISTRADOR (root)"
print_info   "Configurando el sistema: Establecer contraseña del Administrador 'root'"
print_info "Introducimos la contraseña:"
escribe "arch-chroot /mnt passwd"
bash

# CREAMOS LA CUENTA DE USUARIO
write_header "CREAMOS LA CUENTA DE USUARIO"
print_info "Configurando el sistema: Creamos el usuario, añadimos estos grupos:"
#cremos la variable $usuario
print_info "Pon el nombre de tu usuario:"
read usuario
escribe  "arch-chroot /mnt useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash "$usuario" ${fin}"
bash

# ESTABLECER CONTRASEÑA DE USUARIO
write_header "ESTABLECER CONTRASEÑA DE USUARIO"
print_info "Configurando el sistema: Establecer contraseña del usuario:"
escribe "arch-chroot /mnt passwd  $usuario"
print_info "Introducimos la contraseña:"
bash

# COPIAMOS EL ESCRIPT DE INSTALACION
write_header "COPIAMOS EL ESCRIPT DE INSTALACION"
print_info "Copiamos el script de instalacion, vamos un directorio atras."
escribe "cd .. && cp -rp arch1 /mnt/root/arch1"
bash

# DESMONTAMOS PARTICIONES Y REINICIAMOS EL SISTEMA
write_header "DESMONTAMOS PARTICIONES Y REINICIAMOS EL SISTEMA"
print_info "Dosmontar particiones y reinicio de sistema"
escribe "umount -R /mnt"
bash
read -p "Press enter para reiniciar el sistema" 
reboot
