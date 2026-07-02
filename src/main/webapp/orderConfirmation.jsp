<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.instafood.model.OrderTable" %>
<%@ page import="com.instafood.model.OrderItem" %>
<%@ page import="com.instafood.model.Restaurant" %>
<%@ page import="com.instafood.model.Menu" %>
<%@ page import="com.instafood.model.User" %>
<%@ page import="com.instafood.daoimpl.OrderTableDAOImpl" %>
<%@ page import="com.instafood.daoimpl.OrderItemDAOImpl" %>
<%@ page import="com.instafood.daoimpl.RestaurantDAOImpl" %>
<%@ page import="com.instafood.daoimpl.MenuDAOImpl" %>
<%@ page import="java.util.List" %>
<%
// Session & Authentication check
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.html");
    return;
}

// Retrieve and validate orderId parameter
String orderIdStr = request.getParameter("orderId");
if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
    response.sendRedirect("home");
    return;
}

int orderId = 0;
try {
    orderId = Integer.parseInt(orderIdStr.trim());
} catch (NumberFormatException e) {
    response.sendRedirect("home");
    return;
}

// Fetch Order Details
OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
OrderTable order = orderDAO.getOrderById(orderId);
if (order == null || order.getUserId() != user.getUserId()) {
    response.sendRedirect("home");
    return;
}

// Fetch Restaurant Details
RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
Restaurant restaurant = restaurantDAO.getRestaurantById(order.getRestaurantId());

// Fetch Order Items
OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);

