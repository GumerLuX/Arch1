#!/bin/bash

#version: 0.4
# https://github.com/GumerLuX/arch.git
#shellcheck disable=SC2034,SC2162

#Colores
Green="\e[0;32m\033[1m"
Red="\e[0;31m\033[1m"
Blue="\e[0;34m\033[1m"
Yellow="\e[0;33m\033[1m"
Cyan="\e[0;36m\033[1m"
Cyan1="\e[1;36m\033[1m"
Light="\e[96m\033[1m"
Gray="\e[0;37m\033[1m"
fin="\e[0m"
Fondo="\e[4;30;43m"
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
    echo -e "${Blue}#${fin}" "${Gray}Bienbenido a la instalacion automatizada de ArchLinux echo por GumerLuX${fin}"
    echo -e "${Blue}#${fin}" "${Green}$1${fin}" 
    print_line1
    echo ""
}

print_info(){
    echo -e $"${Cyan1}$1${fin}\n"
}

pause_function(){
    echo
    print_line
      read -p "Presiona enter para continuar..."
  }


## INICIANDO LA INSTALACION
write_header $1"Aumentando memoria en sistema"
    mount -o remount,size=2G /run/archiso/cowspace
    pacman -Sy archlinux-keyring
    pause_function

## Crear un menu de inicio: con preguntas idioma. teclado definiendo la zona,region y locales
write_header $1"Distribucion del teclado"
    print_info "Configuramos nuestro teclado"
    read -p "Idioma de tu teclado(ej; es): "  idioma
    loadkeys "$idioma"

write_header $1 "Zona Horaria"
    print_info "Eleginos nuestra Zona Horario"
    #timedatectl list-timezones | sed 's/\/.*$//' | uniq | tr '\n' ' '| xargs -n5 | awk '{print $5"\t\t" $1"\t"$2"\t" $3"\t"$4}'
    ls /usr/share/zoneinfo
    read -p "Cual es tu zona (ej: Europa): " zona
write_header $1 "Zona Horaria"
    print_info "Elige tu pais"
    ls /usr/share/zoneinfo/"$zona"
    print_info "Cual es tu ciudad"
    read -p "Cual es tu ciudad (ej: Madrid): " subzona

write_header $1 "Configuracion del disco"
    sfdisk -l
    print_info "Cual es nuestro disco a FORMATEAR"
    read -p "nuestro disco es (ej: sda): " disco
    ## CREAMOS LAS PARTICIONES
    cfdisk /dev/"$disco"

write_header $1 "Seleccionamos las particiones del disco"
    print_info "Seleccionamos la particion boot de windows con el nombre (EFI System)(ej: sda1)"
    read -p "Particion /boot (EFI System)(ej: sda1): " boot

    print_info "Seleccionamos la particion swap (ej: sda4): "
    read -p "la particion swap (ej: sda4)" swap

    print_info "Seleccionamos la particion root / (ej: sda5): "
    read -p "la particion root / (ej: sda5)" root

write_header $1"Formateamos y montamos"
    print_info "Formateando particiones root, swap y montamos boot /"
    mkfs.ext4 /dev/"$root"
    mount /dev/"$root" /mnt
    mkswap /dev/"$swap"
    swapon /dev/"$swap"
    mkdir /mnt/boot /mnt
    mount /dev/"$boot" /mnt/boot
 
#INSTALANDO EL SISTEMA BASE
write_header $1"INSTALANDO SISTEMA BASE"
    print_info "  Elegimos el sistema base a instalar. Tenemos 4º opciones para elegir:"
    echo -e "   1.La${Yellow} Estable ${fin}— Versión vainilla.${Blue} Recomendado${fin}"
    echo -e "   2.La${Yellow} Hardened ${fin}— Enfocado en la seguridad"
    echo -e "   3.La${Yellow} LTS ${fin}— De larga duración,${Blue} para PCs. antiguos${fin}"
    echo -e "   4.La${Yellow} Kernel ZEN ${fin}— Kernel mejorado, por hackers.${Blue} Recomendado ${fin}"
    echo
    echo -e "${Gray} Eleja una opción ej: '1'${fin}"
    echo
    read sistema
    echo

write_header $1"INSTALANDO SISTEMA BASE"
    if [ "$sistema" = "1" ] 
        then
            pacstrap /mnt base base-devel linux linux-headers linux-firmware
    elif [ "$sistema" = "2" ]
        then
            pacstrap /mnt base base-devel linux linux-hardened linux-hardened-headers linux-firmware
    elif [ "$sistema" = "3" ]
        then
            pacstrap /mnt base base-devel linux linux-lts linux-lts-headers linux-firmware
    elif [ "$sistema" = "4" ]
        then
            pacstrap /mnt base base-devel linux linux-zen linux-zen-headers linux-firmware
    fi

