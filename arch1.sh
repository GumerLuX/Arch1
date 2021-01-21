#!/bin/bash
#version: 0.0
# https://github.com/GumerLuX/arch1.git
#shellcheck disable=SC2162

#es
Green="\e[0;32m\033[1m"
Red="\e[0;31m\033[1m"
Blue="\e[0;34m\033[1m"
Yellow="\e[0;33m\033[1m"
Cyan="\e[0;36m\033[1m"
Light="\e[96m\033[1m"
Gray="\e[0;37m\033[1m"
fin="\e[0m"


## Estilos
print_line(){
    printf "\e[1;34m%$(tput cols)s\n\e[0m"|tr ' ' '-'
}

write_header(){
    clear
    print_line
    echo -e "#${Gray}$1${fin}"
    print_line
    echo ""
}

print_info(){
    echo -e "${Green}$1${fin}\n"
}

pause_function(){
    echo
    print_line
      read -p "Presiona enter para continuar..."
  }

# 1 INTRO
write_header "Bienvenido al instalador de ${Cyan}ARCHLINUX${fin} Creado por ${Green}GumerLuX${fin} https://gumerlux.github.io/Blog.GumerLuX/"
print_info "Este script instalará Archlinux sin necesidad de poner ni un comando.
Estos son los parametros que instalaremos:"
echo -e "${Light}
        1- Idioma del teclado
        2- Identificación y particionado del disco,${fin}${Gray}
            2.0- Nombre de la partición ej: 'sda,
            2.1- Eegimos el modo: ms2 o gpt,
            2.2- Tamaño del boot,
            2.3- Tamaño del sistema,
            2.4- Tamaño de la swap,${fin}${Light}
        3- Eligiendo el sistema base.
        4- Configurando el sistema${fin}${Gray}
            4.1- Nombre de la máquina,
            4.2- Zona horaria,
            4.3- Locales${fin}${Light}
        5- Contraseña de root.
        6- Nombre de usuario
        7- Contraseña de usuario${fin}
"
pause_function

#SELECT KEYMAP
  write_header "KEYMAP - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  La variable KEYMAP se especifica en el archivo /etc/rc.conf. Define qué mapa de teclas es el teclado en las consolas virtuales.
  Los archivos de tabla de claves los proporciona el paquete kbd.
  
    Enter para pasar línea y espacio para página."
  pause_function
  echo "Listado de teclados desde (localectl list-keymaps)"
  localectl list-keymaps | xargs -n5 | awk '{print $5"\t\t" $3"\t"$4}' |column -t | more
  print_line
  echo -e "Introduce la variavle de tu teclado: ej: ${Yellow}[${Green} es ${fin}${Yellow}]${fin} - ${Yellow}[${Green} la-latin1 ${fin}${Yellow}]${fin}"
  echo
  read -r idioma
  pause_function

#IDENTIFICACION DEL DISCO
  write_header "DISCO - Identificamos el nombre del disco - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "Lanzamos el comando fdisk para identificacion del disco"
  fdisk -l
  pause_function
  write_header "DISCO - Identificamos el nombre del disco"
  print_info " Pon el nombre del disco a formatear ej: 'sda'"
  echo
  read disco
  pause_function

#ELEGIMOS EL FORMATO: ms2 o gpt
  write_header " FORMATO - Elegimos el formato de nuestro disco: - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Para MS2 escribimos 'o'.
  Para GPT escribimos 'g'"
  echo
  read format
  pause_function

#ELEGIMOS EL TAMAÑO DE LA PARTICIÓN BOOT
  write_header " PARTICIÓN BOOT -  Elegimos el tamaño de la particion 'boot' - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Elegimos el tamaño de la partición  'boot'.
  ej: 500M:
  La M en Mayuscula = megas."
  echo
  read p_boot
  pause_function

#ELEGIMOS EL TAMAÑO DE LA PARTICIÓN ROOT
  write_header "PARTICIÓN ROOT - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Elegimos el tamaño de la partición del sistema 'root'.
  ej: 27.5
  La G en Mayúscula = gigas."
  echo
  read p_root
  pause_function

#ELEGIMOS EL TAMAÑO DE LA SWAP
  write_header "PARTICIÓN SWAP -  https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "Elegimos el tamaño de la partición de intercambio 'swap'.
  ej: 2G:
  La G en Mayúscula = gigas."
  echo
  read p_swap
  pause_function

#FORMATEAR LAS PARTICIONES
  write_header "FORMATEAR LAS PARTICIONES - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Tenemos que dar formato a las particiones creadas:
  Para eso tenemos que elegir en que partición las ponemos:"
  echo
  echo -e "${Gray}""Indica el disco para formatear la partición ${Yellow}boot${fin} ej: sda1""${fin}"
  echo
  read disco1
  echo
  echo -e "${Gray}""Indica el disco para formatear la partición ${Yellow}root${fin} ej: sda2""${fin}"
  echo
  read disco2
  echo
  echo -e "${Gray}""Indica el disco para formatear la partición ${Yellow}swap${fin} ej: sda3""${fin}"
  echo
  read disco3
  pause_function

