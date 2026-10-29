/* SafeMessageShield — Global Website Translations (11 Languages) */
window.SMS_LANGUAGES = [
    { code: "en", name: "English", flag: "🇬🇧", dir: "ltr" },
    { code: "tr", name: "Türkçe", flag: "🇹🇷", dir: "ltr" },
    { code: "de", name: "Deutsch", flag: "🇩🇪", dir: "ltr" },
    { code: "fr", name: "Français", flag: "🇫🇷", dir: "ltr" },
    { code: "es", name: "Español", flag: "🇪🇸", dir: "ltr" },
    { code: "zh", name: "简体中文", flag: "🇨🇳", dir: "ltr" },
    { code: "ja", name: "日本語", flag: "🇯🇵", dir: "ltr" },
    { code: "ko", name: "한국어", flag: "🇰🇷", dir: "ltr" },
    { code: "ar", name: "العربية", flag: "🇸🇦", dir: "rtl" },
    { code: "hi", name: "हिन्दी", flag: "🇮🇳", dir: "ltr" },
    { code: "ru", name: "Русский", flag: "🇷🇺", dir: "ltr" }
];

window.SMS_TRANSLATIONS = {
    en: {
        nav: {
            features: "Features",
            presets: "Smart Presets",
            simulator: "Simulator",
            howItWorks: "How It Works",
            privacy: "Privacy",
            faq: "FAQ",
            download: "Download"
        },
        hero: {
            title: "Silence SMS & Call Spam on {iOS}",
            subtitle: "The 100% offline, privacy-first mobile shield. Neutralize casino promos, fake delivery phishing, and robocalls with zero data tracking. Your messages and contacts never leave your device.",
            btnDownload: "Download on App Store",
            btnLearnMore: "Learn More",
            badges: ["100% Offline & Private", "Smart Scam Presets", "Rule Simulator Sandbox"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "On-Device & Offline",
            stat2Value: "0", stat2Label: "Data Harvested",
            stat3Value: "11", stat3Label: "Languages Supported",
            stat4Value: "iOS 18", stat4Label: "Native Frameworks"
        },
        features: {
            badge: "Core Features",
            title: "Powerful Privacy-First Defense",
            subtitle: "Engineered with native Apple frameworks to keep your personal communications quiet, safe, and strictly private.",
            items: [
                { title: "Smart Protection Presets", desc: "1-tap defense against casino blasts, fake parcel delivery phishing, loan traps, and crypto scams." },
                { title: "Interactive Simulator Sandbox", desc: "Audit and verify how your active rules evaluate senders and messages before real texts arrive." },
                { title: "Native iOS SMS Junk Filter", desc: "Routes unwanted messages silently into the iOS Junk folder without notification buzzes." },
                { title: "Call Directory Robocall Blocker", desc: "Suppresses fraudulent telemarketing and scam calls at the iOS system level via CallKit." },
                { title: "Pattern & Country Code Rules", desc: "Block by international dialing codes (+XX), carrier prefixes, suffixes, or digit sequences." },
                { title: "Bank OTP & 2FA Guardian", desc: "Trusted family contacts and banking institutions are safeguarded so verification codes always arrive." },
                { title: "100% Offline Architecture", desc: "No remote cloud servers, no account logins, and no contact harvesting. Total privacy." },
                { title: "JSON Backup & Sharing", desc: "1-click export and import of your custom blocklists for seamless cross-device migration." }
            ]
        },
        presets: {
            badge: "Scam Defense",
            title: "1-Tap Smart Protection Presets",
            subtitle: "Turn on battle-tested keyword shields tailored for widespread modern spam patterns across 11 languages.",
            items: [
                { icon: "🎰", name: "Casino & Betting", desc: "Free spins, slot machines, sportsbook promos, and illegal gambling blasts." },
                { icon: "📦", name: "Fake Delivery & Customs", desc: "Detained parcel alerts, unpaid customs duty links, and fake courier phishing." },
                { icon: "💳", name: "Predatory Loans", desc: "Instant cash, zero-interest credit traps, and bogus debt relief solicitations." },
                { icon: "🎁", name: "Lottery & Gift Cards", desc: "Fake prize claims, free smartphone draws, and survey trap links." },
                { icon: "💼", name: "Crypto & Job Scams", desc: "Unsolicited WhatsApp/Telegram work-from-home fraud and crypto schemes." }
            ]
        },
        simulator: {
            badge: "Exclusive Sandbox",
            title: "Interactive Rule Simulator",
            subtitle: "Test any incoming sender or message text in a real-time sandbox before real messages land.",
            testSender: "Sender: +1 (800) 555-0199",
            testBody: "USPS: Your parcel is on hold due to missing address info. Update here: track-usps-fee.xyz",
            simStatus: "SIMULATION EVALUATION",
            simBadge: "FILTERED: JUNK",
            simExplanation: "Matched Rule: 'Fake Delivery & Customs Preset' → Action: Route to iOS Junk Tab (Silenced)"
        },
        howItWorks: {
            badge: "Getting Started",
            title: "Protected in 3 Simple Steps",
            subtitle: "Fast and native iOS setup with zero registration required.",
            steps: [
                { num: "1", title: "Download Free", desc: "Get Safe Message Shield from the official iOS App Store." },
                { num: "2", title: "Enable Extensions", desc: "Toggle Safe Message Shield in iOS Settings under Messages & Phone." },
                { num: "3", title: "Enjoy Peace of Mind", desc: "Spam texts fall silently into Junk, and fraud calls are blocked automatically." }
            ]
        },
        privacy: {
            badge: "Zero-Knowledge",
            title: "Why We Are Fundamentally Safer",
            subtitle: "Unlike legacy caller ID apps that monetize your address book, Safe Message Shield is 100% on-device.",
            legacyTitle: "Legacy Caller ID Apps",
            legacyItems: [
                "Upload your complete address book to external cloud servers",
                "Route incoming communication metadata through corporate datacenters",
                "Sell telemetry and number graphs to data brokers",
                "Lock basic pattern matching behind $4.99/week subscriptions"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "100% on-device computation via Apple IdentityLookup & CallKit",
                "Never reads, accesses, or uploads your personal contact book",
                "Zero third-party analytics SDKs, zero advertising trackers",
                "Free, lightweight, transparent JSON rule export and import"
            ]
        },
        faq: {
            badge: "Questions & Answers",
            title: "Frequently Asked Questions",
            subtitle: "Everything you need to know about SafeMessageShield and iOS privacy.",
            items: [
                { q: "Can SafeMessageShield read my existing or past messages?", a: "No. Apple iOS strictly isolates message history. Third-party apps cannot read, search, or delete your past SMS conversations. Only newly incoming messages are evaluated by the iOS message filter extension." },
                { q: "Do you upload my contacts or phone numbers to the cloud?", a: "Never. SafeMessageShield contains zero network tracking code. All filter matching, presets, and phone directory lookups run 100% offline on your iPhone." },
                { q: "Will important bank OTP or 2FA verification codes be blocked?", a: "No. The built-in Whitelist protects known banking institutions and trusted contacts. You can also whitelist specific sender names or numbers with one tap." },
                { q: "Does the app need to run in the background to filter spam?", a: "No. SafeMessageShield uses Apple's native IdentityLookup and CallDirectory system extensions. iOS triggers them automatically in the background even when the app is completely closed." },
                { q: "How does the Interactive Simulator work?", a: "The Simulator uses the exact same matching engine as the background extension. You can type any sender number or message text to preview in real-time whether your active rules would permit, flag, or block it." },
                { q: "Can I transfer my rules to a new iPhone?", a: "Yes! Use the 1-click JSON Backup feature to export your custom rules and import them seamlessly onto your new device." }
            ]
        },
        download: {
            title: "Reclaim Your Peace of Mind Today",
            subtitle: "Experience a silent, spam-free inbox. Download Safe Message Shield free on the App Store.",
            appstoreAlt: "Download Safe Message Shield on the App Store",
            note: "Requires iOS 18.0 or later • 100% Offline • Zero Data Collection"
        },
        footer: {
            desc: "The 100% offline, privacy-first spam text and robocall blocker for iOS.",
            linksHeading: "Navigation",
            legalHeading: "Legal & Privacy",
            privacy: "Privacy Policy",
            terms: "Terms of Service",
            support: "Support",
            copyright: "All rights reserved."
        },
        misc: { skipLink: "Skip to content", toggleNav: "Toggle navigation", langLabel: "Language" }
    },

    tr: {
        nav: {
            features: "Özellikler",
            presets: "Akıllı Paketler",
            simulator: "Simülatör",
            howItWorks: "Nasıl Çalışır",
            privacy: "Gizlilik",
            faq: "SSS",
            download: "İndir"
        },
        hero: {
            title: "{iOS} için Akıllı Spam ve Arama Kalkanı",
            subtitle: "İstenmeyen SMS'leri ve rahatsız edici aramaları %100 çevrimdışı engelleyin. Bahis, sahte kargo ve dolandırıcılık mesajlarını sıfır veri takibiyle durdurun. Verileriniz asla cihazınızdan çıkmaz.",
            btnDownload: "App Store'dan İndir",
            btnLearnMore: "Detayları İncele",
            badges: ["%100 Çevrimdışı & Gizli", "Akıllı Koruma Paketleri", "Canlı Kural Simülatörü"]
        },
        stats: {
            stat1Value: "%100", stat1Label: "Cihaz İçi & Çevrimdışı",
            stat2Value: "0", stat2Label: "Toplanan Veri",
            stat3Value: "11", stat3Label: "Desteklenen Dil",
            stat4Value: "iOS 18", stat4Label: "Doğal Apple Altyapısı"
        },
        features: {
            badge: "Temel Özellikler",
            title: "Güçlü ve Gizlilik Odaklı Koruma",
            subtitle: "Apple'ın resmi güvenlik çatılarıyla inşa edilmiş, mesaj kutunuzu temiz ve sessiz tutan yeni nesil kalkan.",
            items: [
                { title: "Akıllı Koruma Paketleri", desc: "Bahis, sahte kargo takip, kredi ve kripto iş vaadi spamlarını tek dokunuşla engelleyin." },
                { title: "Canlı Test Simülatörü", desc: "Gerçek bir SMS gelmeden önce belirlediğiniz kuralların nasıl çalışacağını anında test edin." },
                { title: "Doğal SMS Filtresi", desc: "İstenmeyen mesajları bildirim sesi çıkarmadan doğrudan iOS İstenmeyen (Junk) sekmesine yönlendirir." },
                { title: "Sistemsel Arama Engelleme", desc: "CallKit altyapısıyla istenmeyen arayanları sistem seviyesinde susturur, telefonunuz çalmaz." },
                { title: "Numara & Alan Kodu Kuralları", desc: "Uluslararası ülke kodları (+XX), operatör ön ekleri veya numara parçalarıyla toplu filtreleyin." },
                { title: "Banka Onay Kodu (OTP) Kalkanı", desc: "Kritik banka 2FA doğrulama kodlarının ve ailenizin mesajlarının her zaman ulaşmasını garanti eder." },
                { title: "%100 Çevrimdışı Mimari", desc: "Uzak sunucu yok, üyelik yok, rehber kopyalama yok. Tüm analiz telefonunuzda gerçekleşir." },
                { title: "JSON Yedekleme & Paylaşım", desc: "Oluşturduğunuz engelleme kurallarını tek tıkla JSON formatında yedekleyin veya cihazlar arası aktarın." }
            ]
        },
        presets: {
            badge: "Spam Kalkanı",
            title: "Tek Dokunuşla Akıllı Paketler",
            subtitle: "Türkiye'deki en yaygın spam senaryolarına özel olarak optimize edilmiş hazır koruma modülleri.",
            items: [
                { icon: "🎰", name: "Bahis ve Casino", desc: "Deneme bonusu, freespin, slot ve canlı bahis reklamlarını kökten engeller." },
                { icon: "📦", name: "Sahte Kargo & Gümrük", desc: "'Paketiniz teslim edilemedi', gümrük vergisi ve sahte kargo takip bağlantılarını yakalar." },
                { icon: "💳", name: "Ön Onaylı Kredi", desc: "Dosya masrafı, acil nakit ve sicil affı vaatli dolandırıcılık SMS'lerini filtreler." },
                { icon: "🎁", name: "Çekiliş & Hediye", desc: "Sahte ödül kazandınız bildirimlerini ve hediye çeki tuzaklarını durdurur." },
                { icon: "💼", name: "Kripto & Sahte İş", desc: "Telegram ve WhatsApp'a yönlendiren evden çalışma ve görev dolandırıcılıklarını engeller." }
            ]
        },
        simulator: {
            badge: "Özel Sandbox",
            title: "Canlı Filtre Simülatörü",
            subtitle: "Kurallarınızın gelen bir SMS'i nasıl değerlendireceğini gerçek bir mesaj gelmeden önce güvenli ortamda deneyin.",
            testSender: "Gönderen: +90 555 123 4567",
            testBody: "Kargonuz adres yetersizliği nedeniyle teslim edilemedi. Takip için tıklayın: kargo-takip-ptt.xyz",
            simStatus: "SİMÜLASYON ANALİZİ",
            simBadge: "FİLTRELENDİ: JUNK",
            simExplanation: "Eşleşen Kural: 'Sahte Kargo Paketi' → İşlem: iOS İstenmeyen Sekmesine Gönderildi (Sessiz)"
        },
        howItWorks: {
            badge: "Kolay Kurulum",
            title: "3 Kolay Adımda Tam Koruma",
            subtitle: "Kayıt olmadan, hesap açmadan iki dakikada kullanmaya başlayın.",
            steps: [
                { num: "1", title: "Ücretsiz İndirin", desc: "Safe Message Shield'ı App Store'dan doğrudan iPhone'unuza yükleyin." },
                { num: "2", title: "İzinleri Açın", desc: "iOS Ayarları > Mesajlar ve Telefon menülerinden Safe Message Shield'ı aktif edin." },
                { num: "3", title: "Huzurun Tadını Çıkarın", desc: "Spam SMS'ler sessizce çöpe gider, rahatsız edici aramalar anında engellenir." }
            ]
        },
        privacy: {
            badge: "Gizlilik Sözü",
            title: "Neden Temelde Daha Güvenliyiz?",
            subtitle: "Rehberinizi sunuculara yükleyen diğer popüler uygulamaların aksine Safe Message Shield %100 cihazınızdadır.",
            legacyTitle: "Diğer Arayan Kimliği Uygulamaları",
            legacyItems: [
                "Tüm telefon rehberinizi harici sunuculara kopyalar",
                "Gelen mesaj içeriklerini bulut sunucularına aktarır",
                "İletişim verilerinizi pazarlama ağlarıyla paylaşabilir",
                "Haftalık fahiş abonelik ücretleri talep eder"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "Apple IdentityLookup & CallKit ile %100 cihaz içinde çalışır",
                "Rehberinize asla erişmez, hiçbir yere yüklemez",
                "Sıfır analiz SDK'sı, sıfır takip, sıfır reklam kodu",
                "Ücretsiz, hafif ve şeffaf JSON kural yönetimi sunar"
            ]
        },
        faq: {
            badge: "Merak Edilenler",
            title: "Sıkça Sorulan Sorular",
            subtitle: "SafeMessageShield ve iOS filtreleme altyapısı hakkında bilmeniz gereken her şey.",
            items: [
                { q: "SafeMessageShield geçmiş mesajlarımı okuyabilir mi?", a: "Hayır. Apple iOS işletim sistemi geçmiş mesajlara erişimi kesinlikle engeller. SafeMessageShield sadece yeni gelen SMS'leri filtreleyebilir." },
                { q: "Rehberim veya kişisel verilerim sunuculara yüklenir mi?", a: "Asla. Uygulama tamamen çevrimdışı çalışır. İnternet sunucumuz, kullanıcı hesabımız veya veri toplama altyapımız yoktur." },
                { q: "Banka onay kodlarım (OTP / 2FA) engellenir mi?", a: "Hayır. Akıllı beyaz liste banka başlıklarını ve onay kodlarını korur. Dilediğiniz göndereni tek tıkla güvenli listeye ekleyebilirsiniz." },
                { q: "Uygulamanın arka planda açık kalması gerekir mi?", a: "Hayır. iOS sistem uzantıları uygulama tamamen kapalıyken bile işletim sistemi düzeyinde filtrelemeyi sürdürür." },
                { q: "Canlı Simülatör nasıl çalışır?", a: "Simülatör, arka plandaki gerçek filtreleme motorunun aynısını çalıştırır. Bir numara veya metin yazarak sonucun ne olacağını anında görebilirsiniz." },
                { q: "Kurallarımı başka bir iPhone'a taşıyabilir miyim?", a: "Evet! JSON Yedekleme özelliği sayesinde listenizi tek dokunuşla dışa aktarabilir ve yeni telefonunuza aktarabilirsiniz." }
            ]
        },
        download: {
            title: "Telefonunuzda Huzuru Yeniden Yakalayın",
            subtitle: "Tertemiz bir mesaj kutusu için Safe Message Shield'ı App Store'dan hemen ücretsiz indirin.",
            appstoreAlt: "Safe Message Shield'ı App Store'dan İndirin",
            note: "iOS 18.0 veya üstünü gerektirir • %100 Çevrimdışı • Sıfır Veri Toplama"
        },
        footer: {
            desc: "iOS için %100 çevrimdışı, gizlilik odaklı spam SMS ve telefon engelleme kalkanı.",
            linksHeading: "Bağlantılar",
            legalHeading: "Yasal & Gizlilik",
            privacy: "Gizlilik Politikası",
            terms: "Kullanım Koşulları",
            support: "Destek",
            copyright: "Tüm hakları saklıdır."
        },
        misc: { skipLink: "İçeriğe atla", toggleNav: "Menüyü aç/kapat", langLabel: "Dil" }
    },

    de: {
        nav: {
            features: "Funktionen",
            presets: "Schutzpakete",
            simulator: "Simulator",
            howItWorks: "Anleitung",
            privacy: "Datenschutz",
            faq: "FAQ",
            download: "Download"
        },
        hero: {
            title: "Schluss mit SMS- & Anruf-Spam auf {iOS}",
            subtitle: "Der 100% offline, datenschutzorientierte Schutzschild. Blockieren Sie Casino-Spam, gefälschte Paket-SMS und Werbeanrufe ohne jegliches Daten-Tracking.",
            btnDownload: "Im App Store laden",
            btnLearnMore: "Mehr erfahren",
            badges: ["100% Offline & Privat", "Intelligente Schutzpakete", "Filter-Simulator Sandbox"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "Lokal auf dem Gerät",
            stat2Value: "0", stat2Label: "Daten übertragen",
            stat3Value: "11", stat3Label: "Sprachen unterstützt",
            stat4Value: "iOS 18", stat4Label: "Native Apple APIs"
        },
        features: {
            badge: "Funktionen",
            title: "Robuster Schutz für Ihre Privatsphäre",
            subtitle: "Entwickelt nach strengsten europäischen Datenschutz-Standards für ein ruhiges Smartphone.",
            items: [
                { title: "Intelligente Schutzpakete", desc: "1-Klick-Schutz vor Casino-Spam, gefälschten Paketen, Krediten und Job-Betrug." },
                { title: "Filter-Simulator Sandbox", desc: "Testen Sie Ihre Regeln vorab mit beliebigen Nummern und Texten in Echtzeit." },
                { title: "Nativer SMS-Junk-Filter", desc: "Leitet unerwünschte Nachrichten geräuschlos in den iOS-Junk-Ordner." },
                { title: "CallKit Anrufblocker", desc: "Sperrt betrügerische Werbeanrufe direkt auf iOS-Systemebene." },
                { title: "Vorwahl- und Ländercode-Filter", desc: "Sperren nach Ländervorwahl (+XX), Ortsvorwahlen oder Ziffernfolgen." },
                { title: "Bank-OTP & 2FA-Schutz", desc: "Wichtige Verifizierungscodes und Kontakte erreichen Sie stets zuverlässig." },
                { title: "100% Offline-Architektur", desc: "Keine Server, keine Benutzerkonten, kein Hochladen von Kontakten." },
                { title: "JSON-Backup & Export", desc: "Regeln mit 1 Klick als JSON sichern oder auf ein neues iPhone übertragen." }
            ]
        },
        presets: {
            badge: "Betrugsschutz",
            title: "1-Klick-Schutzpakete",
            subtitle: "Sofortige Abwehr der häufigsten Spam- und Phishing-Wellen in Deutschland, Österreich und der Schweiz.",
            items: [
                { icon: "🎰", name: "Casino & Sportwetten", desc: "Freispiele, Spielautomaten und aufdringliche Glücksspielwerbung." },
                { icon: "📦", name: "Gefälschte Paketdienste", desc: "Phishing zu Zollgebühren und angebliche DHL/Hermes-Zustellprobleme." },
                { icon: "💳", name: "Dubiose Sofortkredite", desc: "Kredite ohne Schufa, Blitzgeld-Versprechen und Entschuldungs-Spam." },
                { icon: "🎁", name: "Gewinnspiele & Gutscheine", desc: "Gefälschte Einkaufsgutscheine und angebliche Hauptgewinne." },
                { icon: "💼", name: "Krypto- & Job-Abzocke", desc: "Dubiose Angebote für Heimarbeit via Telegram und WhatsApp." }
            ]
        },
        simulator: {
            badge: "Sandbox",
            title: "Interaktiver Filter-Simulator",
            subtitle: "Überprüfen Sie das Verhalten Ihrer Regeln in einer sicheren Umgebung, bevor echte Nachrichten eingehen.",
            testSender: "Absender: +49 170 1234567",
            testBody: "Ihr Paket liegt beim Zoll. Zahlen Sie die Gebühr unter: dhl-zoll-portal.xyz",
            simStatus: "SIMULATIONSERGEBNIS",
            simBadge: "FILTER: JUNK",
            simExplanation: "Treffer: 'Paket-Phishing Paket' → Aktion: In iOS-Junk verschoben (Lautlos)"
        },
        howItWorks: {
            badge: "Einfach",
            title: "In 3 Schritten geschützt",
            subtitle: "Ohne Registrierung in unter zwei Minuten einsatzbereit.",
            steps: [
                { num: "1", title: "Kostenlos laden", desc: "Safe Message Shield direkt aus dem App Store installieren." },
                { num: "2", title: "Erweiterung aktivieren", desc: "In den iOS-Einstellungen unter Nachrichten & Telefon aktivieren." },
                { num: "3", title: "Ruhe genießen", desc: "Spam landet geräuschlos im Junk-Ordner, betrügerische Anrufe werden geblockt." }
            ]
        },
        privacy: {
            badge: "Datenschutz",
            title: "Warum wir grundlegend sicherer sind",
            subtitle: "Im Gegensatz zu bekannten Anrufer-ID-Apps lädt Safe Message Shield niemals Daten hoch.",
            legacyTitle: "Herkömmliche Apps",
            legacyItems: [
                "Laden Ihr gesamtes Adressbuch in die Cloud hoch",
                "Leiten SMS-Inhalte über Drittanbieter-Server",
                "Verkaufen Telemetriedaten an Werbenetzwerke",
                "Verlangen teure wöchentliche Abonnements"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "100% lokale Berechnung via Apple IdentityLookup & CallKit",
                "Liest oder überträgt niemals Ihre privaten Kontakte",
                "Keine Analyse-SDKs, keine Tracker, keine Werbung",
                "Kostenlos, leichtgewichtig und transparenter JSON-Export"
            ]
        },
        faq: {
            badge: "FAQ",
            title: "Häufig gestellte Fragen",
            subtitle: "Wichtige Informationen zu SafeMessageShield und iOS-Datenschutz.",
            items: [
                { q: "Kann SafeMessageShield alte SMS lesen?", a: "Nein. iOS isoliert alte Nachrichten vollständig. Apps können niemals auf Ihre bisherigen SMS zugreifen. Nur neu eintreffende SMS werden geprüft." },
                { q: "Werden meine Kontakte hochgeladen?", a: "Niemals. SafeMessageShield enthält keinen Netzwerkcode. Alle Filter laufen 100% offline auf Ihrem iPhone." },
                { q: "Werden Bank-TANs oder Bestätigungscodes blockiert?", a: "Nein. Die integrierte Whitelist schützt Banken und OTPs zuverlässig." },
                { q: "Muss die App im Hintergrund geöffnet bleiben?", a: "Nein. iOS führt die Erweiterungen automatisch auf Systemebene aus." },
                { q: "Wie funktioniert der Simulator?", a: "Er nutzt die identische Filter-Engine, um Tests mit beliebigen Texten durchzuführen." },
                { q: "Kann ich meine Regeln auf ein neues iPhone übertragen?", a: "Ja! Exportieren Sie die Regeln einfach als JSON und importieren Sie diese auf dem neuen Gerät." }
            ]
        },
        download: {
            title: "Holen Sie sich Ihre Ruhe zurück",
            subtitle: "Erleben Sie ein ruhiges, spamfreies Postfach. Jetzt kostenlos laden.",
            appstoreAlt: "Safe Message Shield im App Store laden",
            note: "Erfordert iOS 18.0 oder neuer • 100% Offline • Kein Daten-Tracking"
        },
        footer: {
            desc: "100% offline SMS- und Anruf-Spamfilter für iOS mit absolutem Datenschutz.",
            linksHeading: "Navigation",
            legalHeading: "Rechtliches",
            privacy: "Datenschutzerklärung",
            terms: "Nutzungsbedingungen",
            support: "Support",
            copyright: "Alle Rechte vorbehalten."
        },
        misc: { skipLink: "Zum Inhalt springen", toggleNav: "Navigation umschalten", langLabel: "Sprache" }
    },

    fr: {
        nav: {
            features: "Fonctionnalités",
            presets: "Packs Intelligents",
            simulator: "Simulateur",
            howItWorks: "Fonctionnement",
            privacy: "Confidentialité",
            faq: "FAQ",
            download: "Télécharger"
        },
        hero: {
            title: "Bloquez le Spam SMS & Appels sur {iOS}",
            subtitle: "Le bouclier 100% hors-ligne et respectueux de votre vie privée. Neutralisez les arnaques de colis, casino et démarchage sans aucun traçage.",
            btnDownload: "Télécharger sur l'App Store",
            btnLearnMore: "En savoir plus",
            badges: ["100% Hors-ligne & Privé", "Packs Anti-Arnaques", "Simulateur Interactif"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "Sur l'appareil & Hors-ligne",
            stat2Value: "0", stat2Label: "Données transmises",
            stat3Value: "11", stat3Label: "Langues supportées",
            stat4Value: "iOS 18", stat4Label: "Frameworks officiels Apple"
        },
        features: {
            badge: "Fonctionnalités",
            title: "Une protection puissante et privée",
            subtitle: "Conçu avec les frameworks natifs d'Apple pour garantir la tranquillité de vos communications.",
            items: [
                { title: "Packs de Protection Intelligente", desc: "Blocage en 1 clic des arnaques au faux colis, casino, crédits abusifs et fausses offres d'emploi." },
                { title: "Bac à Sable Interactif", desc: "Simulez et vérifiez le comportement de vos règles avant la réception de vrais messages." },
                { title: "Filtre SMS Indésirables Natif", desc: "Redirige silencieusement les spams vers l'onglet Indésirables d'iOS." },
                { title: "Bloqueur d'Appels CallKit", desc: "Supprime les appels commerciaux frauduleux directement au niveau du système iOS." },
                { title: "Règles d'Indicatifs & Préfixes", desc: "Bloquez par indicatif de pays (+XX), séries de numéros ou préfixes régionaux." },
                { title: "Protection OTP & Codes Bancaires", desc: "Garantit que les codes de vérification 2FA et vos proches arrivent toujours." },
                { title: "Architecture 100% Hors-ligne", desc: "Aucun serveur cloud, aucun compte, aucun siphonnage de contacts." },
                { title: "Sauvegarde & Restauration JSON", desc: "Exportez vos listes de blocage en 1 clic pour les transférer sur un autre iPhone." }
            ]
        },
        presets: {
            badge: "Sécurité",
            title: "Packs de Protection en 1 Clic",
            subtitle: "Activez des boucliers adaptés aux arnaques mobiles courantes en France et dans le monde francophone.",
            items: [
                { icon: "🎰", name: "Casinos & Paris en Ligne", desc: "Spams de tours gratuits, machines à sous et incitations aux paris sportifs." },
                { icon: "📦", name: "Faux Colis & Frais de Douane", desc: "Avis de passage frauduleux imitant Colissimo, Mondial Relay ou Chronopost." },
                { icon: "💳", name: "Prêts & Crédits Rapides", desc: "Offres abusives d'argent facile, rachat de crédit et faux dédommagements." },
                { icon: "🎁", name: "Faux Gains & Tirages au Sort", desc: "Alertes de cartes-cadeaux offertes et arnaques aux faux concours." },
                { icon: "💼", name: "Arnaques Emploi & Crypto", desc: "Sollicitations non sollicitées via WhatsApp ou Telegram pour de faux jobs." }
            ]
        },
        simulator: {
            badge: "Bac à Sable",
            title: "Simulateur de Règles Interactif",
            subtitle: "Testez n'importe quel numéro ou texte pour vérifier instantanément la décision de filtrage.",
            testSender: "Expéditeur : +33 6 12 34 56 78",
            testBody: "Votre colis est retenu en douane. Veuillez régler la taxe sur : colis-douane-suivi.xyz",
            simStatus: "ÉVALUATION DE SIMULATION",
            simBadge: "FILTRÉ : INDÉSIRABLE",
            simExplanation: "Règle correspondante : 'Pack Faux Colis' → Action : Déplacé vers Indésirables iOS (Silencieux)"
        },
        howItWorks: {
            badge: "Démarrage",
            title: "Protégé en 3 Étapes Simples",
            subtitle: "Configuration instantanée sans aucune création de compte.",
            steps: [
                { num: "1", title: "Téléchargez Gratuitement", desc: "Installez Safe Message Shield directement depuis l'App Store." },
                { num: "2", title: "Activez les Extensions", desc: "Activez Safe Message Shield dans Réglages iOS > Messages & Téléphone." },
                { num: "3", title: "Retrouvez la Sérénité", desc: "Les spams vont dans les indésirables et les faux appels sont bloqués." }
            ]
        },
        privacy: {
            badge: "Vie Privée",
            title: "Pourquoi nous sommes fondamentalement plus sûrs",
            subtitle: "Contrairement aux applications d'identification d'appel classiques, nous ne collectons aucune donnée.",
            legacyTitle: "Autres Applications",
            legacyItems: [
                "Téléchargent votre répertoire complet sur des serveurs distants",
                "Analysent le contenu de vos messages dans le cloud",
                "Monétisent vos métadonnées auprès de régies publicitaires",
                "Imposent des abonnements hebdomadaires abusifs"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "Traitement 100% local via les API officielles IdentityLookup & CallKit",
                "Ne lit ni ne télécharge jamais votre carnet d'adresses",
                "Zéro traceur publicitaire, zéro outil d'analyse tiers",
                "Exportation et importation de règles JSON transparente et gratuite"
            ]
        },
        faq: {
            badge: "FAQ",
            title: "Questions Fréquentes",
            subtitle: "Tout ce que vous devez savoir sur SafeMessageShield et la protection iOS.",
            items: [
                { q: "SafeMessageShield peut-il lire mes anciens SMS ?", a: "Non. Le système iOS interdit formellement l'accès à l'historique des messages. Seuls les nouveaux SMS entrants sont analysés." },
                { q: "Mes contacts sont-ils envoyés sur un serveur ?", a: "Jamais. SafeMessageShield fonctionne 100% hors-ligne sur votre iPhone." },
                { q: "Les codes de vérification bancaire (OTP / 2FA) sont-ils bloqués ?", a: "Non. La liste blanche intégrée préserve les banques et vos contacts importants." },
                { q: "L'application doit-elle rester ouverte en arrière-plan ?", a: "Non. Les extensions iOS s'exécutent automatiquement au niveau du système d'exploitation." },
                { q: "Comment fonctionne le simulateur ?", a: "Il reproduit exactement le moteur de filtrage pour vous permettre de tester n'importe quel texte." },
                { q: "Puis-je transférer mes règles vers un nouvel iPhone ?", a: "Oui ! Utilisez la fonction d'exportation JSON en 1 clic pour sauvegarder et restaurer vos listes." }
            ]
        },
        download: {
            title: "Reprenez le Contrôle de Votre Téléphone",
            subtitle: "Profitez d'une messagerie calme et sécurisée. Téléchargez gratuitement sur l'App Store.",
            appstoreAlt: "Télécharger Safe Message Shield sur l'App Store",
            note: "Nécessite iOS 18.0 ou supérieur • 100% Hors-ligne • Aucune Collecte de Données"
        },
        footer: {
            desc: "Filtre anti-spam SMS et bloqueur d'appels 100% hors-ligne pour iOS.",
            linksHeading: "Navigation",
            legalHeading: "Légal",
            privacy: "Politique de Confidentialité",
            terms: "Conditions d'Utilisation",
            support: "Assistance",
            copyright: "Tous droits réservés."
        },
        misc: { skipLink: "Aller au contenu", toggleNav: "Basculer la navigation", langLabel: "Langue" }
    },

    es: {
        nav: {
            features: "Funciones",
            presets: "Paquetes Inteligentes",
            simulator: "Simulador",
            howItWorks: "Cómo Funciona",
            privacy: "Privacidad",
            faq: "Preguntas",
            download: "Descargar"
        },
        hero: {
            title: "Detén el Spam de SMS y Llamadas en {iOS}",
            subtitle: "El escudo 100% offline y centrado en la privacidad. Bloquea apuestas, paquetes falsos y llamadas molestas sin rastreo de datos.",
            btnDownload: "Descargar en App Store",
            btnLearnMore: "Saber más",
            badges: ["100% Offline y Privado", "Paquetes Anti-Fraude", "Simulador Interactivo"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "En el dispositivo y Offline",
            stat2Value: "0", stat2Label: "Datos recopilados",
            stat3Value: "11", stat3Label: "Idiomas admitidos",
            stat4Value: "iOS 18", stat4Label: "Tecnología oficial Apple"
        },
        features: {
            badge: "Funciones",
            title: "Defensa potente y privada",
            subtitle: "Construido con las herramientas nativas de Apple para garantizar tu tranquilidad comunicativa.",
            items: [
                { title: "Paquetes de Protección Inteligente", desc: "Bloqueo con 1 toque de estafas de paquetes, apuestas, créditos abusivos y trabajos falsos." },
                { title: "Simulador Interactivo", desc: "Comprueba cómo reaccionan tus reglas ante cualquier remitente o mensaje antes de recibirlo." },
                { title: "Filtro SMS Nativo a Correo No Deseado", desc: "Envía los SMS molestos a la bandeja de No deseados sin molestar con vibraciones." },
                { title: "Bloqueo de Llamadas CallKit", desc: "Rechaza llamadas comerciales fraudulentas directamente a nivel del sistema." },
                { title: "Reglas de Prefijos y Países", desc: "Bloquea por código de país (+XX), prefijo de operador o secuencias de dígitos." },
                { title: "Protección OTP y Códigos Bancarios", desc: "Asegura que los códigos de seguridad de tu banco y familiares lleguen siempre." },
                { title: "Arquitectura 100% Offline", desc: "Sin servidores remotos, sin cuentas de usuario, sin copiar tu agenda." },
                { title: "Copia de Seguridad JSON", desc: "Exporta e importa tus listas de filtros en formato estándar JSON fácilmente." }
            ]
        },
        presets: {
            badge: "Protección",
            title: "Paquetes de Protección Inteligente",
            subtitle: "Activa con un solo toque filtros especializados contra el spam en España y Latinoamérica.",
            items: [
                { icon: "🎰", name: "Apuestas y Casinos", desc: "Giros gratis, ruletas, máquinas tragamonedas y pronósticos deportivos." },
                { icon: "📦", name: "Paquetería Falsa y Aduanas", desc: "Avisos falsos de entregas retenidas o pago de tasas de Correos o DHL." },
                { icon: "💳", name: "Préstamos Engañosos", desc: "Dinero rápido, préstamos sin aval y falsas promesas de cancelación de deudas." },
                { icon: "🎁", name: "Premios y Tarjetas de Regalo", desc: "Falsos sorteos, cheques regalo y enlaces de encuestas trampa." },
                { icon: "💼", name: "Ofertas de Empleo y Cripto", desc: "Estafas de trabajo desde casa enviadas por WhatsApp o Telegram." }
            ]
        },
        simulator: {
            badge: "Simulador",
            title: "Simulador de Reglas en Vivo",
            subtitle: "Prueba cómo evalúan tus filtros cualquier mensaje antes de que llegue a tu teléfono.",
            testSender: "Remitente: +34 600 000 000",
            testBody: "Su paquete no se pudo entregar. Actualice dirección en: correos-entrega-tasa.xyz",
            simStatus: "EVALUACIÓN DE PRUEBA",
            simBadge: "FILTRADO: NO DESEADO",
            simExplanation: "Regla detectada: 'Paquete de Paquetería' → Acción: Movido a No deseados (Silencioso)"
        },
        howItWorks: {
            badge: "Fácil",
            title: "Protegido en 3 Pasos",
            subtitle: "Configuración sencilla y sin necesidad de registrarte.",
            steps: [
                { num: "1", title: "Descarga Gratis", desc: "Instala Safe Message Shield desde la App Store." },
                { num: "2", title: "Activa Extensiones", desc: "Activa Safe Message Shield en Ajustes de iOS > Mensajes y Teléfono." },
                { num: "3", title: "Disfruta de la Paz", desc: "Los SMS spam se filtran en silencio y las llamadas sospechosas se bloquean." }
            ]
        },
        privacy: {
            badge: "Privacidad Total",
            title: "Por qué somos más seguros",
            subtitle: "A diferencia de otras apps que comercializan tu agenda, nosotros nunca recopilamos datos.",
            legacyTitle: "Otras Apps de Identificación",
            legacyItems: [
                "Suben tu libreta de contactos entera a sus servidores",
                "Envían tus mensajes entrantes a servidores en la nube",
                "Comparten tus metadatos con empresas de publicidad",
                "Cobran suscripciones semanales abusivas"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "Procesamiento 100% en el dispositivo con IdentityLookup y CallKit",
                "Jamás lee ni extrae tus contactos personales",
                "Cero SDKs de analítica externa, cero rastreadores",
                "Exportación e importación JSON transparente y gratuita"
            ]
        },
        faq: {
            badge: "Preguntas Frecuentes",
            title: "Dudas Habituales",
            subtitle: "Todo lo que necesitas saber sobre SafeMessageShield en iOS.",
            items: [
                { q: "¿Puede SafeMessageShield leer mis mensajes antiguos?", a: "No. iOS bloquea estrictamente el acceso al historial. Las aplicaciones solo pueden evaluar los nuevos SMS entrantes." },
                { q: "¿Se sube mi agenda de contactos a un servidor?", a: "Jamás. La app opera 100% sin conexión a internet." },
                { q: "¿Se bloquearán mis códigos del banco (OTP / 2FA)?", a: "No. La lista blanca protege los remitentes bancarios y a tus contactos clave." },
                { q: "¿La app debe estar abierta en segundo plano?", a: "No. Las extensiones de iOS se activan automáticamente a nivel del sistema." },
                { q: "¿Cómo funciona el simulador?", a: "Ejecuta exactamente el mismo motor de reglas para comprobar el resultado al instante." },
                { q: "¿Puedo transferir mis reglas a otro iPhone?", a: "¡Sí! Exporta la configuración en formato JSON con un toque y restáurala cuando quieras." }
            ]
        },
        download: {
            title: "Recupera la Tranquilidad en tu Teléfono",
            subtitle: "Prueba una bandeja de entrada limpia y silenciosa. Descárgalo gratis en el App Store.",
            appstoreAlt: "Descargar Safe Message Shield en App Store",
            note: "Requiere iOS 18.0 o posterior • 100% Offline • Cero Datos Recopilados"
        },
        footer: {
            desc: "Filtro de SMS y llamadas spam 100% offline para iOS.",
            linksHeading: "Enlaces",
            legalHeading: "Legal",
            privacy: "Política de Privacidad",
            terms: "Términos de Servicio",
            support: "Soporte",
            copyright: "Todos los derechos reservados."
        },
        misc: { skipLink: "Saltar al contenido", toggleNav: "Alternar navegación", langLabel: "Idioma" }
    },

    zh: {
        nav: {
            features: "核心功能",
            presets: "智能预设",
            simulator: "规则模拟",
            howItWorks: "使用说明",
            privacy: "隐私承诺",
            faq: "常见问题",
            download: "免费下载"
        },
        hero: {
            title: "终结 {iOS} 垃圾短信与骚扰电话",
            subtitle: "100% 本地离线运行的隐私守护工具。一键阻断博彩诱导、虚假快递钓鱼及骚扰电销，绝无数据上传，守卫通信安宁。",
            btnDownload: "前往 App Store 下载",
            btnLearnMore: "了解更多",
            badges: ["100% 离线隐私", "一键防诈预设", "沙盒规则模拟器"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "纯本地运行",
            stat2Value: "0", stat2Label: "数据上传",
            stat3Value: "11", stat3Label: "支持语言",
            stat4Value: "iOS 18", stat4Label: "苹果原生架构"
        },
        features: {
            badge: "功能亮点",
            title: "强大而严苛的隐私防御",
            subtitle: "基于 Apple 官方底层框架构建，让您的 iPhone 告别轰炸与骚扰。",
            items: [
                { title: "智能防护预设包", desc: "一键拦截高频博彩广告、虚假物流钓鱼、高利贷及兼职刷单诈骗。" },
                { title: "交互式规则模拟器", desc: "在收到真实短信前，沙盒实时预览当前规则的拦截判定逻辑。" },
                { title: "原生垃圾短信归类", desc: "命中规则的垃圾短信静默归入 iOS 垃圾信息分类，杜绝振动打扰。" },
                { title: "CallKit 骚扰电话拒接", desc: "在系统底层自动拦截或标识推销、诈骗骚扰电话。" },
                { title: "区号与号段批量拦截", desc: "支持按国际区号 (+XX)、特定号段前缀、后缀或数字组合规则批量拦截。" },
                { title: "白名单与验证码护航", desc: "重要银行与亲友号码受专属保护，确保双重认证动态验证码万无一失。" },
                { title: "100% 纯本地离线架构", desc: "无云端服务器、无需注册账户、严禁抓取通讯录，数据仅在手机本地。" },
                { title: "JSON 规则备份与共享", desc: "一键导出与导入自定义规则黑白名单，换机迁移轻松无忧。" }
            ]
        },
        presets: {
            badge: "防诈预设",
            title: "开箱即用的一键防护预设",
            subtitle: "针对高频电信网络诈骗深度提炼的关键词词库，即开即防。",
            items: [
                { icon: "🎰", name: "博彩与赌博广告", desc: "真人视讯、百家乐、免充首存及彩票推广等。" },
                { icon: "📦", name: "虚假快递与关税", desc: "派送失败、更新收货地址、缴纳关税钓鱼链接等。" },
                { icon: "💳", name: "高利贷与信用卡", desc: "秒批到账、无需征信、急用钱及小额极速贷信贷陷阱。" },
                { icon: "🎁", name: "虚假中奖礼品卡", desc: "恭喜中奖、领取大额礼品卡及问卷钓鱼等。" },
                { icon: "💼", name: "兼职与刷单诱饵", desc: "引导至微信或 Telegram 的虚假高薪居家兼职骗局。" }
            ]
        },
        simulator: {
            badge: "沙盒模拟",
            title: "交互式规则判定模拟器",
            subtitle: "在真实短信到达前，任意输入发件人与内容测试规则判定走向。",
            testSender: "发件人: +86 138 0000 0000",
            testBody: "【国际速递】您的包裹因地址不详被滞留，请点击链接缴纳关税：kuaidi-check-fee.xyz",
            simStatus: "模拟判定结果",
            simBadge: "已判定：垃圾短信",
            simExplanation: "命中规则：'虚假快递预设' → 处理方式：移入 iOS 垃圾信息分类（静音）"
        },
        howItWorks: {
            badge: "轻松上手",
            title: "三步开启静默守护",
            subtitle: "极简配置，无需注册任何个人信息。",
            steps: [
                { num: "1", title: "免费下载", desc: "在 App Store 官方商城直接获取 Safe Message Shield。" },
                { num: "2", title: "启用系统扩展", desc: "前往 iPhone“设置 > 信息”与“电话”，勾选启用扩展工具。" },
                { num: "3", title: "告别骚扰", desc: "垃圾短信自动进垃圾箱，骚扰电话自动拦截，静享通信安宁。" }
            ]
        },
        privacy: {
            badge: "隐私守护",
            title: "为何我们更值得信赖？",
            subtitle: "对比需要上传通讯录构建数据库的传统软件，我们坚守零云端、纯本地原则。",
            legacyTitle: "传统来电标记软件",
            legacyItems: [
                "强制将您的完整通讯录上传至远程服务器",
                "将您的通信内容传输到云端做分析",
                "可能将通信元数据售卖给商业电销渠道",
                "基础正则匹配功能却要收取昂贵周卡订阅"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "100% 依托 Apple 官方原生 IdentityLookup 与 CallKit 设备端运算",
                "严禁扫描、读取或上传您的私人联系人",
                "零第三方追踪 SDK，零广告代码，零数据回传",
                "免费、轻量且支持透明 JSON 规则导入导出"
            ]
        },
        faq: {
            badge: "答疑解惑",
            title: "常见问题解答",
            subtitle: "关于 SafeMessageShield 与 iOS 系统级拦截的一切。",
            items: [
                { q: "SafeMessageShield 会读取我的历史旧短信吗？", a: "绝对不会。苹果 iOS 系统严格隔离历史记录，第三方软件无法读取或检索历史短信，仅对新接收到的短信进行独立判定。" },
                { q: "我的通讯录或电话会被上传到云端吗？", a: "绝对不会。本应用代码无任何网络通讯模块，所有规则与匹配运算都在您的 iPhone 本地执行。" },
                { q: "银行动态验证码（OTP）会被误杀拦截吗？", a: "不会。内置白名单已收录主流银行机构，您也可以随时将关键发件人加入信任名单。" },
                { q: "应用需要一直在后台运行吗？", a: "不需要。iOS 系统扩展会常驻底层，即便完全关闭主应用也能自动静默生效。" },
                { q: "模拟器功能有什么用？", a: "模拟器采用与后台完全一致的判定引擎，让您在收到垃圾短信前预览并验证自制规则效果。" },
                { q: "换新 iPhone 时如何迁移规则？", a: "使用一键 JSON 导出功能即可生成备份文件，在新机上导入即可立即还原。" }
            ]
        },
        download: {
            title: "立即重获干净的手机通信",
            subtitle: "体验清爽无打扰的通知体验。现在就前往 App Store 免费下载。",
            appstoreAlt: "前往 App Store 免费下载 Safe Message Shield",
            note: "适配 iOS 18.0 或更高版本 • 100% 离线运行 • 零数据采集"
        },
        footer: {
            desc: "iOS 纯本地离线垃圾短信过滤与骚扰电话智能拦截工具。",
            linksHeading: "快捷导航",
            legalHeading: "法律与隐私",
            privacy: "隐私政策",
            terms: "服务条款",
            support: "技术支持",
            copyright: "版权所有。"
        },
        misc: { skipLink: "跳过并访问主要内容", toggleNav: "切换菜单", langLabel: "语言切换" }
    },

    ja: {
        nav: {
            features: "機能",
            presets: "保護プリセット",
            simulator: "判定テスト",
            howItWorks: "使い方",
            privacy: "プライバシー",
            faq: "よくある質問",
            download: "ダウンロード"
        },
        hero: {
            title: "{iOS} の迷惑SMSと着信を完全シャットアウト",
            subtitle: "100%端末内オフライン動作のプライバシー保護フィルター。不在配達詐欺、カジノ勧誘、迷惑営業電話を個人情報の送信ゼロでブロック。",
            btnDownload: "App Storeでダウンロード",
            btnLearnMore: "詳しく見る",
            badges: ["100% オフライン動作", "詐欺対策プリセット", "判定シミュレーター"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "端末内オフライン",
            stat2Value: "0", stat2Label: "外部データ送信",
            stat3Value: "11", stat3Label: "対応言語",
            stat4Value: "iOS 18", stat4Label: "Apple公式フレームワーク"
        },
        features: {
            badge: "主な機能",
            title: "強力で安全なプライバシー保護",
            subtitle: "Apple公式の安全なフレームワークを採用し、個人情報を完全に守りながら迷惑通信を排除。",
            items: [
                { title: "スマート保護プリセット", desc: "不在配達詐欺、オンラインカジノ、不審な融資、闇バイト勧誘をワンタップで一括ブロック。" },
                { title: "判定シミュレーター", desc: "実際のSMSが届く前に、作成したルールがどう判定されるかサンドボックスで確認可能。" },
                { title: "iOS公式 迷惑メッセージ分類", desc: "不要なメッセージを通知音なしで自動的に「迷惑メッセージ」フォルダへ隔離。" },
                { title: "CallKit 着信拒否機能", desc: "迷惑なセールス電話や詐欺電話を着信音すら鳴らさずシステムレベルで遮断。" },
                { title: "国番号・局番パターンルール", desc: "国際電話識別番号 (+XX) や特定の市外局番、指定の数字列を一括拒否。" },
                { title: "ホワイトリスト＆2要素認証保護", desc: "銀行や重要連絡先を登録し、認証コード (OTP) が確実に届くよう保護。" },
                { title: "完全オフライン設計", desc: "外部サーバーなし、アカウント登録不要、アドレス帳の吸い上げ一切なし。" },
                { title: "JSONバックアップと共有", desc: "ブロックリストをJSON形式で書き出し、機種変更時も一瞬でリストを復元。" }
            ]
        },
        presets: {
            badge: "防犯対策",
            title: "ワンタップ設定の保護プリセット",
            subtitle: "日本国内で多発する悪質なフィッシング詐欺に特化した専用フィルター。",
            items: [
                { icon: "🎰", name: "オンラインカジノ", desc: "入金不要ボーナス、スロット、違法ギャンブルの勧誘メッセージ。" },
                { icon: "📦", name: "不在配達・宅配偽装", desc: "ヤマト運輸や佐川急便などを装う偽の再配達・不在通知リンク。" },
                { icon: "💳", name: "融資・即日現金化", desc: "無審査ローン、ブラックOK、闇金勧誘などの金融詐欺SMS。" },
                { icon: "🎁", name: "当選詐欺・ギフト券", desc: "高額当選、ギフトカードプレゼントを謳う詐欺メッセージ。" },
                { icon: "💼", name: "闇バイト・高額副業", desc: "TelegramやLINEへ誘導する不審な高額求人勧誘。" }
            ]
        },
        simulator: {
            badge: "テスト機能",
            title: "判定シミュレーター",
            subtitle: "任意の番号や文面を入力し、ルールが正しく動作するか事前にテストできます。",
            testSender: "差出人: +81 90 1234 5678",
            testBody: "お客様宛にお荷物のお届けに伺いましたが不在のため持ち帰りました。ご確認ください: sagawa-fake-info.xyz",
            simStatus: "判定テスト結果",
            simBadge: "判定: 迷惑メッセージ",
            simExplanation: "一致ルール: '不在配達プリセット' → アクション: 迷惑メッセージフォルダへ直行（通知なし）"
        },
        howItWorks: {
            badge: "簡単設定",
            title: "3ステップで守りを固める",
            subtitle: "登録手続きなしで、約1分で使い始められます。",
            steps: [
                { num: "1", title: "アプリを入手", desc: "App StoreからSafe Message Shieldをダウンロード。" },
                { num: "2", title: "設定で拡張機能を有効化", desc: "iOSの「設定 > メッセージ」および「電話」で機能をオン。" },
                { num: "3", title: "静かな毎日へ", desc: "迷惑SMSは自動で迷惑フォルダへ、詐欺電話は着信拒否されます。" }
            ]
        },
        privacy: {
            badge: "安心の理由",
            title: "従来のアプリと何が違うのか？",
            subtitle: "連絡先をサーバーへ送信して照合する従来の番号識別アプリとは根本的に異なります。",
            legacyTitle: "従来の番号識別アプリ",
            legacyItems: [
                "アドレス帳全体を外部クラウドへアップロード",
                "受信メッセージのメタデータをサーバーへ送信",
                "広告会社へ通信データを共有するリスク",
                "高額な週額・月額サブスクリプションの課金"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "Apple公式 IdentityLookup & CallKit により端末内100%完結",
                "アドレス帳の読み取りや外部アップロードは一切なし",
                "外部トラッカーや広告SDKの埋め込みはゼロ",
                "無料で透明性の高いJSONルール管理"
            ]
        },
        faq: {
            badge: "よくある質問",
            title: "Q&A",
            subtitle: "SafeMessageShieldの仕組みに関するよくあるご質問。",
            items: [
                { q: "過去の受信メッセージを読み取られますか？", a: "いいえ。Apple iOSのセキュリティ仕様により、アプリが過去のメッセージを閲覧することは一切できません。新たに届くSMSのみ判定されます。" },
                { q: "連絡先データが外部に送信されますか？", a: "一切送信されません。本アプリは通信機能を備えておらず、全ての判定をiPhone端末内で行います。" },
                { q: "銀行のワンタイムパスワード (OTP) が消えることはありますか？", a: "ありません。金融機関の重要メッセージを保護する安全リスト機能が備わっています。" },
                { q: "アプリを常に起動しておく必要がありますか？", a: "不要です。iOSのシステム拡張として機能するため、アプリを終了していても自動でバックグラウンド動作します。" },
                { q: "判定シミュレーターとは何ですか？", a: "実際のSMSが届く前に、作成した設定で正常に振り分けられるかをテストできる機能です。" },
                { q: "新しいiPhoneへ設定を移行できますか？", a: "はい。ワンタップでJSONファイルにエクスポートし、新しい端末でインポート可能です。" }
            ]
        },
        download: {
            title: "平穏なスマートフォンライフを取り戻す",
            subtitle: "静かで安心な受信ボックスを。App Storeから今すぐダウンロード。",
            appstoreAlt: "App StoreでSafe Message Shieldを入手",
            note: "iOS 18.0以降対応 • 100% オフライン • 個人情報の収集ゼロ"
        },
        footer: {
            desc: "iOS専用の完全オフライン迷惑SMS＆着信拒否フィルター。",
            linksHeading: "リンク",
            legalHeading: "法的情報",
            privacy: "プライバシーポリシー",
            terms: "利用規約",
            support: "サポート",
            copyright: "無断転載を禁じます。"
        },
        misc: { skipLink: "メインコンテンツへスキップ", toggleNav: "ナビゲーションの開閉", langLabel: "言語" }
    },

    ko: {
        nav: {
            features: "기능 소개",
            presets: "스마트 팩",
            simulator: "시뮬레이터",
            howItWorks: "사용 방법",
            privacy: "개인정보 보호",
            faq: "자주 묻는 질문",
            download: "다운로드"
        },
        hero: {
            title: "{iOS} 스팸 문자와 광고 전화 완벽 차단",
            subtitle: "100% 오프라인 작동으로 개인정보 유출 걱정 제로. 불법 도박, 가짜 택배 스미싱, 대출 권유 전화를 서버 전송 없이 내 기기에서 직접 차단하세요.",
            btnDownload: "App Store에서 다운로드",
            btnLearnMore: "자세히 알아보기",
            badges: ["100% 오프라인 차단", "원클릭 스마트 팩", "필터 시뮬레이터"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "기기 내 오프라인 연산",
            stat2Value: "0", stat2Label: "외부 수집 데이터",
            stat3Value: "11", stat3Label: "지원 언어",
            stat4Value: "iOS 18", stat4Label: "Apple 공식 프레임워크"
        },
        features: {
            badge: "핵심 기능",
            title: "강력하고 안전한 프라이버시 방패",
            subtitle: "Apple의 공식 최신 보안 기술로 구축되어 개인정보 유출 없이 평화로운 일상을 지켜드립니다.",
            items: [
                { title: "스마트 보호 팩", desc: "불법 도박, 가짜 택배 스미싱, 대출 사기 및 부업 사기 문자를 원클릭으로 일괄 차단." },
                { title: "필터 시뮬레이터", desc: "실제 스팸 문자가 오기 전 내 필터 규칙이 어떻게 동작하는지 샌드박스에서 즉시 검증." },
                { title: "네이티브 정크 문자 격리", desc: "스팸 문자를 알림 소리 없이 iOS의 '정크(스팸)' 보관함으로 자동 격리." },
                { title: "CallKit 광고 전화 차단", desc: "시스템 수준에서 보이스피싱 및 광고 전화를 전화벨조차 울리지 않고 차단." },
                { title: "국번 및 번호 패턴 규칙", desc: "국제 발신 국가번호 (+XX) 또는 특정 지역번호, 번호 패턴 단위의 맞춤 차단." },
                { title: "은행 본인인증(OTP) 보호", desc: "주요 금융기관과 가족 번호를 안전하게 보호하여 2차 인증 문자가 절대 누락되지 않음." },
                { title: "100% 온디바이스 오프라인", desc: "원격 서버 없음, 계정 가입 없음, 연락처 수집 없음. 모든 처리가 기기 내에서 완결." },
                { title: "JSON 백업 및 복원", desc: "나만의 차단 규칙을 JSON 파일로 간편하게 내보내고 새 iPhone으로 쉽게 이전." }
            ]
        },
        presets: {
            badge: "스팸 방어",
            title: "원클릭 스마트 보호 팩",
            subtitle: "국내에서 가장 기승을 부리는 대표적 스팸 및 스미싱 패턴에 맞춘 맞춤형 사전 차단 팩.",
            items: [
                { icon: "🎰", name: "불법 도박 및 카지노", desc: "바카라, 첫충 보너스, 꽁머니, 슬롯 등 사행성 광고 문자 차단." },
                { icon: "📦", name: "택배 미수령 스미싱", desc: "주소지 불명, 통관비 납부 등 악성 링크가 포함된 가짜 배송 조회 문자 방어." },
                { icon: "💳", name: "불법 대출 및 급전", desc: "당일 무서류 대출, 저금리 대환 대출 유혹 등 사기성 금융 스팸 필터링." },
                { icon: "🎁", name: "가짜 경품 및 당첨", desc: "상품권 지급, 이벤트 당첨 사기 및 설문조사 유도 링크 차단." },
                { icon: "💼", name: "부업 및 리딩방 사기", desc: "텔레그램, 카카오톡 오픈채팅방으로 유인하는 가짜 재택알바 차단." }
            ]
        },
        simulator: {
            badge: "샌드박스",
            title: "실시간 필터 시뮬레이터",
            subtitle: "임의의 가상 발신번호나 본문을 입력하여 차단 규칙의 결과를 사전에 확인해보세요.",
            testSender: "발신번호: 010-0000-0000",
            testBody: "[CJ대한통운] 주소지 불명으로 배송이 중단되었습니다. 확인: delivery-check-kr.xyz",
            simStatus: "시뮬레이션 분석 결과",
            simBadge: "판정: 정크(스팸) 분류",
            simExplanation: "일치 규칙: '택배 스미싱 팩' → 조치: iOS 정크 보관함 격리 (무음 처리)"
        },
        howItWorks: {
            badge: "간단 설정",
            title: "단 3단계로 끝나는 설정",
            subtitle: "회원가입 없이 1분 만에 완벽한 스팸 차단을 시작하세요.",
            steps: [
                { num: "1", title: "무료 다운로드", desc: "App Store에서 Safe Message Shield 앱을 다운로드합니다." },
                { num: "2", title: "설정에서 확장 활성화", desc: "iOS '설정 > 메시지' 및 '전화' 메뉴에서 기능을 켭니다." },
                { num: "3", title: "평화로운 일상 시작", desc: "스팸 문자는 조용히 걸러지고, 불필요한 전화는 알아서 차단됩니다." }
            ]
        },
        privacy: {
            badge: "철저한 프라이버시",
            title: "기존 스팸 차단 앱과 완전히 다른 이유",
            subtitle: "내 주소록을 외부 서버로 전송하는 기존 앱들과 달리, 모든 정보가 내 폰 안에만 머뭅니다.",
            legacyTitle: "기존 발신자 번호 식별 앱",
            legacyItems: [
                "사용자의 전체 연락처 목록을 원격 클라우드로 전송",
                "수신된 문자 및 통화 메타데이터를 외부 서버에서 분석",
                "통신 데이터를 광고 네트워크와 공유할 위험성 존재",
                "터무니없이 비싼 주 단위 정기 결제 유도"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "Apple IdentityLookup & CallKit 기반 100% 기기 내 독립 연산",
                "사용자의 주소록이나 개인정보에 절대 접근하거나 업로드하지 않음",
                "서드파티 분석 SDK, 광고 추적 코드 일체 미탑재",
                "무료이며 투명한 표준 JSON 규칙 내보내기/가져오기 지원"
            ]
        },
        faq: {
            badge: "자주 묻는 질문",
            title: "궁금한 점이 있으신가요?",
            subtitle: "SafeMessageShield의 동작 방식에 대한 명쾌한 답변.",
            items: [
                { q: "SafeMessageShield가 내 과거 메시지를 읽을 수 있나요?", a: "절대 불가능합니다. Apple iOS는 보안상 앱의 과거 메시지 접근을 원천 차단합니다. 오직 새롭게 수신되는 문자만 필터링합니다." },
                { q: "연락처나 개인정보가 서버로 전송되나요?", a: "전혀 전송되지 않습니다. 앱 내에 외부 통신 기능이 없으며 모든 연산은 오프라인으로 처리됩니다." },
                { q: "은행 본인인증 번호(OTP)가 차단될 수도 있나요?", a: "그렇지 않습니다. 내장된 스마트 화이트리스트가 주요 금융기관 발신을 안전하게 통과시킵니다." },
                { q: "앱을 백그라운드에 계속 켜두어야 하나요?", a: "아닙니다. iOS 시스템 확장으로 등록되므로 앱을 완전히 닫아도 백그라운드에서 자동 동작합니다." },
                { q: "필터 시뮬레이터는 무엇인가요?", a: "실제 메시지가 오기 전, 내가 만든 규칙이 어떻게 작동하는지 가상 텍스트로 미리 테스트해보는 기능입니다." },
                { q: "새 iPhone으로 규칙을 옮길 수 있나요?", a: "네! 원클릭 JSON 백업 기능을 이용해 파일로 내보낸 뒤 새 기기에서 간편하게 불러올 수 있습니다." }
            ]
        },
        download: {
            title: "깨끗하고 조용한 스마트폰을 되찾으세요",
            subtitle: "스팸 없는 쾌적한 알림 환경. 지금 App Store에서 무료로 시작하세요.",
            appstoreAlt: "App Store에서 Safe Message Shield 다운로드",
            note: "iOS 18.0 이상 지원 • 100% 오프라인 • 개인정보 수집 제로"
        },
        footer: {
            desc: "iOS 전용 100% 오프라인 프라이버시 스팸 문자 & 광고 전화 차단기.",
            linksHeading: "바로가기",
            legalHeading: "법적 고지",
            privacy: "개인정보 처리방침",
            terms: "이용약관",
            support: "고객 지원",
            copyright: "All rights reserved."
        },
        misc: { skipLink: "본문 바로가기", toggleNav: "메뉴 열기/닫기", langLabel: "언어 선택" }
    },

    ar: {
        nav: {
            features: "المميزات",
            presets: "حزم الحماية",
            simulator: "محاكي الفلترة",
            howItWorks: "طريقة العمل",
            privacy: "الخصوصية",
            faq: "الأسئلة الشائعة",
            download: "تحميل"
        },
        hero: {
            title: "تخلص من إزعاج الرسائل والمكالمات على {iOS}",
            subtitle: "الدرع الأمني الأقوى الذي يعمل دون اتصال بالإنترنت بنسبة 100%. احظر رسائل الاحتيال والطرود المزيفة والمكالمات المزعجة دون مشاركة أي بيانات.",
            btnDownload: "تحميل من App Store",
            btnLearnMore: "اكتشف المزيد",
            badges: ["100% دون إنترنت", "حزم حماية فورية", "محاكي قواعد تجريبي"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "معالجة داخل الجهاز",
            stat2Value: "0", stat2Label: "بيانات مسحوبة",
            stat3Value: "11", stat3Label: "لغة مدعومة",
            stat4Value: "iOS 18", stat4Label: "تقنيات Apple الأصلية"
        },
        features: {
            badge: "أبرز الخصائص",
            title: "حماية فائقة وخصوصية مطلقة",
            subtitle: "مصمم بأحدث واجهات Apple الرسمية لضمان راحة بالك وهدوء هاتفك تماماً.",
            items: [
                { title: "حزم الحماية الذكية", desc: "تفعيل فوري لحظر رسائل القمار والطرود المزيفة والقروض الاحتيالية بلمسة واحدة." },
                { title: "محاكي القواعد التفاعلي", desc: "اختبر مسبقاً طريقة تصفية رسائلك في بيئة تجريبية آمنة قبل وصولها الفعلي." },
                { title: "فلترة الرسائل غير المرغوبة", desc: "توجيه الرسائل المزعجة بصمت تام إلى مجلد المهملات (Junk) في نظام iOS." },
                { title: "حظر المكالمات عبر CallKit", desc: "كبح المكالمات الاحتيالية والتسويقية المزعجة على مستوى النظام مباشرة." },
                { title: "قواعد مفاتيح الدول والأنماط", desc: "حظر بالأرقام الدولية (+XX) أو بادئات الأرقام الخاصة بمناطق محددة." },
                { title: "حماية رموز التحقق البنكية (OTP)", desc: "ضمان وصول رسائل البنوك وجهات الاتصال المهمة دون أي تأخير أو حظر." },
                { title: "معمارية محلية 100%", desc: "لا خوادم سحابية، لا تسجيل حساب، ولا سحب لقائمة جهات الاتصال الخاصة بك." },
                { title: "النسخ الاحتياطي بصيغة JSON", desc: "تصدير واستيراد قوائم الحظر بلمسة واحدة لمشاركتها أو نقلها لهاتف جديد." }
            ]
        },
        presets: {
            badge: "مكافحة الاحتيال",
            title: "حزم الحماية الفورية",
            subtitle: "وحدات حماية مصممة خصيصاً لأكثر أشكال الاحتيال والرسائل المزعجة انتشاراً.",
            items: [
                { icon: "🎰", name: "المراهنات والقمار", desc: "حظر روابط المكافآت الترويجية وعروض الكازينو المزعجة." },
                { icon: "📦", name: "احتيال الشحنات والطرود", desc: "منع روابط التصيد التي تدعي تعذر تسليم طرد أو طلب دفع رسوم جمركية." },
                { icon: "💳", name: "القروض المشبوهة", desc: "تصفية عروض التمويل الفوري والقروض غير المعتمدة." },
                { icon: "🎁", name: "الجوائز واليانصيب الوهمي", desc: "حظر الرسائل التي تدعي فوزك بجوائز وهمية وبطاقات تسوق." },
                { icon: "💼", name: "احتيال التوظيف والاستثمار", desc: "كبح رسائل العمل الوهمي الموجهة عبر تيليجرام أو واتساب." }
            ]
        },
        simulator: {
            badge: "بيئة تجريبية",
            title: "محاكي الفلترة التفاعلي",
            subtitle: "اكتب أي رقم هاتف أو نص لتشاهد فوراً كيف ستتعامل معه القواعد قبل وصول الرسالة لهاتفك.",
            testSender: "المرسل: +966 50 000 0000",
            testBody: "تعذر تسليم شحنتك البريدية لعدم وضوح العنوان. يرجى التحديث وسداد الرسوم: postal-fee-check.xyz",
            simStatus: "نتيجة فحص المحاكاة",
            simBadge: "النتيجة: غير مرغوب فيه (Junk)",
            simExplanation: "القاعدة المطابقة: 'حزمة الطرود المزيفة' → الإجراء: نقل لمجلد المهملات بصمت"
        },
        howItWorks: {
            badge: "البدء السريع",
            title: "الحماية في 3 خطوات بسيطة",
            subtitle: "إعداد فوري وسهل دون الحاجة لإنشاء أي حساب.",
            steps: [
                { num: "1", title: "تحميل مجاني", desc: "ثبّت Safe Message Shield مباشرة من متجر App Store." },
                { num: "2", title: "تفعيل الإضافات", desc: "فعّل التطبيق من إعدادات iOS تحت قسم الرسائل والهاتف." },
                { num: "3", title: "استمتع بالهدوء", desc: "تنتقل الرسائل المزعجة للمهملات وتُحظر المكالمات المشبوهة فوراً." }
            ]
        },
        privacy: {
            badge: "خصوصية مطلقة",
            title: "لماذا نعتبر الخيار الأكثر أماناً؟",
            subtitle: "على عكس تطبيقات كاشف الأرقام التي تجمع جهات اتصالك، Safe Message Shield يعمل بالكامل على جهازك.",
            legacyTitle: "تطبيقات كشف الأرقام التقليدية",
            legacyItems: [
                "ترفع كامل سجل أرقامك وعناوينك لخوادم خارجية",
                "ترسل نصوص ومحتوى رسائلك لقواعد بيانات سحابية",
                "تبيع بيانات الاتصال للشركات الإعلانية",
                "تفرض اشتراكات أسبوعية باهظة الثمن"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "معالجة محلية 100% عبر واجهات IdentityLookup و CallKit الرسمية",
                "لا يقرأ ولا يسحب جهات اتصالك الخاصة إطلاقاً",
                "خالٍ تماماً من أدوات التتبع أو الإعلانات التجارية",
                "تصدير واستيراد قواعد الحظر بصيغة JSON مجاناً وبكل شفافية"
            ]
        },
        faq: {
            badge: "الأسئلة الشائعة",
            title: "إجابات على استفساراتك",
            subtitle: "كل ما تود معرفته عن طريقة عمل التطبيق وحمايته على iOS.",
            items: [
                { q: "هل يستطيع التطبيق قراءة رسائلي السابقة؟", a: "مستحيل تماماً. نظام iOS يمنع التطبيقات كلياً من الوصول لسجل الرسائل القديمة. التطبيق يفحص الرسائل الجديدة لحظة وصولها فقط." },
                { q: "هل تُرفع جهات اتصالي لأي خوادم؟", a: "أبداً. التطبيق يعمل دون اتصال بالإنترنت ولا يمتلك أي خوادم لسحب بياناتك." },
                { q: "هل يمكن أن تُحظر رموز البنوك (OTP) المهمة؟", a: "لا. القائمة البيضاء الذكية تحمي الرسائل البنكية وجهات الاتصال الموثوقة دائماً." },
                { q: "هل يجب إبقاء التطبيق مفتوحاً في الخلفية؟", a: "لا داعي لذلك. ملحقات نظام iOS تعمل تلقائياً على مستوى النظام حتى لو أغلقت التطبيق تماماً." },
                { q: "ما هي فائدة المحاكي التفاعلي؟", a: "يتيح لك تجربة فعالية القواعد بنفس المحرك المحلي للتأكد من تصنيف الرسائل قبل وصولها." },
                { q: "هل يمكنني نقل القواعد لهاتف آيفون جديد؟", a: "نعم! بلمسة واحدة يمكنك تصدير القواعد كملف JSON واستيراده على أي جهاز جديد." }
            ]
        },
        download: {
            title: "استعد راحة بالك وهدوء هاتفك اليوم",
            subtitle: "صندوق رسائل نظيف وخالٍ من الإزعاج. حمّل Safe Message Shield الآن مجاناً.",
            appstoreAlt: "تحميل Safe Message Shield من App Store",
            note: "يتطلب نظام iOS 18.0 أو أحدث • يعمل 100% دون إنترنت • دون سحب بيانات"
        },
        footer: {
            desc: "فلتر الرسائل المزعجة وحظر المكالمات الاحتيالية بنسبة 100% دون إنترنت لنظام iOS.",
            linksHeading: "روابط سريعة",
            legalHeading: "قانوني",
            privacy: "سياسة الخصوصية",
            terms: "شروط الاستخدام",
            support: "الدعم الفني",
            copyright: "جميع الحقوق محفوظة."
        },
        misc: { skipLink: "الانتقال للمحتوى", toggleNav: "تبديل القائمة", langLabel: "اللغة" }
    },

    hi: {
        nav: {
            features: "विशेषताएं",
            presets: "सुरक्षा प्रीसेट",
            simulator: "सिम्युलेटर",
            howItWorks: "कार्यप्रणाली",
            privacy: "गोपनीयता",
            faq: "सवाल-जवाब",
            download: "डाउनलोड"
        },
        hero: {
            title: "{iOS} पर स्पैम संदेशों और फर्जी कॉलों से मुक्ति",
            subtitle: "100% ऑफ़लाइन, पूर्ण गोपनीयता-सक्षम मोबाइल शील्ड। कैसीनो, फर्जी पार्सल ट्रैकिंग और धोखाधड़ी कॉलों को बिना किसी डेटा ट्रैकिंग के रोकें।",
            btnDownload: "App Store पर डाउनलोड करें",
            btnLearnMore: "और जानें",
            badges: ["100% ऑफ़लाइन व सुरक्षित", "स्मार्ट सुरक्षा प्रीसेट", "लाइव टेस्ट सिम्युलेटर"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "डिवाइस पर ऑफ़लाइन",
            stat2Value: "0", stat2Label: "डेटा अपलोड",
            stat3Value: "11", stat3Label: "समर्थित भाषाएं",
            stat4Value: "iOS 18", stat4Label: "ऐप्पल आधिकारिक फ्रेमवर्क"
        },
        features: {
            badge: "मुख्य विशेषताएं",
            title: "मजबूत और गोपनीय सुरक्षा",
            subtitle: "Apple के आधिकारिक सुरक्षा फ्रेमवर्क पर निर्मित, ताकि आपका फोन हमेशा शांत और सुरक्षित रहे।",
            items: [
                { title: "स्मार्ट सुरक्षा प्रीसेट", desc: "जुआ, फर्जी पार्सल, फर्जी लोन और पार्ट-टाइम जॉब स्कैम को एक टैप में रोकें।" },
                { title: "लाइव टेस्ट सिम्युलेटर", desc: "संदेश आने से पहले देखें कि आपके नियम उन्हें कैसे पहचानते हैं।" },
                { title: "iOS जंक एसएमएस फिल्टर", desc: "अवांछित संदेशों को बिना आवाज किए सीधे iOS जंक फोल्डर में भेजता है।" },
                { title: "CallKit कॉल ब्लॉकर", desc: "सिस्टम स्तर पर स्पैम कॉलों को रोकता है, फोन की घंटी भी नहीं बजती।" },
                { title: "कंट्री कोड व नंबर नियम", desc: "अंतरराष्ट्रीय कोड (+XX), विशेष ऑपरेटर नंबर या श्रृंखला को ब्लॉक करें।" },
                { title: "बैंक OTP व 2FA सुरक्षा", desc: "विश्वसनीय बैंक और परिवार के नंबर सुरक्षित रहते हैं ताकि जरूरी कोड कभी न छूटें।" },
                { title: "100% ऑफ़लाइन आर्किटेक्चर", desc: "कोई क्लाउड सर्वर नहीं, कोई लॉगिन नहीं, कोई कांटेक्ट अपलोड नहीं।" },
                { title: "JSON बैकअप और शेयरिंग", desc: "एक टैप में अपने नियमों को JSON में सुरक्षित करें और नए फोन पर ट्रांसफर करें।" }
            ]
        },
        presets: {
            badge: "स्कैम सुरक्षा",
            title: "1-टैप स्मार्ट सुरक्षा प्रीसेट",
            subtitle: "भारत में होने वाले सबसे आम मोबाइल फ्रॉड को रोकने के लिए तैयार मॉड्यूल।",
            items: [
                { icon: "🎰", name: "सट्टा व कैसीनो", desc: "सट्टा, कैसीनो बोनस और ऑनलाइन रमी के अवांछित संदेश ब्लॉक करें।" },
                { icon: "📦", name: "फर्जी कूरियर व पार्सल", desc: "पार्सल अटका हुआ है या सीमा शुल्क भुगतान लिंक रोकने वाला फिल्टर।" },
                { icon: "💳", name: "फर्जी लोन ऑफर", desc: "बिना ब्याज वाले लोन, तुरंत कैश और कर्ज मुक्ति के झांसे से बचें।" },
                { icon: "🎁", name: "लॉटरी व इनाम स्कैम", desc: "फर्जी लॉटरी विनर और गिफ्ट कार्ड दावों वाले संदेश रोकें।" },
                { icon: "💼", name: "वर्क फ्रॉम होम स्कैम", desc: "टेलीग्राम या व्हाट्सएप पर ले जाने वाले फर्जी पार्ट-टाइम जॉब विज्ञापन।" }
            ]
        },
        simulator: {
            badge: "टेस्ट लैब",
            title: "इंटरैक्टिव सिम्युलेटर",
            subtitle: "किसी भी फोन नंबर या संदेश को लिखकर देखें कि असली मैसेज आने पर क्या होगा।",
            testSender: "प्रेषक: +91 98765 43210",
            testBody: "आपका पार्सल पते की कमी के कारण रोक दिया गया है। शुल्क भरें: india-post-duty.xyz",
            simStatus: "सिम्युलेशन परिणाम",
            simBadge: "परिणाम: जंक (Junk)",
            simExplanation: "नियम मिला: 'फर्जी कूरियर प्रीसेट' → कार्रवाई: iOS जंक फोल्डर में स्थानांतरित (मूक)"
        },
        howItWorks: {
            badge: "आसान शुरुआत",
            title: "3 आसान चरणों में सुरक्षा",
            subtitle: "बिना किसी रजिस्ट्रेशन के 2 मिनट में शुरू करें।",
            steps: [
                { num: "1", title: "फ्री डाउनलोड करें", desc: "Safe Message Shield को App Store से डाउनलोड करें।" },
                { num: "2", title: "सेटिंग्स ऑन करें", desc: "iOS सेटिंग्स में जाकर मैसेज और फोन फिल्टर को चालू करें।" },
                { num: "3", title: "शांति का अनुभव करें", desc: "स्पैम मैसेज चुपचाप जंक में जाएंगे और फर्जी कॉलें ब्लॉक होंगी।" }
            ]
        },
        privacy: {
            badge: "पूर्ण गोपनीयता",
            title: "हम दूसरों से बेहतर और सुरक्षित क्यों हैं?",
            subtitle: "अन्य कॉलर आईडी ऐप्स की तरह हम आपकी कांटेक्ट लिस्ट कभी अपलोड नहीं करते।",
            legacyTitle: "अन्य कॉलर आईडी ऐप्स",
            legacyItems: [
                "आपकी पूरी फोन कांटेक्ट बुक सर्वर पर अपलोड करते हैं",
                "आपके संदेशों का ब्योरा क्लाउड में प्रोसेस करते हैं",
                "डेटा को विज्ञापन कंपनियों के साथ साझा करते हैं",
                "महंगे साप्ताहिक सब्सक्रिप्शन थोपते हैं"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "Apple IdentityLookup व CallKit के जरिए 100% डिवाइस पर काम करता है",
                "आपकी कांटेक्ट बुक को कभी नहीं पढ़ता और न अपलोड करता है",
                "शून्य ट्रैकर, शून्य विज्ञापन कोड, शून्य डेटा बिक्री",
                "मुफ्त और पारदर्शी JSON बैकअप सुविधा"
            ]
        },
        faq: {
            badge: "सवाल-जवाब",
            title: "अक्सर पूछे जाने वाले प्रश्न",
            subtitle: "SafeMessageShield के बारे में महत्वपूर्ण जानकारी।",
            items: [
                { q: "क्या SafeMessageShield मेरे पुराने संदेश पढ़ सकता है?", a: "बिल्कुल नहीं। iOS सुरक्षा कारणों से पुराने संदेशों को किसी भी ऐप से पूरी तरह अलग रखता है। सिर्फ नए आने वाले मैसेज फिल्टर होते हैं।" },
                { q: "क्या मेरे कांटेक्ट सर्वर पर अपलोड होते हैं?", a: "कभी नहीं। ऐप में कोई सर्वर कोड नहीं है, सब कुछ ऑफ़लाइन होता है।" },
                { q: "क्या बैंक के जरूरी OTP ब्लॉक हो सकते हैं?", a: "नहीं। स्मार्ट व्हाइटलिस्ट बैंक और आवश्यक संपर्कों को हमेशा सुरक्षित रखती है।" },
                { q: "क्या ऐप को बैकग्राउंड में खुला रखना पड़ता है?", a: "नहीं। iOS सिस्टम एक्सटेंशन के रूप में यह ऐप बंद होने पर भी काम करता है।" },
                { q: "सिम्युलेटर कैसे काम करता है?", a: "यह ठीक उसी इंजन का उपयोग करता है जिससे आप संदेशों की जांच पहले ही कर सकते हैं।" },
                { q: "क्या नए फोन पर नियम ट्रांसफर हो सकते हैं?", a: "हाँ! 1-क्लिक JSON बैकअप से आप आसानी से सेटिंग्स दूसरे फोन पर ले जा सकते हैं।" }
            ]
        },
        download: {
            title: "अपने फोन को आज ही स्पैम-मुक्त बनाएं",
            subtitle: "शांत और साफ इनबॉक्स का अनुभव लें। App Store से तुरंत डाउनलोड करें।",
            appstoreAlt: "App Store पर Safe Message Shield डाउनलोड करें",
            note: "iOS 18.0 या बाद का संस्करण आवश्यक • 100% ऑफ़लाइन • कोई डेटा संग्रह नहीं"
        },
        footer: {
            desc: "iOS के लिए 100% ऑफ़लाइन और सुरक्षित एसएमएस व कॉल फिल्टर।",
            linksHeading: "नेविगेशन",
            legalHeading: "कानूनी व नियम",
            privacy: "गोपनीयता नीति",
            terms: "उपयोग की शर्तें",
            support: "सहायता",
            copyright: "सर्वाधिकार सुरक्षित।"
        },
        misc: { skipLink: "मुख्य सामग्री पर जाएं", toggleNav: "मेन्यू टॉगल करें", langLabel: "भाषा" }
    },

    ru: {
        nav: {
            features: "Возможности",
            presets: "Пакеты защиты",
            simulator: "Симулятор",
            howItWorks: "Как это работает",
            privacy: "Приватность",
            faq: "Вопросы и ответы",
            download: "Скачать"
        },
        hero: {
            title: "Блокировка SMS-спама и звонков на {iOS}",
            subtitle: "100% офлайн-щит для вашего спокойствия. Блокируйте казино, фальшивые посылки и спам-звонки без слежки и отправки данных на серверы.",
            btnDownload: "Скачать в App Store",
            btnLearnMore: "Подробнее",
            badges: ["100% Офлайн и Приватно", "Умные пакеты защиты", "Симулятор правил"]
        },
        stats: {
            stat1Value: "100%", stat1Label: "Локально на устройстве",
            stat2Value: "0", stat2Label: "Собрано данных",
            stat3Value: "11", stat3Label: "Языков поддерживается",
            stat4Value: "iOS 18", stat4Label: "Нативные API Apple"
        },
        features: {
            badge: "Возможности",
            title: "Мощная и конфиденциальная защита",
            subtitle: "Создано на базе официальных технологий Apple для тишины и безопасности вашего смартфона.",
            items: [
                { title: "Умные пакеты защиты", desc: "Блокировка казино, фальшивых служб доставок, микрозаймов и сомнительной работы в 1 клик." },
                { title: "Интерактивный симулятор", desc: "Проверьте правила в песочнице на любых номерах и текстах до поступления реальных SMS." },
                { title: "Фильтрация в папку «Спам»", desc: "Перенаправляет нежелательные SMS в системную папку Junk без звука и вибрации." },
                { title: "Блокировка вызовов CallKit", desc: "Глушит назойливые рекламные звонки непосредственно на уровне системы iOS." },
                { title: "Правила для префиксов и стран", desc: "Блокировка по коду страны (+XX), кодам операторов, префиксам или суффиксам." },
                { title: "Защита банковских кодов (OTP)", desc: "Надежные банки и близкие контакты защищены, важные пароли всегда дойдут вовремя." },
                { title: "100% Офлайн-архитектура", desc: "Никаких облачных серверов, учетных записей и копирования телефонной книги." },
                { title: "Резервное копирование в JSON", desc: "Экспорт и импорт правил в 1 клик для удобного переноса на новый iPhone." }
            ]
        },
        presets: {
            badge: "Антиспам",
            title: "Умные пакеты защиты в 1 клик",
            subtitle: "Готовые фильтры, настроенные против самых частых мобильных мошенничеств.",
            items: [
                { icon: "🎰", name: "Казино и ставки", desc: "Фриспины, слоты, нелегальные букмекеры и промокоды." },
                { icon: "📦", name: "Фальшивые посылки", desc: "Ссылки о задержанных посылках, неоплаченных таможенных пошлинах и фишинг." },
                { icon: "💳", name: "Микрозаймы и долги", desc: "Деньги до зарплаты, займы без отказа и списание долгов." },
                { icon: "🎁", name: "Ложные выигрыши", desc: "Выигранные смартфоны, подарочные сертификаты и фальшивые опросы." },
                { icon: "💼", name: "Схемы с удаленной работой", desc: "Спам с предложениями сомнительного заработка в Telegram и WhatsApp." }
            ]
        },
        simulator: {
            badge: "Песочница",
            title: "Интерактивный симулятор правил",
            subtitle: "Введите любой номер или текст сообщения и сразу посмотрите, как отработает фильтр.",
            testSender: "Отправитель: +7 999 123-45-67",
            testBody: "Ваша посылка задержана на таможне. Оплатите пошлину по ссылке: pochta-customs-pay.xyz",
            simStatus: "РЕЗУЛЬТАТ СИМУЛЯЦИИ",
            simBadge: "ОТФИЛЬТРОВАНО: СПАМ",
            simExplanation: "Сработало правило: 'Пакет доставки' → Действие: Перемещено в папку «Спам» (Без звука)"
        },
        howItWorks: {
            badge: "Начало работы",
            title: "Защита за 3 простых шага",
            subtitle: "Быстрое подключение без регистрации учетных записей.",
            steps: [
                { num: "1", title: "Скачайте бесплатно", desc: "Установите Safe Message Shield из App Store." },
                { num: "2", title: "Включите расширения", desc: "Активируйте Safe Message Shield в Настройках iOS (Сообщения и Телефон)." },
                { num: "3", title: "Наслаждайтесь тишиной", desc: "Спам уходит в корзину, а назойливые звонки сбрасываются." }
            ]
        },
        privacy: {
            badge: "Бескомпромиссная приватность",
            title: "Почему мы принципиально безопаснее?",
            subtitle: "В отличие от других определителей номеров, мы никогда не выгружаем ваши данные.",
            legacyTitle: "Обычные определители номеров",
            legacyItems: [
                "Выгружают всю вашу телефонную книгу на сторонние серверы",
                "Передают метаданные ваших сообщений в облако",
                "Продают данные рекламным брокерам",
                "Требуют грабительские еженедельные подписки"
            ],
            smsTitle: "Safe Message Shield",
            smsItems: [
                "100% локальная работа через Apple IdentityLookup и CallKit",
                "Никогда не читает и не передает ваши контакты",
                "Ноль аналитических трекеров, ноль рекламы",
                "Бесплатный и прозрачный экспорт правил в JSON"
            ]
        },
        faq: {
            badge: "FAQ",
            title: "Часто задаваемые вопросы",
            subtitle: "Все, что нужно знать о работе SafeMessageShield на iOS.",
            items: [
                { q: "Может ли приложение читать мои старые сообщения?", a: "Нет. iOS строго блокирует доступ к истории переписки. Приложение оценивает только новые входящие SMS." },
                { q: "Отправляются ли мои контакты на сервер?", a: "Никогда. Приложение работает 100% офлайн на вашем устройстве." },
                { q: "Будут ли заблокированы банковские коды (OTP / 2FA)?", a: "Нет. Встроенный белый список надежно защищает сообщения от банков и важных сервисов." },
                { q: "Нужно ли держать приложение открытым?", a: "Нет. Системные расширения iOS автоматически работают в фоне даже при закрытом приложении." },
                { q: "Как работает симулятор?", a: "Он запускает тот же алгоритм фильтрации, позволяя протестировать любые тексты заранее." },
                { q: "Можно ли перенести правила на новый iPhone?", a: "Да! Функция экспорта в JSON позволяет сохранить все правила и импортировать их на новом смартфоне." }
            ]
        },
        download: {
            title: "Верните спокойствие вашему iPhone",
            subtitle: "Чистая и безопасная переписка без спама. Скачайте бесплатно в App Store.",
            appstoreAlt: "Скачать Safe Message Shield в App Store",
            note: "Требуется iOS 18.0 или новее • 100% Офлайн • Ноль сбора данных"
        },
        footer: {
            desc: "100% офлайн блокировщик спам-сообщений и звонков для iOS.",
            linksHeading: "Навигация",
            legalHeading: "Правовая информация",
            privacy: "Политика конфиденциальности",
            terms: "Условия использования",
            support: "Поддержка",
            copyright: "Все права защищены."
        },
        misc: { skipLink: "Перейти к содержимому", toggleNav: "Переключить меню", langLabel: "Язык" }
    }
};
