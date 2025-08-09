# Caffex Firebase ☕️🔥

Caffex, Flutter ve Firebase kullanılarak geliştirilmiş bir mobil kahve sipariş uygulamasıdır. Kullanıcı girişi, ürün listeleme, sepete ekleme ve sipariş yönetimi gibi temel e-ticaret işlevlerini içerir.

## 🚀 Özellikler

- Kullanıcı kayıt ve giriş (E-posta/Şifre, Google ile giriş)
- Firebase Authentication entegrasyonu
- Gerçek zamanlı kahve ürünleri listesi (Firestore üzerinden)
- Sepete ürün ekleme / çıkarma işlemleri
- Sipariş onay akışı
- Temiz ve duyarlı arayüz tasarımı
- Firebase Cloud Firestore ve Hosting yapılandırması

## 📦 Teknolojiler

- Flutter (Dart)
- Firebase Authentication
- Firebase Firestore
- Provider veya Riverpod (durum yönetimi)
- Firebase Storage (görseller için)

## 📱 Platform

Şu anda sadece **Android** için geliştirilmekte ve test edilmektedir.

## 📌 Amaç

Bu uygulama, **Firebase backend kullanılarak** uçtan uca mobil uygulama geliştirme pratiği yapmak amacıyla hazırlanmıştır. Kahve dükkanları veya benzeri sipariş uygulamaları için başlangıç şablonu olarak kullanılabilir.

## ⚙️ Kurulum Talimatları

1. Depoyu klonlayın:

- git clone https://github.com/olmezarda/caffex-firebase.git
- cd repository 

2. Bağımlılıkları yükleyin

- flutter pub get

3. Firebase yapılandırması:

- Firebase Console üzerinden bir proje oluşturun.
- Android uygulamanızı paket adı ile (örneğin com.example.caffex) ekleyin.
- google-services.json dosyasını indirip android/app/ klasörüne koyun.

4. Uygulamayı Android cihazda veya emülatörde çalıştırın:

- flutter run

## 📬 İletişim

Eğer bu proje hakkında herhangi bir sorunuz ya da öneriniz varsa, benimle iletişime geçebilirsiniz:

**E-posta:** olm.zarda@gmail.com
