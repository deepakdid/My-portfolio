$cssPath = "c:\Users\deepa\.gemini\antigravity\scratch\portfolio\css\style.css"
$css = Get-Content $cssPath -Raw

# Remove status dot animation and style entirely
$css = $css -replace '\.status-dot\s*\{[\s\S]*?@keyframes\s+blink-pulse\s*\{[\s\S]*?\}', ''

# Append modal css
$modalCss = @"

/* Contact Modal */
.contact-modal-overlay {
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.4);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.3s ease;
}

.contact-modal-overlay.active {
    opacity: 1;
    pointer-events: auto;
}

.contact-modal {
    background: #fff;
    width: 90%;
    max-width: 440px;
    border-radius: 24px;
    padding: 32px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.1);
    position: relative;
    transform: translateY(20px);
    transition: transform 0.3s ease;
    font-family: var(--font-sans);
}

.contact-modal-overlay.active .contact-modal {
    transform: translateY(0);
}

.contact-modal-close {
    position: absolute;
    top: 20px;
    right: 20px;
    background: #f5f5f5;
    border: none;
    border-radius: 50%;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    color: var(--text-primary);
    transition: background 0.2s;
}

.contact-modal-close:hover {
    background: #e0e0e0;
}

.contact-modal-close i {
    width: 16px;
    height: 16px;
}

.contact-modal h3 {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 12px;
    color: var(--text-primary);
}

.contact-modal p {
    font-size: 14px;
    color: var(--text-secondary);
    margin-bottom: 24px;
    line-height: 1.5;
}

.contact-card {
    background: #fff;
    border: 1px solid #eaeaea;
    border-radius: 16px;
    padding: 16px;
    margin-bottom: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.02);
}

.contact-label {
    font-size: 11px;
    color: #888;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
    font-weight: 600;
}

.contact-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.contact-info > span {
    font-size: 15px;
    color: var(--text-primary);
    font-weight: 500;
}

.copy-btn {
    background: #f5f5f5;
    border: none;
    padding: 8px 12px;
    border-radius: 100px;
    font-size: 13px;
    font-weight: 500;
    color: var(--text-primary);
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
    transition: all 0.2s;
}

.copy-btn i {
    width: 14px;
    height: 14px;
}

.copy-btn:hover {
    background: #e0e0e0;
}

.copy-btn.copied {
    background: #e8f5e9;
    color: #2e7d32;
}

.wa-number {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 15px;
    font-weight: 500;
    color: var(--text-primary);
}

.flag-icon {
    font-size: 18px;
    line-height: 1;
}

.chat-btn {
    background: #111;
    color: #fff;
    text-decoration: none;
    padding: 8px 16px;
    border-radius: 100px;
    font-size: 13px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 6px;
    transition: background 0.2s;
}

.chat-btn svg {
    width: 14px;
    height: 14px;
}

.chat-btn:hover {
    background: #333;
}
"@
$css += "`n" + $modalCss

# update border radiuses
$css = $css -replace 'border-radius:\s*20px;', 'border-radius: 100px;'

[IO.File]::WriteAllText($cssPath, $css)

$jsPath = "c:\Users\deepa\.gemini\antigravity\scratch\portfolio\js\script.js"
$js = Get-Content $jsPath -Raw
$modalJs = @"

// Contact Modal
const modalHtml = `
<div class="contact-modal-overlay" id="contactModal">
    <div class="contact-modal">
        <button class="contact-modal-close" onclick="closeContactModal()" aria-label="Close"><i data-lucide="x"></i></button>
        <h3>Let's talk</h3>
        <p>Reach out via email or WhatsApp — I usually reply within a few hours.</p>
        
        <div class="contact-card">
            <div class="contact-label">EMAIL</div>
            <div class="contact-info">
                <span>mani.s.uxui@gmail.com</span>
                <button class="copy-btn" onclick="copyEmail(this)"><i data-lucide="copy"></i> Copy</button>
            </div>
        </div>
        
        <div class="contact-card">
            <div class="contact-label">WHATSAPP</div>
            <div class="contact-info">
                <div class="wa-number"><span class="flag-icon">🇮🇳</span> +91 88707 95729</div>
                <a href="https://wa.me/918870795729" target="_blank" class="chat-btn">
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
    navigator.clipboard.writeText('mani.s.uxui@gmail.com').then(() => {
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
"@
$js += "`n" + $modalJs
[IO.File]::WriteAllText($jsPath, $js)

$htmlFiles = Get-ChildItem -Path c:\Users\deepa\.gemini\antigravity\scratch\portfolio -Recurse -Filter *.html
foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace the Hire me button and dot with Let's talk + openContactModal
    $content = $content -replace '<a href="https://mail.google.com/mail/\?view=cm&fs=1&to=deepak.thinkux@gmail.com" target="_blank" class="hire-me-btn">\s*<span class="status-dot"></span>\s*Hire me\s*</a>', '<a href="#" class="hire-me-btn" onclick="openContactModal(event)">Let''s talk</a>'
    
    [IO.File]::WriteAllText($file.FullName, $content)
}

Write-Output "Update completed."
