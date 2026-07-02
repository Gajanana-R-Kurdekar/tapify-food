<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.instafood.model.Cart" %>
<%@ page import="com.instafood.model.CartItem" %>
<%@ page import="com.instafood.model.User" %>
<%@ page import="java.util.Map" %>
<%
// Session & Cart Initialization
Cart cart = (Cart) session.getAttribute("cart");
Map<Integer, CartItem> cartItems = (cart != null) ? cart.getItems() : null;
boolean isEmpty = (cartItems == null || cartItems.isEmpty());

// Retrieve restaurantId from session for "Add More Items" redirection
Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");

// Calculate pricing details
double subtotal = 0.0;
if (!isEmpty) {
    for (CartItem item : cartItems.values()) {
        subtotal += item.getTotalPrice();
    }
}
double deliveryFee = isEmpty ? 0.0 : 40.0;
double tax = subtotal * 0.05; // 5% GST
double grandTotal = subtotal + deliveryFee + tax;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - Tapify Food</title>
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

        .cart-title-section {
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

        .cart-layout {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2.5rem;
            align-items: flex-start;
        }

        @media (min-width: 992px) {
            .cart-layout {
                grid-template-columns: 1.6fr 1fr;
            }
        }

        /* Items Section */
        .cart-items-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.8rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }

        .cart-page-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            padding: 1.2rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .cart-page-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .cart-page-item:first-child {
            padding-top: 0;
        }

        .item-details-block {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            flex-grow: 1;
        }

        .item-img-thumb {
            width: 70px;
            height: 70px;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            flex-shrink: 0;
        }

        .item-img-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .item-text-info {
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }

        .item-title {
            font-family: var(--font-heading);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .item-base-price {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .item-total-price {
            font-weight: 700;
            font-size: 1.05rem;
            min-width: 80px;
            text-align: right;
        }

        /* Quantity counter style */
        .item-row-controls-block {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .item-qty-selector {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            background-color: var(--border-color);
            border-radius: 8px;
            padding: 0.4rem 0.8rem;
            font-weight: 700;
            font-size: 0.9rem;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2);
        }

        .item-qty-selector a {
            color: var(--accent-orange);
            font-weight: 800;
            font-size: 1.1rem;
            cursor: pointer;
            width: 15px;
            display: inline-block;
            text-align: center;
        }

        .item-qty-selector a:hover {
            color: var(--accent-yellow);
        }

        .btn-trash {
            color: var(--text-muted);
            font-size: 1rem;
            transition: color var(--transition-fast);
        }

        .btn-trash:hover {
            color: #ef5350;
        }

        /* Action Section under Cart List */
        .cart-action-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1.8rem;
            padding-top: 1.5rem;
            border-top: 1px dashed var(--border-color);
        }

        /* Billing Summary Card */
        .cart-checkout-card {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

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

        .summary-row:last-child {
            margin-bottom: 0;
        }

        .summary-row.grand-total {
            border-top: 1px dashed var(--border-color);
            padding-top: 1rem;
            margin-top: 1rem;
            font-weight: 700;
            color: var(--text-primary);
            font-size: 1.15rem;
        }

        /* Empty Cart State Styling */
        .empty-cart-container {
            text-align: center;
            padding: 5rem 2rem;
            background-color: var(--bg-secondary);
            border: 1px dashed var(--border-color);
            border-radius: 20px;
            max-width: 600px;
            margin: 2rem auto;
        }

        .empty-cart-icon {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
            animation: pulse 2s infinite;
        }

        .empty-cart-container h3 {
            font-family: var(--font-heading);
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 0.6rem;
        }

        .empty-cart-container p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-bottom: 2rem;
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

        .btn-view-menu {
            font-size: 0.85rem;
            padding: 0.5rem 1rem;
        }

        /* Animations */
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

        /* Responsive layout */
        @media (max-width: 576px) {
            .cart-page-item {
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
            }
            .item-total-price {
                text-align: left;
                font-size: 1rem;
            }
            .item-row-controls-block {
                justify-content: space-between;
            }
            .cart-action-row {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
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
                    <a href="cart.jsp" class="cart-icon-container active">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span>Cart</span>
                        <% if (!isEmpty) { %>
                            <span class="cart-badge"><%= cartItems.values().stream().mapToInt(CartItem::getQuantity).sum() %></span>
                        <% } %>
                    </a>
                </li>
            </ul>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container">
        <!-- Title section -->
        <div class="cart-title-section">
            <i class="fa-solid fa-cart-shopping" style="color: var(--accent-orange);"></i>
            <span>Your Shopping Cart</span>
        </div>

        <% if (isEmpty) { %>
            <!-- State A: Cart is Empty -->
            <div class="empty-cart-container" id="empty-cart-view">
                <i class="fa-solid fa-bag-shopping empty-cart-icon"></i>
                <h3>Your cart is empty</h3>
                <p>Please add some delicious items to your cart!</p>
                <a href="home" class="btn btn-orange">
                    <i class="fa-solid fa-utensils"></i> Browse Restaurants
                </a>
            </div>
        <% } else { %>
            <!-- State B: Cart Has Items -->
            <div class="cart-layout" id="active-cart-view">
                
                <!-- Left Side: Items Card -->
                <section class="cart-items-card">
                    <h4 class="summary-title" style="margin-bottom: 1.5rem;">
                        <i class="fa-solid fa-burger"></i> Added Items
                    </h4>
                    
                    <div id="cart-page-items-list">
                        <% 
                        // Loop through cart items dynamically
                        for (CartItem item : cartItems.values()) { 
                        %>
                            <div class="cart-page-item">
                                <div class="item-details-block">
                                    <div class="item-img-thumb">
                                        <img src="<%= (item.getImage() != null && !item.getImage().isEmpty()) ? item.getImage() : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=200" %>" alt="<%= item.getName() %>">
                                    </div>
                                    <div class="item-text-info">
                                        <span class="item-title"><%= item.getName() %></span>
                                        <span class="item-base-price">₹<%= (int) item.getPrice() %> each</span>
                                    </div>
                                </div>
                                
                                <div class="item-row-controls-block">
                                    <!-- Quantity Modifier Buttons -->
                                    <div class="item-qty-selector">
                                        <% if (item.getQuantity() <= 1) { %>
                                            <a href="cartServlet?action=delete&menuId=<%= item.getMenuId() %>" title="Decrease quantity">-</a>
                                        <% } else { %>
                                            <a href="cartServlet?action=update&menuId=<%= item.getMenuId() %>&quantity=<%= item.getQuantity() - 1 %>" title="Decrease quantity">-</a>
                                        <% } %>
                                        
                                        <span><%= item.getQuantity() %></span>
                                        
                                        <a href="cartServlet?action=update&menuId=<%= item.getMenuId() %>&quantity=<%= item.getQuantity() + 1 %>" title="Increase quantity">+</a>
                                    </div>
                                    
                                    <!-- Item Total Price -->
                                    <span class="item-total-price">₹<%= (int) item.getTotalPrice() %></span>
                                    
                                    <!-- Remove Item Action Link -->
                                    <a href="cartServlet?action=delete&menuId=<%= item.getMenuId() %>" class="btn-trash" title="Remove Item">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- Action row below items -->
                    <div class="cart-action-row">
                        <% 
                        String backToMenuUrl = (sessionRestaurantId != null) ? "menu?restaurantId=" + sessionRestaurantId : "home"; 
                        %>
                        <a href="<%= backToMenuUrl %>" class="btn btn-outline btn-view-menu">
                            <i class="fa-solid fa-arrow-left"></i> Add More Items
                        </a>
                        <span style="color: var(--text-secondary); font-size: 0.9rem;">
                            Items subtotal: <strong>₹<%= (int) subtotal %></strong>
                        </span>
                    </div>
                </section>

                <!-- Right Side: Billing Summary Card -->
                <section class="cart-checkout-card">
                    <div class="summary-card">
                        <h4 class="summary-title">
                            <i class="fa-solid fa-receipt"></i> Bill Details
                        </h4>
                        <div class="summary-row">
                            <span>Items Subtotal</span>
                            <span>₹<%= (int) subtotal %></span>
                        </div>
                        <div class="summary-row">
                            <span>Delivery Partner Fee</span>
                            <span>₹<%= (int) deliveryFee %></span>
                        </div>
                        <div class="summary-row">
                            <span>Taxes & GST (5%)</span>
                            <span>₹<%= (int) tax %></span>
                        </div>
                        <div class="summary-row grand-total">
                            <span>Total Amount</span>
                            <span>₹<%= (int) grandTotal %></span>
                        </div>

                        <!-- Proceed to Checkout Button -->
                        <% if (session.getAttribute("user") == null) { %>
                            <a href="login.html" class="btn btn-orange" style="width: 100%; margin-top: 1.8rem;">
                                <span>Login to Checkout</span>
                                <i class="fa-solid fa-arrow-right-to-bracket"></i>
                            </a>
                        <% } else { %>
                            <a href="checkout.jsp" class="btn btn-orange" style="width: 100%; margin-top: 1.8rem;">
                                <span>Proceed to Checkout</span>
                                <i class="fa-solid fa-arrow-right-to-bracket"></i>
                            </a>
                        <% } %>
                    </div>
                </section>
            </div>
        <% } %>
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
