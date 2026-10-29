//
//  ProtectionPresetManager.swift
//  SafeMessageShield
//

import Foundation
import SwiftData

/// Akıllı Spam Koruma Şablonlarını yöneten ve SwiftData / App Group ile senkronize eden servis.
@MainActor
final class ProtectionPresetManager {
    static let shared = ProtectionPresetManager()

    let presets: [ProtectionPreset] = [
        ProtectionPreset(
            id: "betting_casino",
            icon: "die.face.5.fill",
            titleKey: "preset.betting.title",
            descriptionKey: "preset.betting.desc",
            category: .promotionalOffers,
            localizedKeywords: [
                "tr": ["casino", "bahis", "slot", "deneme bonusu", "freespin", "canlı bahis", "betturkey", "mobilbahis", "tümbet"],
                "en": ["casino", "betting", "slots", "free spins", "bonus deposit", "poker", "jackpot", "sportsbook", "wagering"],
                "de": ["casino", "sportwetten", "spielautomaten", "freispiele", "willkommensbonus", "wettbonus", "jackpot"],
                "fr": ["casino", "paris sportifs", "tours gratuits", "bonus de bienvenue", "machines à sous", "jackpot"],
                "es": ["casino", "apuestas", "giros gratis", "bono de bienvenida", "tragaperras", "ruleta", "jackpot"],
                "ru": ["казино", "ставки", "фриспины", "бонус за депозит", "слоты", "джекпот", "выигрыш"],
                "ar": ["كازينو", "رهان", "مكافأة", "قمار", "لفات مجانية", "يانصيب"],
                "ja": ["カジノ", "オンラインカジノ", "フリースピン", "入金ボーナス", "スロット", "ジャックポット", "賭け"],
                "ko": ["카지노", "슬롯", "바카라", "무료 스핀", "첫충", "꽁머니", "스포츠토토"],
                "zh-Hans": ["百家乐", "真人视讯", "首存特惠", "彩票", "包赔", "娱乐城", "转盘"],
                "hi": ["कैसीनो", "सट्टा", "फ्री स्पिन", "बोनस ऑफर", "जैकपॉट", "लॉटरी"]
            ]
        ),
        ProtectionPreset(
            id: "loan_phishing",
            icon: "creditcard.trianglebadge.exclamationmark.fill",
            titleKey: "preset.loan.title",
            descriptionKey: "preset.loan.desc",
            category: .promotionalOthers,
            localizedKeywords: [
                "tr": ["faizsiz kredi", "acil nakit", "sicil affı", "kredi kartı aidatı", "dosya masrafı", "ön onaylı kredi", "anında nakit"],
                "en": ["pre-approved loan", "instant cash", "zero interest loan", "credit repair", "fast loan", "debt relief", "payday advance"],
                "de": ["sofortkredit", "kredit ohne schufa", "blitzkredit", "zinsfreier kredit", "schuldenerlass", "eilkredit"],
                "fr": ["prêt express", "crédit sans justificatif", "rachat de crédit", "argent facile", "prêt immédiat"],
                "es": ["préstamo inmediato", "dinero rápido", "sin aval", "crédito aprobado", "borra deudas"],
                "ru": ["быстрый кредит", "займ без отказа", "деньги до зарплаты", "кредит без процентов", "списание долгов"],
                "ar": ["قرض فوري", "تمويل شخصي", "سلفة نقدية", "تسديد ديون", "بدون فوائد"],
                "ja": ["即日融資", "無審査ローン", "ブラックOK", "即日現金化", "低金利融資"],
                "ko": ["당일대출", "무서류대출", "저금리대환", "신용회복", "급전당일"],
                "zh-Hans": ["急用钱", "秒批到账", "免息借款", "无需征信", "小额极速贷"],
                "hi": ["तुरंत लोन", "बिना ब्याज लोन", "आसान ऋण", "कर्ज मुक्ति", "कैश लोन"]
            ]
        ),
        ProtectionPreset(
            id: "delivery_phishing",
            icon: "shippingbox.fill",
            titleKey: "preset.delivery.title",
            descriptionKey: "preset.delivery.desc",
            category: .promotionalOthers,
            localizedKeywords: [
                "tr": ["kargonuz teslim edilemedi", "paketiniz adres yetersizliği", "kargo takip linki", "gümrük vergisi", "teslimat için tıklayın"],
                "en": ["package delivery failed", "parcel address update", "tracking link", "unpaid customs fee", "reschedule delivery"],
                "de": ["paket konnte nicht zugestellt werden", "sendungsverfolgung link", "zollgebühr", "adresse aktualisieren"],
                "fr": ["votre colis est en attente", "frais de douane", "mettre à jour l'adresse", "livraison impossible"],
                "es": ["paquete retenido", "actualizar dirección de entrega", "tasas de aduana", "su envío no pudo entregarse"],
                "ru": ["посылка задержана", "оплата таможенной пошлины", "неверный адрес доставки", "отследить заказ"],
                "ar": ["تعذر تسليم الطرد", "تحديث عنوان التوصيل", "رسوم جمركية", "تتبع الشحنة"],
                "ja": ["お荷物のお届けに伺いましたが", "不在通知", "再配達依頼", "受取人不在", "住所変更"],
                "ko": ["택배 배송 불가", "주소지 불명", "통관비용 납부", "배송조회 링크"],
                "zh-Hans": ["包裹派送失败", "更新收货地址", "缴纳关税", "快件已滞留"],
                "hi": ["पार्सल डिलीवरी विफल", "पता अपडेट करें", "सीमा शुल्क", "डिलीवरी रीशेड्यूल"]
            ]
        ),
        ProtectionPreset(
            id: "lottery_scam",
            icon: "gift.fill",
            titleKey: "preset.lottery.title",
            descriptionKey: "preset.lottery.desc",
            category: .promotionalOffers,
            localizedKeywords: [
                "tr": ["tebrikler kazandınız", "çekiliş talihlisi", "hediye çeki", "iphone kazandınız", "ödülünüzü talep edin"],
                "en": ["congratulations you won", "claim your prize", "lottery winner", "free gift card", "selected winner"],
                "de": ["herzlichen glückwunsch gewonnen", "gewinn einfordern", "gutschein gewinnen", "ausgewählter gewinner"],
                "fr": ["félicitations vous avez gagné", "réclamez votre prix", "carte cadeau offerte", "tirage au sort"],
                "es": ["felicidades ha ganado", "reclame su premio", "tarjeta de regalo", "ganador seleccionado"],
                "ru": ["поздравляем вы выиграли", "получите ваш приз", "лотерейный выигрыш", "подарочный сертификат"],
                "ar": ["تهانينا لقد ربحت", "استلم جائزتك", "سحب الحظ", "بطاقة هدايا مجانية"],
                "ja": ["当選おめでとうございます", "賞品を受け取る", "ギフトカードプレゼント", "抽選結果"],
                "ko": ["축하합니다 당첨되었습니다", "경품 수령", "무료 기프트카드", "당첨자 발표"],
                "zh-Hans": ["恭喜您中奖", "领取您的奖品", "抽中大奖", "免费礼品卡"],
                "hi": ["बधाई हो आप जीते हैं", "अपना इनाम प्राप्त करें", "लॉटरी विजेता", "गिफ्ट कार्ड"]
            ]
        ),
        ProtectionPreset(
            id: "crypto_job_scam",
            icon: "bitcoinsign.circle.fill",
            titleKey: "preset.crypto.title",
            descriptionKey: "preset.crypto.desc",
            category: .promotionalOffers,
            localizedKeywords: [
                "tr": ["günlük 2000 tl", "evden çalışarak kazan", "kripto arbitraj", "görev yap kazan", "kripto sinyal"],
                "en": ["work from home earn", "crypto signals", "daily guaranteed profit", "part-time tasks pay", "crypto arbitrage"],
                "de": ["heimarbeit geld verdienen", "krypto signale", "garantierte rendite", "tagesverdienst", "nebenjob von zuhause"],
                "fr": ["travail à domicile rémunéré", "signaux crypto", "gains quotidiens", "mission payée"],
                "es": ["trabajo desde casa ganar", "señales cripto", "ganancias garantizadas", "empleo de medio tiempo"],
                "ru": ["заработок на дому", "крипто сигналы", "гарантированная прибыль", "доход в день"],
                "ar": ["عمل من المنزل براتب يومي", "إشارات كريبتو", "أرباح مضمونة", "مهمات يومية"],
                "ja": ["在宅ワーク高収入", "暗号資産シグナル", "副業で日給", "簡単な作業で稼ぐ"],
                "ko": ["재택알바 고수익", "가상화폐 리딩방", "일급 보장", "부업 추천"],
                "zh-Hans": ["在家兼职日结", "加密货币套利", "高佣金任务", "带单翻倍"],
                "hi": ["घर बैठे कमाएं", "क्रिप्टो सिग्नल्स", "दैनिक कमाई", "पार्ट टाइम वर्क"]
            ]
        )
    ]

