# 🍔 GANAAN BURGER & FAST FOOD RESTAURANT MANAGEMENT SYSTEM

Nidaam casri ah oo dhamaystiran oo loogu talagalay maamulka muqayadda iyo dalabka cuntada ee **Ganaan Burger** (Burgers, Shawarma, Drinks & Sides).

---

## 🌟 Tilmaamaha Nidaamka (Key Features)

1. **Nashqad Aad U Qurux Badan (Modern Ultra-Sleek UI/UX)**:
   - Ku dhisan **React 18** iyo **Tailwind CSS**.
   - Sawirro tayo sare leh (High-Resolution Food Photography).
   - Saamaynta codadka (Audio interactive sound chimes) marka la dalbayo ama badhanka la riixo.
   - Luuqadaha: **Af-Soomaali** iyo **English**.
   - Lacagaha: **$ USD** iyo **SOS (Somali Shilling)** oo si toos ah isu beddelaya.

2. **Cuntooyinka & Qiimaha (Menu Items & Real Pricing)**:
   - **🍔 Burgers**:
     - *Ganaan Signature Beef Burger* ($4.50)
     - *Crispy Zinger Chicken Burger* ($5.00)
     - *Double Smash Cheeseburger* ($6.50)
     - *Smoky BBQ Bacon Burger* ($5.50)
   - **🌯 Shawarma (Shuwarmo & Wraps)**:
     - *Ganaan Signature Chicken Shawarma* ($3.50)
     - *Premium Beef Shawarma Roll* ($4.20)
     - *Super Mixed Shawarma Plate* ($7.00)
   - **🥤 Drinks & Fresh Juices (Cabitaanno & Casiirro)**:
     - *Fresh Somali Sweet Mango Juice* ($2.00)
     - *Vimto Ice Slush & Mint* ($1.50)
     - *Shaah Caddiis Carfaya* ($1.00)
     - *Creamy Oreo Milkshake* ($3.00)
   - **🍟 Sides & Combos (Raacis & Faraas)**:
     - *Crispy Golden French Fries* ($1.50)
     - *Cheesy Loaded Dynamite Fries* ($3.50)

3. **Gaariga Dalabka & Bixinta (Cart, Checkout & Mobile Money)**:
   - Doorashada nooca adeegga: **Dine-In (Cunista Gudaha / Doorashada Miiska)**, **Takeaway (Horay u qaado)**, ama **Delivery (Geynta Guriga)**.
   - Hababka Lacag-Bixinta Soomaaliya: **EVC Plus**, **Zaad**, **Sahal**, iyo **Lacag Caddaan ah (Cash)**.
   - Waxyaabaha dheeraadka ah (Add-ons: Extra Cheese, Double Patty, Toom Sauce, iwm).

4. **Daabacaadda Rasiidka (Printable Thermal POS Receipt)**:
   - Rasiid rasmi ah oo leh Logo, taariikh, faahfaahinta cuntooyinka, canshuurta, iyo wadarta lacagta.
   - Hal gujin ku daabac qalabka daabacaadda rasiidhada (POS Thermal Printer ama PDF).

5. **Shaashadda Kushiinka (Kitchen Display Screen - KDS)**:
   - Shaashad toos ah oo loogu talagalay shaqaalaha kushiinka.
   - Marxaladaha: **Cooking (Diyaarinta)** ➔ **Ready (Waa Diyaar)** ➔ **Completed (La Bixiyay)**.

6. **Maamulka & Dakhliga (Admin Analytics & Product Manager)**:
   - Dashboard tirakoobaya: Wadarta Dakhliga, Dalabyada firfircoon, Celceliska dalabka.
   - Kudar cunto cusub ama bedel qiimaha.

7. **MySQL Database & REST API**:
   - `database.sql`: Schema dhamaystiran oo leh Tables (`categories`, `products`, `orders`, `order_items`, `product_addons`, `restaurant_settings`).
   - `server.js`: Node.js + Express API backend oo toos ugu xirmaya MySQL.
   - SQL Export feature: Dalabyada toos ugu daji fayl `.sql` ah.

---

## 🚀 Sida Loo Furayo & Loo Isticmaalayo (How to Run)

### Habka 1: Si Toos ah Browser-ka ugu Fur (Double Click - Recommended)
1. Gal galka: `c:\Users\HP\Documents\Ganaan-Burger-System`
2. Labo jeer ku dhufo faylka: **`index.html`** (wuxuu toos ugu furmayaa Microsoft Edge ama Google Chrome).
3. System-ku wuxuu ku shaqeynayaa 100% degdeg ah isagoo wata dhammaan xogta iyo dalabyada!

### Habka 2: Ku Xir MySQL iyo Node.js Server (Full Stack Mode)
Haddii aad rabto inaad ku xirto MySQL Database rasmi ah:
1. Fur MySQL (tusaale ahaan adigoo isticmaalaya **XAMPP** ama MySQL Server).
2. Ku shub faylka `database.sql` adigoo isticmaalaya phpMyAdmin ama amarka:
   ```bash
   mysql -u root -p < database.sql
   ```
3. Ku dhex orod galka amarka:
   ```bash
   npm install
   npm start
   ```
4. Fur: `http://localhost:5000`

---

## 📁 Qaab-dhismeedka Faylasha (File Structure)

```text
Ganaan-Burger-System/
├── index.html        # Frontend-ka React.js, Tailwind CSS, POS & KDS
├── database.sql      # Database-ka MySQL, Tables, Views & Sample Data
├── server.js         # Node.js + Express REST API Server
├── package.json      # Node.js dependencies & scripts
└── README.md         # Faahfaahinta nidaamka iyo tusmada
```

---
**Ganaan Burger System** © 2026 - Waxaa loogu talagalay muqayado casri ah oo heer sare ah.
