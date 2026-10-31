# Blameless Postmortem - Insiden Kegagalan Deployment Manual

## Ringkasan Insiden
Pada pelaksanaan deployment aplikasi Flask di JOB 2, proses deployment dilakukan secara manual melalui instruksi HANDOVER.md. Terjadi kegagalan sistem akibat ketiadaan isolasi virtual environment, ketidaklengkapan berkas dependensi requirements.txt, dan instruksi manual yang ambigu. Hal ini menyebabkan aplikasi gagal berjalan (crash) di lingkungan Operations dan membutuhkan waktu troubleshooting yang lama.

## Kronologi (timeline)
- T+00:00 - Developer menyelesaikan kode dan menyerahkan folder serah-terima tanpa requirements.txt.
- T+05:00 - Operations mencoba menjalankan aplikasi di lingkungan bersih dan mengalami error 'ModuleNotFoundError: No module named flask'.
- T+12:00 - Operations melakukan troubleshooting manual dan menginstal paket di tingkat sistem global.
- T+25:00 - Aplikasi berhasil dijalankan setelah dilakukan penyesuaian lingkungan secara berulang.
- T+40:00 - Tim melakukan refactoring pada JOB 4 dengan membuat skrip otomasi setup.sh.
- T+42:00 - Aplikasi berhasil di-deploy dan lulus smoke test/health check secara otomatis dalam kurun waktu kurang dari 1 menit.

## Dampak (waktu terbuang, jumlah kegagalan)
- Waktu Terbuang: Lead time deployment manual membengkak hingga 20-25 menit.
- Jumlah Kegagalan: Terjadi 3 kali percobaan eksekusi yang gagal akibat error dependensi dan konfigurasi.
- Produktivitas: Munculnya hambatan komunikasi (Wall of Confusion) antara Developer dan Operations.

## Akar Masalah pada SISTEM (bukan pada orang)
1. Ketiadaan Standarisasi Otomasi: Tidak adanya skrip tunggal yang mengeksekusi penyiapan environment secara repeatable.
2. Isolasi Lingkungan Tidak Terjamin: Bergantung pada Python global dan tidak diwajibkannya penggunaan Virtual Environment (.venv).
3. Manajemen Dependensi Rentan: Berkas manifest dependensi (requirements.txt) tidak terikat secara otomatis pada artefak serah-terima.

## Tindakan Perbaikan (action items) + penanggung jawab peran
1. Membuat skrip otomasi 'setup.sh' yang menangani isolasi environment, instalasi dependensi terkunci, dan health check otomatis. (Penanggung Jawab: Dev)
2. Menambahkan berkas '.gitignore' untuk mencegah kebocoran berkas rahasia dan venv ke repository. (Penanggung Jawab: Dev)
3. Menerapkan papan kerja (Board) berbasis DevOps Flow dengan batasan WIP untuk meningkatkan visibilitas aliran kerja. (Penanggung Jawab: Ops)
4. Menggunakan repository private GitHub dan menambahkan kolaborator untuk transparansi kode. (Penanggung Jawab: Ops)

## Pelajaran yang Diambil
1. Prosedur manual yang bergantung pada dokumentasi teks (HANDOVER.md) sangat rentan terhadap human error.
2. Otomatisasi (Automation) dan isolasi sistem merupakan kunci utama dalam memangkas Lead Time dan menekan Change Failure Rate.
3. Pendekatan Blameless Postmortem membantu tim berfokus pada perbaikan kelemahan sistem daripada menyalahkan individu.
