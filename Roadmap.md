# 📱 ROADMAP.md — iOS SMS Filter & Blocker App

## 🎯 Amaç
Kullanıcının işaretlediği "istenmeyen" SMS veya numaralardan gelen mesajların **bildirim olarak kullanıcıya ulaşmasını engelleyen**, **Apple'ın resmi API’larını kullanan**, **sandbox uyumlu** bir iOS uygulaması geliştirmek.

---

## ⚙️ 1. Genel Mimarinin Özeti

### Bileşenler
1. **Ana Uygulama (App Target)**
   - Kullanıcı arayüzü, ayarlar, kara liste yönetimi.
   - App Group içindeki paylaşılan veritabanını yönetir.
   - Kullanıcıdan gelen “İstenmeyen olarak işaretle” işlemini kaydeder.
   - Extension’lara veri sağlar.

2. **Message Filter Extension**
   - Framework: `IdentityLookup`
   - Yeni gelen SMS’leri sistem üzerinden alır.
   - Uygulamanın kara listesini okuyarak “allow / junk / promotion” kararı verir.
   - Sistem “junk” kararında bildirimi bastırır ve mesajı Junk klasörüne taşır.

3. **Call Directory Extension**
   - Framework: `CallKit`
   - Kullanıcı tarafından engellenen numaraları sisteme bildirir.
   - Sistem bu numaralardan gelen çağrıları ve (bazı durumlarda) mesaj bildirimlerini engeller.

4. **Paylaşılan Veri Alanı (App Group)**
   - Hem ana uygulama hem extension’lar aynı veriye erişir.
   - Engellenmiş numaralar, kullanıcı tercihleri, model parametreleri burada tutulur.

---

## 🧩 2. Kullanılacak Apple Framework’leri

| Framework | Kullanım Amacı |
|------------|----------------|
| `IdentityLookup` | Yeni gelen SMS’leri filtrelemek |
| `CallKit` / `CallDirectory` | Sistemsel numara engelleme |
| `AppGroups` | Ana app ile extension’lar arasında veri paylaşımı |
| `CoreData` veya `SQLite` | Kalıcı kara liste ve ayar depolama |
| `UserDefaults(suiteName:)` | Basit yapılandırmalar (App Group içinde) |
| `UIKit` / `SwiftUI` | Kullanıcı arayüzü |
| `NaturalLanguage` veya `CreateML` (opsiyonel) | Metin sınıflandırma veya basit AI filtreleme |
| `Combine` | Durum yönetimi ve reaktif veri akışı |

---

## 🧱 3. Apple Tarafından Belirlenmiş Kısıtlamalar (Mutlak Uyulması Gerekenler)

### Mesaj Erişimi
- ❌ Mesaj geçmişine erişim yasak.  
- ❌ Eski mesajları okumak, silmek veya listelemek yasak.  
- ✅ Sadece **yeni gelen mesajlar**, sistem tarafından filtreleme için extension’a yönlendirilebilir.

### Mesaj İçeriği
- ❌ Mesaj içeriği harici sunucuya gönderilemez.  
- ✅ Analiz/filtre işlemi cihaz üzerinde yapılmalıdır.  
- ⚠️ Eğer uzaktan model kullanılacaksa yalnızca meta veriler gönderilebilir (ör. numara hash’i, mesaj uzunluğu).

### Kullanıcı İzinleri
- Kullanıcı **Ayarlar > Mesajlar > Bilinmeyen & İstenmeyen > [App Adı]** yoluyla filtrelemeyi manuel olarak etkinleştirmelidir.
- **Telefon > Engelleme ve Kimlik Tanımlama > [App Adı]** altında Call Directory extension’ı manuel olarak etkinleştirmelidir.

### App Store Politikaları
- “Mesajlar” uygulamasının yerine geçmek veya onun arayüzünü taklit etmek yasak.  
- Kullanıcının SMS içeriğini loglamak, üçüncü tarafla paylaşmak veya sunucuya aktarmak yasak.  
- Uygulama, gizlilik beyanında “SMS Filtreleme” ve “Telefon Engelleme” izinlerini açıkça belirtmelidir.  
- TestFlight gönderiminde extension’lar aktif olmalı, App Review sırasında extension kimlikleri doğrulanmalıdır.

---

## 🧰 4. Teknik Altyapı ve Bağımlılıklar (Dependencies)

| Kütüphane | Amaç | Not |
|------------|------|------|
| `SQLite.swift` veya `CoreData` | Kara liste ve kullanıcı ayarlarını saklamak | App Group container içinde |
| `SwiftLint` | Kod stili denetimi | CI/CD aşamasında |
| `SwiftGen` | Statik kaynak yönetimi (opsiyonel) | i18n, ikon, asset yönetimi |
| `NaturalLanguage` | Basit metin sınıflandırması | iOS 15+ native |
| `Combine` | Reaktif veri akışı | SwiftUI uyumlu |
| `UserNotifications` | Bildirim yönetimi (örnek testler için) | Sadece ana app tarafında |
| `CallKit` | Engelleme ve kimlik tanımlama | App Extension olarak |
| `IdentityLookup` | SMS filtreleme | App Extension olarak |

