<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.instafood.model.OrderTable" %>
<%@ page import="com.instafood.model.OrderItem" %>
<%@ page import="com.instafood.model.Restaurant" %>
<%@ page import="com.instafood.model.Menu" %>
<%@ page import="com.instafood.model.User" %>
<%@ page import="com.instafood.daoimpl.RestaurantDAOImpl" %>
<%@ page import="com.instafood.daoimpl.OrderItemDAOImpl" %>
<%@ page import="com.instafood.daoimpl.MenuDAOImpl" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
// Session & Authentication check
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.html");
    return;
}

// Retrieve orders list from request scope
List<OrderTable> ordersList = (List<OrderTable>) request.getAttribute("ordersList");
boolean hasOrders = (ordersList != null && !ordersList.isEmpty());

// DAO Instances for lookup
RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
MenuDAOImpl menuDAO = new MenuDAOImpl();

// Date Formatter
SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Orders - Tapify Food</title>
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

        /* Container Layout */
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 3rem 2rem;
            min-height: 80vh;
        }

        .history-title-section {
            font-family: var(--font-heading);
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
        }

        /* Order Cards styling */
        .order-history-list {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .order-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.8rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            transition: transform var(--transition-fast), border-color var(--transition-fast);
        }

        .order-card:hover {
            transform: translateY(-2px);
            border-color: var(--border-hover);
        }

        .order-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px dashed var(--border-color);
            padding-bottom: 1rem;
            margin-bottom: 1.2rem;
            gap: 1rem;
        }

        .order-info-group {
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }

        .order-number {
            font-family: var(--font-heading);
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--accent-yellow);
        }

        .order-date {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .order-status-badge {
            background-color: rgba(76, 175, 80, 0.1);
            color: #4caf50;
            border: 1px solid rgba(76, 175, 80, 0.3);
            font-size: 0.8rem;
            font-weight: 600;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .order-card-body {
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
        }

        .restaurant-info-box {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .restaurant-name {
            font-family: var(--font-heading);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .restaurant-loc {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        /* Items summary in card */
        .order-items-grid {
            display: flex;
            flex-direction: column;
            background-color: var(--bg-tertiary);
            border-radius: 12px;
            padding: 1rem 1.4rem;
            border: 1px solid var(--border-color);
        }

        .order-item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            font-size: 0.9rem;
            border-bottom: 1px solid rgba(44, 36, 30, 0.5);
        }

        .order-item-row:last-child {
            border-bottom: none;
        }

        .order-item-desc {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .order-item-name {
            font-weight: 500;
        }

        .order-item-qty {
            font-size: 0.75rem;
            background-color: var(--border-color);
            color: var(--text-secondary);
            padding: 0.1rem 0.4rem;
            border-radius: 4px;
        }

        .order-item-total {
            font-weight: 600;
        }

        /* Order Card Footer */
        .order-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--border-color);
            padding-top: 1rem;
            margin-top: 0.5rem;
            font-size: 0.95rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .delivery-address-info {
            color: var(--text-secondary);
            font-size: 0.85rem;
            max-width: 60%;
        }

        .total-amount-box {
            text-align: right;
        }

        .total-amount-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .total-amount-value {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* Empty State */
        .empty-history-container {
            text-align: center;
            padding: 5rem 2rem;
            background-color: var(--bg-secondary);
            border: 1px dashed var(--border-color);
            border-radius: 20px;
            max-width: 600px;
            margin: 2rem auto;
        }

        .empty-history-icon {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
        }

        .empty-history-container h3 {
            font-family: var(--font-heading);
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 0.6rem;
        }

        .empty-history-container p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }

        /* Button styles */
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
                <li><a href="home"><i class="fa-solid fa-utensils"></i> <span>Restaurants</span></a></li>
                <li><a href="orderHistory" class="active"><i class="fa-solid fa-clock-rotate-left"></i> <span>Orders</span></a></li>
                <li class="cart-nav-item">
                    <a href="cart.jsp" class="cart-icon-container">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span>Cart</span>
                    </a>
                </li>
            </ul>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container">
        <!-- Title section -->
        <div class="history-title-section">
            <i class="fa-solid fa-clock-rotate-left" style="color: var(--accent-orange);"></i>
            <span>Order History</span>
        </div>

        <% if (!hasOrders) { %>
            <!-- Empty State -->
            <div class="empty-history-container">
                <i class="fa-regular fa-calendar-times empty-history-icon"></i>
                <h3>No orders placed yet</h3>
                <p>Looks like you haven't ordered any delicious food yet.</p>
                <a href="home" class="btn btn-orange">
                    <i class="fa-solid fa-utensils"></i> Browse Restaurants
                </a>
            </div>
        <% } else { %>
            <!-- Order List State -->
            <div class="order-history-list">
                <% 
                for (OrderTable order : ordersList) {
                    Restaurant restaurant = restaurantDAO.getRestaurantById(order.getRestaurantId());
                    List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
                %>
                    <article class="order-card">
                        <!-- Header with ID, date & status -->
                        <div class="order-card-header">
                            <div class="order-info-group">
                                <span class="order-number">Order #<%= order.getOrderId() %></span>
                                <span class="order-date"><%= dateFormat.format(order.getOrderDate()) %></span>
                            </div>
                            <span class="order-status-badge"><%= order.getStatus() %></span>
                        </div>

                        <!-- Card Body with items and restaurant info -->
                        <div class="order-card-body">
                            <div class="restaurant-info-box">
                                <i class="fa-solid fa-store" style="color: var(--accent-orange); font-size: 1.2rem;"></i>
                                <div>
                                    <h5 class="restaurant-name"><%= (restaurant != null) ? restaurant.getName() : "Unknown Restaurant" %></h5>
                                    <span class="restaurant-loc"><%= (restaurant != null) ? restaurant.getAddress() : "Location details unavailable" %></span>
                                </div>
                            </div>

                            <!-- List of items ordered in this specific order -->
                            <div class="order-items-grid">
                                <% 
                                for (OrderItem item : items) {
                                    Menu menu = menuDAO.getMenu(item.getMenuId());
                                    String itemName = (menu != null) ? menu.getItemName() : "Unknown Item";
                                %>
                                    <div class="order-item-row">
                                        <div class="order-item-desc">
                                            <span class="order-item-qty">x<%= item.getQuantity() %></span>
                                            <span class="order-item-name"><%= itemName %></span>
                                        </div>
                                        <span class="order-item-total">₹<%= (int) item.getItemTotal() %></span>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Card Footer showing billing summary and delivery address -->
                        <div class="order-card-footer">
                            <div class="delivery-address-info">
                                <i class="fa-solid fa-location-dot"></i> Delivered to: <strong><%= user.getAddress() != null ? user.getAddress() : "Profile Address" %></strong>
                            </div>
                            
                            <div class="total-amount-box">
                                <span class="total-amount-label">Total (<%= "Cash_On_Delivery".equalsIgnoreCase(order.getPaymentMethod()) ? "Cash on Delivery" : order.getPaymentMethod().replace("_", " ") %>)</span><br>
                                <span class="total-amount-value">₹<%= (int) order.getTotalAmount() %></span>
                            </div>
                        </div>
                    </article>
                <% } %>
            </div>
        <% } %>
    </main>

    <!-- Footer -->
    <footer style="margin-top: 8rem; border-top: 1px solid var(--border-color); padding: 4rem 2rem 2rem 2rem; background-color: var(--bg-secondary);">
        <div style="max-width: 1200px; margin: 0 auto; text-align: center; font-size: 0.85rem; color: var(--text-muted);">
            <p>&copy; 2026 Tapify Food. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
