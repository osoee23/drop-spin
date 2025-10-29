<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Faction Drop Spin</title>
  <link rel="stylesheet" href="assets/css/spinner.css">
</head>
<body>

<h1>Faction Drop Spin</h1>

<div class="spinner">
  <div id="slot" class="slot"></div>
</div>

<button id="spinBtn">SPIN</button>

<!-- Winner Overlay -->
<div id="winnerPopup" class="winner-popup hidden">
  <div class="winner-content">
    <img id="winnerImage" src="" alt="">
    <h2 id="winnerName"></h2>
    <button id="closePopup">OK</button>
  </div>
</div>

<script src="assets/js/spinner.js"></script>
</body>
</html>
body {
  background: #111;
  color: #eee;
  font-family: 'Inter', sans-serif;
  text-align: center;
  padding-top: 40px;
}

h1 {
  font-weight: 300;
  letter-spacing: 2px;
  margin-bottom: 30px;
}

.spinner {
  width: 230px;
  height: 130px;
  overflow: hidden;
  border-radius: 14px;
  margin: 0 auto 20px;
  background: #1a1a1a;
  box-shadow: 0 0 25px rgba(0,0,0,0.35), inset 0 0 8px rgba(255,255,255,0.1);
  padding: 6px;
}

.slot {
  display: flex;
  flex-direction: column;
}

.slot-item {
  height: 130px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.slot-item img {
  width: 85px;
  height: 85px;
  object-fit: contain;
  filter: drop-shadow(0 0 6px rgba(255,255,255,0.2));
}

.slot-item span {
  margin-top: 6px;
  font-size: 17px;
  opacity: 0.85;
}

button {
  background: #ffffff;
  border: none;
  color: #111;
  font-size: 18px;
  padding: 12px 26px;
  border-radius: 8px;
  cursor: pointer;
  transition: 0.25s;
}

button:hover {
  background: #e8e8e8;
}

/* WINNER POPUP */
.winner-popup {
  position: fixed;
  inset: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  backdrop-filter: blur(14px);
  background: rgba(0,0,0,0.55);
}

.winner-popup.hidden {
  display: none;
}

.winner-content {
  background: #1b1b1b;
  padding: 26px 40px;
  border-radius: 14px;
  text-align: center;
  box-shadow: 0 0 30px rgba(0,0,0,0.5);
  animation: pop-in 0.4s ease;
}

.winner-content img {
  width: 120px;
  margin-bottom: 10px;
  filter: drop-shadow(0 0 10px rgba(255,255,255,0.25));
}

@keyframes pop-in {
  from { transform: scale(0.7); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}
const slot = document.getElementById("slot");
const spinBtn = document.getElementById("spinBtn");

const popup = document.getElementById("winnerPopup");
const winnerName = document.getElementById("winnerName");
const winnerImage = document.getElementById("winnerImage");
const closeBtn = document.getElementById("closePopup");

let factions = [];
let spinning = false;

fetch("data/factions.json")
  .then(res => res.json())
  .then(data => factions = data);

function renderSlot() {
  slot.innerHTML = "";
  factions.forEach(f => {
    const item = document.createElement("div");
    item.className = "slot-item";
    item.innerHTML = `
      <img src="${f.image}" alt="${f.name}">
      <span>${f.name}</span>
    `;
    slot.appendChild(item);
  });
}

function showWinner(faction) {
  winnerName.textContent = faction.name;
  winnerImage.src = faction.image;
  popup.classList.remove("hidden");
}

closeBtn.addEventListener("click", () => popup.classList.add("hidden"));

function spin() {
  if (spinning || factions.length === 0) return;
  spinning = true;

  renderSlot();
  slot.style.transition = "none";
  slot.style.transform = "translateY(0px)";

  const itemH = 130;
  const cycles = 25 + Math.floor(Math.random() * 12);
  const index = Math.floor(Math.random() * factions.length);
  const distance = (cycles * factions.length + index) * itemH;

  requestAnimationFrame(() => {
    slot.style.transition = "transform 3.2s cubic-bezier(.25,.9,.25,1)";
    slot.style.transform = `translateY(-${distance}px)`;
  });

  setTimeout(() => {
    showWinner(factions[index]);
    spinning = false;
  }, 3400);
}

spinBtn.addEventListener("click", spin);
