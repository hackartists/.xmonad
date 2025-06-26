#!/bin/bash

INBOX_FILE="$HOME/data/devel/github.com/hackartists/notes/todo.org"
TODAY=$(date "+%Y-%m-%d %a")

parse_todos() {
  mapfile -t todo_lines < <(grep -n '^\*\* TODO' "$INBOX_FILE")
  choices=()
  line_numbers=()

  for entry in "${todo_lines[@]}"; do
    lineno="${entry%%:*}"
    content="${entry#** TODO }"
    content="${content#*:}"
    line_numbers+=("$lineno")
    choices+=("${content}")
  done
}

get_user_selection() {
  selected=$(printf "%s\n" "${choices[@]}" | rofi -dmenu -p "TODOs" -mesg "Enter new or select existing:")
}

mark_todo_as_done() {
  lineno="${line_numbers[$1]}"
  awk -v line="$lineno" -v text="${choices[$1]}" '
    NR == line { print "** DONE " text; next }
    { print }
  ' "$INBOX_FILE" > "$INBOX_FILE.tmp" && mv "$INBOX_FILE.tmp" "$INBOX_FILE"
}

append_new_todo() {
  echo -e "\n** TODO $selected\n:PROPERTIES:\n:CREATED: [$TODAY]\n:END:\n" >> "$INBOX_FILE"
}

main() {
    parse_todos
    get_user_selection

    [[ -z "$selected" ]] && exit 0

    for i in "${!choices[@]}"; do
        if [[ "${choices[$i]}" == "$selected" ]]; then
            mark_todo_as_done "$i"
            exit 0
        fi
    done

    append_new_todo
}

main
