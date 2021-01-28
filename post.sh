#!/bin/bash
#version: 0.1
# https://github.com/GumerLuX/arch1.git
#shellcheck disable=SC2162,SC2034,SC2120

#VARIABLES
#checklist=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#es
#Bold=$(tput bold)
Green="\e[0;32m\033[1m"
Red="\e[0;31m\033[1m"
Blue="\e[0;34m\033[1m"
Yellow="\e[0;33m\033[1m"
Cyan="\e[0;36m\033[1m"
Light="\e[96m\033[1m"
Gray="\e[0;37m\033[1m"
fin="\e[0m"
#BGreen=${Bold}${Green}
#Reset=$(tput sgr0)


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

invalid_option(){
    print_line
    echo "Opción inválida. Prueba otro."
    pause_function
}

read_input_options(){
    local line
    local packages
    if [[ $AUTOMATIC_MODE -eq 1 ]]; then
      array=("$1")
    else
      #printf "%s" "$prompt2"
      read -r OPTION
      IFS=' ' read -r -a array <<< "${OPTION}"
    fi
    for line in "${array[@]/,/ }"; do
      if [[ ${line/-/} != "$line" ]]; then
        for ((i=${line%-*}; i<=${line#*-}; i++)); do
          packages+=("$i");
        done
      else
        packages+=("$line")
      fi
    done
    OPTIONS=("${packages[@]}")
}

barra(){
	p(){ c=$(($(tput cols)-3));j=$(($1*c/100)); tput sc;printf "%s [$(for((k=0;k<j;k++));do printf "=";done;)>";tput cuf $((c-j));printf "]";tput rc; };for((i=0; i<=100; i++));do p i;done;echo
}

install_grafica(){
  while true; do  
  write_header "CONFIGURACION DEL SISTEMA GRAFICO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Tenemos 6º opciones para elegir:"
  echo
  echo -e "   1.La${Yellow} Para tarjeta grafica NVIDIA ---propietario ${fin}"
  echo -e "   2.La${Yellow} Para tarjeta grafica NVIDIA ---libre ${fin}"
  echo -e "   3.La${Yellow} Para tarjeta grafica ATI ${fin}"
  echo -e "   4.La${Yellow} Para tarjeta grafica AMD ${fin}"
  echo -e "   5.La${Yellow} Para tarjeta grafica INTEL ${fin}"
  echo -e "   6.La${Yellow} Si utilizamos una Maquina Virtual ${fin}"
  echo
  echo    "   b) Atras"
  echo
  read -p "Introduzca opcion:" op
    if [ "$op" ]; then
      case $op in
        1)
        pacman -S nvidia nvidia-settings
        ;;
        2)
        pacman -S xf86-video-nouveau
        ;;
        3)
        pacman -S xf86-video-ati
        ;;
        4)
        pacman -S xf86-video-amdgpu amd-ucode
        ;;
        5)
        pacman -S xf86-video-intel intel-ucode
        ;;
        6)
        pacman -S virtualbox-guest-utils xf86-video-vmware
        systemctl start vboxservice
        systemctl enable vboxservice
        ;;
        "b")
        break
			  sleep 1
        ;;
        *)
        invalid_option
        ;;
      esac
      break
    fi
  done
}

install_escritorio(){
    while true; do  
  write_header "CONFIGURACION DEL SISTEMA GRAFICO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Tenemos 6º opciones para elegir:"
  echo
  echo -e "   1.Escritorio${Yellow} Xfce ${fin}"
  echo -e "   2.Escritorio${Yellow} Gnome ${fin}"
  echo -e "   3.Escritorio${Yellow} Kde Plasma ${fin}"
  echo -e "   4.Escritorio${Yellow} Cinnamon ${fin}"
  echo
  echo    "   b) Atras"
  echo
  read -p "Introduzca opcion:" op
    if [ "$op" ]; then
      case $op in
        1)
        sudo pacman -S xfce4 xfce4-goodies network-manager-applet
        sudo pacman -S lightdm-gtk-greeter
        systemctl enable lightdm.service
        ;;
        2)
        sudo pacman -S gnome gnome-extra gnome-tweak-tool
        sudo pacman -S gdm
        systemctl enable gdm.service
        ;;
        3)
        sudo pacman -S plasma kde-applications
        sudo pacman -S plasma-wayland-session ffmpegthumbs discover packagekit-qt5
        systemctl enable sddm.service
        ;;
        4)
        sudo pacman -S cinnamon
        sudo pacman -S lightdm-gtk-greeter
        systemctl enable lightdm.service
        ;;
        "b")
        break
			  sleep 1
        ;;
        *)
        invalid_option
        ;;
      esac
      break
    fi
  done
}