#INSTALANDO EL SISTEMA BASE
write_header "SISTEMA BASE - https://gumerlux.github.io/Blog.GumerLuX/"
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
pause_function

#CONFIGURANDO EL SISTEMA
##NOMBRE DE LA MAQUINA
  write_header "Elegimos el nombre de nuestra máquina 'hostname' - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Tenemos que poner un nombre a nuestro PC o MAQUINA.
  Nos sirve para identificarlo cuando estamos conectados por ."
  read PC
  echo
  pause_function

##ESTABLECER LA ZONA HORARIA
  write_header "ZONA HORARIA - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Escoge tu localización horaria de la lista.
    Respeta las mayúsculas ej: Europe"
  echo
  timedatectl list-timezones | sed 's/\/.*$//' | uniq | tr '\n' ' '
  echo
  read ZONE
  pause_function
  write_header "ZONA HORARIA - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Escoge tu localización horaria de la lista.
    Respeta las mayúsculas ej: Madrid"
  echo
  timedatectl list-timezones | grep "$ZONE" | sed 's/^.*\///' | tr '\n' ' '| xargs -n5 | awk '{print $5"\t\t" $3"\t"$4}' |column -t | more
  echo
  read SUBZONE
  echo
  pause_function

##EDITANDO LOCALES
  write_header "LOCALES - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Tenemos que elegir las locales para nuestro sistema.
    Borrando el hashtag '#' en el siguiente enunciado es_ES.UTF-8 UTF-8'
    Solo tienes que entrar los 4º primeros parámetros"
  echo
  grep "^#$idioma" /etc/locale.gen | tr -d '\n' | xargs -n5 | awk '{print $5"\t\t" $3"\t"$4}' |column -t | more
  echo
  echo -e "${Yellow} Escribe tus locales ej: es_ES${fin}"
  echo
  read LOCALE
  echo
  pause_function

#RESUMEN
  write_header "ARCHLINUX ULTIMATE INSTALL - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Antes de empezar hacemos un repaso o lo que vamos ha instalar
  Si es correcto, continuamos la instalación."
  echo
  echo -e "    1.${Yellow} Teclado: ${fin}${Green}[${Gray}$idioma${fin}${Green}]${Gray}"
  echo -e "    2.${Yellow} Tu disco es: ${fin}${Green}[${Gray}$disco${fin}${Green}]${Gray}"
  echo -e "    3.${Yellow} Tu formato es: ${fin}${Green}[${Gray}$format${fin}${Green}]${Gray}"
  echo -e "    4.${Yellow} Tu p_boot es: ${fin}${Green}[${Gray}$p_boot/$disco1${fin}${Green}]${Gray}"
  echo -e "    5.${Yellow} Tu p_root es: ${fin}${Green}[${Gray}$p_root/$disco2${fin}${Green}]${Gray}"
  echo -e "    6.${Yellow} Tu p_swap es: ${fin}${Green}[${Gray}$p_swap/$disco3${fin}${Green}]${Gray}"
  echo -e "    7.${Yellow} Tu Kernel es: ${fin}${Green}[${Gray}$sistema${fin}${Green}]${Gray}"
  echo -e "    8.${Yellow} En Nombre del PC: ${fin}${Green}[${Gray}$PC${fin}${Green}]${Gray}"
  echo -e "    9.${Yellow} Tu zona horaria es: ${fin}${Green}[${Gray}$ZONE/$SUBZONE${fin}${Green}]${Gray}"
  echo -e "   10.${Yellow} Tu Locale es: ${fin}${Green}[${Gray}$LOCALE${fin}${Green}]${Gray}"
  echo
  print_info "  ${Red}Si por lo contrario tenéis que modificar algún parámetro,
  Crtl + c para salir de la instalación${fin} y empezar de nuevo."
  print_line
  echo
  read -p "Press enter para Iniciar la instalación" 
  clear

# Comandos==========================================================================
# Añadiendo memoria al sistema
mount -o remount,size=2G /run/archiso/cowspace
loadkeys "$idioma"
# Particion del disco a 'MS2' o 'GPT'
echo -e "$format\n w" | fdisk /dev/"$disco"
# Particion boot
echo -e "n\np\n1\n\n+$p_boot\na\n w" | fdisk /dev/"$disco"
# Particion del sistema
echo -e "n\np\n2\n\n+$p_root\n w" | fdisk /dev/"$disco"
# Particion swap
echo -e "n\np\n3\n\n+$p_swap\n t\n3\n82\n w" | fdisk /dev/"$disco"
# Formateando particiones boot
mkfs.ext2 -L boot /dev/"$disco1"
mkfs.ext4 -L KDE /dev/"$disco2"
mkswap -L swap /dev/"$disco3"
swapon /dev/"$disco3"
# Montando particiones
mount /dev/"$disco2" /mnt
mkdir /mnt/boot /mnt
mount /dev/"$disco1" /mnt/boot

