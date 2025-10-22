#!/usr/bin/env bash
set -euo pipefail

PDF="s41559-025-02809-1.pdf"
OUTTXT="analysis/paper.txt"
FIGDIR="assets/figures"
PAGEDIR="assets/pages"

mkdir -p analysis "$FIGDIR" "$PAGEDIR" slides

echo "[1/4] Instalando poppler-utils (pdftotext, pdfimages, pdftoppm)..."
sudo apt-get update -y
sudo apt-get install -y poppler-utils

echo "[2/4] Extrayendo texto a $OUTTXT ..."
pdftotext -layout -nopgbrk -enc UTF-8 -eol unix "$PDF" "$OUTTXT"

echo "[3/4] Extrayendo imágenes incrustadas a $FIGDIR ..."
pdfimages -list "$PDF" > analysis/images_list.tsv || true
pdfimages -png "$PDF" "$FIGDIR/fig" || true

echo "[4/4] Exportando páginas completas a PNG (útil si las figuras son vectoriales) ..."
PAGES=$(pdfinfo "$PDF" | awk '/Pages:/ {print $2}')
pdftoppm -png -r 200 -f 1 -l "$PAGES" "$PDF" "$PAGEDIR/page"

echo "Listo."
echo " - Texto: $OUTTXT"
echo " - Imágenes incrustadas: $FIGDIR (si existían)"
echo " - Páginas como imágenes: $PAGEDIR"