    /// Belirtilen preset'in mevcut kurallar arasında kaç tanesinin aktif olduğunu döner.
    func activeKeywordCount(for preset: ProtectionPreset, languageCode: String, existingRules: [FilterRule]) -> Int {
        let presetKeywords = Set(preset.keywords(for: languageCode).map { $0.lowercased() })
        let existingKeywords = Set(existingRules.map { $0.keyword.lowercased() })
        return presetKeywords.intersection(existingKeywords).count
    }

    /// Bir paketin tamamen aktif olup olmadığını döner.
    func isPresetFullyApplied(preset: ProtectionPreset, languageCode: String, existingRules: [FilterRule]) -> Bool {
        let keywords = preset.keywords(for: languageCode)
        guard !keywords.isEmpty else { return false }
        return activeKeywordCount(for: preset, languageCode: languageCode, existingRules: existingRules) == keywords.count
    }

    /// Belirtilen paketi SwiftData ve DataManager'a uygular.
    /// Eklenen yeni kural sayısını döner.
    @discardableResult
    func applyPreset(
        _ preset: ProtectionPreset,
        languageCode: String,
        existingRules: [FilterRule],
        modelContext: ModelContext
    ) -> Int {
        let existingKeywords = Set(existingRules.map { $0.keyword.lowercased() })
        let keywordsToAdd = preset.keywords(for: languageCode)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty && !existingKeywords.contains($0) }

