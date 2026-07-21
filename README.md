# SafeMessageShield 📱

iOS için SMS Filtreleme ve Telefon Engelleme Uygulaması

## 🎯 Özellikler

- ✅ **SMS Filtreleme**: İstenmeyen SMS'leri otomatik olarak filtreler
- ✅ **Arama Engelleme**: Belirtilen numaralardan gelen aramaları engeller
- ✅ **Manuel Numara Ekleme**: Telefon numaralarını kolayca manuel olarak girin
- ✅ **Rehber Entegrasyonu**: Rehberinizden doğrudan numara seçerek engelleyin
- ✅ **Gizlilik Odaklı**: Tüm veriler cihazda saklanır, sunucuya hiçbir veri gönderilmez
- ✅ **Sürekli Koruma**: Uygulama cihazda yüklü ve extension'lar etkin olduğu sürece uygulama kapalıyken de çalışır
- ✅ **Sıfır Gecikme**: Anında filtreleme ve engelleme
- ✅ **Modern UI**: SwiftUI ile tasarlanmış kullanıcı dostu arayüz

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
   - Kullanıcının tanımladığı kelime kurallarıyla promosyon/işlem kategorileri
   - Whitelist ile güvenilir gönderenleri korur

3. **Call Directory Extension**
   - Framework: `CallKit`
   - Engellenen numaraları sisteme bildirir
   - Çağrı ve mesaj bildirimlerini engeller

4. **Paylaşılan Veri (App Group)**
   - ID: `group.tsavasci.SafeMessageShield`
   - Ana uygulama ve extension'lar arasında veri paylaşımı

## 📋 Gereksinimler

- iOS 18.0+
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

### 4. Extension Target'larını Doğrulayın

Proje `MessageFilterExtension`, `CallDirectoryExtension` ve `SafeMessageShieldTests`
target'larını hazır içerir. Xcode'da bundle ID, signing team ve App Group üyeliklerini
doğrulayın.

Yeni target oluşturmanız gerekmez.

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

**Yöntem 1: Manuel Ekleme**
1. Ana ekranda "+" butonuna tıklayın
2. "Manuel Ekle" seçeneğini seçin
3. Telefon numarasını girin (örn: +905551234567)
4. İsteğe bağlı bir sebep ekleyin
5. "Numarayı Engelle" butonuna tıklayın

**Yöntem 2: Rehberden Seçme**
1. Ana ekranda "+" butonuna tıklayın
2. "Rehberden Seç" seçeneğini seçin
3. Kişiyi ve telefon numarasını seçin
4. Numara otomatik olarak engellenecektir

**Numara Silme**
- Engellenen numara üzerinde sola kaydırın ve "Sil" butonuna tıklayın

### Filtreleme Nasıl Çalışır?

**SMS Filtreleme:**
- Eklediğiniz numaralardan gelen mesajlar otomatik olarak filtrelenir
- Mesajlar "Junk" klasörüne düşer
- Bildirim almaz, rahatsız olmazsınız

**Arama Engelleme:**
- Engellenen numaralardan gelen aramalar otomatik olarak reddedilir
- Arama geçmişinizde "Engellendi" olarak görünür
- Hiçbir bildirim veya rahatsızlık yaşamazsınız

**Önemli Not:**
- Her iki özellik de uygulama cihazda yüklüyken, uygulama kapalı olsa bile çalışır
- Extension'lar iOS tarafından otomatik olarak tetiklenir
- İnternet bağlantısı gerektirmez, tamamen offline çalışır

## 🔒 Gizlilik

- ❌ Mesaj içeriği hiçbir sunucuya gönderilmez
- ✅ Tüm filtreleme cihaz içinde yapılır
- ✅ Veriler yalnızca cihazda saklanır
- ✅ iCloud senkronizasyonu YOK
- ✅ Analytics YOK
- ✅ Tracking YOK

## 🧪 Test

### Otomatik Testler

`SafeMessageShieldTests` target'ı telefon normalizasyonu, alfabetik gönderici
eşleşmeleri ve numara filtre kurallarını doğrular:

```bash
xcodebuild -project SafeMessageShield.xcodeproj \
  -scheme SafeMessageShield \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test
```

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
- **SwiftData**: Veri persistance ve yönetimi
- **IdentityLookup**: SMS filtreleme framework
- **CallKit**: Arama engelleme framework
- **ContactsUI**: Rehber entegrasyonu
- **App Groups**: Extension'lar arası güvenli veri paylaşımı
- **ObservableObject**: State yönetimi için reaktif pattern

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