if [ "$sistema" = "1" ] 
    then
	pacstrap /mnt base base-devel linux linux-headers linux-firmware grub os-prober ntfs-3g networkmanager gvfs gvfs-afc gvfs-mtp xdg-user-dirs nano dhcpcd --noconfirm
elif [ "$sistema" = "2" ]
    then
        pacstrap /mnt base base-devel linux-hardened linux-hardened-headers linux-firmware grub os-prober ntfs-3g networkmanager gvfs gvfs-afc gvfs-mtp xdg-user-dirs nano dhcpcd --noconfirm
elif [ "$sistema" = "3" ]
    then
        pacstrap /mnt base base-devel linux-lts linux-lts-headers linux-firmware grub os-prober ntfs-3g networkmanager gvfs gvfs-afc gvfs-mtp xdg-user-dirs nano dhcpcd --noconfirm
elif [ "$sistema" = "4" ]
    then
        pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware grub os-prober ntfs-3g networkmanager gvfs gvfs-afc gvfs-mtp xdg-user-dirs nano dhcpcd --noconfirm
fi
## Extras
pacman -Sy f2fs-tools espeakup brltty jfsutils logrotate netctl reiserfsprogs s-nail usbutils vi openresolv --noconfirm   
# Configurando el sistema
genfstab -pU /mnt >> /mnt/etc/fstab
echo "$PC" > /mnt/etc/hostname
arch-chroot /mnt ln -s /usr/share/zoneinfo/"$ZONE"/"$SUBZONE" /etc/localtime
# Editando locales
sed -i "/$LOCALE.UTF/s/^#//g" /mnt/etc/locale.gen
# Configurando el relol
arch-chroot /mnt hwclock -w
# Configurando el teclado
echo KEYMAP="$idioma" > /mnt/etc/vconsole.conf
# Configurando GRUB
arch-chroot /mnt grub-install /dev/"$disco"
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

#FIN DE INSTALACIÓN BASE
  write_header "FIN DE INSTALACIÓN BASE - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Con esto nuestro sistema está instalado.
Para poder iniciarlo tenemos que activar el Administrador del sistema 'root'.
Dándole una contraseña y agregar un usuario.
Pues vamos a ello y continuemos."
  pause_function

#CONTRASEÑA ROOT
  write_header "CONTRASEÑA ROOT - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Elegimos una contraseña de administrador 'root'.
    Es una cuenta de superusuario nos provee de todos los privilegios del sistema
    Para entrar en sistema:
    user = root + password"
  echo
  echo -e "${Yellow} Escribe tu contraseña: ${fin}"
  echo
  # Password root
  arch-chroot /mnt passwd
  echo
  pause_function

#CREAR CUENTA DE USUARIO y CONTRASEÑA
  write_header "CREAR CUENTA DE USUARIO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Creamos la cuenta de usuario.
    Es la cuenta que nos da acceso a nuestros archivos, directorios y periféricos del sistema
    Para entrar en sistema:
    usuario + password"
  echo
  echo -e "${Yellow} Escribe tu nombre de usuario: ${fin}"
  echo
  read usuario
  # Crear usuario
  arch-chroot /mnt useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash "$usuario"
  print_info "  Elegimos la contraseña de nuestro usuario.
    Para entrar en sistema:
    user + password" 
  pause_function
  # Contraseña de usuario
  arch-chroot /mnt passwd "$usuario"
  echo
  pause_function

#FIN DE INSTALACION
  write_header "INSTALACION COMPLETADA - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "Se copiará una copia del script Arch1 en el directorio / root de su nuevo sistema"
  pause_function
  echo
  cp -R /root/Arch1 /mnt/root
  echo
  print_info "Desmontando particiones"
  pause_function
  echo
  umount -R /mnt
  echo
  print_info "Reiniciando el sistema"
  pause_function
  # BYE
  echo -e "\n\nBBBBBB  YY    YY EEEEEEE"
  echo        "BB  BBB  YY YY   EE     "
  echo        "BB  BBB   YYY    EE     "
  echo        "BBBBBB    YYY    EEEEEE "
  echo        "BB  BBB   YYY    EE     "
  echo        "BB  BBB   YYY    EE     "
  echo -e     "BBBBBB    YYY    EEEEEEE\n\n"
  sleep 2s
  reboot
