# 🔧 SETUP_INSTRUCTIONS.md

## Xcode Proje Kurulum Adımları

Bu belge, SafeMessageShield projesini Xcode'da tam olarak yapılandırmak için gereken adımları içerir.

---

## ⚠️ ÖNEMLİ: Extension Target'ları Projede Hazırdır

`MessageFilterExtension` ve `CallDirectoryExtension` target'ları projeye eklenmiştir.
Aşağıdaki adımlarda yeni target oluşturmak yerine mevcut target'ların signing,
bundle ID ve App Group ayarlarını doğrulayın.

---

## 📝 ADIM 1: Ana Proje Ayarları

### 1.1 Bundle ID'yi Ayarla
1. Xcode'da projeyi açın
2. **SafeMessageShield** target'ını seçin
3. **Signing & Capabilities** sekmesine gidin
4. Bundle Identifier'ı düzenleyin: `tsavasci.SafeMessageShield`
5. Team'inizi seçin

### 1.2 App Groups Capability Ekle
1. Hala **Signing & Capabilities** sekmesinde
2. **"+ Capability"** butonuna tıklayın
3. **"App Groups"** seçin
4. Container ekleyin: `group.tsavasci.SafeMessageShield`

### 1.3 Entitlements Dosyasını Bağla
1. Project Navigator'da **SafeMessageShield** target'ını seçin
2. **Build Settings** sekmesine gidin
3. "Code Signing Entitlements" araması yapın
4. Değeri şuna ayarlayın: `SafeMessageShield/SafeMessageShield.entitlements`

---

## 📝 ADIM 2: Message Filter Extension'ı Doğrula

### 2.1 Mevcut Target
Project Navigator'da `MessageFilterExtension` target'ının bulunduğunu ve
`SafeMessageShield` uygulamasına gömüldüğünü doğrulayın.

### 2.2 Kaynak Dosyaları
Target'ın `MessageFilterExtension/MessageFilterExtension.swift` ve
`MessageFilterExtension/MessageFilterMatcher.swift` dosyalarını derlediğini doğrulayın.

### 2.3 Bundle ID ve Capabilities
1. **MessageFilterExtension** target'ını seçin
2. Bundle ID: `tsavasci.SafeMessageShield.MessageFilterExtension`
3. Team'i ana app ile aynı yapın
4. **Signing & Capabilities** sekmesinden:
   - **"+ Capability"** > **App Groups**
   - Container: `group.tsavasci.SafeMessageShield`

### 2.4 Info.plist Kontrolü
`MessageFilterExtension/Info.plist` dosyasının içeriğini kontrol edin:
```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.identitylookup.message-filter</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).MessageFilterExtension</string>
</dict>
```

---

## 📝 ADIM 3: Call Directory Extension'ı Doğrula

### 3.1 Mevcut Target
Project Navigator'da `CallDirectoryExtension` target'ının bulunduğunu ve
`SafeMessageShield` uygulamasına gömüldüğünü doğrulayın.

### 3.2 Kaynak Dosyaları
Target'ın `CallDirectoryExtension/CallDirectoryHandler.swift` dosyasını derlediğini
doğrulayın.

### 3.3 Bundle ID ve Capabilities
1. **CallDirectoryExtension** target'ını seçin
2. Bundle ID: `tsavasci.SafeMessageShield.CallDirectoryExtension`
3. Team'i ana app ile aynı yapın
4. **Signing & Capabilities** sekmesinden:
   - **"+ Capability"** > **App Groups**
   - Container: `group.tsavasci.SafeMessageShield`

### 3.4 Info.plist Kontrolü
`CallDirectoryExtension/Info.plist` dosyasının içeriğini kontrol edin:
```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.callkit.call-directory</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).CallDirectoryHandler</string>
</dict>
```

---

## 📝 ADIM 4: Dosya Yapısını Düzenle

### 4.1 Ana App Dosyaları
Şu dosyaların doğru yerde olduğundan emin olun:

```
SafeMessageShield/
├── SafeMessageShieldApp.swift
├── ContentView.swift
├── SafeMessageShield.entitlements
├── Models/
│   └── BlockedNumber.swift
├── Views/
│   ├── AddNumberView.swift
│   └── SettingsView.swift
├── Managers/
│   └── DataManager.swift
└── Assets.xcassets/
```

