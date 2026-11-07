# Animasyon Dizileri Arşivi

Animasyon dizilerini kaydetmek, aramak, güncellemek ve silmek için geliştirilmiş bir web uygulaması. Arka planda PostgreSQL veritabanı, arayüzde Python (Flask) kullanılmıştır. Veritabanı Yönetim Sistemleri dersi kapsamında hazırlanmıştır.


## Özellikler

- Dizileri tablo halinde listeleme ve isme göre arama
- Yeni dizi ekleme, mevcut diziyi güncelleme ve silme
- Hatalı veri girişine karşı iki katmanlı kontrol:
  - **Uygulama tarafında** (`trigger.py`): boş isim, IMDb puanı aralığı, yıl kontrolü, bitiş yılının başlangıçtan önce olmaması, negatif sezon/bölüm sayısı, aynı isimli dizi
  - **Veritabanı tarafında** (tetikleyiciler): IMDb puanının 0–10 arasında olması, yayın yılının gelecekte olmaması, aynı isimli dizinin tekrar eklenmemesi, dizi adının otomatik olarak düzgün biçimlendirilmesi

## Veritabanı Tasarımı

- 17 tablodan oluşan ilişkisel şema (birincil ve yabancı anahtarlar ile)
- Diziler ile tür, teknik, platform ve ödüller arasındaki çoktan-çoğa ilişkiler için ara tablolar
- Yönetmen, senarist ve seslendirmen rolleri ortak bir `Kisiler` tablosu üzerinden modellenmiştir
- Ekleme, güncelleme ve silme işlemleri PL/pgSQL saklı fonksiyonları (`DiziEkle`, `DiziGuncelle`, `DiziSil`) ile yapılır
- SQL sorgularında parametreli sorgu kullanılmıştır (SQL enjeksiyonuna karşı)

## Kullanılan Teknolojiler

- PostgreSQL 18, PL/pgSQL
- Python, Flask, psycopg2
- HTML, CSS (Jinja2 şablonları)

## Kurulum ve Çalıştırma

1. Gerekli Python paketlerini kurun:
   ```
   pip install -r requirements.txt
   ```
2. PostgreSQL'de `AnimasyonDiziVerileri` adında boş bir veritabanı oluşturun ve yedek dosyasını yükleyin:
   ```
   psql -U postgres -d AnimasyonDiziVerileri -f veritabani.sql
   ```
   (Yedek PostgreSQL 18 ile alınmıştır. Başta çıkan "schema public already exists" uyarısı önemsizdir.)
3. Veritabanı şifrenizi ortam değişkeni olarak tanımlayın (Windows PowerShell):
   ```
   $env:DB_PASSWORD="sifreniz"
   ```
4. Uygulamayı başlatın ve tarayıcıda `http://127.0.0.1:5000` adresini açın:
   ```
   python app.py
   ```

## Proje Yapısı

| Dosya | Açıklama |
|---|---|
| `app.py` | Flask uygulaması ve sayfa yönlendirmeleri |
| `fonklarvs.py` | Veritabanı bağlantısı ve sorgu fonksiyonları |
| `trigger.py` | Uygulama tarafındaki veri doğrulama |
| `templates/` | Liste ve form sayfalarının HTML şablonları |
| `veritabani.sql` | Tablolar, fonksiyonlar, tetikleyiciler ve örnek veriler |

## Geliştirilebilecekler

- Tür, platform, ödül ve yönetmen bilgileri şu an ana tabloda metin olarak da tutuluyor. Arayüzün bu bilgileri doğrudan ara tablolardan okuyup yazması, şemadaki normalizasyonu tam olarak kullanmasını sağlar.
- Karakter, sezon ve seslendirmen tabloları için arayüz sayfaları eklenebilir.
