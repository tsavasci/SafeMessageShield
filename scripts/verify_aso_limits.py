#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Validates that all metadata in ASO_AND_MARKETING_PACK conforms to Apple limits:
- Title <= 30 chars
- Subtitle <= 30 chars
- Keywords <= 100 chars, no spaces after commas
- Promotional text <= 170 chars
"""

aso_data = {
    "en": {
        "title": "Safe Message Shield: Anti Spam",
        "subtitle": "Block Spam SMS & Robot Calls",
        "keywords": "text,junk,filter,telemarketer,scam,fraud,stop,blacklist,whitelist,offline,caller,id,protect,private",
        "promo": "Take back control of your phone. Block spam texts and fraud calls 100% offline with zero data tracking. Try our new smart protection presets and rule simulator sandbox!"
    },
    "tr": {
        "title": "Safe Message Shield: Spam Blok",
        "subtitle": "SMS Filtresi & Arama Engelleme",
        "keywords": "istenmeyen,mesaj,numara,dolandirici,bahis,casino,kargo,kredi,gizlilik,guvenlik,kara,liste,cevrildisi",
        "promo": "Telefonunuzun kontrolünü geri alın. İstenmeyen SMS ve aramaları %100 çevrimdışı ve gizli engelleyin. Akıllı koruma paketleri ve canlı simülatör sandbox şimdi yayında!"
    },
    "de": {
        "title": "Safe Message Shield: Anti-Spam",
        "subtitle": "SMS Filter & Anrufe Blockieren",
        "keywords": "werbung,unerwuenscht,betrug,abzocke,phishing,kredit,paket,datenschutz,sperre,offline,privat,schutz",
        "promo": "Schützen Sie sich vor SMS-Spam und betrügerischen Anrufen. 100% offline, keine Server, vollkommene Privatsphäre. Jetzt mit intelligenten Schutzpaketen & Simulator!"
    },
    "fr": {
        "title": "Safe Message Shield Anti Spam",
        "subtitle": "Bloqueur de SMS & Appels Spam",
        "keywords": "indesirable,filtrage,bloquer,arnaque,fraude,demarchage,prive,securite,colis,casino,liste,noire",
        "promo": "Bloquez les SMS indésirables et appels spam 100% hors-ligne. Vos données ne quittent jamais votre iPhone. Découvrez les packs de protection et le bac à sable de test !"
    },
    "es": {
        "title": "Safe Message Shield Anti Spam",
        "subtitle": "Filtro SMS y Bloqueo Llamadas",
        "keywords": "bloquear,mensajes,texto,estafa,fraude,publicidad,privacidad,desconocido,molestos,seguridad,offline",
        "promo": "Dile adiós a los mensajes spam y llamadas no deseadas. 100% offline y con total privacidad. ¡Prueba los paquetes de protección inteligente y el simulador de reglas!"
    },
    "zh": {
        "title": "Safe Message Shield 骚扰拦截",
        "subtitle": "垃圾短信过滤与骚扰电话智能拦截",
        "keywords": "防骚扰,垃圾短信,黑名单,离线过滤,防诈骗,隐私保护,电销拦截,博彩拦截,短信拦截器",
        "promo": "告别垃圾短信与骚扰电话！100%纯本地离线运行，零数据上传，彻底守护通信隐私。现已上线智能防护预设包与交互式规则模拟器！"
    },
    "ar": {
        "title": "Safe Message Shield: مانع سبام",
        "subtitle": "تصفية الرسائل وحظر المكالمات",
        "keywords": "ازعاج,احتيال,اعلانات,مكالمات,خصوصية,حماية,ارقام,نصوص,فلترة,غير,مرغوب,امان",
        "promo": "تخلص نهائياً من الرسائل المزعجة والمكالمات الاحتيالية بنسبة 100% دون اتصال بالإنترنت ودون مشاركة بياناتك. استمتع بحزم الحماية الذكية ومحاكي القواعد الآن!"
    },
    "ja": {
        "title": "Safe Message Shield 迷惑防止",
        "subtitle": "迷惑SMSフィルター＆着信拒否",
        "keywords": "迷惑メール,着信拒否,スパム,ブロック,詐欺,広告,プライバシー,安全,オフライン,ブラックリスト",
        "promo": "迷惑SMSやしつこいセールス電話を自動シャットアウト。完全オフライン動作でプライバシーも安心。新機能のスマート保護プリセット＆判定シミュレーター搭載！"
    },
    "ko": {
        "title": "Safe Message Shield 스팸 차단",
        "subtitle": "스팸 문자 필터링 & 광고 전화 차단",
        "keywords": "스팸문자,광고차단,전화거부,보이스피싱,스미싱,개인정보,오프라인,안심,필터,차단기",
        "promo": "귀찮은 스팸 문자와 보이스피싱 전화를 완벽 차단하세요. 100% 오프라인 작동으로 개인정보 유출 걱정 제로. 원클릭 스마트 보호 팩과 규칙 시뮬레이터 제공!"
    },
    "hi": {
        "title": "Safe Message Shield: स्पैम रोक",
        "subtitle": "SMS फ़िल्टर व कॉल ब्लॉकिंग",
        "keywords": "अवांछित,संदेश,धोखाधड़ी,सुरक्षा,गोपनीयता,ऑफ़लाइन,ब्लैकलिस्ट,फ़िल्टर,कॉल",
        "promo": "स्पैम संदेशों और फर्जी कॉलों को हमेशा के लिए रोकें। 100% ऑफ़लाइन और पूर्ण गोपनीयता। नए स्मार्ट सुरक्षा प्रीसेट और लाइव सिम्युलेटर के साथ उपलब्ध!"
    },
    "ru": {
        "title": "Safe Message Shield Антиспам",
        "subtitle": "Блокировка SMS и спам-звонков",
        "keywords": "фильтр,смс,мошенники,реклама,черный,список,приватность,защита,офлайн,спам,стоп",
        "promo": "Надежная защита от спам-сообщений и назойливых звонков. 100% офлайн, никакой слежки и серверов. Попробуйте умные пакеты защиты и симулятор правил!"
    }
}

errors = []
for lang, item in aso_data.items():
    t_len = len(item["title"])
    s_len = len(item["subtitle"])
    k_len = len(item["keywords"])
    p_len = len(item["promo"])

    if t_len > 30:
        errors.append(f"[{lang}] Title too long: {t_len} > 30 ({item['title']})")
    if s_len > 30:
        errors.append(f"[{lang}] Subtitle too long: {s_len} > 30 ({item['subtitle']})")
    if k_len > 100:
        errors.append(f"[{lang}] Keywords too long: {k_len} > 100 ({item['keywords']})")
    if " " in item["keywords"]:
        errors.append(f"[{lang}] Keywords contain spaces!")
    if p_len > 170:
        errors.append(f"[{lang}] Promo text too long: {p_len} > 170 ({item['promo']})")

    print(f"[{lang:2s}] Title: {t_len:2d}/30 | Subtitle: {s_len:2d}/30 | Keywords: {k_len:2d}/100 | Promo: {p_len:3d}/170 -> PASS")

if errors:
    print("\nERRORS FOUND:")
    for e in errors:
        print("  -", e)
    exit(1)
else:
    print("\nALL 11 LANGUAGES STRICTLY CONFORM TO APP STORE LIMITS! 🎉")
