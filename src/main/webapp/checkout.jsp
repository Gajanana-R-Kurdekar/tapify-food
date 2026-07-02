<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.instafood.model.Cart" %>
<%@ page import="com.instafood.model.CartItem" %>
<%@ page import="com.instafood.model.User" %>
<%@ page import="java.util.Map" %>
<%
// Session & Authentication check
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.html");
    return;
}

// Cart initialization and empty check
Cart cart = (Cart) session.getAttribute("cart");
Map<Integer, CartItem> cartItems = (cart != null) ? cart.getItems() : null;
boolean isEmpty = (cartItems == null || cartItems.isEmpty());
if (isEmpty) {
    response.sendRedirect("cart.jsp");
    return;
}

// Calculate pricing details
double subtotal = 0.0;
for (CartItem item : cartItems.values()) {
    subtotal += item.getTotalPrice();
}
double deliveryFee = 40.0;
double tax = subtotal * 0.05; // 5% GST
double grandTotal = subtotal + deliveryFee + tax;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout - Tapify Food</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;500;600;700;800&display=swap');

        :root {
            /* Color Palette */
            --bg-primary: #120f0d;
            --bg-secondary: #1c1815;
            --bg-tertiary: #25201b;
            --accent-orange: #fc8019;
            --accent-yellow: #ff9f00;
            --text-primary: #ffffff;
            --text-secondary: #a89f95;
            --text-muted: #72685e;
            --border-color: #2c241e;
            --border-hover: #3d3229;
            --glow-orange: rgba(252, 128, 25, 0.25);
            --glow-yellow: rgba(255, 159, 0, 0.3);
            
            /* Fonts */
            --font-heading: 'Outfit', sans-serif;
            --font-body: 'Inter', sans-serif;
            
            /* Transitions */
            --transition-fast: 0.2s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: var(--bg-primary);
            color: var(--text-primary);
            font-family: var(--font-body);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: var(--bg-primary);
        }
        ::-webkit-scrollbar-thumb {
            background: var(--border-color);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: var(--border-hover);
        }

        a {
            color: inherit;
            text-decoration: none;
            transition: var(--transition-fast);
        }

        /* Header/Navbar */
        header {
            background-color: rgba(18, 15, 13, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1.2rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-family: var(--font-heading);
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--accent-yellow);
        }

        .logo-icon {
            color: var(--accent-yellow);
            animation: pulse 2s infinite;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 2rem;
            list-style: none;
        }

        .nav-links li a {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .nav-links li a:hover,
        .nav-links li a.active {
            color: var(--accent-yellow);
        }

        .cart-icon-container {
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .cart-badge {
            background-color: var(--accent-orange);
            color: white;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.1rem 0.4rem;
            border-radius: 10px;
            position: absolute;
            top: -8px;
            right: -10px;
        }

        /* Container Layout */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 2rem;
            min-height: 80vh;
        }

        .checkout-title-section {
            font-family: var(--font-heading);
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
        }

        .checkout-layout {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2.5rem;
            align-items: flex-start;
        }

        @media (min-width: 992px) {
            .checkout-layout {
                grid-template-columns: 1.6fr 1fr;
            }
        }

        /* Form styling */
        .checkout-form-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .form-section-title {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--accent-orange);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1.2rem;
        }

        .form-group label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .form-control {
            background-color: var(--bg-tertiary);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            font-family: var(--font-body);
            font-size: 0.95rem;
            padding: 0.8rem 1rem;
            transition: all var(--transition-fast);
            outline: none;
            width: 100%;
        }

        .form-control:focus {
            border-color: var(--accent-orange);
            box-shadow: 0 0 8px rgba(252, 128, 25, 0.15);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        .form-control-readonly {
            background-color: rgba(37, 32, 27, 0.5);
            color: var(--text-muted);
            cursor: not-allowed;
        }

        /* Payment selection grid */
        .payment-options-grid {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .payment-option-card {
            display: flex;
            align-items: center;
            gap: 1rem;
            background-color: var(--bg-tertiary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.2rem;
            cursor: pointer;
            transition: all var(--transition-fast);
        }

        .payment-option-card:hover {
            border-color: var(--border-hover);
        }

        .payment-option-card input[type="radio"] {
            accent-color: var(--accent-orange);
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .payment-option-details {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .payment-option-title {
            font-family: var(--font-heading);
            font-weight: 600;
            font-size: 1rem;
        }

        .payment-option-desc {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .payment-option-icon {
            margin-left: auto;
            font-size: 1.5rem;
            color: var(--text-secondary);
        }

        .payment-option-card input[type="radio"]:checked + .payment-option-details + .payment-option-icon {
            color: var(--accent-orange);
        }

        /* Summary Sidebar */
        .summary-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.8rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }

        .summary-title {
            font-family: var(--font-heading);
            font-size: 1.1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--accent-orange);
            margin-bottom: 1.2rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
            margin-bottom: 0.8rem;
            color: var(--text-secondary);
        }

        .summary-row.grand-total {
            border-top: 1px dashed var(--border-color);
            padding-top: 1rem;
            margin-top: 1rem;
            font-weight: 700;
            color: var(--text-primary);
            font-size: 1.15rem;
        }

        .order-items-list-preview {
            max-height: 250px;
            overflow-y: auto;
            margin-bottom: 1.5rem;
            padding-right: 0.5rem;
        }

        .order-item-mini {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
            padding: 0.6rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .order-item-mini:last-child {
            border-bottom: none;
        }

        .order-item-mini-details {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .order-item-mini-name {
            font-weight: 500;
        }

        .order-item-mini-qty {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        .order-item-mini-price {
            font-weight: 600;
        }

        /* Buttons styling */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-family: var(--font-heading);
            font-weight: 600;
            padding: 0.8rem 1.8rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all var(--transition-fast);
            border: none;
            outline: none;
            font-size: 0.95rem;
            text-align: center;
        }

        .btn-orange {
            background-color: var(--accent-orange);
            color: white;
            box-shadow: 0 0 12px var(--glow-orange);
        }

        .btn-orange:hover {
            background-color: #e27212;
            transform: translateY(-2px);
            box-shadow: 0 0 18px var(--glow-orange);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .btn-outline:hover {
            background-color: var(--bg-tertiary);
            border-color: var(--border-hover);
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
                opacity: 1;
            }
            50% {
                transform: scale(1.05);
                opacity: 0.8;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>
</head>
<body>

    <!-- Sticky Header -->
    <header>
        <div class="nav-container">
            <a href="home" class="logo-section">
                <i class="fa-solid fa-bolt logo-icon"></i>
                <span>Tapify Food</span>
            </a>
            
            <ul class="nav-links">
                <li><a href="home"><i class="fa-solid fa-house"></i> <span>Home</span></a></li>
                <li><a href="home" class="active"><i class="fa-solid fa-utensils"></i> <span>Restaurants</span></a></li>
                <li><a href="orderHistory"><i class="fa-solid fa-clock-rotate-left"></i> <span>Orders</span></a></li>
                <li class="cart-nav-item">
                    <a href="cart.jsp" class="cart-icon-container">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span>Cart</span>
                        <span class="cart-badge"><%= cartItems.values().stream().mapToInt(CartItem::getQuantity).sum() %></span>
                    </a>
                </li>
            </ul>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container">
        <!-- Title section -->
        <div class="checkout-title-section">
            <i class="fa-solid fa-shield-halved" style="color: var(--accent-orange);"></i>
            <span>Secure Checkout</span>
        </div>

        <form action="checkoutServlet" method="POST">
            <div class="checkout-layout">
                
                <!-- Left Side: Checkout Details Form -->
                <div class="checkout-form-card">
                    <!-- Delivery Details Section -->
                    <div>
                        <h4 class="form-section-title">
                            <i class="fa-solid fa-location-dot"></i> Delivery Details
                        </h4>
                        
                        <div class="form-group">
                            <label>Receiver Name</label>
                            <input type="text" class="form-control form-control-readonly" value="<%= user.getUserName() %>" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" class="form-control form-control-readonly" value="<%= user.getEmail() %>" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Delivery Address</label>
                            <textarea id="address" name="address" class="form-control" placeholder="Enter your full delivery address" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                        </div>
                    </div>

                    <!-- Payment Section -->
                    <div>
                        <h4 class="form-section-title">
                            <i class="fa-solid fa-credit-card"></i> Select Payment Method
                        </h4>
                        
                        <div class="payment-options-grid">
                            <label class="payment-option-card" style="border-color: var(--accent-orange); box-shadow: 0 0 12px var(--glow-orange);">
                                <input type="radio" name="paymentMethod" value="Cash_On_Delivery" checked required>
                                <div class="payment-option-details">
                                    <span class="payment-option-title">Cash on Delivery (COD)</span>
                                    <span class="payment-option-desc">Pay cash or scan QR code on delivery</span>
                                </div>
                                <i class="fa-solid fa-money-bill-wave payment-option-icon" style="color: var(--accent-orange);"></i>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Right Side: Order Summary Card -->
                <div class="summary-card">
                    <h4 class="summary-title">
                        <i class="fa-solid fa-receipt"></i> Order Summary
                    </h4>

                    <!-- Order Items Preview List -->
                    <div class="order-items-list-preview">
                        <% for (CartItem item : cartItems.values()) { %>
                            <div class="order-item-mini">
                                <div class="order-item-mini-details">
                                    <span class="order-item-mini-name"><%= item.getName() %></span>
                                    <span class="order-item-mini-qty">Qty: <%= item.getQuantity() %> x ₹<%= (int) item.getPrice() %></span>
                                </div>
                                <span class="order-item-mini-price">₹<%= (int) item.getTotalPrice() %></span>
                            </div>
                        <% } %>
                    </div>

                    <!-- Bill Details -->
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>₹<%= (int) subtotal %></span>
                    </div>
                    <div class="summary-row">
                        <span>Delivery Fee</span>
                        <span>₹<%= (int) deliveryFee %></span>
                    </div>
                    <div class="summary-row">
                        <span>GST / Taxes (5%)</span>
                        <span>₹<%= (int) tax %></span>
                    </div>
                    <div class="summary-row grand-total">
                        <span>Total Payable</span>
                        <span>₹<%= (int) grandTotal %></span>
                    </div>

                    <!-- Hidden Inputs to pass totals if needed (optional since computed in backend too) -->
                    
                    <button type="submit" class="btn btn-orange" style="width: 100%; margin-top: 1.8rem;">
                        <i class="fa-solid fa-lock"></i> Place Order (₹<%= (int) grandTotal %>)
                    </button>
                    
                    <a href="cart.jsp" class="btn btn-outline" style="width: 100%; margin-top: 0.8rem;">
                        <i class="fa-solid fa-chevron-left"></i> Return to Cart
                    </a>
                </div>
            </div>
        </form>
    </main>

    <!-- Footer -->
    <footer style="margin-top: 8rem; border-top: 1px solid var(--border-color); padding: 4rem 2rem 2rem 2rem; background-color: var(--bg-secondary);">
        <div style="max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem;">
            <div>
                <h4 style="font-family: var(--font-heading); color: var(--accent-yellow); margin-bottom: 1rem;">Tapify Food</h4>
                <p style="font-size: 0.9rem; color: var(--text-secondary);">Fastest street food and gourmet delivery at your fingertips.</p>
            </div>
            <div>
                <h4 style="font-family: var(--font-heading); color: var(--text-primary); margin-bottom: 1rem;">About Us</h4>
                <ul style="list-style: none; font-size: 0.9rem; color: var(--text-secondary); display: flex; flex-direction: column; gap: 0.5rem;">
                    <li><a href="#">Our Story</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
            <div>
                <h4 style="font-family: var(--font-heading); color: var(--text-primary); margin-bottom: 1rem;">Contact</h4>
                <ul style="list-style: none; font-size: 0.9rem; color: var(--text-secondary); display: flex; flex-direction: column; gap: 0.5rem;">
                    <li><a href="#">Help & Support</a></li>
                    <li><a href="#">Partner with us</a></li>
                    <li><a href="#">Ride with us</a></li>
                </ul>
            </div>
        </div>
        <div style="max-width: 1200px; margin: 2rem auto 0 auto; padding-top: 2rem; border-top: 1px solid var(--border-color); text-align: center; font-size: 0.85rem; color: var(--text-muted);">
            <p>&copy; 2026 Tapify Food. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
