#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SafeMessageShield - Website SEO & Conversion Enhancer
Adds:
- Apple Smart App Banner (<meta name="apple-itunes-app" content="app-id=6755031025">)
- Open Graph & Twitter Cards
- Hreflang & Canonical Links
- Schema.org (SoftwareApplication) JSON-LD structured data with direct App Store URL
- Updates App Store download CTAs with real App Store URL
"""

import os
import re
import json

APP_ID = "6755031025"
APP_STORE_URL = f"https://apps.apple.com/app/id{APP_ID}"
WEBSITE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "website"))

PAGE_CONFIGS = {
    "index.html": {
        "lang": "tr",
        "title": "Safe Message Shield - Spam Mesaj ve Arama Engelleyici (iOS)",
        "desc": "iOS için en güvenli, %100 çevrimdışı ve gizlilik odaklı spam SMS filtreleme ve arama engelleme uygulaması. İstenmeyen mesajlardan kurtulun.",
        "keywords": "SMS engelleme, spam filtre, arama engelleme, istenmeyen mesaj engelleme, iOS spam filtresi, iPhone gizlilik, güvenli SMS",
        "features": ["Otomatik SMS Filtreleme", "İstenmeyen Arama Engelleme", "%100 Çevrimdışı ve Gizli", "Akıllı Koruma Paketleri", "Kural Simülatörü", "Yedekleme ve Geri Yükleme"]
    },
    "index-en.html": {
        "lang": "en",
        "title": "Safe Message Shield - Spam SMS & Call Blocker for iOS",
        "desc": "The most secure, 100% offline, privacy-first spam text and call blocker for iOS. Eliminate unwanted SMS and protect your inbox.",
        "keywords": "SMS blocker, call blocker, spam filter iOS, spam text blocker, iPhone spam filter, privacy blocker, offline SMS filter",
        "features": ["Automatic SMS Filtering", "Spam Call Blocker", "100% Offline & Private", "Smart Protection Presets", "Rule Simulator", "Backup & Restore"]
    },
    "index-de.html": {
        "lang": "de",
        "title": "Safe Message Shield - Spam-SMS & Anruf-Blocker für iOS",
        "desc": "100% offline und privater Spam-Filter für SMS und unerwünschte Anrufe auf dem iPhone. Schützen Sie Ihre Privatsphäre ohne Server.",
        "keywords": "SMS Blocker, Spam Filter iPhone, Anrufe blockieren, Spam SMS sperren, iOS Privatsphäre, Offline Werbeblocker",
        "features": ["Automatische SMS-Filterung", "Anrufblockierung", "100% Offline & Privat", "Schutzpakete", "Filter-Simulator", "Backup & Wiederherstellung"]
    },
    "index-fr.html": {
        "lang": "fr",
        "title": "Safe Message Shield - Bloqueur de Spam SMS & Appels pour iOS",
        "desc": "Bloquez les SMS indésirables et appels spam sur iOS. 100% hors-ligne, aucune donnée ne quitte votre appareil.",
        "keywords": "bloqueur SMS, anti spam iOS, bloquer appels spam, filtre SMS iPhone, sécurité messages, respect vie privée",
        "features": ["Filtrage automatique des SMS", "Blocage d'appels indésirables", "100% Hors-ligne & Privé", "Packs de protection", "Simulateur de règles", "Sauvegarde & Restauration"]
    },
    "index-es.html": {
        "lang": "es",
        "title": "Safe Message Shield - Bloqueador de SMS Spam y Llamadas para iOS",
        "desc": "Bloquee mensajes de texto spam y llamadas no deseadas en iPhone. 100% sin conexión y máxima privacidad.",
        "keywords": "bloqueador SMS, filtro spam iOS, bloquear llamadas spam, anti spam iPhone, privacidad móvil, filtro offline",
        "features": ["Filtrado automático de SMS", "Bloqueo de llamadas spam", "100% Offline y Privado", "Paquetes de protección", "Simulador de reglas", "Copia de seguridad"]
    },
    "index-zh.html": {
        "lang": "zh-Hans",
        "title": "Safe Message Shield - iOS 垃圾短信与骚扰电话拦截器",
        "desc": "专为 iOS 打造的安全、100% 离线、注重隐私的垃圾短信与骚扰电话智能拦截工具。数据不上云，守卫通信安宁。",
        "keywords": "短信拦截, 垃圾短信过滤, 骚扰电话拦截, iOS短信过滤器, iPhone防骚扰, 隐私保护, 离线拦截",
        "features": ["智能垃圾短信过滤", "骚扰来电拦截", "100% 离线与隐私保护", "一键安全预设", "规则沙盒模拟器", "规则备份与恢复"]
    },
    "index-ar.html": {
        "lang": "ar",
        "title": "Safe Message Shield - مانع الرسائل والمكالمات المزعجة لنظام iOS",
        "desc": "حظر الرسائل النصية القصيرة والمكالمات غير المرغوب فيها دون اتصال بالإنترنت مع حماية كاملة لخصوصيتك على iPhone.",
        "keywords": "حظر الرسائل المزعجة, فلتر سبام iOS, حظر المكالمات, حماية الخصوصية, تطبيق حظر إعلانات الرسائل, بدون خوادم",
        "features": ["تصفية الرسائل المزعجة تلقائياً", "حظر المكالمات المزعجة", "100% غير متصل بالإنترنت وخاص", "حزم الحماية الذكية", "محاكي القواعد", "نسخ احتياطي واستعادة"]
    },
    "index-ja.html": {
        "lang": "ja",
        "title": "Safe Message Shield - iOS向け迷惑SMS・着信拒否フィルター",
        "desc": "iPhone向けの100%完全オフライン迷惑SMS＆電話ブロックアプリ。プライバシー保護を徹底し、不要な通知をシャットアウト。",
        "keywords": "SMS拒否, 迷惑メッセージブロック, 着信拒否 iOS, スパムフィルター, iPhone プライバシー, オフラインフィルター",
        "features": ["自動迷惑SMS振り分け", "迷惑着信ブロック", "完全オフライン＆プライバシー保護", "スマート保護プリセット", "シミュレーター機能", "バックアップと復元"]
    },
    "index-ko.html": {
        "lang": "ko",
        "title": "Safe Message Shield - iOS 스팸 문자 및 전화 차단 앱",
        "desc": "iPhone을 위한 100% 오프라인 개인정보 보호 스팸 SMS 및 통화 차단 솔루션. 서버 전송 없는 완벽한 보안.",
        "keywords": "스팸 문자 차단, 스팸 전화 거부, iOS 스팸 필터, 아이폰 문자 필터링, 프라이버시 보호, 오프라인 차단",
        "features": ["스마트 SMS 스팸 필터링", "스팸 통화 자동 차단", "100% 오프라인 & 프라이버시", "원클릭 스마트 보호 팩", "필터 시뮬레이터", "규칙 백업 및 복원"]
    },
    "index-hi.html": {
        "lang": "hi",
        "title": "Safe Message Shield - iOS के लिए स्पैम SMS और कॉल ब्लॉकर",
        "desc": "iPhone के लिए 100% ऑफ़लाइन और सुरक्षित स्पैम संदेश और कॉल ब्लॉकिंग ऐप। पूर्ण गोपनीयता और शून्य डेटा संग्रह।",
        "keywords": "SMS ब्लॉकर, स्पैम फिल्टर iOS, स्पैम कॉल ब्लॉकर, iPhone सुरक्षा, ऑफ़लाइन संदेश फिल्टर, गोपनीयता",
        "features": ["स्वचालित SMS फ़िल्टरिंग", "स्पैम कॉल ब्लॉकिंग", "100% ऑफ़लाइन और सुरक्षित", "स्मार्ट सुरक्षा प्रीसेट", "नियम सिम्युलेटर", "बैकअप और रीस्टोर"]
    },
    "index-ru.html": {
        "lang": "ru",
        "title": "Safe Message Shield - Блокировка спам-SMS и звонков для iOS",
        "desc": "100% автономная и конфиденциальная защита от нежелательных SMS и спам-звонков на iPhone. Ваши данные не покидают устройство.",
        "keywords": "блокировка спама, фильтр SMS iOS, блокировка звонков, антиспам iPhone, приватность, блокировка рекламы",
        "features": ["Автоматическая фильтрация SMS", "Блокировка нежелательных звонков", "100% Офлайн и Приватно", "Умные пакеты защиты", "Песочница-симулятор", "Резервное копирование"]
    }
}

ALL_HREFLANGS = """
    <link rel="alternate" hreflang="tr" href="index.html" />
    <link rel="alternate" hreflang="en" href="index-en.html" />
    <link rel="alternate" hreflang="de" href="index-de.html" />
    <link rel="alternate" hreflang="fr" href="index-fr.html" />
    <link rel="alternate" hreflang="es" href="index-es.html" />
    <link rel="alternate" hreflang="zh-Hans" href="index-zh.html" />
    <link rel="alternate" hreflang="ar" href="index-ar.html" />
    <link rel="alternate" hreflang="ja" href="index-ja.html" />
    <link rel="alternate" hreflang="ko" href="index-ko.html" />
    <link rel="alternate" hreflang="hi" href="index-hi.html" />
    <link rel="alternate" hreflang="ru" href="index-ru.html" />
    <link rel="alternate" hreflang="x-default" href="index-en.html" />"""

def generate_head_tags(filename, config):
    schema_data = {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Safe Message Shield",
        "operatingSystem": "iOS 17.0 and later",
        "applicationCategory": "UtilitiesApplication",
        "url": APP_STORE_URL,
        "downloadUrl": APP_STORE_URL,
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "description": config["desc"],
        "featureList": config["features"],
        "author": {
            "@type": "Person",
            "name": "Tamer Savaşcı"
        }
    }
    schema_json = json.dumps(schema_data, ensure_ascii=False, indent=4)

    tags = f"""    <!-- App Store & SEO Meta Tags -->
    <meta name="apple-itunes-app" content="app-id={APP_ID}">
    <meta name="robots" content="index, follow">
    <link rel="canonical" href="{filename}" />
{ALL_HREFLANGS}

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="{config['title']}">
    <meta property="og:description" content="{config['desc']}">
    <meta property="og:image" content="images/app-preview.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{config['title']}">
    <meta name="twitter:description" content="{config['desc']}">
    <meta name="twitter:image" content="images/app-preview.png">

    <!-- Schema.org SoftwareApplication JSON-LD -->
    <script type="application/ld+json">
{schema_json}
    </script>"""
    return tags

def update_file(filename, config):
    path = os.path.join(WEBSITE_DIR, filename)
    if not os.path.exists(path):
        print(f"Skipping {filename}: not found.")
        return

    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # Update description & keywords
    content = re.sub(
        r'<meta\s+name="description"\s+content="[^"]*"',
        f'<meta name="description" content="{config["desc"]}"',
        content,
        flags=re.IGNORECASE
    )
    content = re.sub(
        r'<meta\s+name="keywords"\s+content="[^"]*"',
        f'<meta name="keywords" content="{config["keywords"]}"',
        content,
        flags=re.IGNORECASE
    )
    content = re.sub(
        r'<title>[^<]*</title>',
        f'<title>{config["title"]}</title>',
        content,
        flags=re.IGNORECASE
    )

    # Clean existing injected SEO block
    content = re.sub(r'\s*<!-- App Store & SEO Meta Tags -->.*?<\/script>', '', content, flags=re.DOTALL)

    # Insert before </head>
    head_tags = generate_head_tags(filename, config)
    replacement = f"\n{head_tags}\n</head>"
    content = re.sub(r'</head>', replacement, content, count=1, flags=re.IGNORECASE)

    # Update download CTA links to point directly to the App Store
    content = re.sub(
        r'<a\s+href="[^"]*"\s+class="btn-download"',
        f'<a href="{APP_STORE_URL}" target="_blank" rel="noopener noreferrer" class="btn-download"',
        content
    )
    content = re.sub(
        r'<a\s+href="#download"\s+class="btn-hero"',
        f'<a href="{APP_STORE_URL}" target="_blank" rel="noopener noreferrer" class="btn-hero"',
        content
    )

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Updated {filename} successfully with App ID {APP_ID}.")

def main():
    print(f"Injecting App ID {APP_ID} and SEO into {WEBSITE_DIR}...")
    for filename, config in PAGE_CONFIGS.items():
        update_file(filename, config)
    print("All website pages updated with real App Store links and metadata!")

if __name__ == "__main__":
    main()
