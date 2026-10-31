#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$APP_DIR/lib/common.sh"

VENV_DIR="$APP_DIR/.venv"
PORT="${PORT:-5000}"

log_info "[1/5] Memeriksa prasyarat..."
require_cmd python3
require_cmd curl
port_is_free "$PORT" || die "port $PORT sudah dipakai proses lain"

log_info "[2/5] Menyiapkan virtual environment..."
python3 -m venv "$VENV_DIR"

log_info "[3/5] Memasang dependensi..."
"$VENV_DIR/bin/pip" install --quiet --upgrade pip
"$VENV_DIR/bin/pip" install --quiet -r "$APP_DIR/requirements.txt"

log_info "[4/5] Menjalankan aplikasi di latar belakang..."
nohup "$VENV_DIR/bin/python" "$APP_DIR/src/app.py" > "$APP_DIR/app.log" 2>&1 &

log_info "[5/5] Memverifikasi layanan..."
sleep 2
if curl -s "http://localhost:$PORT/" | grep -q "status"; then
  log_info "Aplikasi berhasil berjalan di port $PORT!"
else
  die "Gagal memverifikasi aplikasi!"
fi
