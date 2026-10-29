/* Localized Privacy Policy content for SafeMessageShield (11 languages) */
window.SMS_PRIVACY = {
  en: {
    title: "Privacy Policy - Safe Message Shield",
    description: "Safe Message Shield Privacy Policy — Learn how our 100% offline, on-device architecture protects your messages, contacts, and calls on iOS.",
    h1: "Privacy Policy",
    updated: "Last updated: October 2026",
    lead: "Safe Message Shield is engineered from the ground up with a strict local-first, zero-knowledge privacy architecture. Your messages, phone numbers, contacts, and custom filter rules never leave your iPhone.",
    toc_title: "On this page",
    summary_title: "Privacy Summary",
    summary_text: "Safe Message Shield does not operate any remote servers and never collects, transmits, or sells your personal data. All SMS filtering and call blocking decisions are computed 100% offline inside Apple's native iOS sandbox on your device, giving you total peace of mind.",
    sections: [
      [
        "introduction",
        "1. Introduction",
        "<p>Welcome to Safe Message Shield. We believe your personal communications belong exclusively to you. This Privacy Policy details how our iOS application and website handle information.</p>\n<p><b>Core Principle:</b> Safe Message Shield operates on a strict <b>100% on-device, zero-cloud architecture</b>. We do not own or maintain cloud servers for message evaluation. All filtering decisions occur locally within your iPhone's secure system sandbox.</p>"
      ],
      [
        "not-collected",
        "2. Information We Do NOT Collect",
        "<p>Safe Message Shield does <b>not</b> collect, transmit, store on servers, or share any of the following:</p>\n<ul>\n<li>The text content or sender details of your SMS and MMS messages</li>\n<li>Your past, current, or incoming phone call logs</li>\n<li>Your complete contact book or address book entries</li>\n<li>Your phone number, SIM card info, or cellular carrier data</li>\n<li>Device identifiers, advertising identifiers (IDFA), or location data</li>\n<li>Usage telemetry or third-party behavioral analytics</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. How On-Device Protection Works",
        "<h3>3.1 Apple IdentityLookup Framework</h3>\n<p>SMS filtering is handled by Apple's official <code>ILMessageFilterExtension</code>. When an SMS arrives from an unknown sender, iOS passes the message locally to our extension inside a memory-isolated sandbox. The extension evaluates the message against your local rules and returns an action code (e.g., Allow, Junk, or Promotion) directly to iOS. No network requests are made.</p>\n<h3>3.2 Apple CallKit Call Directory Framework</h3>\n<p>Call blocking is powered by Apple's <code>CXCallDirectoryProvider</code>. Your blocked numbers and prefix rules are loaded into the local iOS telephony subsystem. When a call arrives, iOS silences or identifies the call at the kernel level without ever launching our main app or contacting an external server.</p>\n<h3>3.3 Local App Group Container</h3>\n<p>Your custom rules, presets, and blocklists are stored securely within the local App Group directory (<code>group.tsavasci.SafeMessageShield</code>) on your iPhone. This storage is completely offline and not synced to third-party clouds.</p>"
      ],
      [
        "permissions",
        "4. Permissions & Device Access",
        "<ul>\n<li><b>SMS Filtering Extension:</b> Enables iOS to pass incoming unknown SMS messages to the local filter engine. Apple strictly prohibits the extension from accessing your historical messages or making network calls.</li>\n<li><b>Call Blocking &amp; Identification:</b> Permits iOS to recognize numbers in your blocklist and reject unwanted incoming calls.</li>\n<li><b>Contacts Access (Optional):</b> If you choose to add a number from your address book to your blocklist or whitelist, iOS presents the contact picker. Safe Message Shield only reads the single number you explicitly select; your contact book is never scanned or uploaded.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. Protection Presets & Custom Rules",
        "<p>Our Smart Protection Presets (such as Casino, Fake Delivery Phishing, and Predatory Loans) consist of curated keyword lists bundled directly inside the app binary. When you enable or customize these presets, they remain strictly on your iPhone. You have complete control to add, edit, or delete keywords at any time.</p>"
      ],
      [
        "otp-whitelist",
        "6. Whitelist & 2FA Bank Verification Codes",
        "<p>To protect essential financial and authentication messages, Safe Message Shield incorporates a priority Whitelist. Known financial institution headers and contacts you designate as trusted always bypass spam categorization, ensuring you never miss a two-factor authentication (OTP) code.</p>"
      ],
      [
        "zero-tracking",
        "7. Zero Third-Party Trackers & Advertising",
        "<p>Safe Message Shield contains <b>zero</b> third-party analytics SDKs (no Google Analytics, no Firebase, no Facebook SDK), zero crash-reporting telemetry tools, and zero advertising networks. Your in-app activity is completely private.</p>"
      ],
      [
        "data-portability",
        "8. Rule Portability & JSON Export",
        "<p>You retain full ownership of your data. Using the built-in Backup &amp; Restore feature, you can export your entire rule database to an open, human-readable JSON file. This file can be audited, stored securely, or imported onto another iPhone.</p>"
      ],
      [
        "children",
        "9. Children's Privacy",
        "<p>Safe Message Shield does not collect any personal information from anyone, including children under the age of 13. The app is completely safe for users of all ages.</p>"
      ],
      [
        "contact",
        "10. Contact & User Rights",
        "<p>Because we do not collect or store your data on any server, there is no personal data for us to access, rectify, or delete. If you uninstall the application from your iPhone, all locally stored rules, presets, and configuration files are permanently erased by iOS.</p>\n<p>If you have any questions or feedback regarding our privacy practices, please contact us at: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  tr: {
    title: "Gizlilik Politikası - Safe Message Shield",
    description: "Safe Message Shield Gizlilik Politikası — %100 çevrimdışı, cihaz içi mimarimizin mesajlarınızı ve aramalarınızı iOS üzerinde nasıl koruduğunu öğrenin.",
    h1: "Gizlilik Politikası",
    updated: "Son güncelleme: Ekim 2026",
    lead: "Safe Message Shield, baştan sona yerel odaklı, sıfır-bilgi (zero-knowledge) gizlilik mimarisiyle geliştirilmiştir. Mesajlarınız, telefon numaralarınız, rehberiniz ve filtreleme kurallarınız asla iPhone'unuzdan dışarı çıkmaz.",
    toc_title: "Bu sayfada",
    summary_title: "Gizlilik Özeti",
    summary_text: "Safe Message Shield hiçbir uzak sunucu barındırmaz ve kişisel verilerinizi asla toplamaz, iletmez veya satmaz. Tüm SMS filtreleme ve arama engelleme kararları doğrudan cihazınızdaki Apple sandbox içinde %100 çevrimdışı hesaplanır.",
    sections: [
      [
        "introduction",
        "1. Giriş",
        "<p>Safe Message Shield'a hoş geldiniz. Kişisel iletişiminizin yalnızca size ait olması gerektiğine inanıyoruz. Bu Gizlilik Politikası, iOS uygulamamızın ve web sitemizin verileri nasıl işlediğini açıklamaktadır.</p>\n<p><b>Temel İlke:</b> Safe Message Shield, katı bir <b>%100 cihaz içi ve bulutsuz mimari</b> ile çalışır. Mesajları analiz etmek için hiçbir sunucu kullanmayız; tüm filtreleme kararları iPhone'unuzun korumalı yerel alanında gerçekleşir.</p>"
      ],
      [
        "not-collected",
        "2. Kesinlikle Toplamadığımız Veriler",
        "<p>Safe Message Shield aşağıdaki bilgilerin hiçbirini <b>toplamaz, sunuculara iletmez, saklamaz veya paylaşmaz</b>:</p>\n<ul>\n<li>SMS ve MMS mesajlarınızın metin içerikleri ve gönderen detayları</li>\n<li>Geçmiş veya anlık telefon arama kayıtlarınız</li>\n<li>Rehberiniz veya kişi listenizin tamamı</li>\n<li>Telefon numaranız, SIM kart veya hücresel operatör bilgileriniz</li>\n<li>Cihaz kimlikleri, reklam tanımlayıcıları (IDFA) veya konum verileri</li>\n<li>Kullanım analizleri veya üçüncü taraf takip kodları</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. Cihaz İçi Koruma Nasıl Çalışır?",
        "<h3>3.1 Apple IdentityLookup Altyapısı</h3>\n<p>SMS filtreleme, Apple'ın resmi <code>ILMessageFilterExtension</code> teknolojisi ile yürütülür. Bilinmeyen bir numaradan SMS geldiğinde, iOS sistemi mesajı yerel uzantımıza bellekte yalıtılmış bir sandbox içinde iletir. Uzantı, mesajı yerel kurallarınızla karşılaştırır ve sonucu (İzin Ver, Junk veya Promosyon) doğrudan iOS'e bildirir. Hiçbir internet isteği yapılmaz.</p>\n<h3>3.2 Apple CallKit Call Directory Altyapısı</h3>\n<p>Arama engelleme, Apple'ın <code>CXCallDirectoryProvider</code> altyapısıyla çalışır. Engellediğiniz numaralar ve alan kodu kuralları iOS telefon alt sistemine aktarılır. Arama geldiğinde sistem, ana uygulamayı bile başlatmadan aramayı sessize alır veya engeller.</p>\n<h3>3.3 Yerel App Group Alanı</h3>\n<p>Filtre kurallarınız ve kara listeniz, iPhone'unuzdaki yerel App Group dizininde (<code>group.tsavasci.SafeMessageShield</code>) saklanır. Bu alan tamamen çevrimdışıdır ve harici bulutlara aktarılmaz.</p>"
      ],
      [
        "permissions",
        "4. İzinler ve Cihaz Erişimi",
        "<ul>\n<li><b>SMS Filtreleme Uzantısı:</b> Yeni gelen bilinmeyen SMS'lerin cihaz içi motor tarafından incelenmesine izin verir. Apple kuralları gereği uzantının geçmiş mesajlara erişmesi veya internete bağlanması teknik olarak imkansızdır.</li>\n<li><b>Arama Engelleme ve Kimlik Tanımlama:</b> Engellenen numaralardan gelen aramaların çalmadan reddedilmesini sağlar.</li>\n<li><b>Kişiler Erişimi (İsteğe Bağlı):</b> Yalnızca rehberinizden bir kişiyi engellenenlere veya güvenli listeye eklemek istediğinizde sistem seçicisi açılır. Uygulama sadece seçtiğiniz numarayı kaydeder, rehberinizi taramaz veya kopyalamaz.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. Akıllı Koruma Paketleri ve Özel Kurallar",
        "<p>Akıllı Koruma Paketlerimiz (Bahis, Sahte Kargo, Ön Onaylı Kredi vb.), doğrudan uygulama paketi içinde yerel anahtar kelime kurallarından oluşur. Bu paketleri açtığınızda veriler tamamen iPhone'unuzda işlenir. Dilediğiniz zaman kuralları düzenleyebilir veya silebilirsiniz.</p>"
      ],
      [
        "otp-whitelist",
        "6. Güvenli Liste ve Banka Onay Kodları (OTP)",
        "<p>Önemli banka ve kimlik doğrulama mesajlarının kaybolmaması için uygulamada öncelikli Beyaz Liste (Güvenli Liste) yer alır. Tanımlı banka başlıkları ve güvendiğiniz kişiler spam filtresine takılmaz; 2FA onay kodlarınız her zaman gelen kutunuza ulaşır.</p>"
      ],
      [
        "zero-tracking",
        "7. Sıfır Takipçi ve Reklamsız Deneyim",
        "<p>Safe Message Shield içinde <b>kesinlikle hiçbir</b> üçüncü taraf analiz SDK'sı (Google Analytics, Firebase vb.), hata izleme aracı veya reklam kütüphanesine yer verilmemiştir. Uygulama içi hareketleriniz tamamen size özeldir.</p>"
      ],
      [
        "data-portability",
        "8. Veri Taşınabilirliği ve JSON Yedekleme",
        "<p>Verilerinizin kontrolü tamamen sizdedir. Yerleşik JSON Yedekleme özelliği sayesinde engelleme listenizi tek dokunuşla dışa aktarabilir, dosya olarak saklayabilir veya yeni bir iPhone'a kolayca aktarabilirsiniz.</p>"
      ],
      [
        "children",
        "9. Çocukların Gizliliği",
        "<p>Uygulamamız hiçbir kullanıcıdan veri toplamadığı gibi 13 yaş altı çocuklardan da hiçbir bilgi almaz. Her yaştan kullanıcı için tamamen güvenlidir.</p>"
      ],
      [
        "contact",
        "10. İletişim ve Kullanıcı Hakları",
        "<p>Sunucularımızda hiçbir kullanıcı verisi saklanmadığından, tarafımızda saklanan silinecek veya düzeltilecek bir veriniz bulunmamaktadır. Uygulamayı telefonunuzdan sildiğinizde, cihazınızdaki tüm kurallar ve ayarlar iOS tarafından kalıcı olarak silinir.</p>\n<p>Gizlilikle ilgili tüm sorularınız için bizimle iletişime geçebilirsiniz: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  de: {
    title: "Datenschutzerklärung - Safe Message Shield",
    description: "Safe Message Shield Datenschutzerklärung — Erfahren Sie, wie unsere 100% Offline-Architektur Ihre Nachrichten und Anrufe auf iOS schützt.",
    h1: "Datenschutzerklärung",
    updated: "Zuletzt aktualisiert: Oktober 2026",
    lead: "Safe Message Shield basiert auf einer strikten lokalen Zero-Knowledge-Datenschutzarchitektur. Ihre Nachrichten, Kontakte, Telefonnummern und Filterregeln verlassen niemals Ihr iPhone.",
    toc_title: "Auf dieser Seite",
    summary_title: "Datenschutz-Zusammenfassung",
    summary_text: "Safe Message Shield betreibt keine Remote-Server und sammelt, überträgt oder verkauft zu keinem Zeitpunkt persönliche Daten. Alle SMS- und Anrufentscheidungen werden zu 100% offline in der Apple-Sandbox auf Ihrem Gerät berechnet.",
    sections: [
      [
        "introduction",
        "1. Einleitung",
        "<p>Willkommen bei Safe Message Shield. Wir sind davon überzeugt, dass Ihre private Kommunikation ausschließlich Ihnen gehört. Diese Datenschutzerklärung erläutert, wie wir Daten verarbeiten.</p>\n<p><b>Grundprinzip:</b> Safe Message Shield arbeitet nach einer strikten <b>100% Offline- und Zero-Cloud-Architektur</b>. Es gibt keine externen Server zur Nachrichtenanalyse.</p>"
      ],
      [
        "not-collected",
        "2. Daten, die wir NICHT erfassen",
        "<p>Safe Message Shield erfasst, überträgt, speichert oder teilt <b>keine</b> der folgenden Daten:</p>\n<ul>\n<li>Inhalte oder Absenderangaben Ihrer SMS- und MMS-Nachrichten</li>\n<li>Anruflisten oder Telefonverläufe</li>\n<li>Einträge Ihres Adressbuchs oder vollständige Kontaktlisten</li>\n<li>Telefonnummern, SIM-Karten- oder Mobilfunkbetreiberdaten</li>\n<li>Gerätekennungen, Werbe-IDs (IDFA) oder Standortdaten</li>\n<li>Analytik- oder Nutzungsdaten von Drittanbietern</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. Wie der Schutz auf dem Gerät funktioniert",
        "<h3>3.1 Apple IdentityLookup Framework</h3>\n<p>Die SMS-Filterung erfolgt über <code>ILMessageFilterExtension</code> von Apple. Unbekannte SMS werden lokal in einer isolierten Sandbox geprüft. Es finden keine Netzwerkübertragungen statt.</p>\n<h3>3.2 Apple CallKit Call Directory Framework</h3>\n<p>Die Anrufblockierung nutzt <code>CXCallDirectoryProvider</code>. Sperrlisten werden direkt im iOS-Telefonsystem hinterlegt. Eingehende Spam-Anrufe werden auf Kernelebene stummgeschaltet.</p>\n<h3>3.3 Lokaler App-Group-Speicher</h3>\n<p>Ihre Regeln liegen ausschließlich im lokalen App-Group-Container (<code>group.tsavasci.SafeMessageShield</code>) auf Ihrem iPhone.</p>"
      ],
      [
        "permissions",
        "4. Berechtigungen & Zugriff",
        "<ul>\n<li><b>SMS-Filterung:</b> Ermöglicht die lokale Prüfung eingehender SMS. Zugriff auf alte Nachrichten ist technisch unmöglich.</li>\n<li><b>Anrufblockierung:</b> Erlaubt iOS, gesperrte Rufnummern abzuweisen.</li>\n<li><b>Kontakte (optional):</b> Wird nur geöffnet, wenn Sie explizit eine Nummer aus dem Adressbuch auswählen. Es erfolgt kein vollständiger Adressbuch-Scan.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. Schutzpakete & eigene Filter",
        "<p>Unsere intelligenten Schutzpakete (Casino, Phishing, Kredite) basieren auf lokal im App-Paket hinterlegten Schlüsselwörtern. Sie können diese jederzeit bearbeiten oder löschen.</p>"
      ],
      [
        "otp-whitelist",
        "6. Whitelist & 2FA-Bankcodes",
        "<p>Um wichtige TAN-Codes und SMS von Familienmitgliedern zu schützen, verfügt die App über eine priorisierte Whitelist, die niemals gefiltert wird.</p>"
      ],
      [
        "zero-tracking",
        "7. Keine Tracker & keine Werbung",
        "<p>Safe Message Shield enthält <b>keine</b> Tracking-SDKs von Drittanbietern (kein Google, kein Firebase, kein Facebook) und keine Werbenetzwerke.</p>"
      ],
      [
        "data-portability",
        "8. Datenportabilität & JSON-Export",
        "<p>Ihre Daten gehören Ihnen. Sie können alle Sperrlisten mit einem Klick als JSON-Datei exportieren und auf ein neues Gerät übertragen.</p>"
      ],
      [
        "children",
        "9. Schutz von Minderjährigen",
        "<p>Die App sammelt keinerlei Daten und ist für Nutzer jeden Alters vollkommen sicher.</p>"
      ],
      [
        "contact",
        "10. Kontakt & Rechte",
        "<p>Da keine Daten auf Servern vorliegen, gibt es keine zentralen Datensätze zu löschen. Beim Deinstallieren der App werden alle lokalen Einstellungen von iOS gelöscht.</p>\n<p>Kontakt: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  fr: {
    title: "Politique de Confidentialité - Safe Message Shield",
    description: "Politique de Confidentialité de Safe Message Shield — Découvrez notre architecture 100% hors-ligne sur iOS.",
    h1: "Politique de Confidentialité",
    updated: "Dernière mise à jour : Octobre 2026",
    lead: "Safe Message Shield est conçu selon une architecture stricte de confidentialité locale et zéro-connaissance. Vos messages, contacts et règles ne quittent jamais votre iPhone.",
    toc_title: "Sur cette page",
    summary_title: "Résumé de Confidentialité",
    summary_text: "Safe Message Shield n'utilise aucun serveur distant et ne collecte ni ne vend aucune donnée personnelle. Le filtrage des SMS et des appels s'exécute à 100% hors-ligne dans le bac à sable iOS.",
    sections: [
      [
        "introduction",
        "1. Introduction",
        "<p>Bienvenue sur Safe Message Shield. Vos communications privées vous appartiennent exclusivement. Cette politique détaille notre engagement absolu envers le respect de votre vie privée.</p>\n<p><b>Principe fondamental :</b> Safe Message Shield fonctionne à <b>100% en local, sans cloud</b>. Aucun serveur n'est utilisé pour analyser vos messages.</p>"
      ],
      [
        "not-collected",
        "2. Données NON collectées",
        "<p>Safe Message Shield <b>ne collecte, ne transmet, ne stocke ni ne partage</b> aucune des données suivantes :</p>\n<ul>\n<li>Le contenu textuel ou l'expéditeur de vos SMS/MMS</li>\n<li>L'historique ou le journal de vos appels</li>\n<li>Votre carnet d'adresses ou liste de contacts</li>\n<li>Vos identifiants d'appareil, ID publicitaires (IDFA) ou données de localisation</li>\n<li>Les données d'analyse ou traceurs de tiers</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. Fonctionnement local",
        "<h3>3.1 Framework IdentityLookup</h3>\n<p>Le filtrage s'exécute via <code>ILMessageFilterExtension</code> d'Apple dans une sandbox mémoire isolée, sans accès réseau.</p>\n<h3>3.2 Framework CallKit</h3>\n<p>Le blocage d'appels s'appuie sur <code>CXCallDirectoryProvider</code>, intégré directement au sous-système de téléphonie d'iOS.</p>\n<h3>3.3 Conteneur App Group local</h3>\n<p>Vos règles et listes sont stockées exclusivement dans l'App Group local (<code>group.tsavasci.SafeMessageShield</code>).</p>"
      ],
      [
        "permissions",
        "4. Permissions requises",
        "<ul>\n<li><b>Filtrage SMS :</b> Évalue uniquement les nouveaux SMS entrants non sollicités. L'accès aux anciens messages est techniquement interdit par iOS.</li>\n<li><b>Blocage d'appels :</b> Rejette silencieusement les numéros répertoriés dans votre liste noire.</li>\n<li><b>Contacts (optionnel) :</b> Utilisé uniquement lorsque vous choisissez manuellement un numéro à ajouter. Aucun siphonnage complet n'a lieu.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. Packs et règles personnalisées",
        "<p>Nos packs de protection préconfigurés sont stockés directement dans l'application. Vous pouvez les activer, les modifier ou les supprimer librement.</p>"
      ],
      [
        "otp-whitelist",
        "6. Liste blanche & Codes 2FA",
        "<p>La liste blanche prioritaire garantit que les codes de vérification bancaire et les messages de vos proches ne sont jamais interceptés.</p>"
      ],
      [
        "zero-tracking",
        "7. Zéro traceur publicitaire",
        "<p>Aucun SDK d'analyse tiers (ni Google, ni Firebase, ni Facebook) n'est présent dans l'application.</p>"
      ],
      [
        "data-portability",
        "8. Exportation et sauvegarde JSON",
        "<p>Exportez vos listes de blocage au format JSON en 1 clic pour les archiver ou les transférer vers un autre iPhone.</p>"
      ],
      [
        "children",
        "9. Protection des enfants",
        "<p>L'application ne collectant aucune donnée, elle est parfaitement sûre pour tous les âges.</p>"
      ],
      [
        "contact",
        "10. Contact et droits",
        "<p>La suppression de l'application de votre iPhone efface instantanément et définitivement l'ensemble de vos règles et réglages.</p>\n<p>Contact : <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  es: {
    title: "Política de Privacidad - Safe Message Shield",
    description: "Política de Privacidad de Safe Message Shield — Conozca cómo nuestra arquitectura 100% offline protege sus mensajes y llamadas en iOS.",
    h1: "Política de Privacidad",
    updated: "Última actualización: Octubre 2026",
    lead: "Safe Message Shield está diseñado con una estricta arquitectura local y de conocimiento cero. Sus mensajes, contactos, números y reglas jamás salen de su iPhone.",
    toc_title: "En esta página",
    summary_title: "Resumen de Privacidad",
    summary_text: "Safe Message Shield no dispone de servidores remotos y nunca recopila, transmite ni vende datos personales. Toda la filtración de SMS y bloqueo de llamadas se calcula 100% sin conexión dentro del entorno seguro de Apple en su dispositivo.",
    sections: [
      [
        "introduction",
        "1. Introducción",
        "<p>Bienvenido a Safe Message Shield. Creemos firmemente que sus comunicaciones le pertenecen únicamente a usted. Esta política explica nuestro modelo de privacidad transparente.</p>\n<p><b>Principio básico:</b> Safe Message Shield opera bajo una arquitectura <b>100% local y sin nube</b>. No procesamos mensajes en servidores externos.</p>"
      ],
      [
        "not-collected",
        "2. Información que NO recopilamos",
        "<p>Safe Message Shield <b>no recopila, no transmite, no almacena ni comparte</b> nada de lo siguiente:</p>\n<ul>\n<li>El contenido o remitente de sus mensajes SMS y MMS</li>\n<li>El registro de llamadas entrantes o salientes</li>\n<li>Su libreta de direcciones o contactos</li>\n<li>Identificadores de dispositivo, identificadores de publicidad (IDFA) o ubicación</li>\n<li>Datos analíticos o rastreadores de terceros</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. Cómo funciona la protección local",
        "<h3>3.1 Framework IdentityLookup de Apple</h3>\n<p>El filtrado se gestiona mediante <code>ILMessageFilterExtension</code> dentro de una memoria aislada sin conexión de red.</p>\n<h3>3.2 Framework CallKit de Apple</h3>\n<p>El bloqueo de llamadas utiliza <code>CXCallDirectoryProvider</code>, actuando a nivel de sistema antes de que suene el teléfono.</p>\n<h3>3.3 Contenedor local App Group</h3>\n<p>Sus reglas se guardan exclusivamente en el contenedor local <code>group.tsavasci.SafeMessageShield</code> de su iPhone.</p>"
      ],
      [
        "permissions",
        "4. Permisos y accesos",
        "<ul>\n<li><b>Filtro de mensajes:</b> Evalúa únicamente SMS entrantes desconocidos. iOS impide el acceso a mensajes antiguos.</li>\n<li><b>Bloqueo de llamadas:</b> Permite rechazar llamadas comerciales no deseadas.</li>\n<li><b>Contactos (opcional):</b> Se utiliza únicamente al seleccionar un número específico. No se escanea su agenda completa.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. Paquetes de protección y reglas",
        "<p>Los paquetes inteligentes contra apuestas y fraudes residen localmente en el dispositivo. Usted tiene el control absoluto para editarlos o eliminarlos.</p>"
      ],
      [
        "otp-whitelist",
        "6. Lista blanca y códigos bancarios (OTP)",
        "<p>La lista blanca prioritaria asegura que los códigos de seguridad bancarios y mensajes de sus seres queridos lleguen siempre a la bandeja principal.</p>"
      ],
      [
        "zero-tracking",
        "7. Cero rastreadores de terceros",
        "<p>Safe Message Shield no contiene herramientas de telemetría de terceros ni librerías publicitarias.</p>"
      ],
      [
        "data-portability",
        "8. Copias de seguridad en JSON",
        "<p>Exporte e importe sus listas de bloqueo en formato estándar JSON con un solo toque para guardarlas o migrarlas de dispositivo.</p>"
      ],
      [
        "children",
        "9. Privacidad de menores",
        "<p>No recopilamos información de ningún usuario, por lo que la aplicación es segura para todas las edades.</p>"
      ],
      [
        "contact",
        "10. Contacto y derechos",
        "<p>Al desinstalar la aplicación de su iPhone, todos los datos y reglas almacenadas localmente se eliminan de forma permanente por iOS.</p>\n<p>Contacto: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  zh: {
    title: "隐私政策 - Safe Message Shield",
    description: "Safe Message Shield 隐私政策 — 了解我们如何通过 100% 本地离线技术守护您的 iOS 短信与通话安全。",
    h1: "隐私政策",
    updated: "最后更新：2026年10月",
    lead: "Safe Message Shield 自诞生起便严格秉承本地优先、零知识（Zero-Knowledge）隐私架构。您的短信、联系人、电话号码及规则配置永远不会离开您的 iPhone。",
    toc_title: "本页目录",
    summary_title: "隐私概要",
    summary_text: "Safe Message Shield 不搭建任何远程云端服务器，绝不收集、传输或出售您的任何个人隐私数据。所有垃圾短信过滤与骚扰拦截均在设备端离线运行，给您十足安心。",
    sections: [
      [
        "introduction",
        "1. 引言",
        "<p>欢迎使用 Safe Message Shield。我们坚信您的私人通信专属于您个人。本政策详细说明了我们的本地化隐私保护实践。</p>\n<p><b>核心原则：</b> Safe Message Shield 采用极其严苛的 <b>100% 纯本地离线、零云端架构</b>。我们不设立用于分析用户信息的云端服务器。</p>"
      ],
      [
        "not-collected",
        "2. 我们绝不收集的信息",
        "<p>Safe Message Shield <b>绝不收集、上传、存储或共享</b>以下任何信息：</p>\n<ul>\n<li>您的任何短信及彩信的文本内容或发件人信息</li>\n<li>历史或实时的通话记录</li>\n<li>您的通讯录或联系人清单</li>\n<li>设备唯一标识符、广告标识符 (IDFA) 或地理位置</li>\n<li>第三方行为分析数据或使用追踪统计</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. 本地运算机制",
        "<h3>3.1 Apple IdentityLookup 原生扩展</h3>\n<p>短信分类由官方 <code>ILMessageFilterExtension</code> 在内存隔离沙盒中完成，该扩展不具备任何网络访问权限。</p>\n<h3>3.2 Apple CallKit 通话扩展</h3>\n<p>通话拦截基于 <code>CXCallDirectoryProvider</code>，直接将黑名单录入 iOS 电话底层，无需启动主应用即可完成阻断。</p>\n<h3>3.3 本地 App Group 容器</h3>\n<p>您的拦截规则完全存放在 iPhone 本地的 App Group 共享目录 (<code>group.tsavasci.SafeMessageShield</code>) 中，不向外同步。</p>"
      ],
      [
        "permissions",
        "4. 系统权限说明",
        "<ul>\n<li><b>短信过滤权限：</b> 仅用于新收到的未知短信进行设备端判定。根据苹果隐私规范，扩展程序无法读取历史短信。</li>\n<li><b>通话拦截与来电识别：</b> 允许系统直接拒接黑名单号码。</li>\n<li><b>通讯录访问（可选）：</b> 仅在您手动挑选号码添加至黑/白名单时唤出系统选择器，绝不会抓取完整通讯录。</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. 智能预设与自定规则",
        "<p>内置的博彩、虚假快递等预设规则均作为静态规则集成在应用内部，您可以随时修改、启用或停用。</p>"
      ],
      [
        "otp-whitelist",
        "6. 白名单与双重验证码保护",
        "<p>内置高优先级白名单，确保各类银行动态验证码 (OTP) 及亲友来信稳定放行，永不误杀。</p>"
      ],
      [
        "zero-tracking",
        "7. 绝无第三方追踪与广告",
        "<p>应用未嵌入任何第三方统计分析 SDK（如 Google、Firebase 或 Facebook），彻底阻绝数据外泄。</p>"
      ],
      [
        "data-portability",
        "8. 数据备份与 JSON 迁移",
        "<p>支持将规则一键导出为开放的 JSON 文本文件，方便自行审计或跨 iPhone 设备无缝导入。</p>"
      ],
      [
        "children",
        "9. 未成年人保护",
        "<p>应用不搜集任何个人信息，适合所有年龄层用户安全使用。</p>"
      ],
      [
        "contact",
        "10. 权利保障与联络方式",
        "<p>当您从 iPhone 上卸载本应用时，所有保存在本地的规则和偏好设置都将被 iOS 系统彻底清除。</p>\n<p>联系方式：<a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  ja: {
    title: "プライバシーポリシー - Safe Message Shield",
    description: "Safe Message Shield プライバシーポリシー — 100%オフライン設計による安心のiOS迷惑通信対策。",
    h1: "プライバシーポリシー",
    updated: "最終更新日：2026年10月",
    lead: "Safe Message Shield は完全ローカル・ゼロ知識アーキテクチャを採用しています。メッセージ、連絡先、電話番号、設定ルールが端末の外に出ることは一切ありません。",
    toc_title: "目次",
    summary_title: "プライバシーの要約",
    summary_text: "外部サーバーを一切運用しておらず、個人情報の収集・送信・販売は行いません。すべての判定は端末内のAppleセキュアサンドボックスで100%オフライン完結します。",
    sections: [
      [
        "introduction",
        "1. はじめに",
        "<p>Safe Message Shieldへようこそ。お客様の個人通信はお客様だけのものです。本ポリシーでは情報の取り扱いについて透明に説明します。</p>\n<p><b>基本原則：</b> <b>完全ローカル動作・クラウド不使用</b>を徹底しています。メッセージ解析用の外部サーバーは存在しません。</p>"
      ],
      [
        "not-collected",
        "2. 収集しない情報",
        "<p>以下の情報を<b>収集、送信、保存、共有することは一切ありません</b>：</p>\n<ul>\n<li>SMSやMMSの本文や差出人詳細</li>\n<li>通話履歴や着信記録</li>\n<li>連絡先・アドレス帳の全データ</li>\n<li>端末識別子、広告識別子 (IDFA)、位置情報</li>\n<li>外部解析ツールによる利用ログ</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. 端末内動作の仕組み",
        "<h3>3.1 Apple IdentityLookup フレームワーク</h3>\n<p>SMS判定は <code>ILMessageFilterExtension</code> によりメモリ分離環境で行われ、外部通信は行われません。</p>\n<h3>3.2 Apple CallKit フレームワーク</h3>\n<p>着信拒否は <code>CXCallDirectoryProvider</code> によりiOSの電話システムに直接登録され、着信前にブロックされます。</p>\n<h3>3.3 ローカル App Group 領域</h3>\n<p>拒否リストや設定は、端末内の <code>group.tsavasci.SafeMessageShield</code> 領域にのみ保存されます。</p>"
      ],
      [
        "permissions",
        "4. 権限とアクセス",
        "<ul>\n<li><b>SMSフィルタリング：</b> 未知の新規SMSのみを判定します。過去のSMS履歴へのアクセスはiOSにより禁止されています。</li>\n<li><b>着信拒否と発信者番号：</b> 登録された悪質番号を拒否するために使用します。</li>\n<li><b>連絡先（任意）：</b> 手動で特定の番号を登録する際にのみ標準ピッカーが表示され、アドレス帳の吸い上げは行いません。</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. 保護プリセットと自作ルール",
        "<p>不在配達詐欺やカジノ対策のキーワードはアプリ内に保持され、いつでも自由に編集・削除できます。</p>"
      ],
      [
        "otp-whitelist",
        "6. ホワイトリストと認証コード保護",
        "<p>金融機関の認証SMS (OTP) や重要な連絡先が誤って迷惑フォルダに振り分けられないよう最優先で保護します。</p>"
      ],
      [
        "zero-tracking",
        "7. 追跡トラッカー・広告なし",
        "<p>Google、Firebase、Facebookなどの外部トラッキングSDKは一切含まれていません。</p>"
      ],
      [
        "data-portability",
        "8. JSONバックアップと復元",
        "<p>作成したルールは1タップでJSONファイルとして出力し、新しいiPhoneへ移行できます。</p>"
      ],
      [
        "children",
        "9. お子様のプライバシー",
        "<p>個人情報を一切収集しないため、全年齢のユーザーに安全にご利用いただけます。</p>"
      ],
      [
        "contact",
        "10. お問い合わせと権利",
        "<p>端末からアプリを削除すると、保存されたすべての設定とルールがiOSによって完全に消去されます。</p>\n<p>お問い合わせ：<a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  ko: {
    title: "개인정보 처리방침 - Safe Message Shield",
    description: "Safe Message Shield 개인정보 처리방침 — 100% 오프라인 온디바이스 기술로 통신 프라이버시를 안전하게 보호합니다.",
    h1: "개인정보 처리방침",
    updated: "최종 수정일: 2026년 10월",
    lead: "Safe Message Shield는 철저한 로컬 우선, 제로 지식(Zero-Knowledge) 프라이버시 원칙에 따라 구축되었습니다. 메시지, 연락처, 차단 규칙은 절대 사용자의 iPhone을 벗어나지 않습니다.",
    toc_title: "목차",
    summary_title: "개인정보 보호 요약",
    summary_text: "원격 서버를 전혀 운영하지 않으며 개인정보를 수집, 전송, 판매하지 않습니다. 모든 스팸 필터링과 전화 차단은 기기 내의 안전한 Apple 샌드박스에서 100% 오프라인으로 연산됩니다.",
    sections: [
      [
        "introduction",
        "1. 소개",
        "<p>Safe Message Shield를 이용해 주셔서 감사합니다. 개인적인 통신은 온전히 사용자 본인의 것이어야 합니다. 본 방침은 데이터 처리에 관한 투명한 원칙을 설명합니다.</p>\n<p><b>핵심 원칙:</b> <b>100% 온디바이스 및 무서버 아키텍처</b>를 고수합니다. 메시지를 수집하거나 분석하는 외부 서버가 존재하지 않습니다.</p>"
      ],
      [
        "not-collected",
        "2. 수집하지 않는 정보",
        "<p>Safe Message Shield는 다음 정보를 <b>수집, 전송, 저장, 공유하지 않습니다</b>:</p>\n<ul>\n<li>수신된 SMS/MMS의 본문 내용 및 발신자 세부 정보</li>\n<li>과거 또는 실시간 전화 통화 기록</li>\n<li>사용자의 전체 주소록 및 연락처 목록</li>\n<li>기기 고유 식별자, 광고 식별자 (IDFA), 위치 정보</li>\n<li>서드파티 분석 툴 및 사용 행태 추적 데이터</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. 온디바이스 작동 메커니즘",
        "<h3>3.1 Apple IdentityLookup 프레임워크</h3>\n<p>스팸 문자 분류는 Apple의 공식 <code>ILMessageFilterExtension</code>을 통해 네트워크가 차단된 독립 메모리에서 실행됩니다.</p>\n<h3>3.2 Apple CallKit 프레임워크</h3>\n<p>광고 전화 차단은 <code>CXCallDirectoryProvider</code>를 통해 iOS 전화 시스템에 직접 등록되어 전화벨이 울리기 전에 차단합니다.</p>\n<h3>3.3 로컬 App Group 저장소</h3>\n<p>설정된 차단 규칙은 iPhone 기기 내의 <code>group.tsavasci.SafeMessageShield</code> 영역에만 안전하게 보관됩니다.</p>"
      ],
      [
        "permissions",
        "4. 권한 및 기기 접근",
        "<ul>\n<li><b>메시지 필터링 권한:</b> 새로 수신되는 미확인 SMS만 로컬에서 판별합니다. iOS 정책상 과거 메시지 접근은 원천 불가합니다.</li>\n<li><b>전화 차단 및 발신자 확인:</b> 차단 목록에 등록된 악성 번호를 자동으로 거절합니다.</li>\n<li><b>연락처 접근 (선택 사항):</b> 주소록에서 특정 번호를 직접 지정해 추가할 때만 시스템 팝업이 호출되며, 전체 주소록을 긁어가지 않습니다.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. 스마트 보호 팩과 맞춤 규칙",
        "<p>도박 및 택배 스미싱 차단 팩은 앱 내부에 로컬 키워드로 탑재되어 있으며 사용자가 언제든 수정 및 삭제할 수 있습니다.</p>"
      ],
      [
        "otp-whitelist",
        "6. 화이트리스트 및 본인인증(OTP) 보호",
        "<p>금융기관의 2단계 인증 번호나 가족의 중요 문자가 누락되지 않도록 최우선 허용 화이트리스트가 작동합니다.</p>"
      ],
      [
        "zero-tracking",
        "7. 광고 추적기 및 트래커 제로",
        "<p>구글 애널리틱스, 파이어베이스, 페이스북 등 외부 데이터 수집 SDK가 전혀 포함되어 있지 않습니다.</p>"
      ],
      [
        "data-portability",
        "8. JSON 백업 및 데이터 이전",
        "<p>등록된 모든 규칙을 단 한 번의 탭으로 표준 JSON 파일로 내보내어 새 기기로 손쉽게 복원할 수 있습니다.</p>"
      ],
      [
        "children",
        "9. 아동 개인정보 보호",
        "<p>어떠한 개인 데이터도 수집하지 않으므로 모든 연령대가 안전하게 사용할 수 있습니다.</p>"
      ],
      [
        "contact",
        "10. 문의 및 권리",
        "<p>iPhone에서 앱을 삭제하면 기기 내에 보관된 모든 설정과 규칙이 iOS에 의해 영구적으로 파기됩니다.</p>\n<p>문의: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  ar: {
    title: "سياسة الخصوصية - Safe Message Shield",
    description: "سياسة خصوصية Safe Message Shield — تعرف على كيفية حماية رسائلك ومكالماتك دون اتصال بالإنترنت على iOS.",
    h1: "سياسة الخصوصية",
    updated: "آخر تحديث: أكتوبر 2026",
    lead: "تم تصميم Safe Message Shield وفق مبدأ صارم يضمن الخصوصية التامة دون اتصال بالإنترنت. لا تغادر رسائلك أو جهات اتصالك أو أرقامك هاتفك الآيفون إطلاقاً.",
    toc_title: "فهرس الصفحة",
    summary_title: "ملخص الخصوصية",
    summary_text: "لا نمتلك أي خوادم سحابية ولا نجمع أو نبيع بياناتك الشخصية أبداً. جميع عمليات تصفية الرسائل وحظر المكالمات تتم محلياً داخل بيئة Apple الآمنة على هاتفك.",
    sections: [
      [
        "introduction",
        "1. مقدمة",
        "<p>أهلاً بك في Safe Message Shield. نؤمن بأن اتصالاتك الشخصية ملك لك وحدك. توضح هذه السياسة التزامنا المطلق بعدم جمع بياناتك.</p>\n<p><b>المبدأ الأساسي:</b> يعمل التطبيق بـ <b>معمارية محلية 100% دون خوادم سحابية</b>.</p>"
      ],
      [
        "not-collected",
        "2. البيانات التي لا نجمعها إطلاقاً",
        "<p>لا يقوم التطبيق <b>بجمع أو نقل أو تخزين أو مشاركة</b> أي من البيانات التالية:</p>\n<ul>\n<li>محتوى ونصوص رسائل SMS أو تفاصيل المرسلين</li>\n<li>سجلات المكالمات الهاتفية السابقة أو الحالية</li>\n<li>دفتر العناوين أو جهات اتصالك بالكامل</li>\n<li>معرفات الأجهزة، معرفات الإعلانات (IDFA)، أو الموقع الجغرافي</li>\n<li>بيانات التتبع أو أدوات التحليل الخارجية</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. كيفية عمل الحماية داخل الجهاز",
        "<h3>3.1 واجهة IdentityLookup الرسمية</h3>\n<p>تتم فلترة الرسائل عبر <code>ILMessageFilterExtension</code> داخل مساحة ذاكرة معزولة دون أي اتصال بالإنترنت.</p>\n<h3>3.2 واجهة CallKit لحظر المكالمات</h3>\n<p>يعتمد حظر المكالمات على <code>CXCallDirectoryProvider</code> ويتم الحظر مباشرة على مستوى نظام الهاتف.</p>\n<h3>3.3 حاوية App Group المحلية</h3>\n<p>تُحفظ قواعدك وقوائم الحظر حصرياً في مساحة <code>group.tsavasci.SafeMessageShield</code> داخل هاتفك.</p>"
      ],
      [
        "permissions",
        "4. الأذونات وصلاحيات الجهاز",
        "<ul>\n<li><b>فلترة الرسائل:</b> تفحص الرسائل الجديدة الواردة فقط. يمنع نظام iOS التطبيقات من الوصول للرسائل القديمة.</li>\n<li><b>حظر المكالمات:</b> تسمح برفض أرقام الاحتيال والتسويق تلقائياً.</li>\n<li><b>جهات الاتصال (اختياري):</b> تُستخدم فقط عند اختيار رقم يدوي لإضافته، ولا يتم سحب دفتر العناوين.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. حزم الحماية والقواعد",
        "<p>جميع حزم الحماية ضد القمار والطرود المزيفة مخزنة محلياً في التطبيق ويمكنك تعديلها بحرية.</p>"
      ],
      [
        "otp-whitelist",
        "6. القائمة البيضاء ورموز التحقق البنكية",
        "<p>تحمي القائمة البيضاء رسائل البنوك ورموز التحقق (OTP) من الحظر لضمان وصولها دائماً.</p>"
      ],
      [
        "zero-tracking",
        "7. خالٍ تماماً من التتبع والإعلانات",
        "<p>لا يحتوي التطبيق على أي حزم برمجية للتتبع أو التحليل (مثل Google أو Firebase أو Facebook).</p>"
      ],
      [
        "data-portability",
        "8. النسخ الاحتياطي بصيغة JSON",
        "<p>يمكنك تصدير واستيراد قواعدك كملف JSON بلمسة واحدة لنقلها إلى هاتف آيفون جديد.</p>"
      ],
      [
        "children",
        "9. خصوصية الأطفال",
        "<p>التطبيق لا يجمع أي معلومات، وهو آمن تماماً لكافة الأعمار.</p>"
      ],
      [
        "contact",
        "10. التواصل وحقوق المستخدم",
        "<p>عند حذف التطبيق من جهازك، يتم مسح جميع القواعد والإعدادات المحلية نهائياً بواسطة نظام iOS.</p>\n<p>للتواصل: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  hi: {
    title: "गोपनीयता नीति - Safe Message Shield",
    description: "Safe Message Shield गोपनीयता नीति — जानें कि हमारा 100% ऑफ़लाइन सिस्टम iOS पर आपके संदेशों और कॉलों की सुरक्षा कैसे करता है।",
    h1: "गोपनीयता नीति",
    updated: "अंतिम अपडेट: अक्टूबर 2026",
    lead: "Safe Message Shield पूरी तरह से लोकल-फर्स्ट और जीरो-नॉलेज गोपनीयता आर्किटेक्चर पर आधारित है। आपके संदेश, संपर्क और नियम कभी भी आपके iPhone से बाहर नहीं जाते।",
    toc_title: "इस पृष्ठ पर",
    summary_title: "गोपनीयता सारांश",
    summary_text: "Safe Message Shield कोई रिमोट सर्वर नहीं चलाता और कभी भी आपका व्यक्तिगत डेटा एकत्र, प्रेषित या बेचता नहीं है। सभी निर्णय डिवाइस पर 100% ऑफ़लाइन होते हैं।",
    sections: [
      [
        "introduction",
        "1. प्रस्तावना",
        "<p>Safe Message Shield में आपका स्वागत है। आपका संचार केवल आपका है। यह नीति स्पष्ट करती है कि हम आपकी गोपनीयता का सम्मान कैसे करते हैं।</p>\n<p><b>मूल सिद्धांत:</b> <b>100% ऑफ़लाइन और क्लाउड-मुक्त</b> आर्किटेक्चर। संदेशों की जांच के लिए कोई बाहरी सर्वर नहीं है।</p>"
      ],
      [
        "not-collected",
        "2. डेटा जो हम एकत्र नहीं करते",
        "<p>Safe Message Shield निम्नलिखित में से कुछ भी <b>एकत्र, प्रेषित, संग्रहीत या साझा नहीं करता</b>:</p>\n<ul>\n<li>आपके एसएमएस/एमएमएस का पाठ या प्रेषक का विवरण</li>\n<li>कॉल इतिहास या संपर्क सूची</li>\n<li>डिवाइस आईडी, विज्ञापन आईडी (IDFA) या स्थान</li>\n<li>तृतीय-पक्ष एनालिटिक्स या ट्रैकिंग डेटा</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. डिवाइस पर सुरक्षा कार्यप्रणाली",
        "<h3>3.1 Apple IdentityLookup फ्रेमवर्क</h3>\n<p>एसएमएस फिल्टरिंग बिना इंटरनेट कनेक्शन के एक सुरक्षित मेमोरी सैंडबॉक्स में होती है।</p>\n<h3>3.2 Apple CallKit फ्रेमवर्क</h3>\n<p>कॉल ब्लॉकिंग सीधे iOS फोन सबसिस्टम के माध्यम से फोन बजने से पहले काम करती है।</p>\n<h3>3.3 स्थानीय App Group स्टोरेज</h3>\n<p>आपके नियम केवल आपके iPhone के स्थानीय कंटेनर (<code>group.tsavasci.SafeMessageShield</code>) में सुरक्षित रहते हैं।</p>"
      ],
      [
        "permissions",
        "4. अनुमतियां",
        "<ul>\n<li><b>एसएमएस फ़िल्टर:</b> केवल नए आने वाले संदेशों का विश्लेषण करता है। पुराने संदेशों तक पहुंच संभव नहीं है।</li>\n<li><b>कॉल ब्लॉकिंग:</b> स्पैम नंबरों को ब्लॉक करने के लिए उपयोग किया जाता है।</li>\n<li><b>संपर्क (वैकल्पिक):</b> केवल तब उपयोग होता है जब आप स्वयं किसी नंबर को जोड़ने के लिए चुनते हैं।</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. सुरक्षा प्रीसेट और नियम",
        "<p>सट्टा और कूरियर धोखाधड़ी से जुड़े प्रीसेट सीधे ऐप में संग्रहीत होते हैं और आप इन्हें बदल सकते हैं।</p>"
      ],
      [
        "otp-whitelist",
        "6. व्हाइटलिस्ट और बैंक OTP सुरक्षा",
        "<p>प्राथमिकता सूची सुनिश्चित करती है कि बैंक प्रमाणीकरण कोड कभी ब्लॉक न हों।</p>"
      ],
      [
        "zero-tracking",
        "7. कोई ट्रैकर या विज्ञापन नहीं",
        "<p>ऐप में कोई तृतीय-पक्ष ट्रैकर (जैसे Google, Firebase या Facebook) शामिल नहीं है।</p>"
      ],
      [
        "data-portability",
        "8. JSON बैकअप सुविधा",
        "<p>एक टैप में अपने सभी नियमों को JSON फ़ाइल में बैकअप करें और नए फोन पर ट्रांसफर करें।</p>"
      ],
      [
        "children",
        "9. बच्चों की सुरक्षा",
        "<p>हम कोई व्यक्तिगत जानकारी एकत्र नहीं करते हैं, इसलिए यह सभी उम्र के लिए सुरक्षित है।</p>"
      ],
      [
        "contact",
        "10. संपर्क व अधिकार",
        "<p>जब आप ऐप अनइंस्टॉल करते हैं, तो सभी स्थानीय सेटिंग्स iOS द्वारा पूरी तरह हटा दी जाती हैं।</p>\n<p>ईमेल: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  },

  ru: {
    title: "Политика конфиденциальности - Safe Message Shield",
    description: "Политика конфиденциальности Safe Message Shield — узнайте, как наша 100% офлайн-архитектура защищает ваши сообщения и звонки на iOS.",
    h1: "Политика конфиденциальности",
    updated: "Последнее обновление: Октябрь 2026",
    lead: "Safe Message Shield спроектирован на базе строгой локальной архитектуры с нулевым разглашением. Ваши сообщения, контакты, номера и правила никогда не покидают iPhone.",
    toc_title: "На этой странице",
    summary_title: "Кратко о приватности",
    summary_text: "Safe Message Shield не использует удаленные серверы и никогда не собирает, не передает и не продает личные данные. Вся фильтрация SMS и блокировка спам-звонков происходит на 100% офлайн в изолированной песочнице Apple на вашем устройстве.",
    sections: [
      [
        "introduction",
        "1. Введение",
        "<p>Добро пожаловать в Safe Message Shield. Мы убеждены, что ваши личные коммуникации принадлежат только вам. В этом документе подробно описаны наши строгие принципы защиты приватности.</p>\n<p><b>Ключевой принцип:</b> Safe Message Shield работает по схеме <b>100% офлайн без использования облака</b>. У нас нет серверов для анализа сообщений.</p>"
      ],
      [
        "not-collected",
        "2. Данные, которые мы НЕ собираем",
        "<p>Safe Message Shield <b>не собирает, не передает, не хранит и не передает третьим лицам</b> следующее:</p>\n<ul>\n<li>Тексты и данные отправителей ваших SMS и MMS</li>\n<li>Историю входящих и исходящих вызовов</li>\n<li>Записи вашей телефонной книги и контакты</li>\n<li>Идентификаторы устройств, рекламные ID (IDFA) или геолокацию</li>\n<li>Стороннюю аналитику и данные о поведении</li>\n</ul>"
      ],
      [
        "how-data-stays-private",
        "3. Механизм защиты на устройстве",
        "<h3>3.1 Apple IdentityLookup Framework</h3>\n<p>Фильтрация сообщений выполняется системным расширением <code>ILMessageFilterExtension</code> в изолированной памяти без доступа к сети.</p>\n<h3>3.2 Apple CallKit Framework</h3>\n<p>Блокировка спам-звонков осуществляется через <code>CXCallDirectoryProvider</code> напрямую в телефонии iOS до срабатывания звонка.</p>\n<h3>3.3 Локальный контейнер App Group</h3>\n<p>Ваши списки блокировки и правила сохраняются исключительно в локальном хранилище <code>group.tsavasci.SafeMessageShield</code> на вашем iPhone.</p>"
      ],
      [
        "permissions",
        "4. Системные разрешения",
        "<ul>\n<li><b>Фильтрация SMS:</b> Оценивает только новые входящие сообщения от неизвестных номеров. Доступ к истории старых сообщений невозможен.</li>\n<li><b>Блокировка вызовов:</b> Позволяет системе сбрасывать нежелательные звонки.</li>\n<li><b>Контакты (по желанию):</b> Используется только тогда, когда вы вручную выбираете номер из адресной книги. Полное сканирование не производится.</li>\n</ul>"
      ],
      [
        "presets-rules",
        "5. Пакеты защиты и правила",
        "<p>Умные пакеты защиты против казино и фишинга доставок хранятся локально в приложении. Вы можете свободно редактировать или удалять любые правила.</p>"
      ],
      [
        "otp-whitelist",
        "6. Белый список и банковские коды (OTP)",
        "<p>Приоритетный белый список гарантирует беспрепятственную доставку одноразовых паролей авторизации от банков и сообщений от близких.</p>"
      ],
      [
        "zero-tracking",
        "7. Ноль трекеров и никакой рекламы",
        "<p>В приложении нет никаких сторонних аналитических инструментов (Google, Firebase, Facebook) и рекламных модулей.</p>"
      ],
      [
        "data-portability",
        "8. Экспорт и резервное копирование в JSON",
        "<p>Экспортируйте ваши правила в стандартный формат JSON в 1 клик для резервного сохранения или переноса на новый смартфон.</p>"
      ],
      [
        "children",
        "9. Защита детей",
        "<p>Приложение не собирает никаких личных данных и полностью безопасно для пользователей любого возраста.</p>"
      ],
      [
        "contact",
        "10. Контакты и удаление данных",
        "<p>При удалении приложения с iPhone все локальные файлы и настройки окончательно стираются операционной системой iOS.</p>\n<p>Контакт для связи: <a href=\"mailto:support@safemessageshield.app\">support@safemessageshield.app</a></p>"
      ]
    ]
  }
};
