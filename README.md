# SafeMessageShield 📱

iOS için SMS Filtreleme ve Telefon Engelleme Uygulaması

## 🎯 Özellikler

- ✅ **SMS Filtreleme**: İstenmeyen SMS'leri otomatik olarak filtreler
- ✅ **Numara Engelleme**: Belirtilen numaralardan gelen aramaları ve mesajları engeller
- ✅ **Kara Liste Yönetimi**: Kolayca numara ekle/çıkar
- ✅ **Gizlilik Odaklı**: Tüm veriler cihazda saklanır, sunucuya hiçbir veri gönderilmez
- ✅ **Akıllı Filtreleme**: AI bazlı spam tespiti (cihaz içi)
- ✅ **Transaction Koruması**: Banka, OTP gibi önemli mesajları korur

## 🏗️ Mimari

### Bileşenler

1. **Ana Uygulama (SafeMessageShield)**
   - SwiftUI tabanlı modern arayüz
   - SwiftData ile veri yönetimi
   - Kara liste düzenleme
   - Ayarlar ve yönlendirmeler

2. **Message Filter Extension**
   - Framework: `IdentityLookup`
   - Gelen SMS'leri filtreler
   - Spam ve promosyon tespiti
   - Transaction mesajlarını korur

3. **Call Directory Extension**
   - Framework: `CallKit`
   - Engellenen numaraları sisteme bildirir
   - Çağrı ve mesaj bildirimlerini engeller

4. **Paylaşılan Veri (App Group)**
   - ID: `group.tsavasci.SafeMessageShield`
   - Ana uygulama ve extension'lar arasında veri paylaşımı