        guard !keywordsToAdd.isEmpty else { return 0 }

        for keyword in keywordsToAdd {
            let rule = FilterRule(keyword: keyword, category: preset.category.rawValue)
            modelContext.insert(rule)
            DataManager.shared.addFilterRule(keyword: keyword, category: preset.category.rawValue)
        }

        try? modelContext.save()

        // Puanlama yöneticisinde pozitif aksiyon kaydet
        StoreReviewManager.shared.recordPositiveAction()

        return keywordsToAdd.count
    }

    /// Belirtilen paketin anahtar kelimelerini kaldırır.
    @discardableResult
    func removePreset(
        _ preset: ProtectionPreset,
        languageCode: String,
        existingRules: [FilterRule],
        modelContext: ModelContext
    ) -> Int {
        let presetKeywords = Set(preset.keywords(for: languageCode).map { $0.lowercased() })
        let rulesToRemove = existingRules.filter { presetKeywords.contains($0.keyword.lowercased()) }

        guard !rulesToRemove.isEmpty else { return 0 }

        for rule in rulesToRemove {
            DataManager.shared.removeFilterRule(keyword: rule.keyword)
            modelContext.delete(rule)
        }

        try? modelContext.save()
        return rulesToRemove.count
    }

    /// Tüm önerilen paketleri tek tıkla uygular.
    @discardableResult
    func applyAllPresets(
        languageCode: String,
        existingRules: [FilterRule],
        modelContext: ModelContext
    ) -> Int {
        var totalAdded = 0
        for preset in presets {
            totalAdded += applyPreset(preset, languageCode: languageCode, existingRules: existingRules, modelContext: modelContext)
        }
        return totalAdded
    }
}
