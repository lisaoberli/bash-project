#!/bin/bash
set -euo pipefail
IFS=$'\n\t

while true; do
echo "============================"
    echo "   Git-Helfer Menü"
    echo "============================"
    echo "1) Status anzeigen"
    echo "2) Änderungen hinzufügen (git add .)"
    echo "3) Commit erstellen"
    echo "4) Push zu Remote"
    echo "5) Pull von Remote"
    echo "6) Branches anzeigen"
    echo "7) Branch wechseln"
    echo "8) Neues Branch erstellen"
    echo "9) Beenden"
    echo "============================"
    read -p "Wähle eine Option: " choice

    case $choice in
        1)
            git status
            ;;
        2)
            git add .
            echo "Alle Änderungen hinzugefügt!"
            ;;
        3)
            read -p "Commit-Nachricht: " msg
            git commit -m "$msg"
            ;;
        4)
            git push
            ;;
        5)
            git pull
            ;;
        6)
            git branch
            ;;
        7)
            read -p "Branch-Name: " branch
            git checkout "$branch"
            ;;
        8)
            read -p "Neuer Branch-Name: " newbranch
            git checkout -b "$newbranch"
            ;;
        9)
            echo "Tschüss 👋"
            break
            ;;
        *)
            echo "Ungültige Eingabe!"
            ;;
    esac
    echo
done