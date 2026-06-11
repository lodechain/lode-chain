const express = require('express');
const rateLimit = require('express-rate-limit');
const fetch = require('node-fetch');

const app = express();
app.use(express.json());

// Serve a beautiful HTML form
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>LODE Testnet Faucet</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
            <style>
                :root {
                    --bg-base: #050505;
                    --bg-surface: rgba(17, 17, 17, 0.85);
                    --bg-surface-hover: rgba(26, 26, 26, 0.95);
                    --text-primary: #f0f0f0;
                    --text-secondary: #a0a0a0;
                    --accent: #d4af37;
                    --accent-glow: rgba(212, 175, 55, 0.15);
                    --border-color: #222;
                    --success: #4ade80;
                    --error: #f87171;
                }

                * { box-sizing: border-box; margin: 0; padding: 0; }

                body {
                    background-color: var(--bg-base);
                    color: var(--text-primary);
                    font-family: 'Inter', sans-serif;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    -webkit-font-smoothing: antialiased;
                }

                /* Network Canvas Background */
                #networkCanvas {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100vw;
                    height: 100vh;
                    z-index: -2;
                }

                .bg-fx {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100vw;
                    height: 100vh;
                    z-index: -1;
                    background: radial-gradient(circle at 50% 0%, var(--accent-glow) 0%, transparent 60%);
                    opacity: 0.8;
                    pointer-events: none;
                }

                .container {
                    width: 100%;
                    max-width: 600px;
                    padding: 40px;
                    background: var(--bg-surface);
                    backdrop-filter: blur(10px);
                    -webkit-backdrop-filter: blur(10px);
                    border: 1px solid var(--border-color);
                    border-radius: 16px;
                    box-shadow: 0 20px 40px rgba(0,0,0,0.6);
                    text-align: center;
                    animation: fadeIn 0.8s ease-out;
                    position: relative;
                    z-index: 1;
                }

                .logo {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 2.5rem;
                    font-weight: 700;
                    letter-spacing: 4px;
                    color: var(--accent);
                    margin-bottom: 8px;
                    text-decoration: none;
                    text-shadow: 0 0 15px var(--accent-glow);
                }

                h1 {
                    font-size: 1.8rem;
                    font-weight: 600;
                    margin-bottom: 16px;
                }

                p {
                    color: var(--text-secondary);
                    margin-bottom: 32px;
                    font-size: 1.05rem;
                }

                .input-group {
                    position: relative;
                    margin-bottom: 24px;
                }

                input {
                    width: 100%;
                    padding: 16px 20px;
                    background: var(--bg-base);
                    border: 1px solid var(--border-color);
                    border-radius: 8px;
                    color: var(--text-primary);
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 1rem;
                    transition: all 0.2s ease;
                }

                input:focus {
                    outline: none;
                    border-color: var(--accent);
                    box-shadow: 0 0 10px var(--accent-glow);
                }

                input::placeholder {
                    color: #444;
                }

                .btn {
                    width: 100%;
                    padding: 16px;
                    background: var(--accent);
                    color: #000;
                    border: none;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 1.1rem;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    font-family: 'Inter', sans-serif;
                }

                .btn:hover {
                    background: #e6c55c;
                    box-shadow: 0 0 20px rgba(212, 175, 55, 0.5);
                }
                
                .btn:disabled {
                    background: #555;
                    color: #888;
                    cursor: not-allowed;
                    box-shadow: none;
                }

                .message {
                    margin-top: 24px;
                    padding: 16px;
                    border-radius: 8px;
                    display: none;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 0.9rem;
                    word-break: break-all;
                }

                .message.success {
                    display: block;
                    background: rgba(74, 222, 128, 0.1);
                    color: var(--success);
                    border: 1px solid rgba(74, 222, 128, 0.2);
                }

                .message.error {
                    display: block;
                    background: rgba(248, 113, 113, 0.1);
                    color: var(--error);
                    border: 1px solid rgba(248, 113, 113, 0.2);
                }

                @keyframes fadeIn {
                    from { opacity: 0; transform: translateY(-20px); }
                    to { opacity: 1; transform: translateY(0); }
                }
                
                .back-link {
                    display: inline-block;
                    margin-top: 30px;
                    color: var(--text-secondary);
                    text-decoration: none;
                    font-size: 0.9rem;
                    transition: color 0.2s;
                }
                
                .back-link:hover {
                    color: var(--accent);
                }
            </style>
        </head>
        <body>
            <canvas id="networkCanvas"></canvas>
            <div class="bg-fx"></div>
            
            <div class="container">
                <a href="https://lodechain.org" class="logo">LODE</a>
                <h1>Testnet Faucet</h1>
                <p>Enter your LODE Testnet address (starting with M) to receive 10 free LODE for testing the network.</p>
                
                <div class="input-group">
                    <input type="text" id="address" placeholder="Enter your Testnet wallet address..." autocomplete="off" spellcheck="false">
                </div>
                
                <button id="submitBtn" class="btn" onclick="requestLODE()">Get LODE</button>
                
                <div id="result" class="message"></div>
                
                <a href="https://lodechain.org" class="back-link">← Back to Home</a>
            </div>

            <script>
                // Network Animation Script
                const canvas = document.getElementById('networkCanvas');
                const ctx = canvas.getContext('2d');
                let width, height, particles;

                function init() {
                    width = canvas.width = window.innerWidth;
                    height = canvas.height = window.innerHeight;
                    particles = [];
                    const particleCount = Math.floor((width * height) / 12000);
                    
                    for(let i = 0; i < particleCount; i++) {
                        particles.push(new Particle());
                    }
                }

                class Particle {
                    constructor() {
                        this.x = Math.random() * width;
                        this.y = Math.random() * height;
                        this.vx = (Math.random() - 0.5) * 0.6;
                        this.vy = (Math.random() - 0.5) * 0.6;
                        this.radius = Math.random() * 1.5 + 0.5;
                    }
                    update() {
                        this.x += this.vx;
                        this.y += this.vy;
                        
                        if(this.x < 0 || this.x > width) this.vx = -this.vx;
                        if(this.y < 0 || this.y > height) this.vy = -this.vy;
                    }
                    draw() {
                        ctx.beginPath();
                        ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
                        ctx.fillStyle = 'rgba(212, 175, 55, 0.4)';
                        ctx.fill();
                    }
                }

                function animate() {
                    ctx.clearRect(0, 0, width, height);
                    
                    for(let i = 0; i < particles.length; i++) {
                        particles[i].update();
                        particles[i].draw();
                        
                        for(let j = i + 1; j < particles.length; j++) {
                            const dx = particles[i].x - particles[j].x;
                            const dy = particles[i].y - particles[j].y;
                            const dist = Math.sqrt(dx*dx + dy*dy);
                            
                            if(dist < 140) {
                                ctx.beginPath();
                                ctx.moveTo(particles[i].x, particles[i].y);
                                ctx.lineTo(particles[j].x, particles[j].y);
                                ctx.strokeStyle = \`rgba(212, 175, 55, \${0.2 * (1 - dist/140)})\`;
                                ctx.lineWidth = 1;
                                ctx.stroke();
                            }
                        }
                    }
                    requestAnimationFrame(animate);
                }

                window.addEventListener('resize', init);
                init();
                animate();

                // Faucet Logic
                async function requestLODE() {
                    const addrInput = document.getElementById('address');
                    const addr = addrInput.value.trim();
                    const resultDiv = document.getElementById('result');
                    const btn = document.getElementById('submitBtn');
                    
                    if (!addr) {
                        resultDiv.className = 'message error';
                        resultDiv.innerText = 'Please enter a wallet address.';
                        return;
                    }

                    btn.disabled = true;
                    btn.innerText = 'Processing...';
                    resultDiv.className = 'message';
                    resultDiv.innerText = '';

                    try {
                        const res = await fetch('/faucet', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify({address: addr})
                        });
                        const data = await res.json();
                        
                        if (res.ok && data.message) {
                            resultDiv.className = 'message success';
                            resultDiv.innerText = data.message;
                            addrInput.value = '';
                        } else {
                            resultDiv.className = 'message error';
                            resultDiv.innerText = data.error || 'An error occurred. Please try again later.';
                        }
                    } catch (e) {
                        resultDiv.className = 'message error';
                        resultDiv.innerText = 'Connection error to the Faucet server.';
                    } finally {
                        btn.disabled = false;
                        btn.innerText = 'Get LODE';
                    }
                }
            </script>
        </body>
        </html>
    `);
});

// Trust proxy for rate limiting (Cloudflare/Nginx)
app.set('trust proxy', 1);

// Rate limiter: 1 request per IP per 24 hours
const limiter = rateLimit({
    windowMs: 24 * 60 * 60 * 1000, // 24 hours
    max: 1, // limit each IP to 1 request per windowMs
    message: { error: "You have already requested LODE today. Please try again tomorrow." }
});

const RPC_URL = "http://127.0.0.1:38083/json_rpc";

app.post('/faucet', limiter, async (req, res) => {
    const { address } = req.body;

    if (!address || typeof address !== 'string') {
        return res.status(400).json({ error: "Address is required." });
    }

    // Verify testnet prefix (Starts with 'M' based on prefix 120)
    if (!address.startsWith('M') || address.length < 90) {
        return res.status(400).json({ error: "Invalid Testnet address. (Must start with M)" });
    }

    // Amount to send: 10 LODE (10 * 10^8 grains)
    const amount = 1000000000;

    try {
        const response = await fetch(RPC_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                jsonrpc: "2.0",
                id: "0",
                method: "transfer",
                params: {
                    destinations: [{ amount: amount, address: address }],
                    ring_size: 16
                }
            })
        });

        const data = await response.json();

        if (data.error) {
            console.error("RPC Error:", data.error);
            return res.status(500).json({ error: "Internal Faucet Wallet Error: " + data.error.message });
        }

        res.json({ message: "Success! 10 LODE sent. TX Hash: " + data.result.tx_hash });
    } catch (err) {
        console.error("Fetch Error:", err);
        res.status(500).json({ error: "Failed to connect to Faucet Wallet RPC." });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`LODE Faucet running on port ${PORT}`);
});