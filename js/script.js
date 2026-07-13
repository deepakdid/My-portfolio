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

// Progressive blur on scroll â€” add .scrolled class to navbar
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


// Contact Modal
const modalHtml = `
<div class="contact-modal-overlay" id="contactModal">
    <div class="contact-modal">
        <button class="contact-modal-close" onclick="closeContactModal()" aria-label="Close"><i data-lucide="x"></i></button>
        <h3>Let's talk</h3>
        <p>Reach out via email or WhatsApp. I usually reply within a few hours.</p>
        
        <div class="contact-card">
            <div class="contact-label">EMAIL</div>
            <div class="contact-info">
                <span>deepak.thinkux@gmail.com</span>
                <button class="copy-btn" onclick="copyEmail(this)"><i data-lucide="copy"></i> Copy</button>
            </div>
        </div>
        
        <div class="contact-card">
            <div class="contact-label">WHATSAPP</div>
            <div class="contact-info">
                <div class="wa-number"><span class="flag-icon">🇮🇳</span> +91 9677081096</div>
                <a href="https://wa.me/919677081096" target="_blank" class="chat-btn">
                    <svg viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12.031 0C5.394 0 .013 5.38.013 12.016c0 2.12.553 4.186 1.604 6.002L.053 24l6.147-1.611a11.97 11.97 0 005.831 1.517c6.634 0 12.016-5.38 12.016-12.016S18.667 0 12.031 0zm6.54 17.202c-.279.787-1.618 1.488-2.222 1.545-.53.05-1.198.156-3.791-.918-3.136-1.299-5.188-4.542-5.344-4.75-.157-.208-1.275-1.696-1.275-3.238 0-1.542.805-2.302 1.09-2.589.284-.287.622-.358.828-.358.208 0 .416.001.597.009.188.008.439-.074.686.52.261.63.834 2.034.908 2.181.074.146.124.318.02.525-.104.208-.156.338-.312.52-.156.182-.33.407-.47.545-.156.155-.316.326-.134.64.182.313.808 1.336 1.737 2.164 1.206 1.838 1.487 2.02 1.774.182.287.02.443-.075.641-.093.197-.406.47-.562.641-.156.171-.322.364-.104.737.218.373.97 1.591 2.08 2.592 1.442 1.3 2.628 1.705 3.003 1.85.375.146.595.124.819-.13.224-.254.965-1.127 1.225-1.516.26-.388.52-.325.867-.195.346.13 2.193 1.036 2.568 1.225.375.188.625.281.716.436.091.155.091.902-.188 1.689z"/></svg> 
                    Chat
                </a>
            </div>
        </div>
    </div>
</div>
`;
document.body.insertAdjacentHTML('beforeend', modalHtml);
if(window.lucide) { lucide.createIcons(); }

window.openContactModal = function(e) {
    if(e) e.preventDefault();
    document.getElementById('contactModal').classList.add('active');
}

window.closeContactModal = function() {
    document.getElementById('contactModal').classList.remove('active');
}

// Close modal when clicking outside
document.getElementById('contactModal').addEventListener('click', function(e) {
    if(e.target === this) {
        closeContactModal();
    }
});

window.copyEmail = function(btn) {
    navigator.clipboard.writeText('deepak.thinkux@gmail.com').then(() => {
        const originalHtml = btn.innerHTML;
        btn.innerHTML = '<i data-lucide="check"></i> Copied';
        lucide.createIcons();
        btn.classList.add('copied');
        setTimeout(() => {
            btn.innerHTML = originalHtml;
            lucide.createIcons();
            btn.classList.remove('copied');
        }, 2000);
    });
}