# UTILIDADES EXTRAS PARA EL SISTEMA-RED-USER
write_header $1 "Instalando utilidades del sistema RED, USB, Editores,,,,"
    print_info "Afinando el sistema, instalando extras y utilidades"
    pacstrap /mnt f2fs-tool ntfs-3g gvfs gvfs-afc gvfs-mtp espeakup networkmanager dhcpcd netctl s-nail openresolv wpa_supplicant samba xdg-user-dirs nano vi git gpm jfsutils logrotate usbutils neofetch --noconfirm

# GENERAR EL FSTAB
write_header $1 "Creando el fstab"
    print_info "Instalando el Sistema Base: 'Generar fstab'"
    genfstab -pU /mnt >> /mnt/etc/fstab

# CREANDO EL HOSTNAME Entrar en el sistema base
write_header $1 "Configurando el sistema"
    print_info "Creando nombre del sistema 'hostname'"
    read -p "Cual es el nombre de tu PC (ej: sinlux): " PC
    echo "$PC" > /mnt/etc/hostname
    echo -e "127.0.0.1       localhost\n::1             localhost\n127.0.0.1       $PC.localhost     $PC" > /mnt/etc/hosts

# ESTABLECER LA ZONA HORARIA
write_header $1 "Configurando el sistema arch-chroot"
    print_info "Establecer la zona horaria 'Creamos un link de nuestra zona horaria'"
    arch-chroot /mnt ln -s /usr/share/zoneinfo/"$zona"/"$subzona" /etc/localtime

## EDITANDO LOCALES
write_header $1 "Configurando el sistema arch-chroot"
    print_info "Configurando el sistema Locales"
    sed -i '/es_ES.UTF/s/^#//g' /mnt/etc/locale.gen
    echo LANG=es_ES.UTF-8 > /mnt/etc/locale.conf
    arch-chroot /mnt locale-gen
    echo KEYMAP=es > /mnt/etc/vconsole.conf

# CONFIGURAR EL RELOJ DE HARDWARE
write_header $1 "Configurando el sistema arch-chroot"
    print_info "Configurando el sistema: Configurar el reloj de hardware"
    arch-chroot /mnt hwclock -w

# INSTALACION systen-boot - UEFI
write_header $1 "Configurando el sistema arch-chroot"
    print_info "INSTALACION systen-boot - UEFI"
    arch-chroot /mnt bootctl --path=/boot install
    echo -e "default  arch\ntimeout  5\neditor  0" > /mnt/boot/loader/loader.conf
    partuuid=$(blkid -s PARTUUID -o value /dev/"$root")
    echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/initramfs-linux.img\noptions\troot=PARTUUID=${partuuid} rw" > /mnt/boot/loader/entries/arch.conf

# ESTABLECER CONTRASEÑA DE ADMINISTRADOR (root)
write_header $1 "Configurando el sistema user-root"
	print_info "Configurando el sistema: Establecer contraseña del Administrador 'root'
	Introducimos la contraseña:
	"
	arch-chroot /mnt passwd

# CREAMOS LA CUENTA DE USUARIO
write_header $1 "Configurando el sistema usuario"
	print_info "Configurando el sistema: Creamos el usuario, añadimos estos grupos:"
	read -p "Pon el nombre de tu usuario: " usuario
	arch-chroot /mnt useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash "$usuario"
	print_info "Introducimos la contraseña:"
	arch-chroot /mnt passwd  "$usuario"

# DESMONTAMOS PARTICIONES Y REINICIAMOS EL SISTEMA
write_header $1 "DESMONTAMOS PARTICIONES Y REINICIAMOS EL SISTEMA"
    print_info "Copiando archivos de configuracion a /root"
    cd .. && cp -rp arch1 /mnt/root/arch1
    umount -R /mnt

write_header $1 "Fin de la instalacion"
	print_info "Reiniciando el sistema"
	print_info "Crtl +c para salir del script o Enter para reiniciar"
	pause_function
  # BYE
 write_header $1 "GRACIAS POR ELEGIR ESTA INSTALACION"
    echo
	echo -e "\n\nBBBBBB  YY    YY EEEEEEE"
	echo        "BB  BBB  YY YY   EE     "
	echo        "BB  BBB   YYY    EE     "
	echo        "BBBBBB    YYY    EEEEEE "
	echo        "BB  BBB   YYY    EE     "
	echo        "BB  BBB   YYY    EE     "
	echo -e     "BBBBBB    YYY    EEEEEEE\n\n"
	sleep 2s
	read 
	reboot