### 4.2 Extension Dosyaları
```
MessageFilterExtension/
├── MessageFilterExtension.swift
└── Info.plist

CallDirectoryExtension/
├── CallDirectoryHandler.swift
└── Info.plist
```

---

## 📝 ADIM 5: Build Settings Kontrolü

### 5.1 Deployment Target
Tüm target'lar için (Ana App, Message Filter, Call Directory):
1. **Build Settings** sekmesine gidin
2. "iOS Deployment Target" araması yapın
3. Değeri **iOS 18.0** veya üstü yapın

### 5.2 Swift Version
1. **Build Settings** sekmesinde
2. "Swift Language Version" araması yapın
3. Değeri **Swift 5** yapın

---

## 📝 ADIM 6: Test ve Doğrulama

### 6.1 Derleme Testi
```bash
# Clean build folder
⌘ + Shift + K

# Build
⌘ + B
```

Herhangi bir hata almamalısınız.

### 6.2 Scheme Kontrolü
1. Scheme seçiciden **SafeMessageShield** seçili olmalı
2. Fiziksel iOS cihaz seçin (Simulator değil!)

### 6.3 Çalıştır
```bash
⌘ + R
```

---

## 📝 ADIM 7: iOS Cihazda Etkinleştirme

### 7.1 SMS Filtreleme Etkinleştir
1. iOS **Ayarlar** uygulamasını açın
2. **Mesajlar** > **Bilinmeyen & İstenmeyen**
3. **SafeMessageShield**'i etkinleştirin

### 7.2 Telefon Engelleme Etkinleştir
1. iOS **Ayarlar** uygulamasını açın
2. **Telefon** > **Engelleme ve Kimlik Tanımlama**
3. **SafeMessageShield**'i etkinleştirin

---

## 🐛 Olası Sorunlar ve Çözümleri

### "No such module 'IdentityLookup'"
- **Çözüm**: Deployment target'ı iOS 11.0+ yaptığınızdan emin olun

### "App Groups capability not found"
- **Çözüm**: Her target için App Groups capability'sini manuel olarak ekleyin

### "Code signing error"
- **Çözüm**: 
  1. Apple Developer hesabınızın aktif olduğundan emin olun
  2. Signing & Capabilities'de team'i düzgün seçin
  3. Gerekirse Automatically manage signing işaretini kaldırıp tekrar işaretleyin

### Extension'lar çalışmıyor
- **Çözüm**:
  1. Extension'ları iOS Ayarlar'dan etkinleştirin
  2. Cihazı yeniden başlatın
  3. Console.app ile log kontrol edin

### "Could not create ModelContainer"
- **Çözüm**: 
  1. SafeMessageShieldApp.swift'teki schema'nın `BlockedNumber.self` içerdiğinden emin olun
  2. Eski `Item.swift` dosyasını sildiğinizden emin olun

---

## ✅ Kontrol Listesi

Aşağıdaki tüm maddeleri kontrol edin:

- [ ] Ana app bundle ID ayarlandı: `tsavasci.SafeMessageShield`
- [ ] Message Filter bundle ID: `tsavasci.SafeMessageShield.MessageFilterExtension`
- [ ] Call Directory bundle ID: `tsavasci.SafeMessageShield.CallDirectoryExtension`
- [ ] Tüm target'lara App Groups eklendi
- [ ] App Group ID: `group.tsavasci.SafeMessageShield`
- [ ] Tüm target'lar aynı team ile imzalanıyor
- [ ] Entitlements dosyası bağlandı
- [ ] Extension Info.plist dosyaları doğru
- [ ] Proje hatasız derleniyor
- [ ] Fiziksel cihazda çalışıyor
- [ ] iOS Ayarlar'dan extension'lar etkinleştirildi

---

## 📞 Destek

Sorun yaşarsanız:
1. Hata mesajını not edin
2. Console.app'te log kontrol edin
3. Build Settings ve Capabilities'i tekrar kontrol edin
4. Gerekirse clean build (⌘ + Shift + K) yapın

---

**İyi kodlamalar! 🚀**