#POST INSTALACION MENU
	write_header "Bienvenido al instalador de ${Cyan}ARCHLINUX${fin} Creado por ${Green}GumerLuX${fin} https://gumerlux.github.io/Blog.GumerLuX/"
	print_info  "	Para empezar a utilizar el sistema hay que configurar unos parametos:
	Enpezando por root y luego nuestro usuario.
	"
	pause_function
	
#CONFIGURACION ROOT
select_root(){
  #habilitamos la red
	write_header "CONFIGURACION ROOT - https://gumerlux.github.io/Blog.GumerLuX/"
	print_info "  Havilitamos el NetworkManager para poder tener red:
    Y Actulizamos los repositorios."
	systemctl start NetworkManager.service
	systemctl enable NetworkManager.service
	pacman -Sy
  
	pause_function

  #descomentanos  #%wheel ALL=(ALL) ALL
  write_header "CONFIGURACION ROOT - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Editamos sudoers, descomentanos  #%wheel ALL=(ALL) ALL
  Para poder dar permisos sudo, al usuario."
  sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
  pause_function

  #Instalamos codecs de audio
  write_header "CONFIGURACION ROOT - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Instalamos codecs de audio."
  pacman -Sy pulseaudio pulseaudio-alsa alsa-utils alsa-plugins
  pause_function

  #Instalamos servidor grafico, XORG Y MESA
  write_header "CONFIGURACION ROOT - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Instalamos servidor grafico mesa y la Grafica.
    "
  pacman -Sy xorg xorg-xinit mesa mesa-demos
  # xorg-server xorg-apps xorg-xinit xorg-xkill xorg-xinput xf86-input-libinput
  pause_function

  #Grafica 
  write_header "CONFIGURACION DEL SISTEMA GRAFICO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Tenemos que instalar los drivers de nuestra trajeta.
  Comprovamos la trajeta grafica de nuestro sistema.
  La identificamos y elegimos la que vamos a instalar."
  pause_function
  lspci | grep VGA
  pause_function
  install_grafica

  #FIN DE INSTALACION
  write_header "CONFIGURACION ROOT COMPLETADA - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "Se completo la configuracion de root.
  Salga del script y de root, y entre como usuario, para su configuracion."
  print_line
  print_info "Se copiará una copia del script Arch1 en el directorio / home/user de su nuevo sistema"
  pause_function
  echo
  cp -R /root/Arch1 ~/Arch1
  echo
  print_info "Saliendo del script"
  return
}

