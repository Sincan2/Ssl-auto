#!/bin/bash

# Fungsi untuk menampilkan teks berwarna
function print_color() {
    local color_code=$1
    shift
    echo -e "\e[${color_code}m$*\e[0m"
}

# Fungsi untuk membuat tampilan kotak
function draw_box() {
    local width=$((${#1} + 4))
    printf "%${width}s\n" | tr " " "#"
    printf "# %s #\n" "$1"
    printf "%${width}s\n" | tr " " "#"
}

# Fungsi untuk menghitung mundur
function countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "\rMenunggu $seconds detik untuk verifikasi DNS... "
        sleep 1
        ((seconds--))
    done
    echo -e "\rWaktu habis. Lanjutkan proses.               "
}

# Memastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
    print_color 31 "Harap jalankan script sebagai root."
    exit 1
fi

# Menampilkan menu utama
draw_box "Welcome to Free SSL Setup Script for NGINX"
print_color 36 "Pilih opsi berikut:"

options=(
    "Single Domain"
    "Wildcard Domain"
    "Exit"
)

select opt in "${options[@]}"; do
    case $REPLY in
    1)
        draw_box "Single Domain Setup"
        print_color 32 "Masukkan nama domain Anda (contoh: example.com):"
        read DOMAIN

        # Menginstal Certbot jika belum ada
        if ! command -v certbot &>/dev/null; then
            print_color 33 "Certbot tidak ditemukan. Menginstalnya sekarang..."
            apt update
            apt install -y certbot python3-certbot-nginx
        fi

        # Memasang SSL
        certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos --email admin@$DOMAIN

        # Menambahkan cron job
        (crontab -l 2>/dev/null; echo "0 0 * * * certbot renew --quiet") | crontab -

        print_color 32 "SSL berhasil diatur untuk $DOMAIN! Perpanjangan otomatis telah diaktifkan."
        ;;

    2)
        draw_box "Wildcard Domain Setup"
        print_color 32 "Masukkan nama domain utama Anda (contoh: example.com):"
        read DOMAIN

        if ! command -v certbot &>/dev/null; then
            print_color 33 "Certbot tidak ditemukan. Menginstalnya sekarang..."
            apt update
            apt install -y certbot python3-certbot-nginx
        fi

        print_color 36 "Pastikan Anda memiliki akses untuk menambahkan DNS TXT record untuk *.$DOMAIN."

        # Memberi waktu untuk verifikasi DNS
        countdown 120

        # Memasang SSL untuk wildcard dengan otomatisasi
        certbot --nginx -d "$DOMAIN" -d "*.$DOMAIN" --server https://acme-v02.api.letsencrypt.org/directory --agree-tos --email admin@$DOMAIN --manual-public-ip-logging-ok --preferred-challenges dns-01 --manual

        print_color 32 "Wildcard SSL berhasil diatur untuk $DOMAIN! By Sincan2"
        print_color 33 "Ingat: Perpanjangan otomatis telah diaktifkan untuk wildcard domain. By Sincan2"
        ;;

    3)
        print_color 31 "Keluar dari script."
        exit 0
        ;;

    *)
        print_color 31 "Opsi tidak valid. Silakan coba lagi."
        ;;
    esac

done
