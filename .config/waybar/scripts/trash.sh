#!/bin/bash

if [[ -z "${TRASH_DIR}" ]]; then
  notify CRITICAL "  ERROR" "\${TRASH_DIR} not set in your environment!"
  exit
fi

trash_icon=""
trash_num_files=$(find "${TRASH_DIR}" -type f | wc -l)
trash_size=$(du -hs "${TRASH_DIR}" | cut -f 1)

if [ -z "$(ls -A ${TRASH_DIR})" ]; then
  # Trash is empty
  trash_size="-"
fi

function trash_info() {
  local waybar_text="${trash_icon} ${trash_size}"

  if [[ "${trash_size}" == "-" ]]; then
    local waybar_tooltip="Nothing to see here :)"
  else
    local waybar_tooltip="There are <span color='turquoise'>${trash_num_files}</span> files in the trash totaling <span color='turquoise'>${trash_size}</span>\n\nTrash is located at ${TRASH_DIR}\n(click to open, right click to clear)"
  fi

  echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\"}"
}

function trash_clear() {
  if [[ "${trash_size}" == "-" ]]; then
    notify GOOD "${trash_icon}  Trash is empty" "Nothing to see here :)"
    exit
  fi

  # Would you like to clear the trash?
  notify NORMAL "${trash_icon}  Would you like to permanently clear the trash?" "There are ${trash_num_files} files totaling ${trash_size}"

  yn=$(printf 'Yes\nNo' | fuzzel --dmenu --prompt "Really delete ${trash_num_files} files? ")

  case "${yn}" in
    Yes)
    ;;

    *)
      notify CRITICAL "  Aborted" "Not clearing the trash..."
      exit
    ;;
  esac

  # Clear the trash
  notify NORMAL "${trash_icon}  Clearing the trash, please wait..."

  # Clear normal and hidden files
  rm -rf ${TRASH_DIR}/*
  rm -rf ${TRASH_DIR}/.*

  notify GOOD "${trash_icon}  Trash cleared!" "Freed ${trash_size} of disk space"
}

function trash_open() {
  notify NORMAL "${trash_icon}  Opening the trash..."

  ${FILE_BROWSER} ${TRASH_DIR}
}

if [[ "$1" == "info" ]]; then
  trash_info
elif [[ "$1" == "clear" ]]; then
  trash_clear
elif [[ "$1" == "open" ]]; then
  trash_open
else
  # Invalid argument passed
  echo "Usage: trash.sh [info,clear,open]"
  exit
fi

