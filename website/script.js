// Navbar scroll effect
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

// Smooth scroll for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const navbarHeight = document.querySelector('.navbar').offsetHeight;
            const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - navbarHeight - 20;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Animate elements on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe feature cards, steps, and sections
document.addEventListener('DOMContentLoaded', function() {
    // Set initial state for animated elements
    const animatedElements = document.querySelectorAll('.feature-card, .step, .privacy-content > *');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Add stagger delay to feature cards
    document.querySelectorAll('.feature-card').forEach((card, index) => {
        card.style.transitionDelay = `${index * 0.1}s`;
    });

    // Add stagger delay to steps
    document.querySelectorAll('.step').forEach((step, index) => {
        step.style.transitionDelay = `${index * 0.15}s`;
    });
});

// Mobile menu toggle (if needed in the future)
function toggleMobileMenu() {
    const navLinks = document.querySelector('.nav-links');
    navLinks.classList.toggle('active');
}

// Add parallax effect to hero background circles
window.addEventListener('scroll', function() {
    const scrolled = window.pageYOffset;
    const circles = document.querySelectorAll('.gradient-circle');
    
    circles.forEach((circle, index) => {
        const speed = (index + 1) * 0.1;
        circle.style.transform = `translateY(${scrolled * speed}px)`;
    });
});

// Update stats with animation (when they come into view)
function animateCounter(element, target, duration) {
    let current = 0;
    const increment = target / (duration / 16);
    
    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            element.textContent = target;
            clearInterval(timer);
        } else {
            element.textContent = Math.floor(current);
        }
    }, 16);
}

// Observe stats for counter animation
const statsObserver = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting && !entry.target.dataset.animated) {
            entry.target.dataset.animated = 'true';
            // You can add counter animation here if needed for stats
        }
    });
}, { threshold: 0.5 });

document.querySelectorAll('.stat-number').forEach(stat => {
    statsObserver.observe(stat);
});

// Add hover effect to phone mockup
const phoneMockup = document.querySelector('.phone-mockup');
if (phoneMockup) {
    phoneMockup.addEventListener('mouseenter', function() {
        this.style.transform = 'scale(1.05) rotateY(5deg)';
        this.style.transition = 'transform 0.3s ease';
    });
    
    phoneMockup.addEventListener('mouseleave', function() {
        this.style.transform = 'scale(1) rotateY(0deg)';
    });
}

// Handle App Store link click (update this when you have the actual App Store URL)
document.querySelectorAll('a[href="#"]').forEach(link => {
    if (link.textContent.includes('App Store')) {
        link.addEventListener('click', function(e) {
            // Uncomment when you have the App Store URL
            // window.open('YOUR_APP_STORE_URL', '_blank');
            console.log('App Store link clicked - add your App Store URL here');
        });
    }
});

// Prevent default on placeholder links
document.querySelectorAll('a[href="#download"]').forEach(link => {
    link.addEventListener('click', function(e) {
        e.preventDefault();
        // Scroll to download section
        const downloadSection = document.querySelector('#download');
        if (downloadSection) {
            const navbarHeight = document.querySelector('.navbar').offsetHeight;
            const targetPosition = downloadSection.getBoundingClientRect().top + window.pageYOffset - navbarHeight - 20;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Add active state to navigation links based on scroll position
window.addEventListener('scroll', function() {
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.nav-links a[href^="#"]');
    
    let current = '';
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (pageYOffset >= sectionTop - 200) {
            current = section.getAttribute('id');
        }
    });

    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href').slice(1) === current) {
            link.classList.add('active');
        }
    });
});

// Easter egg: Konami code for fun
const konamiCode = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'b', 'a'];
let konamiIndex = 0;

document.addEventListener('keydown', function(e) {
    if (e.key === konamiCode[konamiIndex]) {
        konamiIndex++;
        if (konamiIndex === konamiCode.length) {
            // Easter egg activated!
            document.body.style.animation = 'rainbow 2s linear infinite';
            setTimeout(() => {
                document.body.style.animation = '';
            }, 5000);
            konamiIndex = 0;
        }
    } else {
        konamiIndex = 0;
    }
});

// Add rainbow animation for easter egg
const style = document.createElement('style');
style.textContent = `
    @keyframes rainbow {
        0% { filter: hue-rotate(0deg); }
        100% { filter: hue-rotate(360deg); }
    }
`;
document.head.appendChild(style);
