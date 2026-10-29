/* SafeMessageShield — Modern Interactive Script & Multi-Language Engine */

function resolveI18nValue(dict, path) {
    return path
        .split(".")
        .reduce((acc, key) => (acc == null ? undefined : acc[key]), dict);
}

function initI18n() {
    const languages = window.SMS_LANGUAGES || [];
    const translations = window.SMS_TRANSLATIONS || {};
    if (!languages.length || !Object.keys(translations).length) {
        return;
    }

    const STORAGE_KEY = "sms_lang";
    const codes = languages.map((l) => l.code);

    const detectInitialLanguage = () => {
        try {
            const urlLang = new URLSearchParams(window.location.search)
                .get("lang")
                ?.slice(0, 7)
                .toLowerCase();
            if (urlLang && codes.includes(urlLang)) {
                return urlLang;
            }
        } catch (e) {
            /* URLSearchParams unavailable */
        }

        try {
            const saved = localStorage.getItem(STORAGE_KEY);
            if (saved && codes.includes(saved)) {
                return saved;
            }
        } catch (e) {
            /* localStorage unavailable */
        }

        const browserLangs = navigator.languages || [navigator.language || "en"];
        for (const bl of browserLangs) {
            const short = bl.slice(0, 2).toLowerCase();
            if (codes.includes(short)) {
                return short;
            }
        }
        return "en";
    };

    const applyTranslations = (code) => {
        const dict = translations[code] || translations.en;
        const currentLangObj = languages.find((l) => l.code === code) || languages[0];

        // Set document language and text direction
        document.documentElement.lang = code;
        document.documentElement.dir = currentLangObj.dir || "ltr";

        // Translate text content
        document.querySelectorAll("[data-i18n]").forEach((el) => {
            const value = resolveI18nValue(dict, el.getAttribute("data-i18n"));
            if (typeof value === "string") {
                el.textContent = value;
            }
        });

        // Translate HTML content (replaces {iOS} placeholder with gradient span)
        document.querySelectorAll("[data-i18n-html]").forEach((el) => {
            const value = resolveI18nValue(dict, el.getAttribute("data-i18n-html"));
            if (typeof value === "string") {
                el.innerHTML = value.replace(
                    "{iOS}",
                    '<span class="gradient-text">iOS</span>'
                );
            }
        });

        // Translate attributes (e.g. aria-label or placeholder)
        document.querySelectorAll("[data-i18n-attr]").forEach((el) => {
            el.getAttribute("data-i18n-attr")
                .split(";")
                .forEach((pair) => {
                    const [attr, key] = pair.split(":").map((part) => part.trim());
                    if (!attr || !key) return;
                    const value = resolveI18nValue(dict, key);
                    if (typeof value === "string") {
                        el.setAttribute(attr, value);
                    }
                });
        });

        // Update current toggle labels
        const currentFlagEl = document.getElementById("lang-current-flag");
        const currentCodeEl = document.getElementById("lang-current-code");
        if (currentFlagEl) currentFlagEl.textContent = currentLangObj.flag;
        if (currentCodeEl) currentCodeEl.textContent = currentLangObj.code.toUpperCase();

        // Update active class in menu
        document.querySelectorAll("#lang-menu li").forEach((li) => {
            li.classList.toggle("active", li.getAttribute("data-lang") === code);
        });

        // Save preference
        try {
            localStorage.setItem(STORAGE_KEY, code);
        } catch (e) {
            /* localStorage unavailable */
        }

        // Notify privacy policy page if present
        if (typeof window.applyPrivacyTranslations === "function") {
            window.applyPrivacyTranslations(code);
        }
    };

    // Render language switcher menu items
    const langMenuEl = document.getElementById("lang-menu");
    if (langMenuEl) {
        langMenuEl.innerHTML = languages
            .map(
                (l) =>
                    `<li data-lang="${l.code}">
                        <button type="button">
                            <span class="lang-flag">${l.flag}</span>
                            <span>${l.name}</span>
                        </button>
                    </li>`
            )
            .join("");

        langMenuEl.querySelectorAll("li button").forEach((btn) => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation();
                const code = btn.closest("li").getAttribute("data-lang");
                applyTranslations(code);
                closeLangMenu();
            });
        });
    }

    const langToggleBtn = document.getElementById("lang-toggle");
    const closeLangMenu = () => {
        if (langMenuEl) langMenuEl.classList.remove("open");
        if (langToggleBtn) langToggleBtn.setAttribute("aria-expanded", "false");
    };

    if (langToggleBtn && langMenuEl) {
        langToggleBtn.addEventListener("click", (e) => {
            e.stopPropagation();
            const isOpen = langMenuEl.classList.toggle("open");
            langToggleBtn.setAttribute("aria-expanded", isOpen ? "true" : "false");
        });

        document.addEventListener("click", (e) => {
            if (!langToggleBtn.contains(e.target) && !langMenuEl.contains(e.target)) {
                closeLangMenu();
            }
        });
    }

    // Initial translation run
    const initialCode = detectInitialLanguage();
    applyTranslations(initialCode);
}

// Mobile menu toggle
function initNavToggle() {
    const navToggle = document.querySelector(".nav-toggle");
    const navMenu = document.querySelector(".nav-menu");
    if (!navToggle || !navMenu) return;

    navToggle.addEventListener("click", () => {
        const isOpen = navMenu.classList.toggle("open");
        navToggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
    });

    navMenu.querySelectorAll(".nav-link").forEach((link) => {
        link.addEventListener("click", () => {
            navMenu.classList.remove("open");
            navToggle.setAttribute("aria-expanded", "false");
        });
    });
}

// Navbar scroll styling
function initNavbarScroll() {
    const navbar = document.querySelector(".navbar");
    if (!navbar) return;

    window.addEventListener(
        "scroll",
        () => {
            navbar.classList.toggle("scrolled", window.scrollY > 40);
        },
        { passive: true }
    );
}

// FAQ Accordion
function initFaqAccordion() {
    document.querySelectorAll(".faq-item").forEach((item) => {
        const questionBtn = item.querySelector(".faq-question");
        if (!questionBtn) return;
        questionBtn.addEventListener("click", () => {
            const wasActive = item.classList.contains("active");
            document.querySelectorAll(".faq-item").forEach((other) => {
                other.classList.remove("active");
            });
            if (!wasActive) {
                item.classList.add("active");
            }
        });
    });
}

// Table of contents active highlight for Docs / Privacy Policy
function bindTocHighlight() {
    const tocLinks = document.querySelectorAll(".docs-toc a");
    const sections = document.querySelectorAll(".docs-section");
    if (!tocLinks.length || !sections.length) return;

    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    const id = entry.target.getAttribute("id");
                    tocLinks.forEach((link) => {
                        link.classList.toggle("active", link.getAttribute("href") === `#${id}`);
                    });
                }
            });
        },
        { rootMargin: "-20% 0px -70% 0px" }
    );

    sections.forEach((sec) => observer.observe(sec));
}

// Initialize on DOMContentLoaded
document.addEventListener("DOMContentLoaded", () => {
    initI18n();
    initNavToggle();
    initNavbarScroll();
    initFaqAccordion();
    bindTocHighlight();
});