#CONFIGURACION USUARIO
	select_user(){
	write_header "CONFIGURACION USUARIO - https://gumerlux.github.io/Blog.GumerLuX/"
	print_info "  Bienvenido a la configuracion de usuario:
  Estos son los parametros que vamos a utilizar."
  echo
  echo -e   1- Activando el NetworkManager y actualizando sistema.
  echo -e   2- Ponemos el teclado en español
  echo -e   3- Elegimos los mirrors mas rapidos de ArchLinux
  echo -e   4- Instalando Elementos basicos, utilidades.
  echo -e   5- Instalacion de AURHelper y configurar color.
  echo -e   6- Instalando el entorno grafico "'escritorio'"
  echo
	pause_function

  #NetworkManager
  write_header " 1 - HAVILITAMOS EL NETWORKMANAGER - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Havilitamos el NetworkManager:
  Y Actualizamos el sistema. Activamos sudo por primera vez"
  pause_function
  systemctl enable NetworkManager.service
  sudo pacman -Syyu --noconfirm

  #Teclado
  write_header "2 - CONFIGURACION TECLADO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Fijamos el teclado en el sistema."
  pause_function
  localectl set-x11-keymap es

  #Mirrorlist
  write_header "3 - ACTULIZACION MIRRORS - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info  "  Elegimos los mirrors mas rapidos de ArchLinux:
  Primero hacemos una copia de seguridad. Instalamos el programa reflector"
  pause_function
  sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  sudo pacman -S reflector --noconfirm
  sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
  sudo pacman -Syy --noconfirm

    # Elementos basicos de Bash y utilidades
  write_header "4 - ELEMENTOS BASICOS BASH - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info  " Bash es el shell de linea de comandos:
  Añadiremos unos programas necesarios para su utilizacion.
  Utilidades de bash, compresion, DNS, disco 'NTFS/EXT."
  sudo pacman -Sy bc rsync mlocate bash-completion pkgstats arch-wiki-lite zip unzip unrar p7zip lzop cpio avahi nss-mdns dosfstools exfat-utils f2fs-tools fuse fuse-exfat autofs mtpfs --noconfirm
  system_ctl enable avahi-daemon.service
  timedatectl set-ntp true

  #AURhelper
  write_header "5 - INSTALACION DE AUR-HELPER - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Instalamos 'yay', programa para instalar en pacman desde nuestro usuario,
  sin necesidad de tener permiso de sudo."
  pause_function
  sudo pacman -S git --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si --noconfirm

  # Configuracion de Pacman, color y ponemos el comococos en la barra
  write_header "5.A - CONFIGURACION DE PACMAN - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info " Tenemos que modificar, el archivo ${Gray}/etc/pacman.conf${fin}"
  print_info " Descomentamos el hastag de la linea #Color del archivo ${Gray}/etc/pacman.conf${fin}  
    Añadimos al final del grupo color ${Gray}ILoveCandy${fin}, las letras 'ILC' son mayusculas.
    Desmarcamos las casillas de:
        [multilib]
        include /ete/pacman.d/mirrorlist"
  pause_function
  cp /etc/pacman.con /etc/pacman.conf.olg
  sudo sed -i "37i ILoveCandy" /etc/pacman.conf
  sudo sed -i "/Color/s/^#//g" /etc/pacman.conf
  sudo sed -i "93i \Include = /etc/pacman.d/mirrorlist" /etc/pacman.conf

  # Dar color a nano
  write_header "4.B - PONEMOS COLOR A NANO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Configuramos 'nano' tanto para nuestro usuario como para root"
  pause_function
  sudo sed -i '/*.nanorc/s/^#//g' /etc/nanorc
  sudo sed -i '/set linenumbers/s/^#//g' /etc/nanorc

  # Instalando el entorno grafico "escritorio"
  write_header "6 - INSTALAMOS EL ESCRITORIO - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info  " En Linux tenemos muchos entornos graficos:
  En este escript solo mostrare estos cuatro,'xfce, gnome, Plasma, cinnamon'.
  Escoge uno para la instalacion."
  install_escritorio

  #FIN DE INSTALACION
  write_header "CONFIGURACION USUARIO COMPLETADA - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Se completo la configuracion del usuaro.
  Salga del script y reinicie el sistema. Entre como usuario, para iniciar su configuracion."
  print_line
  print_info "  Ctrl + C para salir del script y volver al Bash.
  Enter para reiniciar el sistema"
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

}

while true; do
  write_header "MENU PRINCIPAL - https://gumerlux.github.io/Blog.GumerLuX/"
  print_info "  Elige una opcion para empezar la configuracion"
  echo " 1) "Configuración root" "
  echo " 2) "Configuración usario" "
  echo ""
  echo " d) Salir"
  echo ""
  read_input_options
  for OPT in "${OPTIONS[@]}"; do
    case "$OPT" in
    1)
      select_root
      ;;
    2)
      select_user
      ;;
    "d")
			write_header "GRACIAS por usar la configuracion https://gumerlux.github.io/Blog.GumerLuX/"
			sleep 1
      exit 1
      ;;
    *)
      invalid_option
      ;;
    esac
  done
done
