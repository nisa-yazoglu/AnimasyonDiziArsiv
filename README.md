# Animasyon Dizi Arşivi

Veritabanı Yönetim Sistemleri dersi için yaptığım proje. Animasyon dizilerini listeleyip arayabildiğin, yeni dizi ekleyip düzenleyebildiğin ve silebildiğin basit bir web uygulaması. Veritabanı PostgreSQL'de, arayüz Python ve Flask ile yazıldı.

## Neler var

Veritabanında 17 tablo var. Ana tablo AnimasyonDizileri. Türler, teknikler, platformlar ve ödüller ayrı tablolarda tutuluyor ve ara tablolarla dizilere bağlanıyor. Yönetmen, senarist ve seslendirmenler için ortak bir Kisiler tablosu kullandım.

Ekleme, güncelleme ve silme işlemleri PostgreSQL'de yazdığım fonksiyonlar üzerinden yapılıyor (DiziEkle, DiziGuncelle, DiziSil). Tabloda birkaç trigger da var: IMDb puanı 0-10 arasında değilse, yayın yılı gelecekteyse ya da aynı isimde bir dizi zaten varsa kayıt eklenmiyor. Dizi adlarının her kelimesinin baş harfi de kaydedilirken otomatik olarak büyütülüyor.

Bu kontrollerin bir kısmını formdan gelen veri için Python tarafında da yaptım (trigger.py), böylece hata mesajı direkt sayfada görünüyor.

## Çalıştırmak için

PostgreSQL ve Python kurulu olmalı.

1. `AnimasyonDiziVerileri` adında bir veritabanı oluştur ve `veritabani.sql` dosyasını içine yükle:
   ```
   psql -U postgres -d AnimasyonDiziVerileri -f veritabani.sql
   ```
   Yedek PostgreSQL 18 ile alındı, eski sürümlerde sorun çıkabilir.
2. Paketleri kur:
   ```
   pip install -r requirements.txt
   ```
3. Veritabanı şifresini ortam değişkeni olarak ver ve uygulamayı başlat (PowerShell):
   ```
   $env:DB_PASSWORD="sifren"
   python app.py
   ```
4. Tarayıcıda 'http://127.0.0.1:5000' adresini aç.

## Dosyalar

- `app.py`: Flask uygulaması, sayfalar burada
- `fonklarvs.py`: veritabanı bağlantısı ve sorgular
- `trigger.py`: formdan gelen verinin kontrolü
- `templates/`: HTML sayfaları
- `veritabani.sql`: veritabanı yedeği (tablolar, fonksiyonlar, triggerlar ve örnek veriler)

## Eksikler

Tür, platform, ödül ve yönetmen için ara tablolar olsa da arayüz bu bilgileri hâlâ ana tablodaki metin alanlarından okuyor. Ara tablolar şu an sadece Arcane için dolu. Karakter, sezon ve seslendirmen tabloları için de arayüzde henüz bir sayfa yok.