// Fetch Menu Items Helper
MenuDAOImpl menuDAO = new MenuDAOImpl();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed! - Tapify Food</title>
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

        .nav-links li a:hover {
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
            max-width: 800px;
            margin: 0 auto;
            padding: 4rem 2rem;
            min-height: 80vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2.5rem;
        }

        /* Success Animation */
        .success-animation-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
            text-align: center;
        }

        .success-checkmark-circle {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: rgba(76, 175, 80, 0.1);
            border: 2px solid #4caf50;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #4caf50;
            box-shadow: 0 0 20px rgba(76, 175, 80, 0.2);
            animation: popCheckmark 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .success-heading {
            font-family: var(--font-heading);
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .success-subheading {
            color: var(--text-secondary);
            font-size: 1.05rem;
            max-width: 500px;
        }

        /* Order Details Card */
        .confirmation-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            width: 100%;
            padding: 2.2rem;
            box-shadow: 0 8px 30px rgba(0,0,0,0.3);
            display: flex;
            flex-direction: column;
            gap: 1.8rem;
        }

        .order-meta-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .meta-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .meta-value {
            font-family: var(--font-heading);
            font-size: 1rem;
            font-weight: 600;
        }

        .delivery-tracker-box {
            background: linear-gradient(135deg, #1c1815 0%, #25201b 100%);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.2rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }

        .tracker-icon {
            font-size: 2.2rem;
            color: var(--accent-orange);
            animation: deliveryBike 3s infinite ease-in-out;
        }

        .tracker-text {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .tracker-title {
            font-family: var(--font-heading);
            font-weight: 700;
            font-size: 1.1rem;
        }

        .tracker-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        /* Items summary in card */
        .items-summary-section {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
        }

        .section-title {
            font-family: var(--font-heading);
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--accent-yellow);
        }

        .items-receipt-list {
            display: flex;
            flex-direction: column;
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.95rem;
        }

        .receipt-row:last-child {
            border-bottom: none;
        }

        .receipt-item-details {
            display: flex;
            flex-direction: column;
        }

        .receipt-item-name {
            font-weight: 500;
        }

        .receipt-item-qty {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .receipt-item-price {
            font-weight: 600;
        }

        .receipt-billing-details {
            border-top: 1px dashed var(--border-color);
            padding-top: 1.2rem;
            margin-top: 0.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
        }

        .bill-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .bill-row.grand-total {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-primary);
            border-top: 1px solid var(--border-color);
            padding-top: 0.8rem;
            margin-top: 0.4rem;
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
            width: 100%;
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

        /* Keyframes */
        @keyframes popCheckmark {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            80% {
                transform: scale(1.15);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        @keyframes deliveryBike {
            0%, 100% {
                transform: translateX(0);
            }
            50% {
                transform: translateX(6px);
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
            </ul>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container">
        <!-- Success Animation & Title -->
        <div class="success-animation-container">
            <div class="success-checkmark-circle">
                <i class="fa-solid fa-check"></i>
            </div>
            <h2 class="success-heading">Order Confirmed!</h2>
            <p class="success-subheading">Thank you for ordering with us. Your meal is being prepared and will be delivered shortly!</p>
        </div>

        <!-- Order Information Card -->
        <div class="confirmation-card">
            <!-- Order Meta details -->
            <div class="order-meta-info">
                <div class="meta-item">
                    <span class="meta-label">Order Number</span>
                    <span class="meta-value" style="color: var(--accent-yellow);">#<%= order.getOrderId() %></span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">Payment Mode</span>
                    <span class="meta-value"><%= order.getPaymentMethod() %></span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">Status</span>
                    <span class="meta-value" style="color: #4caf50;"><%= order.getStatus() %></span>
                </div>
            </div>

            <!-- Delivery Tracker Simulation -->
            <div class="delivery-tracker-box">
                <i class="fa-solid fa-motorcycle tracker-icon"></i>
                <div class="tracker-text">
                    <span class="tracker-title">Arriving in <%= restaurant != null ? restaurant.getDeliveryTime() : 30 %> mins</span>
                    <span class="tracker-desc">Estimated delivery from <%= restaurant != null ? restaurant.getName() : "the restaurant" %></span>
                </div>
            </div>

            <!-- Items Ordered Details -->
            <div class="items-summary-section">
                <h4 class="section-title">Items Ordered</h4>
                <div class="items-receipt-list">
                    <%
                    double subtotal = 0.0;
                    for (OrderItem item : orderItems) {
                        Menu menu = menuDAO.getMenu(item.getMenuId());
                        String name = (menu != null) ? menu.getItemName() : "Unknown Item";
                        subtotal += item.getItemTotal();
                    %>
                        <div class="receipt-row">
                            <div class="receipt-item-details">
                                <span class="receipt-item-name"><%= name %></span>
                                <span class="receipt-item-qty">Qty: <%= item.getQuantity() %></span>
                            </div>
                            <span class="receipt-item-price">₹<%= (int) item.getItemTotal() %></span>
                        </div>
                    <%
                    }
                    double deliveryFee = 40.0;
                    double tax = subtotal * 0.05;
                    %>
                </div>

                <!-- Billing breakdown -->
                <div class="receipt-billing-details">
                    <div class="bill-row">
                        <span>Items Subtotal</span>
                        <span>₹<%= (int) subtotal %></span>
                    </div>
                    <div class="bill-row">
                        <span>Delivery Fee</span>
                        <span>₹<%= (int) deliveryFee %></span>
                    </div>
                    <div class="bill-row">
                        <span>Taxes & GST (5%)</span>
                        <span>₹<%= (int) tax %></span>
                    </div>
                    <div class="bill-row grand-total">
                        <span>Total Paid</span>
                        <span>₹<%= (int) order.getTotalAmount() %></span>
                    </div>
                </div>
            </div>

            <!-- Shipping address details -->
            <div class="items-summary-section" style="border-top: 1px solid var(--border-color); padding-top: 1.5rem;">
                <h4 class="section-title"><i class="fa-solid fa-location-dot"></i> Delivery Address</h4>
                <p style="font-size: 0.95rem; color: var(--text-secondary); margin-top: 0.4rem; line-height: 1.5;"><%= user.getAddress() %></p>
            </div>

            <!-- Action buttons -->
            <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 1rem;">
                <a href="home" class="btn btn-orange">
                    <i class="fa-solid fa-utensils"></i> Order Something Else
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer style="margin-top: 8rem; border-top: 1px solid var(--border-color); padding: 4rem 2rem 2rem 2rem; background-color: var(--bg-secondary);">
        <div style="max-width: 1200px; margin: 0 auto; text-align: center; font-size: 0.85rem; color: var(--text-muted);">
            <p>&copy; 2026 Tapify Food. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
