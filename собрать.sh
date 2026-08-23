#!/bin/bash
# Собирает сайт tawhiid.com в папку site/:
#   site/index.html   — главная (пишется руками, лежит в главная/)
#   site/ilm/         — база знаний, собранная Quartz из вольта
# В базу знаний попадают только заметки с `publish: true` — плагин explicit-publish.
#
# Генератор (quartz/) в репозитории не хранится, он ставится один раз:
#   git clone --depth 1 https://github.com/jackyzha0/quartz.git quartz && (cd quartz && npm install)
set -e
vault="$HOME/obsid/alqasawi/Ислам"
root="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$root/quartz/node_modules" ]; then
  echo "Нет quartz/ — поставь генератор, как написано в шапке скрипта." >&2
  exit 1
fi

# 1. наша настройка поверх генератора
cp "$root/quartz.config.yaml" "$root/quartz/quartz.config.yaml"

# 2. заметки из вольта -> content
rsync -a --delete --exclude '.obsidian' "$vault/" "$root/quartz/content/Ислам/"
cp "$root/главная-базы.md" "$root/quartz/content/index.md"

# 3. сборка Quartz прямо в site/ilm
cd "$root/quartz"
npx quartz build -o "$root/site/ilm"

# 4. главная страница и .htaccess поверх
cp -a "$root/главная/." "$root/site/"

echo "Готово: $root/site"
