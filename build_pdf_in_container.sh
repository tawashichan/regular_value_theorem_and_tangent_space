#!/usr/bin/env sh
set -eu

TEX_FILE="${1:-main.tex}"
IMAGE_NAME="${IMAGE_NAME:-regular-value-tex}"

if [ ! -f "$TEX_FILE" ]; then
  echo "TeX file not found: $TEX_FILE" >&2
  exit 1
fi

case "$TEX_FILE" in
  */*) TEX_DIR="${TEX_FILE%/*}" ;;
  *) TEX_DIR="." ;;
esac

TEX_NAME="${TEX_FILE##*/}"
case "$TEX_NAME" in
  *.tex) BASE_NAME="${TEX_NAME%.tex}" ;;
  *) BASE_NAME="$TEX_NAME" ;;
esac

if [ "${REBUILD_IMAGE:-0}" = "1" ] || ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  docker build -t "$IMAGE_NAME" .
fi

docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  "$IMAGE_NAME" \
  sh -c '
    set -eu
    tex_dir="$1"
    tex_name="$2"
    base_name="$3"

    cd "$tex_dir"
    uplatex -kanji=utf8 -interaction=nonstopmode -halt-on-error "$tex_name"
    uplatex -kanji=utf8 -interaction=nonstopmode -halt-on-error "$tex_name"
    dvipdfmx "${base_name}.dvi"
  ' sh "$TEX_DIR" "$TEX_NAME" "$BASE_NAME"

echo "Generated ${TEX_DIR}/${BASE_NAME}.pdf"