---

## 🧠 5. Filtreleme Mantığı

### Filtre Tipleri
- **Kara Liste Bazlı (Deterministik)**  
  Kullanıcı tarafından işaretlenmiş numaralar doğrudan `junk`.

- **Heuristik / NLP Bazlı (Yapay Zeka)**  
  Metin içeriği “kampanya”, “kredi”, “hediye”, “kazandınız” vb. içeriyorsa `junk`.  
  Bu kısım opsiyonel ve cihaz içi modelle çalışmalıdır.

### Karar Ağaçları
- 1️⃣ Mesaj geldi → `IdentityLookup` tetiklendi  
- 2️⃣ Extension kara listeye bakar  
- 3️⃣ Kara listedeyse → `.junk` döndür  
- 4️⃣ Değilse → Metin analiz modelini uygula  
- 5️⃣ Sonuç → `.junk`, `.promotion` veya `.none`

---

## 🧱 6. Veritabanı (Shared Container Yapısı)

App Group ID: group.com.companyname.smsfilter

📂 /Library/Application Support/group.com.companyname.smsfilter/
├── blacklist.sqlite
├── preferences.plist
└── logs/


**Tablolar:**
- `blocked_numbers(phone TEXT PRIMARY KEY, added_at DATETIME)`
- `user_settings(key TEXT, value TEXT)`
- (opsiyonel) `ml_model_cache`

---

## 🔐 7. Uygulama Arayüzü (Ana App)

### Ekranlar
- “Engellenen Numaralar” listesi  
- “Yeni Numarayı Engelle” ekranı  
- “Filtreleme Durumu” göstergesi  
- “Ayarlar” → iOS izin yönlendirmeleri  
- (opsiyonel) “Filtre Öğrenimi” veya “Geri Bildirim” sayfası

---

## 🧩 8. Extension Etkileşimi (App ↔ Extensions)

| Veri | Yön | Mekanizma |
|------|------|------------|
| Engellenmiş numaralar | App → Message Filter | App Group JSON veya SQLite |
| Kullanıcı ayarları | App → Extensions | `UserDefaults(suiteName:)` |
| Filtre karar istatistikleri | Extension → App | Arşivlenmiş JSON veya log dosyası |

---

## 🧱 9. Güvenlik & Gizlilik

- App Group verisi yalnızca cihaz içinde saklanmalı.  
- iCloud senkronizasyonu devre dışı bırakılmalı.  
- Her extension kendi sandbox’ında çalışır, sadece App Group dizinine erişebilir.  
- Mesaj içeriği **asla** network’e gönderilmemeli.  
- Apple’ın “Sensitive Data” etiketleri Info.plist’e eklenmeli.  

---

## 🧩 10. Test & Doğrulama

### Test Araçları
- **Xcode Simulator** → SMS filtreleme extension’ı test edilemez (fiziksel cihaz gerekir).  
- **TestFlight Beta Testing** → iMessage + SMS testleri.  
- **Console.app** → `identitylookupd` log takibi.

### Manuel Test Senaryoları
1. Bilinen spam mesajı → Junk klasörüne düşmeli.  
2. Engellenmiş numaradan mesaj → Bildirim gelmemeli.  
3. Temiz mesaj → normal bildirim almalı.  
4. Kullanıcı izinleri kapalı → filtre devre dışı kalmalı.

---

## 🧠 11. Dağıtım

- **App Store Connect**’te ana uygulama ve extension bundle ID’leri eşleştirilmeli.  
- **Privacy Manifest** zorunlulukları (2024 sonrası) tamamlanmalı:  
  - `SMS Filtering` capability  
  - `Call Directory` capability  
- Review açıklamasında Apple’a filtre mekanizması ve offline çalışma garantisi belirtilmeli.

---

## ✅ 12. Başarı Kriterleri

- Yeni gelen spam SMS’lerin %95+ oranla bildirim üretmemesi.  
- Kullanıcı gizliliği: hiçbir mesaj içeriği cihaz dışına çıkmamalı.  
- Uygulama App Store Review’dan ilk denemede geçmeli.  
- CPU / bellek kullanımı extension başına <10ms işlem süresi.

---

## 🔮 13. Gelecek Geliştirme (Opsiyonel)

- Spam tespiti için on-device ML model (CoreML).  
- iCloud tabanlı kara liste senkronizasyonu (Apple izin verirse).  
- Region-specific filtre profilleri.  
- Siri Shortcuts entegrasyonu (“Bu numarayı engelle” komutu).  
- UI iyileştirmeleri (SwiftUI 3 + Combine).

---

## 🧾 Referanslar

- [Apple IdentityLookup Framework Docs](https://developer.apple.com/documentation/identitylookup/)
- [Apple CallKit / Call Directory Docs](https://developer.apple.com/documentation/callkit)
- [Apple App Extension Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/)
- [App Store Review Guidelines – Privacy & Filtering](https://developer.apple.com/app-store/review/guidelines/)
- [WWDC20: Filtering Unwanted Messages](https://developer.apple.com/videos/play/wwdc2020/10168/)

---

