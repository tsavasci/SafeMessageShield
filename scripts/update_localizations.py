import os

langs = ["en", "tr", "de", "fr", "es", "zh-Hans", "ar", "ja", "ko", "hi", "ru"]

# Dictionary of all new keys with translations in 11 languages
keys_data = {
    "presets.nav.title": {
        "en": "Spam Protection Packs", "tr": "Spam Koruma Paketleri", "de": "Spam-Schutzpakete",
        "fr": "Packs Anti-Spam", "es": "Paquetes Anti-Spam", "zh-Hans": "垃圾信息防护包",
        "ar": "حزم الحماية من الرسائل المزعجة", "ja": "迷惑メッセージ対策パック", "ko": "스팸 방지 패키지",
        "hi": "स्पैम सुरक्षा पैक", "ru": "Пакеты защиты от спама"
    },
    "presets.header.title": {
        "en": "One-Tap Protection Packs", "tr": "Tek Dokunuşla Koruma", "de": "Ein-Klick Schutzpakete",
        "fr": "Packs de Protection Rapide", "es": "Protección con un Toque", "zh-Hans": "一键启用防护包",
        "ar": "حزم حماية بلمسة واحدة", "ja": "ワンタップ保護パック", "ko": "원터치 보호 패키지",
        "hi": "वन-टैप सुरक्षा पैक", "ru": "Защитные пакеты в одно касание"
    },
    "presets.header.subtitle": {
        "en": "Quickly block common scams, casino, loans and phishing messages.",
        "tr": "Kumar, sahte kargo, kredi ve dolandırıcılık mesajlarını anında engelleyin.",
        "de": "Blockieren Sie Casino-, Kredit- und Phishing-Nachrichten sofort.",
        "fr": "Bloquez instantanément les arnaques, casinos et faux colis.",
        "es": "Bloquea al instante estafas, casinos y paquetes falsos.",
        "zh-Hans": "即刻拦截博彩、网贷、钓鱼快递与诈骗短信。",
        "ar": "احظر فوراً رسائل الاحتيال والكازينو والطرود المزيفة والقروض.",
        "ja": "カジノ、詐欺、偽の不在通知などの迷惑メッセージを即座にブロック。",
        "ko": "도박, 대출, 피싱 택배 및 사기 문자를 즉시 차단합니다.",
        "hi": "जुआ, फर्जी पार्सल, ऋण और धोखाधड़ी संदेशों को तुरंत ब्लॉक करें।",
        "ru": "Мгновенно блокируйте казино, фальшивые посылки, спам-займы и фишинг."
    },
    "presets.apply.all": {
        "en": "Apply All Packs", "tr": "Tümünü Uygula", "de": "Alle Pakete aktivieren",
        "fr": "Tout Activer", "es": "Aplicar Todos", "zh-Hans": "全部应用",
        "ar": "تطبيق الكل", "ja": "すべて適用", "ko": "전체 적용",
        "hi": "सभी पैक लागू करें", "ru": "Применить все"
    },
    "presets.apply": {
        "en": "Apply", "tr": "Uygula", "de": "Aktivieren",
        "fr": "Activer", "es": "Aplicar", "zh-Hans": "应用",
        "ar": "تطبيق", "ja": "適用", "ko": "적용",
        "hi": "लागू करें", "ru": "Применить"
    },
    "presets.remove": {
        "en": "Remove", "tr": "Kaldır", "de": "Entfernen",
        "fr": "Supprimer", "es": "Eliminar", "zh-Hans": "移除",
        "ar": "إزالة", "ja": "解除", "ko": "제거",
        "hi": "हटाएं", "ru": "Удалить"
    },
    "presets.applied.toast": {
        "en": "%d rules applied", "tr": "%d kural uygulandı", "de": "%d Regeln hinzugefügt",
        "fr": "%d règles appliquées", "es": "%d reglas añadidas", "zh-Hans": "已应用 %d 条规则",
        "ar": "تم تطبيق %d قاعدة", "ja": "%d件のルールを適用しました", "ko": "%d개 규칙 적용됨",
        "hi": "%d नियम लागू किए गए", "ru": "Применено правил: %d"
    },
    "presets.removed.toast": {
        "en": "%d rules removed", "tr": "%d kural kaldırıldı", "de": "%d Regeln entfernt",
        "fr": "%d règles supprimées", "es": "%d reglas eliminadas", "zh-Hans": "已移除 %d 条规则",
        "ar": "تمت إزالة %d قاعدة", "ja": "%d件のルールを解除しました", "ko": "%d개 규칙 제거됨",
        "hi": "%d नियम हटा दिए गए", "ru": "Удалено правил: %d"
    },
    "presets.all.applied.toast": {
        "en": "%d total rules applied", "tr": "Toplam %d kural uygulandı", "de": "Insgesamt %d Regeln angewendet",
        "fr": "%d règles appliquées au total", "es": "Total de %d reglas aplicadas", "zh-Hans": "共应用 %d 条规则",
        "ar": "تم تطبيق إجمالي %d قاعدة", "ja": "合計 %d件のルールを適用しました", "ko": "총 %d개 규칙 적용 완료",
        "hi": "कुल %d नियम लागू किए गए", "ru": "Всего применено правил: %d"
    },
    "preset.betting.title": {
        "en": "Casino & Betting", "tr": "Bahis & Kumar", "de": "Casino & Wetten",
        "fr": "Paris & Casino", "es": "Apuestas y Casino", "zh-Hans": "博彩与赌博",
        "ar": "المراهنات والكازينو", "ja": "カジノ・ギャンブル", "ko": "도박 및 카지노",
        "hi": "सट्टा और कैसीनो", "ru": "Казино и ставки"
    },
    "preset.betting.desc": {
        "en": "Blocks gambling invitations, bonus alerts, and casino promotions.",
        "tr": "Bahis davetleri, bonus bildirimleri ve kumar reklamlarını engeller.",
        "de": "Blockiert Casino-Einladungen, Boni und Wettwerbung.",
        "fr": "Bloque les offres de bonus et publicités de paris/casino.",
        "es": "Bloquea ofertas de bonos y publicidad de juegos de azar.",
        "zh-Hans": "拦截赌场邀请、彩金赠送与下注短信。",
        "ar": "يحظر دعوات المقامرة ومكافآت الرهان والترويج.",
        "ja": "ボーナス通知やオンラインカジノの勧誘をブロックします。",
        "ko": "베팅 초대, 첫충 보너스 및 카지노 광고를 차단합니다.",
        "hi": "जुआ निमंत्रण, बोनस अलर्ट और प्रचार ब्लॉक करता है।",
        "ru": "Блокирует спам казино, рекламу ставок и фриспинов."
    },
    "preset.loan.title": {
        "en": "Unsolicited Loans", "tr": "İzinsiz Kredi & Finans", "de": "Kredit-Spam",
        "fr": "Crédits Non Sollicités", "es": "Préstamos No Solicitados", "zh-Hans": "垃圾贷款短信",
        "ar": "القروض غير المرغوبة", "ja": "迷惑融資・ローン", "ko": "스팸 대출",
        "hi": "अनचाहे ऋण", "ru": "Спам-кредиты и займы"
    },
    "preset.loan.desc": {
        "en": "Filters instant credit offers and unauthorized loan spam.",
        "tr": "Onaysız kredi tekliflerini ve finansal spamları filtreler.",
        "de": "Filtert ungebetene Sofortkredit- und Darlehensangebote.",
        "fr": "Filtre les propositions de crédit instantané non désirées.",
        "es": "Filtra ofertas de crédito rápido y préstamos abusivos.",
        "zh-Hans": "过滤未经请求的即时贷款与额度提升短信。",
        "ar": "يصفي عروض القروض والائتمان الفوري غير المصرح بها.",
        "ja": "無審査融資や即日キャッシングの勧誘をフィルタリングします。",
        "ko": "무담보 대출, 긴급 자금 대출 스팸을 차단합니다.",
        "hi": "तत्काल ऋण प्रस्तावों और स्पैम को फ़िल्टर करता है।",
        "ru": "Фильтрует навязчивые предложения микрозаймов и кредитов."
    },
    "preset.delivery.title": {
        "en": "Fake Delivery Scams", "tr": "Sahte Kargo Takip", "de": "Paket-Phishing",
        "fr": "Faux Suivi de Colis", "es": "Paquetería Falsa", "zh-Hans": "钓鱼快递通知",
        "ar": "احتيال الطرود المزيفة", "ja": "偽不在通知・配達詐欺", "ko": "피싱 택배 사기",
        "hi": "फर्जी पार्सल डिलीवरी", "ru": "Фальшивые службы доставки"
    },
    "preset.delivery.desc": {
        "en": "Catches fake parcel updates and suspicious tracking links.",
        "tr": "Sahte teslimat uyarılarını ve şüpheli kargo linklerini yakalar.",
        "de": "Erkennt betrügerische Benachrichtigungen über angebliche Pakete.",
        "fr": "Intercepte les faux avis de livraison et liens frauduleux.",
        "es": "Detecta avisos de entrega falsos y enlaces sospechosos.",
        "zh-Hans": "识别虚假包裹投递、地址确认与欠费钓鱼链接。",
        "ar": "يكتشف إشعارات الشحن الوهمية وروابط تتبع الطرود المشبوهة.",
        "ja": "不在届や住所確認を騙るフィッシングURLをブロックします。",
        "ko": "배송지 오류, 통관료 납부 유도 등 가짜 택배 문자를 차단합니다.",
        "hi": "फर्जी डिलीवरी अलर्ट और संदिग्ध लिंक को रोकता है।",
        "ru": "Останавливает фальшивые уведомления о доставке и вредоносные ссылки."
    },
    "preset.lottery.title": {
        "en": "Lottery & Gift Traps", "tr": "Hediye & Çekiliş Tuzağı", "de": "Gewinnspiel-Fallen",
        "fr": "Loteries & Fausses Récompenses", "es": "Loterías y Regalos Falsos", "zh-Hans": "中奖与礼品陷阱",
        "ar": "فخاخ الجوائز واليانصيب", "ja": "当選詐欺・偽ギフト", "ko": "당첨 및 경품 사기",
        "hi": "लॉटरी और उपहार के जाल", "ru": "Лотереи и ложные призы"
    },
    "preset.lottery.desc": {
        "en": "Blocks fake prize, gift card, and raffle winner messages.",
        "tr": "Sahte ödül, hediye çeki ve çekiliş kazandınız mesajlarını engeller.",
        "de": "Blockiert gefälschte Gewinnmitteilungen und Gutschein-Fallen.",
        "fr": "Bloque les faux gains de loterie et cartes-cadeaux factices.",
        "es": "Bloquea avisos fraudulentos de premios y cheques regalo.",
        "zh-Hans": "拦截虚假中奖通知、免费礼品卡与转盘抽奖信息。",
        "ar": "يحظر رسائل الفوز بالجوائز الوهمية والبطاقات المجانية.",
        "ja": "「当選しました」等の偽賞金やギフト券詐欺メッセージを防止。",
        "ko": "허위 당첨 문자, 모바일 상품권 지급 유도 사기를 차단합니다.",
        "hi": "नकली इनाम और उपहार कार्ड संदेशों को रोकता है।",
        "ru": "Блокирует сообщения о выигрышах в лотерею и фальшивых купонах."
    },
    "preset.crypto.title": {
        "en": "Crypto & Job Scams", "tr": "Kripto & Sahte İş", "de": "Krypto- & Job-Betrug",
        "fr": "Crypto & Faux Emplois", "es": "Cripto y Empleo Falso", "zh-Hans": "虚假兼职与虚拟币",
        "ar": "احتيال العملات والوظائف", "ja": "副業詐欺・仮想通貨勧誘", "ko": "가상화폐 및 구인 사기",
        "hi": "क्रिप्टो और फर्जी नौकरी", "ru": "Крипта и фальшивые вакансии"
    },
    "preset.crypto.desc": {
        "en": "Protects against Telegram task scams and fake crypto investment offers.",
        "tr": "Günde 1000 TL kazan vaatleri ve kripto dolandırıcılıklarını engeller.",
        "de": "Schützt vor unseriösen Jobangeboten und Krypto-Abzocke.",
        "fr": "Protège contre les arnaques à l'emploi et fausses cryptos.",
        "es": "Protege frente a estafas de trabajo rápido y falsas inversiones.",
        "zh-Hans": "拦截刷单兼职、高回报日结及虚假虚拟货币交易信息。",
        "ar": "يحميك من احتيال مهام التليجرام وعروض العملات المزيفة.",
        "ja": "「誰でも稼げる」等の高額副業勧誘や暗号資産詐欺を防ぎます。",
        "ko": "재택알바 고수익 미끼, 텔레그램 미션 및 가상화폐 사기를 차단합니다.",
        "hi": "टेलीग्राम टास्क घोटालों और नकली निवेश से सुरक्षा।",
        "ru": "Защищает от сомнительных вакансий с легким заработком и криптопирамид."
    },
    "sim.title": {
        "en": "Filter Simulator", "tr": "Filtre Simülatörü", "de": "Filter-Simulator",
        "fr": "Simulateur de Filtre", "es": "Simulador de Filtro", "zh-Hans": "过滤模拟器",
        "ar": "محاكي الفلترة", "ja": "フィルターシミュレータ", "ko": "필터 시뮬레이터",
        "hi": "फ़िल्टर सिम्युलेटर", "ru": "Симулятор фильтрации"
    },
    "sim.header.title": {
        "en": "Interactive Sandbox", "tr": "Canlı Test Laboratuvarı", "de": "Interaktive Sandbox",
        "fr": "Bac à Sable Interactif", "es": "Área de Pruebas", "zh-Hans": "规则测试沙盒",
        "ar": "مختبر الاختبار المباشر", "ja": "リアルタイムテスト環境", "ko": "실시간 테스트 샌드박스",
        "hi": "इंटरैक्टिव सैंडबॉक्स", "ru": "Интерактивная песочница"
    },
    "sim.header.subtitle": {
        "en": "Test how your active rules and blocklists would handle an SMS before it arrives.",
        "tr": "Gelen bir SMS'in kurallarınız ve listeniz tarafından nasıl işleneceğini önceden görün.",
        "de": "Prüfen Sie vorab, wie Ihre aktiven Regeln eine SMS einstufen würden.",
        "fr": "Testez en direct comment vos règles traiteront un futur message entrant.",
        "es": "Comprueba cómo tus reglas procesarán un mensaje antes de recibirlo.",
        "zh-Hans": "在收到短信前，测试当前规则与黑名单的拦截判定。",
        "ar": "اختبر كيف ستتعامل قواعدك النشطة مع الرسائل قبل وصولها.",
        "ja": "設定したルールやブラックリストがSMSをどう判定するかテストできます。",
        "ko": "실제 문자가 도착하기 전 내 규칙이 어떻게 동작하는지 테스트해보세요.",
        "hi": "जांचें कि आपके सक्रिय नियम संदेश आने से पहले उसे कैसे संभालेंगे।",
        "ru": "Проверьте, как сработают ваши правила до поступления реального SMS."
    },
    "sim.input.title": {
        "en": "Test Inputs", "tr": "Test Verileri", "de": "Testdaten",
        "fr": "Données de Test", "es": "Datos de Prueba", "zh-Hans": "测试输入",
        "ar": "مدخلات الاختبار", "ja": "テスト入力", "ko": "테스트 입력",
        "hi": "परीक्षण इनपुट", "ru": "Входные данные"
    },
    "sim.sender.label": {
        "en": "Sender (Number or Name)", "tr": "Gönderen (Numara veya Başlık)", "de": "Absender (Nummer oder Name)",
        "fr": "Expéditeur (Numéro ou Nom)", "es": "Remitente (Número o Nombre)", "zh-Hans": "发件人（号码或标识）",
        "ar": "المرسل (رقم أو اسم)", "ja": "送信者（電話番号または名前）", "ko": "발신자 (전화번호 또는 발신자명)",
        "hi": "प्रेषक (नंबर या नाम)", "ru": "Отправитель (номер или имя)"
    },
    "sim.sender.placeholder": {
        "en": "+1..., BET999, AMAZON", "tr": "+90..., BAHIS, KARGO", "de": "+49..., BONUS, PAKET",
        "fr": "+33..., CASINO, COLIS", "es": "+34..., APUESTAS, CORREOS", "zh-Hans": "+86..., 优惠, 快递通知",
        "ar": "+966..., مكافأة, بريد", "ja": "+81..., カジノ, 不在通知", "ko": "+82..., 당첨, 로젠택배",
        "hi": "+91..., सट्टा, पार्सल", "ru": "+7..., КАЗИНО, ДОСТАВКА"
    },
    "sim.message.label": {
        "en": "Message Body", "tr": "Mesaj Metni", "de": "Nachrichtentext",
        "fr": "Contenu du Message", "es": "Cuerpo del Mensaje", "zh-Hans": "短信内容",
        "ar": "نص الرسالة", "ja": "本文", "ko": "메시지 본문",
        "hi": "संदेश सामग्री", "ru": "Текст сообщения"
    },
    "sim.run.button": {
        "en": "Run Simulation", "tr": "Simülasyonu Çalıştır", "de": "Simulation starten",
        "fr": "Lancer la Simulation", "es": "Ejecutar Simulación", "zh-Hans": "运行测试",
        "ar": "تشغيل المحاكاة", "ja": "判定を実行", "ko": "시뮬레이션 실행",
        "hi": "सिम्युलेशन चलाएं", "ru": "Запустить симуляцию"
    },
    "sim.samples.title": {
        "en": "Quick Test Samples", "tr": "Hızlı Örnekler", "de": "Schnellbeispiele",
        "fr": "Exemples Rapides", "es": "Ejemplos Rápidos", "zh-Hans": "快捷测试样本",
        "ar": "أمثلة سريعة", "ja": "サンプルを試す", "ko": "빠른 샘플",
        "hi": "त्वरित परीक्षण नमूने", "ru": "Быстрые примеры"
    },
    "sim.sample.casino": {
        "en": "Casino Promo", "tr": "Bahis Mesajı", "de": "Casino-Spam",
        "fr": "Promo Casino", "es": "Mensaje Casino", "zh-Hans": "博彩广告",
        "ar": "ترويج كازينو", "ja": "カジノ勧誘", "ko": "카지노 홍보",
        "hi": "कैसीनो प्रोमो", "ru": "Спам казино"
    },
    "sim.sample.casino.body": {
        "en": "Congratulations! Claim your 500 free spins and 100% deposit bonus today at bit.ly/test-casino",
        "tr": "Tebrikler! 500 TL deneme bonusu hesabınıza tanımlandı. Hemen oynamak için: bit.ly/ornek-bahis",
        "de": "Glückwunsch! 500 Freispiele warten auf Sie unter bit.ly/beispiel-casino",
        "fr": "Félicitations ! Profitez de 500 tours gratuits sur bit.ly/exemple-casino",
        "es": "¡Felicidades! Consigue 500 giros gratis y bono del 100% en bit.ly/ejemplo-casino",
        "zh-Hans": "恭喜！您已获得500点体验礼金，立即点击领取：bit.ly/test-casino",
        "ar": "مبروك! تم تفعيل مكافأة 500 ليرة في حسابك، العب الآن عبر الرابط bit.ly/test-casino",
        "ja": "おめでとうございます！500回の無料スピンを獲得しました：bit.ly/test-casino",
        "ko": "축하합니다! 5만 포인트 체험머니가 충전되었습니다. 즉시 확인: bit.ly/test-casino",
        "hi": "बधाई हो! आज ही अपना बोनस प्राप्त करें bit.ly/test-casino",
        "ru": "Поздравляем! Вам начислен бонус 500 фриспинов: bit.ly/test-casino"
    },
    "sim.sample.delivery": {
        "en": "Delivery Phishing", "tr": "Kargo Dolandırıcılığı", "de": "Paket-Phishing",
        "fr": "Faux Colis", "es": "Paquetería Falsa", "zh-Hans": "钓鱼快递",
        "ar": "احتيال طرد", "ja": "不在配達詐欺", "ko": "피싱 택배",
        "hi": "फर्जी पार्सल", "ru": "Фишинг доставки"
    },
    "sim.sample.delivery.body": {
        "en": "Your parcel #US-8891 could not be delivered due to incorrect address. Update it here: bit.ly/track-delivery",
        "tr": "Paketiniz adres eksikliği nedeniyle teslim edilemedi. Adresinizi güncellemek için: bit.ly/kargo-takip",
        "de": "Ihr Paket konnte wegen falscher Adresse nicht zugestellt werden: bit.ly/paket-status",
        "fr": "Votre colis n'a pas pu être livré. Mettez votre adresse à jour: bit.ly/suivi-colis",
        "es": "No se pudo entregar su paquete por dirección incompleta. Actualice aquí: bit.ly/rastreo-entrega",
        "zh-Hans": "您的包裹因地址信息不完整配送失败，请及时更新：bit.ly/track-delivery",
        "ar": "تعذر تسليم طردك بسبب نقص في العنوان، يرجى التحديث: bit.ly/track-delivery",
        "ja": "お届け先住所が不明のため荷物を保留しています。確認はこちら：bit.ly/track-delivery",
        "ko": "주소지 불명으로 배송이 중단되었습니다. 주소 수정: bit.ly/track-delivery",
        "hi": "गलत पते के कारण आपका पार्सल डिलीवर नहीं हो सका: bit.ly/track-delivery",
        "ru": "Ваша посылка задержана из-за неполного адреса. Обновите данные: bit.ly/track-delivery"
    },
    "sim.sample.bank": {
        "en": "Bank Verification", "tr": "Banka Doğrulama", "de": "Bank-SMS",
        "fr": "Code Bancaire", "es": "SMS Bancario", "zh-Hans": "银行验证码",
        "ar": "رمز بنكي", "ja": "銀行認証コード", "ko": "은행 인증번호",
        "hi": "बैंक सत्यापन", "ru": "Банковский код"
    },
    "sim.sample.bank.body": {
        "en": "Your verification code is 849201. Never share this code with anyone.",
        "tr": "Güvenlik kodunuz 849201. Bu kodu kimseyle paylaşmayınız.",
        "de": "Ihr Bestätigungscode lautet 849201. Bitte nicht weitergeben.",
        "fr": "Votre code de sécurité est 849201. Ne le partagez jamais.",
        "es": "Su código de verificación es 849201. No lo comparta con nadie.",
        "zh-Hans": "您的验证码为 849201，请勿向任何人透露。",
        "ar": "رمز التحقق الخاص بك هو 849201. لا تشاركه مع أي شخص.",
        "ja": "認証コードは 849201 です。他人に教えないでください。",
        "ko": "인증번호 [849201] 입니다. 타인에게 절대 공유하지 마세요.",
        "hi": "आपका सत्यापन कोड 849201 है। इसे किसी के साथ साझा न करें।",
        "ru": "Ваш проверочный код 849201. Никому не сообщайте его."
    },
    "sim.action.blocked": {
        "en": "Action: Blocked / Filtered", "tr": "İşlem: Engellendi / Filtrelendi", "de": "Aktion: Blockiert / Gefiltert",
        "fr": "Action : Bloqué / Filtré", "es": "Acción: Bloqueado / Filtrado", "zh-Hans": "判定：已拦截 / 已过滤",
        "ar": "الإجراء: محظور / مفلتر", "ja": "結果: ブロック / 隔離", "ko": "동작: 차단 / 필터링됨",
        "hi": "कार्रवाई: ब्लॉक / फ़िल्टर", "ru": "Действие: Заблокировано / Отфильтровано"
    },
    "sim.action.passed": {
        "en": "Action: Allowed to Inbox", "tr": "İşlem: Gelen Kutusuna İletilir", "de": "Aktion: Posteingang erlaubt",
        "fr": "Action : Autorisé dans la Boîte", "es": "Acción: Permitido en Bandeja", "zh-Hans": "判定：允许进入收件箱",
        "ar": "الإجراء: يُسمح بدخوله للوارد", "ja": "結果: 通常の受信箱へ", "ko": "동작: 정상 수신함 전달",
        "hi": "कार्रवाई: इनबॉक्स में अनुमति दी गई", "ru": "Действие: Допущено во входящие"
    },
    "sim.result.reason": {
        "en": "Evaluation Reason", "tr": "Değerlendirme Gerekçesi", "de": "Entscheidungsbegründung",
        "fr": "Motif de la Décision", "es": "Motivo de la Decisión", "zh-Hans": "判定依据",
        "ar": "سبب التقييم", "ja": "判定理由", "ko": "판단 사유",
        "hi": "मूल्यांकन का कारण", "ru": "Причина решения"
    },
    "sim.result.note": {
        "en": "Simulated offline using your active whitelist, blocklist and keyword rules.",
        "tr": "Aktif güvenli listeniz, kara listeniz ve kelime kurallarınızla cihazınızda simüle edildi.",
        "de": "Lokal mit Ihren aktiven Listen und Schlüsselwortregeln simuliert.",
        "fr": "Simulé localement selon vos listes et règles de mots-clés actives.",
        "es": "Simulado localmente según tus listas y reglas de palabras clave activas.",
        "zh-Hans": "基于设备端已启用的白名单、黑名单与关键词规则离线判定。",
        "ar": "تمت المحاكاة دون اتصال بالإنترنت استناداً إلى قوائمك وقواعدك النشطة.",
        "ja": "設定されたホワイトリスト、ブラックリスト、キーワードに基づき端末内で判定。",
        "ko": "기기에 등록된 허용/차단 번호 및 키워드 규칙을 기반으로 오프라인 평가되었습니다.",
        "hi": "सक्रिय श्वेतसूची, काली सूची और कीवर्ड नियमों से ऑफ़लाइन सिम्युलेट किया गया।",
        "ru": "Рассчитано локально на устройстве по вашим активным спискам и правилам."
    },
    "sim.outcome.allowed.safe": {
        "en": "Allowed (Safe Sender)", "tr": "İzin Verildi (Güvenli Gönderen)", "de": "Erlaubt (Sicherer Absender)",
        "fr": "Autorisé (Expéditeur Sûr)", "es": "Permitido (Remitente Seguro)", "zh-Hans": "已放行（白名单安全发件人）",
        "ar": "مسموح به (مرسل آمن)", "ja": "許可（信頼できる送信者）", "ko": "수신 허용 (안전한 발신자)",
        "hi": "अनुमति (सुरक्षित प्रेषक)", "ru": "Разрешено (белый список)"
    },
    "sim.outcome.blocked.number": {
        "en": "Blocked by Number", "tr": "Numara / Başlık Engelli", "de": "Nummer blockiert",
        "fr": "Numéro Bloqué", "es": "Número Bloqueado", "zh-Hans": "已拦截（黑名单号码/名称）",
        "ar": "محظور برقم أو اسم", "ja": "番号ブロック", "ko": "발신 번호 차단됨",
        "hi": "नंबर द्वारा ब्लॉक", "ru": "Заблокировано по номеру"
    },
    "sim.outcome.blocked.pattern": {
        "en": "Blocked by Pattern Rule", "tr": "Numara Kuralı ile Engellendi", "de": "Musterregel blockiert",
        "fr": "Règle de Motif Bloquée", "es": "Bloqueado por Patrón", "zh-Hans": "已拦截（号码模式规则）",
        "ar": "محظور بنمط الأرقام", "ja": "番号パターン一致によりブロック", "ko": "번호 패턴 일치 차단",
        "hi": "पैटर्न नियम द्वारा ब्लॉक", "ru": "Заблокировано по маске номера"
    },
    "sim.outcome.filtered.keyword": {
        "en": "Filtered by Keyword", "tr": "Kelime Kuralı ile Filtrelendi", "de": "Durch Schlüsselwort gefiltert",
        "fr": "Filtré par Mot-Clé", "es": "Filtrado por Palabra Clave", "zh-Hans": "已过滤（命中关键词）",
        "ar": "مفلتر بكلمة مفتاحية", "ja": "キーワードにより隔離", "ko": "키워드 필터링됨",
        "hi": "कीवर्ड द्वारा फ़िल्टर", "ru": "Отфильтровано по ключевому слову"
    },
    "sim.outcome.allowed.inbox": {
        "en": "Clean Message (Inbox)", "tr": "Temiz Mesaj (Gelen Kutusu)", "de": "Saubere Nachricht (Eingang)",
        "fr": "Message Sain (Boîte)", "es": "Mensaje Limpio (Bandeja)", "zh-Hans": "正常短信（进入收件箱）",
        "ar": "رسالة نظيفة (صندوق الوارد)", "ja": "正常なメッセージ（受信箱）", "ko": "정상 메시지 (수신함)",
        "hi": "सुरक्षित संदेश (इनबॉक्स)", "ru": "Чистое сообщение (входящие)"
    },
    "sim.error.empty.sender": {
        "en": "Sender cannot be empty for simulation.", "tr": "Simülasyon için gönderen boş olamaz.", "de": "Absender darf nicht leer sein.",
        "fr": "L'expéditeur ne peut pas être vide.", "es": "El remitente no puede estar vacío.", "zh-Hans": "发件人不能为空。",
        "ar": "لا يمكن أن يكون المرسل فارغاً.", "ja": "送信者を指定してください。", "ko": "발신자를 입력해주세요.",
        "hi": "प्रेषक खाली नहीं हो सकता।", "ru": "Отправитель не может быть пустым."
    },
    "sim.explanation.allowed.name": {
        "en": "'%@' is in your allowed sender whitelist.", "tr": "'%@' güvenli gönderici listenizde olduğu için izin verildi.", "de": "'%@' ist in Ihrer Positivliste sicherer Absender.",
        "fr": "'%@' est dans votre liste d'expéditeurs autorisés.", "es": "'%@' está en tu lista de remitentes permitidos.", "zh-Hans": "'%@' 在您的安全发件人白名单中。",
        "ar": "تم السماح به لأن '%@' موجود في قائمة المرسلين الموثوقين.", "ja": "'%@' はホワイトリストに登録されています。", "ko": "'%@' 발신자가 허용 목록에 등록되어 있습니다.",
        "hi": "'%@' आपकी श्वेतसूची में है।", "ru": "'%@' находится в списке доверенных отправителей."
    },
    "sim.explanation.allowed.number": {
        "en": "%@ is in your allowed numbers whitelist.", "tr": "%@ güvenli numara listenizde olduğu için izin verildi.", "de": "%@ ist in Ihrer Liste erlaubter Nummern.",
        "fr": "%@ est dans votre liste de numéros autorisés.", "es": "%@ está en tu lista de números permitidos.", "zh-Hans": "%@ 在您的安全号码白名单中。",
        "ar": "تم السماح به لأن %@ موجود في قائمة الأرقام الموثوقة.", "ja": "%@ は信頼できる番号に登録されています。", "ko": "%@ 번호가 허용 목록에 등록되어 있습니다.",
        "hi": "%@ आपकी सुरक्षित नंबर सूची में है।", "ru": "%@ находится в списке доверенных номеров."
    },
    "sim.explanation.blocked.name": {
        "en": "'%@' is in your blocked sender list.", "tr": "'%@' engellenen gönderici listenizde olduğu için engellendi.", "de": "'%@' steht auf Ihrer Sperrliste.",
        "fr": "'%@' est dans votre liste d'expéditeurs bloqués.", "es": "'%@' está en tu lista de remitentes bloqueados.", "zh-Hans": "'%@' 位于您的黑名单中。",
        "ar": "تم الحظر لأن '%@' موجود في قائمة المرسلين المحظورين.", "ja": "'%@' はブロックリストに登録されています。", "ko": "'%@' 발신자가 차단 목록에 등록되어 있습니다.",
        "hi": "'%@' आपकी ब्लॉक सूची में है।", "ru": "'%@' находится в черном списке отправителей."
    },
    "sim.explanation.blocked.number": {
        "en": "%@ is in your blocked numbers list.", "tr": "%@ engellenen numara listenizde olduğu için engellendi.", "de": "%@ steht auf Ihrer Sperrliste.",
        "fr": "%@ est dans votre liste de numéros bloqués.", "es": "%@ está en tu lista de números bloqueados.", "zh-Hans": "%@ 位于您的黑名单中。",
        "ar": "تم الحظر لأن %@ موجود في قائمة الأرقام المحظورة.", "ja": "%@ は着信拒否リストに登録されています。", "ko": "%@ 번호가 차단 목록에 등록되어 있습니다.",
        "hi": "%@ आपकी ब्लॉक नंबर सूची में है।", "ru": "%@ находится в черном списке номеров."
    },
    "sim.explanation.blocked.rule": {
        "en": "Sender matched rule '%@: %@'.", "tr": "Gönderen numarası '%@: %@' kuralıyla eşleştiği için engellendi.", "de": "Absender stimmte mit Regel '%@: %@' überein.",
        "fr": "L'expéditeur correspond à la règle '%@: %@'.", "es": "El remitente coincidió con la regla '%@: %@'.", "zh-Hans": "发件人匹配了规则 '%@: %@'。",
        "ar": "تطابق رقم المرسل مع القاعدة '%@: %@'.", "ja": "番号がルール '%@: %@' に一致しました。", "ko": "발신 번호가 '%@: %@' 규칙과 일치합니다.",
        "hi": "प्रेषक नियम '%@: %@' से मेल खाता है।", "ru": "Отправитель соответствует правилу '%@: %@'."
    },
    "sim.explanation.filtered.keyword": {
        "en": "Message body matched keyword '%@' and will be moved to '%@'.",
        "tr": "Mesaj içeriğindeki '%@' kelimesi nedeniyle '%@' kategorisine filtrelendi.",
        "de": "Nachricht enthielt '%@' und wird nach '%@' verschoben.",
        "fr": "Le message contient '%@' et sera déplacé vers '%@'.",
        "es": "El mensaje contiene '%@' y se moverá a '%@'.",
        "zh-Hans": "短信包含关键词 '%@'，将被归类至 '%@'。",
        "ar": "تم تصنيف الرسالة في فئة '%2$@' بسبب الكلمة '%1$@'.",
        "ja": "本文にキーワード '%@' が含まれるため、'%@' に分類されます。",
        "ko": "메시지에 키워드 '%@'가 포함되어 '%@' 카테고리로 필터링됩니다.",
        "hi": "संदेश में '%@' कीवर्ड पाया गया और इसे '%@' में ले जाया जाएगा।",
        "ru": "Содержит ключевое слово '%@' и перемещено в категорию '%@'."
    },
    "sim.explanation.default.inbox": {
        "en": "No rules matched. Message is delivered normally to your Inbox.",
        "tr": "Hiçbir engelleme veya filtre kuralıyla eşleşmedi. Mesaj normal gelen kutusuna iletilir.",
        "de": "Keine Regel zutreffend. Die Nachricht wird normal zugestellt.",
        "fr": "Aucune règle correspondante. Le message arrive dans la boîte principale.",
        "es": "No coincide con ninguna regla. El mensaje llegará a tu bandeja principal.",
        "zh-Hans": "未命中任何拦截规则，短信将正常进入收件箱。",
        "ar": "لم تتطابق أي قاعدة. ستصل الرسالة كالمعتاد إلى صندوق الوارد.",
        "ja": "一致するルールはありません。メッセージは通常通り受信箱に届きます。",
        "ko": "일치하는 차단 규칙이 없습니다. 메시지는 정상 수신함으로 전달됩니다.",
        "hi": "कोई नियम मेल नहीं खाया। संदेश सामान्य रूप से इनबॉक्स में पहुंचेगा।",
        "ru": "Правила не сработали. Сообщение будет доставлено в обычные входящие."
    },
    "guide.nav.title": {
        "en": "Setup & Diagnostics", "tr": "Kurulum & Teşhis", "de": "Einrichtung & Diagnose",
        "fr": "Configuration & Diagnostic", "es": "Configuración y Diagnóstico", "zh-Hans": "设置与检测指南",
        "ar": "الإعداد والتشخيص", "ja": "設定・診断ガイド", "ko": "설정 및 진단",
        "hi": "सेटअप और निदान", "ru": "Настройка и диагностика"
    },
    "guide.open.button": {
        "en": "Interactive Setup Guide & Diagnostics", "tr": "İnteraktif Kurulum Rehberi & Teşhis", "de": "Interaktiver Einrichtungsassistent",
        "fr": "Guide de Configuration & Diagnostic", "es": "Guía Interactiva de Configuración", "zh-Hans": "交互式设置指南与诊断",
        "ar": "دليل الإعداد التفاعلي والتشخيص", "ja": "設定ガイドと動作確認", "ko": "인터랙티브 설정 가이드 및 진단",
        "hi": "इंटरैक्टिव सेटअप गाइड और निदान", "ru": "Интерактивный мастер настройки"
    },
    "guide.header.title": {
        "en": "Protection Status", "tr": "Koruma Durumu", "de": "Schutzstatus",
        "fr": "État de la Protection", "es": "Estado de la Protection", "zh-Hans": "防护状态检测",
        "ar": "حالة الحماية", "ja": "保護ステータス", "ko": "보호 상태",
        "hi": "सुरक्षा स्थिति", "ru": "Статус защиты"
    },
    "guide.header.subtitle": {
        "en": "Complete these 2 quick steps in iOS Settings to enable full blocking.",
        "tr": "Tam koruma için iOS Ayarlarındaki bu 2 adımı tamamlayın.",
        "de": "Aktivieren Sie diese beiden Schritte in den iOS-Einstellungen für vollen Schutz.",
        "fr": "Complétez ces 2 étapes dans les Réglages iOS pour activer le filtrage.",
        "es": "Completa estos 2 pasos en Ajustes de iOS para activar la protección completa.",
        "zh-Hans": "在 iOS“设置”中完成以下两项开关以开启完整防护。",
        "ar": "أكمل هاتين الخطوتين في إعدادات iOS لتفعيل الحماية الكاملة.",
        "ja": "完全な保護を有効にするには、設定アプリで以下の2項目を完了してください。",
        "ko": "완벽한 차단을 위해 iOS 설정에서 아래 2가지 단계를 활성화하세요.",
        "hi": "पूर्ण सुरक्षा के लिए iOS सेटिंग्स में ये 2 त्वरित कदम पूरे करें।",
        "ru": "Выполните 2 шага в настройках iOS для включения полной блокировки."
    },
    "guide.all.ready.title": {
        "en": "All Systems Shielded!", "tr": "Tüm Korumalar Aktif!", "de": "Vollständig geschützt!",
        "fr": "Protection Maximale Active !", "es": "¡Protección Total Activa!", "zh-Hans": "防护已完全就绪！",
        "ar": "جميع أنظمة الحماية مفعلة!", "ja": "すべての保護が有効です！", "ko": "모든 보호가 활성화되었습니다!",
        "hi": "सभी सुरक्षा प्रणालियां सक्रिय हैं!", "ru": "Все системы защиты активны!"
    },
    "guide.all.ready.subtitle": {
        "en": "SMS filtering and call blocking are properly enabled in iOS.",
        "tr": "SMS filtresi ve arama engelleme iOS üzerinde başarıyla etkinleştirildi.",
        "de": "SMS-Filter und Anrufblocker sind in iOS aktiviert.",
        "fr": "Le filtrage SMS et le blocage d'appels sont activés sur iOS.",
        "es": "El filtro de SMS y el bloqueo de llamadas están activados en iOS.",
        "zh-Hans": "短信过滤与电话拦截已在 iOS 中正确启用。",
        "ar": "تم تمكين تصفية الرسائل وحظر المكالمات بنجاح في نظام iOS.",
        "ja": "SMSフィルタリングと着信拒否が正常に有効化されています。",
        "ko": "SMS 필터링 및 전화 차단이 iOS에서 정상 동작 중입니다.",
        "hi": "SMS फ़िल्टरिंग और कॉल ब्लॉकिंग iOS में ठीक से सक्षम हैं।",
        "ru": "Фильтрация SMS и блокировка звонков успешно включены в iOS."
    },
    "guide.status.active": {
        "en": "Active", "tr": "Aktif", "de": "Aktiv",
        "fr": "Actif", "es": "Activo", "zh-Hans": "已启用",
        "ar": "نشط", "ja": "有効", "ko": "활성",
        "hi": "सक्रिय", "ru": "Активно"
    },
    "guide.status.pending": {
        "en": "Setup Required", "tr": "Ayar Gerekli", "de": "Einrichtung nötig",
        "fr": "Configuration Requise", "es": "Requiere Ajuste", "zh-Hans": "待配置",
        "ar": "مطلوب الإعداد", "ja": "要設定", "ko": "설정 필요",
        "hi": "सेटअप आवश्यक", "ru": "Требуется настройка"
    },
    "guide.confirm": {
        "en": "I Turned It On", "tr": "Açtım, Onayla", "de": "Ich habe es aktiviert",
        "fr": "J'ai activé", "es": "Lo he activado", "zh-Hans": "我已开启",
        "ar": "قمت بتفعيله", "ja": "オンにしました", "ko": "설정 완료",
        "hi": "मैंने इसे चालू कर दिया", "ru": "Я включил"
    },
    "guide.confirmed": {
        "en": "Confirmed", "tr": "Onaylandı", "de": "Bestätigt",
        "fr": "Confirmé", "es": "Confirmado", "zh-Hans": "已确认",
        "ar": "تم التأكيد", "ja": "確認済み", "ko": "확인됨",
        "hi": "पुष्टि की गई", "ru": "Подтверждено"
    },
    "guide.step1.title": {
        "en": "Step 1: Enable SMS Filtering", "tr": "1. Adım: SMS Filtresini Açın", "de": "Schritt 1: SMS-Filter aktivieren",
        "fr": "Étape 1 : Activer le Filtrage SMS", "es": "Paso 1: Activar Filtro SMS", "zh-Hans": "第 1 步：开启信息过滤",
        "ar": "الخطوة 1: تفعيل فلتر الرسائل", "ja": "ステップ1: SMSフィルタを有効化", "ko": "1단계: SMS 필터링 활성화",
        "hi": "कदम 1: SMS फ़िल्टरिंग सक्षम करें", "ru": "Шаг 1: Включите фильтрацию SMS"
    },
    "guide.step1.desc": {
        "en": "Go to iOS Settings > Messages > Unknown & Spam > Select SafeMessageShield.",
        "tr": "iOS Ayarlar > Mesajlar > Bilinmeyenler ve İstenmeyenler > SafeMessageShield'ı seçin.",
        "de": "Gehen Sie zu iOS Einstellungen > Nachrichten > Unbekannt & Spam > SafeMessageShield auswählen.",
        "fr": "Allez dans Réglages iOS > Messages > Inconnus et indésirables > Choisissez SafeMessageShield.",
        "es": "Ve a Ajustes de iOS > Mensajes > Desconocidos y spam > Selecciona SafeMessageShield.",
        "zh-Hans": "前往 iOS 设置 > 信息 > 未知与垃圾信息 > 勾选 SafeMessageShield。",
        "ar": "انتقل إلى إعدادات iOS > الرسائل > غير معروف ومزعج > اختر SafeMessageShield.",
        "ja": "設定 > メッセージ > 不明な差出人および迷惑メッセージ > SafeMessageShield を選択。",
        "ko": "iOS 설정 > 메시지 > 알 수 없는 발신자 및 스팸 > SafeMessageShield 선택.",
        "hi": "iOS सेटिंग्स > संदेश > अज्ञात और स्पैम > SafeMessageShield चुनें।",
        "ru": "Перейдите в Настройки iOS > Сообщения > Неизвестные и спам > Выберите SafeMessageShield."
    },
    "guide.step2.title": {
        "en": "Step 2: Enable Call Blocking", "tr": "2. Adım: Arama Engellemeyi Açın", "de": "Schritt 2: Anrufsperre aktivieren",
        "fr": "Étape 2 : Activer le Blocage d'Appels", "es": "Paso 2: Activar Bloqueo de Llamadas", "zh-Hans": "第 2 步：开启来电阻止",
        "ar": "الخطوة 2: تفعيل حظر المكالمات", "ja": "ステップ2: 着信拒否を有効化", "ko": "2단계: 전화 차단 활성화",
        "hi": "कदम 2: कॉल ब्लॉकिंग सक्षम करें", "ru": "Шаг 2: Включите блокировку вызовов"
    },
    "guide.step2.desc": {
        "en": "Go to iOS Settings > Phone > Call Blocking & Identification > Turn on SafeMessageShield.",
        "tr": "iOS Ayarlar > Telefon > Arama Engelleme ve No. Belirleme > SafeMessageShield'ı açın.",
        "de": "Gehen Sie zu iOS Einstellungen > Telefon > Anrufe blockieren & identifizieren > SafeMessageShield aktivieren.",
        "fr": "Allez dans Réglages iOS > Téléphone > Blocage d'appels et identification > Activez SafeMessageShield.",
        "es": "Ve a Ajustes de iOS > Teléfono > Bloqueo e ident. de llamadas > Activa SafeMessageShield.",
        "zh-Hans": "前往 iOS 设置 > 电话 > 来电阻止与身份识别 > 开启 SafeMessageShield 开关。",
        "ar": "انتقل إلى إعدادات iOS > الهاتف > حظر المكالمات والتعريف بها > قم بتشغيل SafeMessageShield.",
        "ja": "設定 > 電話 > 着信拒否と発信者番号 > SafeMessageShield をオンにする。",
        "ko": "iOS 설정 > 전화 > 전화 차단 및 발신자 확인 > SafeMessageShield 활성화.",
        "hi": "iOS सेटिंग्स > फ़ोन > कॉल ब्लॉकिंग और पहचान > SafeMessageShield चालू करें।",
        "ru": "Перейдите в Настройки iOS > Телефон > Блокировка и идентификация вызова > Включите SafeMessageShield."
    },
    "guide.step3.title": {
        "en": "Step 3: Add Protection Packs", "tr": "3. Adım: Hazır Koruma Paketleri Ekleyin", "de": "Schritt 3: Schutzpakete laden",
        "fr": "Étape 3 : Ajouter des Packs Anti-Spam", "es": "Paso 3: Añadir Paquetes de Protección", "zh-Hans": "第 3 步：一键添加常用防护包",
        "ar": "الخطوة 3: أضف حزم الحماية الجاهزة", "ja": "ステップ3: 対策パックを追加", "ko": "3단계: 추천 스팸 방지 패키지 적용",
        "hi": "कदम 3: सुरक्षा पैक जोड़ें", "ru": "Шаг 3: Добавьте готовые пакеты защиты"
    },
    "guide.step3.desc": {
        "en": "One-tap packs for casinos, fake parcel tracking, and scam loans.",
        "tr": "Bahis, sahte kargo ve kredi tuzaklarına karşı tek dokunuşla hazır kuralları yükleyin.",
        "de": "Ein-Klick-Regeln gegen Casino-, Paket- und Darlehensfallen.",
        "fr": "Activez en un clic les règles contre les casinos, faux colis et faux crédits.",
        "es": "Activa con un toque reglas contra apuestas, paquetería falsa y préstamos sospechosos.",
        "zh-Hans": "一键加载博彩、快递钓鱼、套路贷等高频拦截规则库。",
        "ar": "حمّل بنقرة واحدة قواعد جاهزة لحظر الكازينو والطرود والقروض الاحتيالية.",
        "ja": "カジノ、偽不在通知、違法金融対策のキーワードを一括適用。",
        "ko": "원터치로 도박, 피싱 택배, 스팸 대출 대응 규칙을 등록하세요.",
        "hi": "कैसीनो, फर्जी डिलीवरी और ऋण घोटालों के लिए वन-टैप पैक जोड़ें।",
        "ru": "Установите в один клик правила против казино, фальшивых посылок и спам-займов."
    },
    "guide.step4.title": {
        "en": "Step 4: Test in Simulator", "tr": "4. Adım: Simülatörde Test Edin", "de": "Schritt 4: Im Simulator testen",
        "fr": "Étape 4 : Tester dans le Simulateur", "es": "Paso 4: Probar en el Simulador", "zh-Hans": "第 4 步：在模拟器中验证",
        "ar": "الخطوة 4: اختبر في المحاكي", "ja": "ステップ4: シミュレータで確認", "ko": "4단계: 시뮬레이터에서 검증",
        "hi": "कदम 4: सिम्युलेटर में परीक्षण करें", "ru": "Шаг 4: Проверьте в симуляторе"
    },
    "guide.step4.desc": {
        "en": "Send a mock SMS through our sandbox to verify your rules work exactly as expected.",
        "tr": "Örnek bir mesajla kurallarınızın kusursuz çalıştığını laboratuvarımızda teyit edin.",
        "de": "Überprüfen Sie mit einer Test-SMS, ob Ihre Regeln einwandfrei funktionieren.",
        "fr": "Envoyez un message test pour vérifier que le filtre répond exactement à vos attentes.",
        "es": "Prueba un SMS simulado para comprobar que todo funciona a la perfección.",
        "zh-Hans": "使用测试短信即时验证您的过滤规则是否按预期生效。",
        "ar": "أرسل رسالة تجريبية للتأكد من أن القواعد تعمل بدقة تامة.",
        "ja": "テストメッセージを使ってルールが正しく動作するか検証できます。",
        "ko": "모의 메시지를 입력하여 차단 규칙이 의도대로 동작하는지 확인하세요.",
        "hi": "नियमों के सटीक काम करने की पुष्टि के लिए एक परीक्षण SMS भेजें।",
        "ru": "Отправьте тестовое сообщение в песочнице, чтобы убедиться в правильности работы."
    },
    "backup.nav.title": {
        "en": "Backup & Transfer", "tr": "Yedekle & Aktar", "de": "Sichern & Übertragen",
        "fr": "Sauvegarde & Transfert", "es": "Copia de Seguridad y Transferencia", "zh-Hans": "备份与转移",
        "ar": "النسخ الاحتياطي والنقل", "ja": "バックアップ・移行", "ko": "백업 및 이전",
        "hi": "बैकअप और स्थानांतरण", "ru": "Резервная копия и перенос"
    },
    "backup.header.title": {
        "en": "Rules Backup & Restore", "tr": "Kural Yedekleme & Geri Yükleme", "de": "Regeln sichern & wiederherstellen",
        "fr": "Sauvegarde & Restauration des Règles", "es": "Respaldar y Restaurar Reglas", "zh-Hans": "规则备份与还原",
        "ar": "نسخ احتياطي واستعادة القواعد", "ja": "ルールのバックアップと復元", "ko": "규칙 백업 및 복원",
        "hi": "नियम बैकअप और पुनर्स्थापना", "ru": "Резервная копия и восстановление"
    },
    "backup.header.subtitle": {
        "en": "Safely export your blocklists and custom rules as JSON, or paste to transfer to a new device.",
        "tr": "Kurallarınızı ve engelli listenizi JSON olarak dışa aktarın veya yeni cihazınıza kolayca kopyalayın.",
        "de": "Exportieren Sie Ihre Listen als JSON oder übertragen Sie sie auf ein neues Gerät.",
        "fr": "Exportez vos listes au format JSON ou collez-les sur votre nouvel appareil.",
        "es": "Exporta tus listas en formato JSON o pégalas para transferirlas a otro dispositivo.",
        "zh-Hans": "将黑名单与自定义过滤规则安全导出为 JSON，在新设备上轻松粘贴恢复。",
        "ar": "قم بتصدير القوائم كملف JSON بأمان أو الصقها لنقلها إلى جهاز جديد.",
        "ja": "ブロックリストやカスタムルールをJSON形式で安全に書き出し、新端末へ移行できます。",
        "ko": "차단 목록과 규칙을 JSON으로 안전하게 내보내거나 새 기기로 간편하게 복사하세요.",
        "hi": "अपनी सूचियों को JSON के रूप में निर्यात करें या नए डिवाइस पर स्थानांतरित करें।",
        "ru": "Экспортируйте ваши списки и правила в JSON или скопируйте на новое устройство."
    },
    "backup.export.title": {
        "en": "Export Backup (JSON)", "tr": "Yedek Dışa Aktar (JSON)", "de": "Backup exportieren (JSON)",
        "fr": "Exporter la Sauvegarde (JSON)", "es": "Exportar Copia de Seguridad", "zh-Hans": "导出备份（JSON）",
        "ar": "تصدير نسخة احتياطية (JSON)", "ja": "バックアップを出力（JSON）", "ko": "백업 내보내기 (JSON)",
        "hi": "बैकअप निर्यात करें (JSON)", "ru": "Экспорт резервной копии (JSON)"
    },
    "backup.export.desc": {
        "en": "Create a portable JSON snapshot containing all your numbers and filter keywords.",
        "tr": "Tüm engelli/güvenli numaralarınızı ve kelime kurallarınızı içeren JSON yedeği oluşturun.",
        "de": "Erstellen Sie eine JSON-Datei mit all Ihren Nummern und Schlüsselwörtern.",
        "fr": "Créez une archive JSON contenant tous vos numéros et filtres.",
        "es": "Crea una copia JSON con todos tus números y palabras clave de filtro.",
        "zh-Hans": "生成包含全部黑白名单号码与关键词规则的便携式 JSON 备份。",
        "ar": "أنشئ لقطة JSON تتضمن جميع أرقامك وقواعد الكلمات المفتاحية.",
        "ja": "登録されたすべての番号とキーワードルールを含むJSONファイルを生成します。",
        "ko": "등록된 모든 번호와 키워드 필터를 포함하는 JSON 스냅샷을 생성합니다.",
        "hi": "अपने सभी नंबरों और नियमों का एक पोर्टेबल JSON स्नैपशॉट बनाएं।",
        "ru": "Создайте JSON-файл со всеми заблокированными номерами и правилами фильтрации."
    },
    "backup.export.counts": {
        "en": "%d blocked • %d allowed • %d keywords • %d number rules",
        "tr": "%d engelli • %d güvenli • %d kelime • %d numara kuralı",
        "de": "%d blockiert • %d erlaubt • %d Schlüsselwörter • %d Nummerregeln",
        "fr": "%d bloqués • %d autorisés • %d mots-clés • %d règles de numéro",
        "es": "%d bloqueados • %d permitidos • %d palabras clave • %d reglas numéricas",
        "zh-Hans": "%d 条黑名单 • %d 条白名单 • %d 个关键词 • %d 条号码规则",
        "ar": "%d محظور • %d مسموح • %d كلمات • %d قواعد أرقام",
        "ja": "%d件の着信拒否 • %d件の許可 • %d個のキーワード • %d件の番号ルール",
        "ko": "%d개 차단 • %d개 허용 • %d개 키워드 • %d개 번호 규칙",
        "hi": "%d ब्लॉक • %d अनुमत • %d कीवर्ड • %d नंबर नियम",
        "ru": "%d заблокировано • %d разрешено • %d ключевых слов • %d правил номеров"
    },
    "backup.export.button": {
        "en": "Share / Save Backup JSON", "tr": "Yedek JSON Paylaş / Kaydet", "de": "Backup-JSON teilen / sichern",
        "fr": "Partager / Enregistrer le JSON", "es": "Compartir / Guardar JSON", "zh-Hans": "共享 / 存储备份 JSON",
        "ar": "مشاركة / حفظ ملف JSON", "ja": "バックアップJSONを共有・保存", "ko": "백업 JSON 공유 / 저장",
        "hi": "बैकअप JSON साझा / सहेजें", "ru": "Поделиться / Сохранить JSON"
    },
    "backup.file.name": {
        "en": "SafeMessageShield_Backup.json", "tr": "SafeMessageShield_Yedek.json", "de": "SafeMessageShield_Backup.json",
        "fr": "SafeMessageShield_Sauvegarde.json", "es": "SafeMessageShield_Copia.json", "zh-Hans": "SafeMessageShield_备份.json",
        "ar": "SafeMessageShield_نسخة.json", "ja": "SafeMessageShield_バックアップ.json", "ko": "SafeMessageShield_백업.json",
        "hi": "SafeMessageShield_बैकअप.json", "ru": "SafeMessageShield_Резервная_копия.json"
    },
    "backup.import.title": {
        "en": "Restore from Clipboard", "tr": "Panodan İçe Aktar", "de": "Aus Zwischenablage wiederherstellen",
        "fr": "Restaurer depuis le Presse-papier", "es": "Restaurar desde Portapapeles", "zh-Hans": "从剪贴板导入",
        "ar": "استعادة من الحافظة", "ja": "クリップボードから復元", "ko": "클립보드에서 복원",
        "hi": "क्लिपबोर्ड से पुनर्स्थापित करें", "ru": "Импорт из буфера обмена"
    },
    "backup.import.desc": {
        "en": "Paste a backup JSON below to merge its rules into your local database.",
        "tr": "Yeni kuralları mevcut listenizle birleştirmek için JSON metnini aşağıya yapıştırın.",
        "de": "Fügen Sie das Backup-JSON hier ein, um Ihre Regeln zusammenzuführen.",
        "fr": "Collez le JSON ci-dessous pour fusionner les règles avec votre liste.",
        "es": "Pega el texto JSON abajo para fusionar las reglas con tus listas locales.",
        "zh-Hans": "在下方粘贴备份 JSON 文本，系统将自动合并到现有规则库中。",
        "ar": "الصق نص JSON أدناه لدمج القواعد في قاعدة بياناتك المحلية.",
        "ja": "バックアップJSONを貼り付けると、既存のリストに重複なく統合されます。",
        "ko": "아래에 백업 JSON을 붙여넣으면 기존 데이터에 안전하게 병합됩니다.",
        "hi": "नियमों को अपनी स्थानीय सूची में विलय करने के लिए नीचे JSON चिपकाएं।",
        "ru": "Вставьте текст резервной копии JSON ниже для объединения со своими правилами."
    },
    "backup.paste.clipboard": {
        "en": "Paste from Clipboard", "tr": "Panodan Yapıştır", "de": "Aus Zwischenablage einfügen",
        "fr": "Coller depuis le Presse-papier", "es": "Pegar desde Portapapeles", "zh-Hans": "从剪贴板粘贴",
        "ar": "لصق من الحافظة", "ja": "クリップボードから貼付", "ko": "클립보드에서 붙여넣기",
        "hi": "क्लिपबोर्ड से चिपकाएं", "ru": "Вставить из буфера"
    },
    "backup.import.button": {
        "en": "Import & Merge Rules", "tr": "Kuralları İçe Aktar ve Birleştir", "de": "Regeln importieren & zusammenführen",
        "fr": "Importer et Fusionner", "es": "Importar y Fusionar Reglas", "zh-Hans": "导入并合并规则",
        "ar": "استيراد ودمج القواعد", "ja": "インポートして統合", "ko": "규칙 가져오기 및 병합",
        "hi": "नियम आयात और विलय करें", "ru": "Импортировать и объединить"
    },
    "backup.import.success": {
        "en": "Successfully imported: %d new rules added.", "tr": "Başarıyla içe aktarıldı: %d yeni kural eklendi.", "de": "Erfolgreich importiert: %d neue Regeln hinzugefügt.",
        "fr": "Importation réussie : %d nouvelles règles ajoutées.", "es": "Importado con éxito: %d nuevas reglas añadidas.", "zh-Hans": "导入成功：已添加 %d 条新规则。",
        "ar": "تم الاستيراد بنجاح: تمت إضافة %d قاعدة جديدة.", "ja": "インポート完了：%d件の新しいルールを追加しました。", "ko": "가져오기 성공: %d개의 새 규칙이 추가되었습니다.",
        "hi": "सफलतापूर्वक आयात किया गया: %d नए नियम जोड़े गए।", "ru": "Успешно импортировано: добавлено %d новых правил."
    },
    "settings.rate.app": {
        "en": "Rate on App Store", "tr": "App Store'da Değerlendirin", "de": "Im App Store bewerten",
        "fr": "Noter sur l'App Store", "es": "Valorar en App Store", "zh-Hans": "前往 App Store 评价",
        "ar": "تقييم التطبيق على App Store", "ja": "App Store で評価する", "ko": "App Store 에서 평가하기",
        "hi": "App Store पर समीक्षा करें", "ru": "Оценить в App Store"
    },
    "settings.rate.app.subtitle": {
        "en": "Support our independent, privacy-first spam shield",
        "tr": "Gizlilik odaklı, bağımsız korumamızı destekleyin",
        "de": "Unterstützen Sie unseren datenschutzorientierten Spamschutz",
        "fr": "Soutenez notre bouclier anti-spam indépendant et respectueux de la vie privée",
        "es": "Apoya nuestro escudo anti-spam independiente y centrado en la privacidad",
        "zh-Hans": "支持独立开发、零数据收集的高效防骚扰工具",
        "ar": "ادعم تطبيق الحماية المستقل الذي يحمي خصوصيتك",
        "ja": "プライバシーを最優先にした迷惑防止アプリを応援してください",
        "ko": "개인정보 보호를 최우선으로 하는 독립 스팸 쉴드를 응원해주세요",
        "hi": "हमारी गोपनीयता-केंद्रित सुरक्षा का समर्थन करें",
        "ru": "Поддержите независимый щит от спама с приоритетом приватности"
    }
}

for lang in langs:
    path = f"SafeMessageShield/{lang}.lproj/Localizable.strings"
    with open(path, "r", encoding="utf-8") as f:
        existing = f.read()

    new_entries = []
    for k, trans_dict in keys_data.items():
        if f'"{k}"' not in existing:
            val = trans_dict.get(lang, trans_dict["en"]).replace('"', '\\"')
            new_entries.append(f'"{k}" = "{val}";')

    if new_entries:
        updated = existing.rstrip() + "\n\n/* Growth & Simulation Features */\n" + "\n".join(new_entries) + "\n"
        with open(path, "w", encoding="utf-8") as f:
            f.write(updated)
        print(f"{lang}: Added {len(new_entries)} keys.")
    else:
        print(f"{lang}: All keys already present.")

print("All localization updates completed!")
