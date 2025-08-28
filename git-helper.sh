#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Mini-Helpers
ok()   { echo "[✓] $*"; }
warn() { echo "[!] $*" >&2; }
die()  { echo "[x] $*" >&2; exit 1; }

trap 'echo; echo "Tschüss"; exit 0' INT

# Grundchecks
command -v git >/dev/null 2>&1 || die "git ist nicht installiert."
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "Nicht in einem Git-Repository."

# (Optional) kleine Helfer
current_branch(){ git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(detached)"; }
has_upstream(){ git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; }
default_remote(){ git remote 2>/dev/null | head -n1 || true; }

while true; do
  echo "============================"
  echo "   Git-Helfer Menü  (Branch: $(current_branch))"
  echo "============================"
  echo "1) Status anzeigen"
  echo "2) Änderungen hinzufügen (git add -A)"
  echo "3) Commit erstellen"
  echo "4) Push zu Remote"
  echo "5) Pull von Remote"
  echo "6) Branches anzeigen"
  echo "7) Branch wechseln"
  echo "8) Neues Branch erstellen"
  echo "9) Stash erstellen"
  echo "10) Beenden"
  echo "============================"
  read -r -p "Wähle eine Option: " choice

  case "$choice" in
    1)
      git -c color.status=always status
      ;;
    2)
      git add -A
      ok "Alle Änderungen hinzugefügt."
      ;;
    3)
      # --- Identity-Check before commit
      name="$(git config user.name || true)"
      email="$(git config user.email || true)"
      if [[ -z "$name" || -z "$email" ]]; then
        echo "[*] Git-Identität ist nicht gesetzt."
        read -r -p "Name: " name
        read -r -p "E-Mail: " email
        git config user.name  "$name"
        git config user.email "$email"
        ok "Lokale Git-Identität gesetzt."
      fi

      read -r -p "Commit-Nachricht: " msg
      [[ -n "$msg" ]] || { warn "Leere Commit-Nachricht – abgebrochen."; continue; }
      git commit -m "$msg" && ok "Commit erstellt."
      ;;
    4)
      git push
      ;;
    5)
      git pull --ff-only && ok "Pull ok (fast-forward)."
      ;;
    6)
      git branch
      ;;
    7)
      read -r -p "Branch-Name: " branch
      [[ -n "$branch" ]] || { warn "Kein Branch angegeben."; continue; }
      git switch "$branch"
      ;;
    8)
      read -r -p "Neuer Branch-Name: " newbranch
      [[ -n "$newbranch" ]] || { warn "Kein Name angegeben."; continue; }
      git switch -c "$newbranch"
      ;;
    9)
      git stash push -u -m "helper $(date +%F_%T)"
      ok "Stash erstellt."
      ;;
    10)
      echo "Tschüss"
      break
      ;;
    *)
      echo "Ungültige Eingabe!"
      ;;
  esac
  echo
done