## 📋 Gereksinimler

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Fiziksel iOS cihaz (Simulator'da SMS filtreleme test edilemez)

## 🚀 Kurulum

### 1. Proje Ayarları

```bash
git clone [repository-url]
cd SafeMessageShield
open SafeMessageShield.xcodeproj
```

### 2. Bundle ID'leri Ayarlayın

Xcode'da her target için bundle ID'leri düzenleyin:
- Ana App: `tsavasci.SafeMessageShield`
- Message Filter: `tsavasci.SafeMessageShield.MessageFilterExtension`
- Call Directory: `tsavasci.SafeMessageShield.CallDirectoryExtension`

### 3. Capabilities Ekleyin

Her target için (Ana App, Message Filter, Call Directory):
1. Signing & Capabilities sekmesine gidin
2. "+ Capability" tıklayın
3. "App Groups" ekleyin
4. Container olarak `group.tsavasci.SafeMessageShield` ekleyin

### 4. Extension Target'larını Oluşturun

#### Message Filter Extension:
1. File > New > Target
2. iOS > Message Filter Extension seçin
3. Product Name: `MessageFilterExtension`
4. `MessageFilterExtension.swift` dosyasını kullanın

#### Call Directory Extension:
1. File > New > Target
2. iOS > Call Directory Extension seçin
3. Product Name: `CallDirectoryExtension`
4. `CallDirectoryHandler.swift` dosyasını kullanın

### 5. Derleyin ve Çalıştırın

```bash
# Ana uygulamayı derle
⌘ + B

# Fiziksel cihazda çalıştır
⌘ + R
```

## 📱 Kullanım

### İlk Kurulum

1. Uygulamayı açın
2. Ayarlar sekmesine gidin
3. "SMS Filtreleme" için:
   - **Ayarlar > Mesajlar > Bilinmeyen & İstenmeyen**
   - SafeMessageShield'i etkinleştirin

4. "Telefon Engelleme" için:
   - **Ayarlar > Telefon > Engelleme ve Kimlik Tanımlama**
   - SafeMessageShield'i etkinleştirin

### Numara Engelleme

1. Ana ekranda "+" butonuna tıklayın
2. Telefon numarasını girin (örn: +905551234567)
3. Opsiyonel bir sebep ekleyin
4. "Numarayı Engelle" butonuna tıklayın

### Filtreleme Nasıl Çalışır?

**Otomatik Spam Tespiti:**
- Kampanya, hediye, kazandınız gibi kelimeler içeren mesajlar
- Şüpheli linkler içeren mesajlar
- Promosyon karakteristiği taşıyan mesajlar

**Korunan Mesajlar:**
- Banka bildirimleri
- OTP kodları
- Doğrulama mesajları
- Güvenlik kodları

## 🔒 Gizlilik

- ❌ Mesaj içeriği hiçbir sunucuya gönderilmez
- ✅ Tüm filtreleme cihaz içinde yapılır
- ✅ Veriler yalnızca cihazda saklanır
- ✅ iCloud senkronizasyonu YOK
- ✅ Analytics YOK
- ✅ Tracking YOK

## 🧪 Test

### Manuel Test Senaryoları

1. **Spam Mesajı Testi**
   - Başka bir telefondan spam içerikli mesaj gönderin
   - Mesaj "Junk" klasörüne düşmeli
   - Bildirim gelmemeli

2. **Engellenen Numara Testi**
   - Bir numarayı engelleyin
   - O numaradan mesaj gönderin
   - Mesaj görünmemeli veya Junk'a düşmeli

3. **Normal Mesaj Testi**
   - Normal bir mesaj gönderin
   - Mesaj normal gelmeli
   - Bildirim almalısınız

### Debug

Console.app kullanarak log takibi:
```bash
# Message Filter logs
log stream --predicate 'process == "identitylookupd"'

# Call Directory logs
log stream --predicate 'process == "callservicesd"'
```

## 🐛 Bilinen Sorunlar ve Çözümler

### "Extension çalışmıyor"
- iOS Ayarlar'dan extension'ları etkinleştirdiğinizden emin olun
- Cihazı yeniden başlatın
- Extension'ları devre dışı bırakıp tekrar etkinleştirin

### "Mesajlar filtrelenmiyor"
- Extension'ın App Group erişimi olduğunu kontrol edin
- Entitlements dosyasında App Group'un doğru olduğunu kontrol edin
- Console.app'te hata loglarını kontrol edin

### "Numaralar engellenmiyor"
- Call Directory Extension'ın etkinleştirildiğinden emin olun
- Ayarlar > Telefon > Engelleme ve Kimlik Tanımlama
- Extension'ı devre dışı bırakıp tekrar etkinleştirin

## 📚 Kullanılan Teknolojiler

- **SwiftUI**: Modern UI framework
- **SwiftData**: Veri yönetimi
- **IdentityLookup**: SMS filtreleme
- **CallKit**: Numara engelleme
- **App Groups**: Extension'lar arası veri paylaşımı
- **Combine**: Reaktif programlama

## 🔮 Gelecek Özellikler

- [ ] CoreML tabanlı gelişmiş spam tespiti
- [ ] Özelleştirilebilir filtre profilleri
- [ ] İstatistikler ve raporlama
- [ ] Siri Shortcuts entegrasyonu
- [ ] Widget desteği
- [ ] Apple Watch uygulaması

## 📄 Lisans

Bu proje örnek bir eğitim projesidir. Ticari kullanım için uygun lisans eklenmelidir.

## 👨‍💻 Geliştirici

Tamer Savaşcı

## 🙏 Kaynaklar

- [Apple IdentityLookup Documentation](https://developer.apple.com/documentation/identitylookup/)
- [Apple CallKit Documentation](https://developer.apple.com/documentation/callkit)
- [WWDC20: Filtering Unwanted Messages](https://developer.apple.com/videos/play/wwdc2020/10168/)
- [App Extension Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/)

---

**NOT**: Bu uygulama sadece Apple'ın resmi API'larını kullanır ve App Store politikalarına uygundur. Ancak App Store'a göndermeden önce mutlaka güncel politikaları kontrol edin.
