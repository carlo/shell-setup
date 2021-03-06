#!/usr/local/bin/bash

for CFG in \
  fish/config.fish \
  peco/config.json \
; do
  echo "Creating symlink: configs/${CFG} ➔ ~/.config/${CFG}"
  LINKED_FILE="${HOME}/.config/${CFG}"
  DIR_NAME=$(dirname "${LINKED_FILE}")
  [[ ! -d "${DIR_NAME}" ]] && mkdir -p "${DIR_NAME}"
  [[ -h "${LINKED_FILE}" || -e "${LINKED_FILE}" ]] && mv "${LINKED_FILE}" "${LINKED_FILE}.old"
  ln -s "$(pwd)/configs/${CFG}" "${LINKED_FILE}"
done

# Symlinking dotfiles
for F in dotfiles/.*; do
  if [[ -f "$F" ]]; then
    LINKED_FILE="${HOME}/$( basename ${F} )"
    echo "Creating symlink: ${F} ➔ ${LINKED_FILE}"
    [[ -h "${LINKED_FILE}" || -e "${LINKED_FILE}" ]] && mv "${LINKED_FILE}" "${LINKED_FILE}.old"
    ln -s "$(pwd)/${F}" "${LINKED_FILE}"
  fi
done
