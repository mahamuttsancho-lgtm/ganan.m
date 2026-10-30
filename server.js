/**
 * GANAAN BURGER & FAST FOOD RESTAURANT
 * Backend API Server (Node.js + Express + MySQL)
 */

const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));

// MySQL Connection Configuration
const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'ganaan_burger_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
};

let pool;
let isDbConnected = false;

async function initDb() {
    try {
        pool = mysql.createPool(dbConfig);
        const connection = await pool.getConnection();
        console.log('✅ Xiriirka MySQL wuu guuleystay! (Connected to MySQL database: ' + dbConfig.database + ')');
        connection.release();
        isDbConnected = true;
    } catch (err) {
        console.warn('⚠️ Digniin: MySQL ma xirna ama wali lama bilaabin. (MySQL not currently reachable: ' + err.message + ')');
        console.warn('💡 Tip: Waxaad isticmaali kartaa system-ka browser ahaan ama bilaabi kartaa XAMPP / MySQL.');
        isDbConnected = false;
    }
}

initDb();

// ----------------------------------------------------
// API ROUTES
// ----------------------------------------------------

// 1. Health check
app.get('/api/health', (req, res) => {
    res.json({
        status: 'online',
        system: 'Ganaan Burger & Fast Food API',
        databaseConnected: isDbConnected,
        timestamp: new Date()
    });
});

// 2. Categories
app.get('/api/categories', async (req, res) => {
    if (!isDbConnected) return res.status(503).json({ error: 'Database not connected' });
    try {
        const [rows] = await pool.query('SELECT * FROM categories WHERE is_active = 1 ORDER BY id ASC');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 3. Products
app.get('/api/products', async (req, res) => {
    if (!isDbConnected) return res.status(503).json({ error: 'Database not connected' });
    try {
        const { category_id, search } = req.query;
        let query = `
            SELECT p.*, c.name as category_name, c.name_so as category_name_so 
            FROM products p 
            JOIN categories c ON p.category_id = c.id 
            WHERE p.is_available = 1
        `;
        const params = [];

        if (category_id && category_id !== 'all') {
            query += ' AND p.category_id = ?';
            params.push(category_id);
        }

        if (search) {
            query += ' AND (p.name LIKE ? OR p.name_so LIKE ? OR p.description LIKE ?)';
            const term = `%${search}%`;
            params.push(term, term, term);
        }

        query += ' ORDER BY p.is_featured DESC, p.id ASC';

        const [products] = await pool.query(query, params);
        res.json(products);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 4. Create New Order (Dalab Cusub)
app.post('/api/orders', async (req, res) => {
    if (!isDbConnected) return res.status(503).json({ error: 'Database not connected' });
    
    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        const {
            customer_name,
            customer_phone,
            order_type,
            table_number,
            delivery_address,
            items,
            subtotal,
            tax,
            delivery_fee,
            total_amount,
            payment_method,
            notes
        } = req.body;

        const orderNumber = 'ORD-' + Math.floor(100000 + Math.random() * 900000);

        const [orderResult] = await connection.query(
            `INSERT INTO orders 
            (order_number, customer_name, customer_phone, order_type, table_number, delivery_address, subtotal, tax, delivery_fee, total_amount, payment_method, payment_status, order_status, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'paid', 'cooking', ?)`,
            [orderNumber, customer_name, customer_phone, order_type, table_number || null, delivery_address || null, subtotal, tax || 0, delivery_fee || 0, total_amount, payment_method, notes || '']
        );

        const orderId = orderResult.insertId;

        // Insert items
        for (const item of items) {
            await connection.query(
                `INSERT INTO order_items (order_id, product_id, product_name, price, quantity, addons_detail, subtotal)
                VALUES (?, ?, ?, ?, ?, ?, ?)`,
                [orderId, item.id, item.name, item.price, item.quantity, item.addons ? item.addons.join(', ') : null, (item.price * item.quantity)]
            );
        }

        await connection.commit();

        res.status(201).json({
            success: true,
            message: 'Dalabkaaga si fiican baa loo gudbiyay!',
            order_id: orderId,
            order_number: orderNumber
        });
    } catch (err) {
        await connection.rollback();
        res.status(500).json({ error: err.message });
    } finally {
        connection.release();
    }
});

// 5. Get All Orders (Maamulka / Kitchen Display)
app.get('/api/orders', async (req, res) => {
    if (!isDbConnected) return res.status(503).json({ error: 'Database not connected' });
    try {
        const [orders] = await pool.query('SELECT * FROM orders ORDER BY created_at DESC LIMIT 50');
        
        // Fetch items for each order
        for (let order of orders) {
            const [items] = await pool.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
            order.items = items;
        }

        res.json(orders);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 6. Update Order Status
app.patch('/api/orders/:id/status', async (req, res) => {
    if (!isDbConnected) return res.status(503).json({ error: 'Database not connected' });
    try {
        const { id } = req.params;
        const { order_status } = req.body;
        
        await pool.query('UPDATE orders SET order_status = ? WHERE id = ?', [order_status, id]);
        res.json({ success: true, message: 'Heerka dalabka waa la cusbooneysiiyay!' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 7. System Dashboard Stats
app.get('/api/stats', async (req, res) => {
    if (!isDbConnected) return res.status(503).json({ error: 'Database not connected' });
    try {
        const [[sales]] = await pool.query('SELECT SUM(total_amount) as total_revenue, COUNT(id) as total_orders FROM orders WHERE payment_status = "paid"');
        const [[pending]] = await pool.query('SELECT COUNT(id) as pending_count FROM orders WHERE order_status IN ("pending", "cooking")');
        const [topItems] = await pool.query(`
            SELECT product_name, SUM(quantity) as total_qty, SUM(subtotal) as revenue 
            FROM order_items 
            GROUP BY product_name 
            ORDER BY total_qty DESC 
            LIMIT 5
        `);

        res.json({
            total_revenue: sales.total_revenue || 0,
            total_orders: sales.total_orders || 0,
            pending_orders: pending.pending_count || 0,
            top_items: topItems
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Default route opens index.html
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start Server
app.listen(PORT, () => {
    console.log(`🚀 Ganaan Burger Server is running on http://localhost:${PORT}`);
});
