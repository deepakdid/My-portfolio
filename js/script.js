// Initialize Lucide icons
lucide.createIcons();

// Add smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Progressive blur on scroll — add .scrolled class to navbar
const navbar = document.querySelector('.navbar');
let ticking = false;

window.addEventListener('scroll', () => {
    if (!ticking) {
        window.requestAnimationFrame(() => {
            if (window.scrollY > 20) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
            ticking = false;
        });
        ticking = true;
    }
});

// Mobile menu toggle
const mobileMenuBtn = document.getElementById('mobileMenuBtn');
if (mobileMenuBtn) {
    mobileMenuBtn.addEventListener('click', () => {
        document.body.classList.toggle('menu-open');
    });
}

// Close mobile menu when a nav link is clicked
document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', () => {
        document.body.classList.remove('menu-open');
    });
});

// Close mobile menu when clicking the empty background area
const mainNav = document.getElementById('mainNav');
if (mainNav) {
    mainNav.addEventListener('click', (e) => {
        if (e.target === mainNav) {
            document.body.classList.remove('menu-open');
        }
    });
}

// Case study sidebar scroll tracking
const caseSections = document.querySelectorAll('.case-content section[id]');
const sidebarLinks = document.querySelectorAll('.sidebar-nav li a');

if (caseSections.length > 0 && sidebarLinks.length > 0) {
    const observerOptions = {
        root: null,
        rootMargin: '-20% 0px -60% 0px',
        threshold: 0
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.getAttribute('id');
                
                // Remove active class from all links
                sidebarLinks.forEach(link => {
                    link.classList.remove('active');
                });
                
                // Add active class to corresponding link
                const activeLink = document.querySelector(`.sidebar-nav li a[href="#${id}"]`);
                if (activeLink) {
                    activeLink.classList.add('active');
                }
            }
        });
    }, observerOptions);

    caseSections.forEach(section => {
        observer.observe(section);
    });
}

// Fun Facts Marquee smooth hover slow-down
const factsMarquee = document.getElementById('factsMarquee');
if (factsMarquee) {
    const track = factsMarquee.querySelector('.marquee-track');
    let animFrameId;
    
    const animatePlaybackRate = (targetRate) => {
        const animations = track.getAnimations();
        if (animations.length === 0) return;
        
        cancelAnimationFrame(animFrameId);
        
        animations.forEach(anim => {
            const startRate = anim.playbackRate;
            const startTime = performance.now();
            const duration = 400; // ms to complete the speed change
            
            const step = (currentTime) => {
                const progress = Math.min((currentTime - startTime) / duration, 1);
                // Easing function (ease-out cubic)
                const easeOut = 1 - Math.pow(1 - progress, 3);
                
                anim.playbackRate = startRate + (targetRate - startRate) * easeOut;
                
                if (progress < 1) {
                    animFrameId = requestAnimationFrame(step);
                }
            };
            animFrameId = requestAnimationFrame(step);
        });
    };
    
    factsMarquee.addEventListener('mouseenter', () => {
        animatePlaybackRate(0.15); // Slow down to 15% speed for gentle scroll
    });
    
    factsMarquee.addEventListener('mouseleave', () => {
        animatePlaybackRate(1); // Back to normal speed
    });
}
