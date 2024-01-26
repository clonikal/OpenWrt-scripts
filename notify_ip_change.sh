#!/bin/sh

# Script que almacena la IP actual en un archivo temporal y en caso de que cambie manda una notificacion por Telegram
# Para crear un bot visita https://telegram.org/faq#p-como-creo-un-bot

# Edita GROUP_ID y BOT_TOKEN con los datos de tu bot
GROUP_ID=-0123456789012 
BOT_TOKEN=0123456789:ABCDEFGHIJKLMNIOPQRSTUVWXYZ

# Crea el fichero /tmp/currentip si no existe
[[ -f /tmp/currentip ]] || touch /tmp/currentip

# Comprueba si hay cambio de IP y manda mensaje en caso afirmativo
current_ip=`wget -qO- http://ipecho.net/plain`
old_ip=`cat /tmp/currentip`

if [ "$current_ip" != "$old_ip" ]; then
  # Grabo en log el cambio de IP. Comenta la siguiente linea si no lo necesitas
  echo `date +"[%F %T]"` "La nueva IP es: $current_ip" >> /tmp/log/notify_ip.log
  # Notifico por Telegram
  EMOJI=$'\xE2\x9A\xA0' # Simbolo de warning
  MESSAGE="${EMOJI} <b>Cambio de IP</b>%0A`date +"[%F %T]"` La nueva IP es: <i>$current_ip</i>"
  curl -s \
  --data "parse_mode=HTML" \
  --data "text=$MESSAGE" \
  --data "chat_id="$GROUP_ID 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
  echo $current_ip>/tmp/currentip # Actualizo el archivo con la IP actual
else
  # Grabo en log para saber que esta funcionando. Comenta la siguiente linea si no lo necesitas
  echo `date +"[%F %T]"` "IP Actual: $current_ip" >> /tmp/log/notify_ip.log
fi
