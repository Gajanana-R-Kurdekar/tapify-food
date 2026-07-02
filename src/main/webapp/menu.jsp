<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafood.model.Restaurant" %>
<%@ page import="com.instafood.model.Menu" %>
<%@ page import="com.instafood.model.Cart" %>
<%@ page import="com.instafood.model.CartItem" %>
<%
Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");

Cart sessionCart = (Cart) session.getAttribute("cart");
int cartQuantity = 0;
double cartSubtotal = 0.0;
StringBuilder cartItemsJson = new StringBuilder("{");
if (sessionCart != null) {
    boolean first = true;
    for (CartItem item : sessionCart.getItems().values()) {
        cartQuantity += item.getQuantity();
        cartSubtotal += item.getTotalPrice();
        if (!first) {
            cartItemsJson.append(",");
        }
        cartItemsJson.append(item.getMenuId()).append(":").append(item.getQuantity());
        first = false;
    }
}
cartItemsJson.append("}");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu - <%= restaurant != null ? restaurant.getName() : "Tapify Food" %></title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Main Style Sheet -->
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
    --transition-medium: 0.3s ease;
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

body.home-page {
    background: linear-gradient(
                    180deg, 
                    rgba(18, 15, 13, 0.78) 0%, 
                    rgba(18, 15, 13, 0.92) 100%
                ), 
                url('https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=1600') 
                no-repeat center center fixed;
    background-size: cover;
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

.address-selector {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.9rem;
    color: var(--text-secondary);
    cursor: pointer;
    border-left: 1px solid var(--border-color);
    padding-left: 1rem;
    margin-left: 1rem;
}

.address-selector:hover {
    color: var(--accent-orange);
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

/* Buttons */
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
}

.btn-primary {
    background-color: var(--accent-yellow);
    color: var(--bg-primary);
    box-shadow: 0 0 15px var(--glow-yellow);
}

.btn-primary:hover {
    background-color: #ffb300;
    transform: translateY(-2px);
    box-shadow: 0 0 22px var(--glow-yellow);
}

.btn-outline {
    background-color: transparent;
    color: var(--text-primary);
    border: 1px solid var(--border-color);
}

.btn-outline:hover {
    border-color: var(--accent-yellow);
    color: var(--accent-yellow);
    transform: translateY(-2px);
}

.btn-orange {
    background-color: var(--accent-orange);
    color: white;
    box-shadow: 0 0 15px var(--glow-orange);
}

.btn-orange:hover {
    background-color: #ff9133;
    transform: translateY(-2px);
    box-shadow: 0 0 22px var(--glow-orange);
}

/* Forms & Authentication Layout */
.auth-wrapper {
    min-height: calc(100vh - 80px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem 1rem;
    background: radial-gradient(circle at 10% 20%, rgba(252, 128, 25, 0.05) 0%, rgba(0, 0, 0, 0) 60%);
}

.auth-container {
    background-color: var(--bg-secondary);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    width: 100%;
    max-width: 480px;
    padding: 2.5rem;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
    position: relative;
}

.auth-header {
    text-align: center;
    margin-bottom: 2rem;
}

.auth-header h2 {
    font-family: var(--font-heading);
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
}

.auth-header h2 span {
    color: var(--accent-orange);
}

.auth-header p {
    color: var(--text-secondary);
    font-size: 0.95rem;
}

.form-group {
    margin-bottom: 1.2rem;
    position: relative;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-size: 0.85rem;
    font-weight: 500;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.input-icon-wrapper {
    position: relative;
    display: flex;
    align-items: center;
}

.input-icon-wrapper i,
.input-icon-wrapper svg {
    position: absolute;
    left: 1rem;
    color: var(--text-muted);
    pointer-events: none;
    width: 16px;
    height: 16px;
}

.form-control {
    width: 100%;
    background-color: var(--bg-primary);
    border: 1px solid var(--border-color);
    color: var(--text-primary);
    padding: 0.8rem 1rem 0.8rem 2.8rem;
    border-radius: 8px;
    font-family: var(--font-body);
    font-size: 0.95rem;
    transition: all var(--transition-fast);
}

.form-control:focus {
    border-color: var(--accent-orange);
    box-shadow: 0 0 10px var(--glow-orange);
    outline: none;
}

.password-toggle {
    position: absolute;
    right: 1rem;
    cursor: pointer;
    color: var(--text-muted);
}

.password-toggle:hover {
    color: var(--text-primary);
}

.form-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 1.5rem;
    font-size: 0.9rem;
    color: var(--text-secondary);
}

.form-footer a {
    color: var(--accent-orange);
}

.form-footer a:hover {
    text-decoration: underline;
}

.auth-submit-btn {
    width: 100%;
    margin-top: 1.8rem;
}

/* Password Strength Indicator */
.strength-container {
    margin-top: 0.4rem;
}

.strength-bar-wrapper {
    height: 4px;
    background-color: var(--border-color);
    border-radius: 2px;
    width: 100%;
    overflow: hidden;
}

.strength-bar {
    height: 100%;
    width: 0%;
    transition: width var(--transition-fast), background-color var(--transition-fast);
}

.strength-text {
    font-size: 0.75rem;
    color: var(--text-muted);
    margin-top: 0.2rem;
    display: block;
}

/* Verification validation helpers */
.form-control.is-valid {
    border-color: #2e7d32;
    box-shadow: 0 0 5px rgba(46, 125, 50, 0.2);
}

.form-control.is-invalid {
    border-color: #c62828;
    box-shadow: 0 0 5px rgba(198, 40, 40, 0.2);
}

.invalid-feedback {
    color: #ef5350;
    font-size: 0.75rem;
    margin-top: 0.25rem;
    display: none;
}

.form-control.is-invalid + .invalid-feedback {
    display: block;
}

/* Animations */
@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); text-shadow: 0 0 10px rgba(255, 159, 0, 0.6); }
    100% { transform: scale(1); }
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.fade-in {
    animation: fadeIn 0.4s ease-out forwards;
}

/* Responsive Grid layouts */
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
}

/* Footer Section */
footer {
    background-color: #0d0a08;
    border-top: 1px solid var(--border-color);
    padding: 3rem 2rem;
    margin-top: 4rem;
    color: var(--text-secondary);
}

.footer-container {
    max-width: 1200px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 2rem;
}

.footer-col h4 {
    font-family: var(--font-heading);
    color: var(--text-primary);
    margin-bottom: 1.2rem;
    font-size: 1.1rem;
}

.footer-col ul {
    list-style: none;
}

.footer-col ul li {
    margin-bottom: 0.6rem;
}

.footer-col ul li a:hover {
    color: var(--accent-orange);
}

.footer-bottom {
    text-align: center;
    margin-top: 3rem;
    padding-top: 1.5rem;
    border-top: 1px solid var(--border-color);
    font-size: 0.85rem;
    color: var(--text-muted);
}

/* ==========================================================================
   Responsive Overrides
   ========================================================================== */

@media (max-width: 768px) {
    .nav-container {
        padding: 1rem 1.2rem;
        gap: 0.5rem;
    }
    
    .address-selector {
        display: none !important; /* Hide address on small screens to save space */
    }
    
    .nav-links {
        gap: 1.2rem;
    }
    
    /* Hide text labels, show only icons for responsive compact navbar */
    .nav-links li a span,
    .nav-links li a .dynamic-auth-text {
        display: none !important;
    }
    
    .nav-links li a i,
    .nav-links li a svg {
        font-size: 1.25rem;
        display: inline-block;
    }
    
    .cart-icon-container {
        gap: 0;
    }
    
    .cart-badge {
        top: -6px;
        right: -8px;
    }
}

@media (max-width: 480px) {
    .auth-container {
        padding: 1.8rem 1.2rem;
        border-radius: 12px;
    }
    
    .auth-header h2 {
        font-size: 1.6rem;
    }
    
    .form-control {
        font-size: 0.9rem;
        padding-top: 0.7rem;
        padding-bottom: 0.7rem;
    }
    
    footer {
        padding: 2.5rem 1rem 1.5rem 1rem;
        margin-top: 3rem;
    }
}

</style>
    <style>
        /* Specific Page Styles */
        .menu-wrapper {
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        /* Restaurant Info Card */
        .restaurant-info-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 2rem;
            margin-bottom: 2.5rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            animation: fadeIn 0.4s ease-out;
        }

        .rest-details {
            flex-grow: 1;
        }

        .rest-name {
            font-family: var(--font-heading);
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 0.4rem;
        }

        .rest-cuisines {
            font-size: 0.95rem;
            color: var(--accent-orange);
            font-weight: 500;
            margin-bottom: 0.8rem;
        }

        .rest-address {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .rest-meta {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .rest-rating {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 6px;
            font-size: 0.85rem;
        }

        .rating-high {
            background-color: #1b8a5a; /* Deep Green */
        }
        .rating-mid {
            background-color: #db7c00; /* Warm Orange */
        }
        .rating-low {
            background-color: #c62828; /* Red */
        }

        .rest-time {
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .meta-separator {
            color: var(--text-muted);
        }

        .rest-cover-image {
            width: 180px;
            height: 120px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            flex-shrink: 0;
        }

        .rest-cover-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Split Screen Menu Columns */
        .menu-columns {
            display: flex;
            gap: 2.5rem;
            align-items: flex-start;
        }

        /* Sidebar Category List */
        .category-sidebar {
            width: 200px;
            position: sticky;
            top: 100px;
            border-right: 1px solid var(--border-color);
            padding-right: 1.5rem;
            flex-shrink: 0;
            display: none; /* Desktop only */
        }

        .category-sidebar ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
        }

        .category-sidebar ul li a {
            color: var(--text-secondary);
            font-size: 0.95rem;
            font-weight: 500;
            display: block;
            padding: 0.4rem 0;
            text-align: right;
            border-right: 2px solid transparent;
            padding-right: 0.8rem;
        }

        .category-sidebar ul li a:hover,
        .category-sidebar ul li a.active {
            color: var(--accent-yellow);
            border-right-color: var(--accent-yellow);
            font-weight: 600;
        }

        /* Menu Panel List */
        .menu-panel {
            flex-grow: 1;
        }

        .menu-category-section {
            margin-bottom: 3rem;
            scroll-margin-top: 100px;
        }

        .category-heading {
            font-family: var(--font-heading);
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }

        /* Dish Card layout */
        .dish-card {
            display: flex;
            justify-content: space-between;
            gap: 2rem;
            padding: 1.5rem;
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.25);
            transition: all var(--transition-medium);
        }

        .dish-card:hover {
            transform: translateY(-4px);
            border-color: var(--accent-orange);
            box-shadow: 0 10px 25px var(--glow-orange);
        }

        .dish-card.out-of-stock {
            opacity: 0.5;
        }

        .dish-details {
            flex-grow: 1;
        }

        .dish-veg-badge {
            margin-bottom: 0.5rem;
        }

        .dish-title {
            font-family: var(--font-heading);
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.3rem;
        }

        .dish-price {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.6rem;
        }

        .dish-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
            max-width: 500px;
        }

        .dish-img-section {
            position: relative;
            width: 120px;
            height: 120px;
            flex-shrink: 0;
        }

        .dish-img-section img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        /* Absolute ADD Button Overlay */
        .dish-action-container {
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 85%;
            z-index: 10;
        }

        .dish-add-btn {
            width: 100%;
            background-color: var(--bg-secondary);
            border: 1px solid var(--accent-orange);
            color: var(--accent-orange);
            padding: 0.5rem 0.8rem;
            font-family: var(--font-heading);
            font-weight: 700;
            font-size: 0.8rem;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            transition: all var(--transition-fast);
            text-align: center;
        }

        .dish-add-btn:hover:not(.disabled) {
            background-color: var(--accent-orange);
            color: white;
            box-shadow: 0 4px 15px var(--glow-orange);
        }

        .dish-add-btn.disabled {
            border-color: var(--border-color);
            color: var(--text-muted);
            cursor: not-allowed;
            background-color: var(--bg-primary);
        }

        /* Quantity Counter Widget */
        .dish-qty-control {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: var(--accent-orange);
            color: white;
            border-radius: 8px;
            padding: 0.4rem 0.6rem;
            box-shadow: 0 4px 12px var(--glow-orange);
            font-weight: 700;
            font-size: 0.85rem;
        }

        .dish-qty-control button {
            background: none;
            border: none;
            color: white;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            padding: 0 0.4rem;
        }

        /* Sticky bottom drawer */
        .cart-drawer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background-color: #1b8a5a; /* Swiggy green indicator */
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 900;
            transform: translateY(100%);
            transition: transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            box-shadow: 0 -4px 15px rgba(0,0,0,0.3);
        }

        .cart-drawer.visible {
            transform: translateY(0);
        }

        .drawer-info {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .drawer-info h4 {
            font-family: var(--font-heading);
            font-size: 1rem;
            font-weight: 700;
        }

        .drawer-info p {
            font-size: 0.8rem;
            opacity: 0.9;
        }

        .btn-view-cart {
            background-color: white;
            color: #1b8a5a;
            font-weight: 700;
            font-size: 0.85rem;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 0.4rem;
            transition: transform var(--transition-fast);
        }

        .btn-view-cart:hover {
            transform: scale(1.05);
        }

        /* Responsive Overrides for Menu Page */
        @media (max-width: 768px) {
            .restaurant-info-card {
                flex-direction: column-reverse;
                align-items: stretch;
                padding: 1.5rem;
                gap: 1.5rem;
            }
            .rest-cover-image {
                width: 100%;
                height: 160px;
            }
            .rest-name {
                font-size: 1.7rem;
            }
            .menu-columns {
                gap: 1.5rem;
            }
        }

        @media (max-width: 600px) {
            .dish-card {
                gap: 1rem;
            }
            .dish-img-section {
                width: 90px;
                height: 90px;
            }
            .dish-title {
                font-size: 1.1rem;
            }
            .dish-desc {
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
            .cart-drawer {
                padding: 0.8rem 1.2rem;
            }
            .drawer-info h4 {
                font-size: 0.9rem;
            }
            .drawer-info p {
                font-size: 0.75rem;
            }
            .btn-view-cart {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
            }
        }

        @media (min-width: 768px) {
            .category-sidebar {
                display: block;
            }
        }

        /* User Profile Badge Styling */
        .user-badge-item {
            display: flex;
            align-items: center;
        }

        .user-badge {
            background: var(--bg-tertiary);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 0.4rem 0.9rem;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-family: var(--font-heading);
            font-size: 0.9rem;
            font-weight: 600;
        }

        .user-avatar {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background-color: var(--accent-orange);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .logout-link {
            color: #ef5350 !important;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.4rem;
            transition: all var(--transition-fast);
        }

        .logout-link:hover {
            color: #ef9a9a !important;
            text-shadow: 0 0 10px rgba(239, 83, 80, 0.3);
        }

        /* Toast Notification */
        .toast-container {
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 12px;
            pointer-events: none;
        }

        .toast {
            background-color: var(--bg-tertiary);
            border-left: 4px solid var(--accent-orange);
            color: var(--text-primary);
            padding: 1rem 1.5rem;
            border-radius: 8px;
            font-family: var(--font-body);
            font-weight: 500;
            font-size: 0.95rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            gap: 0.8rem;
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            pointer-events: auto;
        }

        .toast.show {
            opacity: 1;
            transform: translateY(0);
        }

        .toast-icon {
            color: var(--accent-orange);
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <%
    com.instafood.model.User loggedUser = (com.instafood.model.User) session.getAttribute("user");
    if (loggedUser != null) {
    %>
    <script>
        localStorage.setItem('tapify_user', JSON.stringify({
            userName: "<%= loggedUser.getUserName().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") %>",
            email: "<%= loggedUser.getEmail() %>",
            address: "<%= loggedUser.getAddress().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") %>",
            role: "<%= loggedUser.getRole() %>"
        }));
    </script>
    <%
    } else {
    %>
    <script>
        localStorage.removeItem('tapify_user');
    </script>
    <%
    }
    %>

    <!-- Sticky Header -->
    <header>
        <div class="nav-container">
            <a href="home.html" class="logo-section">
                <i class="fa-solid fa-bolt logo-icon"></i>
                <span>Tapify Food</span>
            </a>
            
            <ul class="nav-links">
                <li><a href="home.html"><i class="fa-solid fa-house"></i> <span>Home</span></a></li>
                <li><a href="home" class="active"><i class="fa-solid fa-utensils"></i> <span>Restaurants</span></a></li>
                <% if (loggedUser != null) { %>
                <li><a href="orderHistory"><i class="fa-solid fa-clock-rotate-left"></i> <span>Orders</span></a></li>
                <% } %>
                <li class="cart-nav-item">
                    <a href="cart.jsp" class="cart-icon-container">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span>Cart</span>
                        <span class="cart-badge" style="<%= cartQuantity > 0 ? "" : "display: none;" %>"><%= cartQuantity %></span>
                    </a>
                </li>
            </ul>
        </div>
    </header>

    <!-- Main Container -->
    <div class="menu-wrapper">
        <!-- Restaurant Detail Header Card -->
        <section class="restaurant-info-card" id="restaurant-info-card">
            <%
            if (restaurant != null) {
                double rating = restaurant.getRating();
                String ratingClass = rating >= 4.5 ? "rating-high" : (rating >= 4.0 ? "rating-mid" : "rating-low");
            %>
            <div class="rest-details">
                <h1 class="rest-name"><%= restaurant.getName() %></h1>
                <p class="rest-cuisines"><%= restaurant.getCuisineType() %></p>
                <p class="rest-address"><i class="fa-solid fa-location-dot"></i> <%= restaurant.getAddress() %></p>
                <div class="rest-meta">
                    <span class="rest-rating <%= ratingClass %>">
                        <i class="fa-solid fa-star"></i> <%= String.format("%.1f", rating) %>
                    </span>
                    <span class="meta-separator">•</span>
                    <span class="rest-time"><i class="fa-solid fa-clock"></i> <%= restaurant.getDeliveryTime() %> mins delivery</span>
                </div>
            </div>
            <div class="rest-cover-image">
                <img src="<%= restaurant.getImagePath() %>" alt="<%= restaurant.getName() %>">
            </div>
            <%
            }
            %>
        </section>

        <!-- Main Menu List -->
        <main class="menu-panel" id="menu-items-container" style="max-width: 800px; margin: 0 auto;">
            <div class="menu-category-section">
                <h2 class="category-heading">All Menu Items</h2>
                <%
                if (menuList != null && !menuList.isEmpty()) {
                    for (Menu dish : menuList) {
                %>
                <div class="dish-card <%= !dish.isAvailable() ? "out-of-stock" : "" %>" id="dish-card-<%= dish.getMenuId() %>">
                    <div class="dish-details">
                        <h3 class="dish-title"><%= dish.getItemName() %></h3>
                        <p class="dish-price">₹<%= (int) dish.getPrice() %></p>
                        <p class="dish-desc"><%= dish.getDescription() != null ? dish.getDescription() : "" %></p>
                    </div>
                    <div class="dish-img-section">
                        <img src="<%= dish.getImage() %>" alt="<%= dish.getItemName() %>">
                        <div class="dish-action-container" id="action-container-<%= dish.getMenuId() %>">
                            <% if (!dish.isAvailable()) { %>
                            <button class="dish-add-btn disabled" disabled>Out of Stock</button>
                            <% } else { %>
                            <button class="dish-add-btn" onclick="addDishToCart(<%= dish.getMenuId() %>)">ADD <i class="fa-solid fa-plus" style="font-size: 0.75rem;"></i></button>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div style="text-align: center; padding: 4rem; color: var(--text-secondary);">
                    <h3>No Items Available</h3>
                    <p>This restaurant's menu will be updated soon.</p>
                </div>
                <%
                }
                %>
            </div>
        </main>
    </div>

    <!-- Floating bottom drawer (Visible only when items are added) -->
    <div class="cart-drawer <%= cartQuantity > 0 ? "visible" : "" %>" id="cart-drawer">
        <div class="drawer-info">
            <h4 id="drawer-item-count"><%= cartQuantity %> item<%= cartQuantity > 1 ? "s" : "" %></h4>
            <p>Plus taxes & delivery charges | Subtotal: <span id="drawer-subtotal">₹<%= (int) cartSubtotal %></span></p>
        </div>
        <a href="cart.jsp" class="btn-view-cart">
            <span>View Cart</span>
            <i class="fa-solid fa-arrow-right"></i>
        </a>
    </div>

    <!-- Footer -->
    <footer style="margin-top: 8rem;">
        <div class="footer-container">
            <div class="footer-col">
                <h4>Tapify Food</h4>
                <p style="font-size: 0.9rem; margin-top: 0.5rem;">Fastest street food and gourmet delivery at your fingertips.</p>
            </div>
            <div class="footer-col">
                <h4>About Us</h4>
                <ul>
                    <li><a href="#">Our Story</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Contact</h4>
                <ul>
                    <li><a href="#">Help & Support</a></li>
                    <li><a href="#">Partner with us</a></li>
                    <li><a href="#">Ride with us</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 Tapify Food. All rights reserved.</p>
        </div>
    </footer>

    <!-- Global Helpers and Menu Logic -->
    <script>
// Global Utilities for Tapify Food

// Format Currency
function formatPrice(amount) {
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR',
        minimumFractionDigits: 0
    }).format(amount);
}

// User Session Management
const SessionManager = {
    getUser() {
        const user = localStorage.getItem('tapify_user');
        return user ? JSON.parse(user) : null;
    },
    
    setUser(user) {
        localStorage.setItem('tapify_user', JSON.stringify(user));
        this.updateHeaderUser();
    },
    
    logout() {
        localStorage.removeItem('tapify_user');
        window.location.href = 'logout';
    },
    
    updateHeaderUser() {
        const user = this.getUser();
        const navLinks = document.querySelector('.nav-links');
        if (!navLinks) return;
        
        // Remove existing dynamic nodes (like Profile or Login links)
        const dynamicNodes = navLinks.querySelectorAll('.dynamic-auth');
        dynamicNodes.forEach(node => node.remove());
        
        if (user) {
            // Logged in: Add Profile Badge and Logout Link
            const badgeLi = document.createElement('li');
            badgeLi.className = 'dynamic-auth user-badge-item';
            
            // Get user initials for avatar
            const initials = user.userName ? user.userName.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase() : 'U';
            
            badgeLi.innerHTML = `
                <div class="user-badge">
                    <div class="user-avatar">${initials}</div>
                    <span class="user-name">Hi, ${user.userName.split(' ')[0]}</span>
                </div>
            `;
            
            const logoutLi = document.createElement('li');
            logoutLi.className = 'dynamic-auth';
            logoutLi.innerHTML = `<a href="#" id="logout-btn" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a>`;
            
            // Insert before cart if cart exists
            const cartItem = navLinks.querySelector('.cart-nav-item');
            if (cartItem) {
                navLinks.insertBefore(badgeLi, cartItem);
                navLinks.insertBefore(logoutLi, cartItem);
            } else {
                navLinks.appendChild(badgeLi);
                navLinks.appendChild(logoutLi);
            }
            
            // Bind logout
            document.getElementById('logout-btn')?.addEventListener('click', (e) => {
                e.preventDefault();
                this.logout();
            });
            
            // Update address display
            const addrSelector = document.querySelector('.address-selector span');
            if (addrSelector && user.address) {
                addrSelector.textContent = user.address.length > 25 ? user.address.substring(0, 25) + '...' : user.address;
                addrSelector.title = user.address;
            }
        } else {
            // Not logged in: Add Login / Register links
            const loginLi = document.createElement('li');
            loginLi.className = 'dynamic-auth';
            loginLi.innerHTML = `<a href="login.html"><i class="fas fa-sign-in-alt"></i> <span class="dynamic-auth-text">Login</span></a>`;
            
            const registerLi = document.createElement('li');
            registerLi.className = 'dynamic-auth';
            registerLi.innerHTML = `<a href="register.html" class="btn btn-outline" style="padding: 0.4rem 1rem; font-size: 0.9rem;"><i class="fas fa-user-plus"></i> <span class="dynamic-auth-text">Register</span></a>`;
            
            // Insert
            const cartItem = navLinks.querySelector('.cart-nav-item');
            if (cartItem) {
                navLinks.insertBefore(loginLi, cartItem);
                navLinks.insertBefore(registerLi, cartItem);
            } else {
                navLinks.appendChild(loginLi);
                navLinks.appendChild(registerLi);
            }
        }
    }
};

// Cart Management (Persisted in LocalStorage)
const CartManager = {
    getCart() {
        const cart = localStorage.getItem('tapify_cart');
        return cart ? JSON.parse(cart) : { restaurantId: null, items: [] };
    },
    
    saveCart(cart) {
        localStorage.setItem('tapify_cart', JSON.stringify(cart));
        this.updateCartBadge();
        
        // Dispatch custom event for pages (like menu.html) to listen to
        window.dispatchEvent(new CustomEvent('cartUpdated', { detail: cart }));
    },
    
    addItem(restaurantId, menuItem, quantity = 1) {
        const cart = this.getCart();
        
        // If ordering from a different restaurant, ask user to clear cart (Swiggy logic)
        if (cart.restaurantId && cart.restaurantId !== restaurantId && cart.items.length > 0) {
            if (confirm("Your cart contains dishes from another restaurant. Do you want to clear your cart and add this dish instead?")) {
                cart.restaurantId = restaurantId;
                cart.items = [];
            } else {
                return false; // Cancelled
            }
        }
        
        if (!cart.restaurantId) {
            cart.restaurantId = restaurantId;
        }
        
        const existingItem = cart.items.find(item => item.menuId === menuItem.menuId);
        if (existingItem) {
            existingItem.quantity += quantity;
        } else {
            cart.items.push({
                menuId: menuItem.menuId,
                itemName: menuItem.itemName,
                price: menuItem.price,
                imagePath: menuItem.imagePath,
                quantity: quantity
            });
        }
        
        this.saveCart(cart);
        return true;
    },
    
    updateQuantity(menuId, quantity) {
        const cart = this.getCart();
        const existingItem = cart.items.find(item => item.menuId === menuId);
        
        if (existingItem) {
            existingItem.quantity = quantity;
            if (existingItem.quantity <= 0) {
                cart.items = cart.items.filter(item => item.menuId !== menuId);
            }
        }
        
        if (cart.items.length === 0) {
            cart.restaurantId = null;
        }
        
        this.saveCart(cart);
    },
    
    clearCart() {
        this.saveCart({ restaurantId: null, items: [] });
    },
    
    updateCartBadge() {
        const cart = this.getCart();
        const totalItems = cart.items.reduce((sum, item) => sum + item.quantity, 0);
        
        const badge = document.querySelector('.cart-badge');
        if (badge) {
            badge.textContent = totalItems;
            badge.style.display = totalItems > 0 ? 'inline-block' : 'none';
        }
    }
};

// Initialize common behaviors
document.addEventListener('DOMContentLoaded', () => {
    SessionManager.updateHeaderUser();
    CartManager.updateCartBadge();
    
    // Smooth scroll navigation hooks
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href === '#') return;
            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });
});

</script>
<script>
// Menu Controller - Dish Rendering, Cart Interactivity, and Order Checkouts

// Dynamic activeRestaurant set from JSP request attribute
const activeRestaurant = {
    restaurantId: <%= restaurant != null ? restaurant.getRestaurantId() : 1 %>,
    name: "<%= restaurant != null ? restaurant.getName().replace("\"", "\\\"") : "" %>",
    cuisineType: "<%= restaurant != null ? restaurant.getCuisineType().replace("\"", "\\\"") : "" %>",
    deliveryTime: <%= restaurant != null ? restaurant.getDeliveryTime() : 0 %>,
    address: "<%= restaurant != null ? restaurant.getAddress().replace("\"", "\\\"") : "" %>",
    rating: <%= restaurant != null ? restaurant.getRating() : 0.0 %>,
    isActive: <%= restaurant != null ? restaurant.isActive() : false %>,
    imagePath: "<%= restaurant != null ? restaurant.getImagePath() : "" %>"
};

// Dynamic mockDishes array populated from database
const mockDishes = [
    <%
    if (menuList != null) {
        for (int i = 0; i < menuList.size(); i++) {
            Menu item = menuList.get(i);
    %>
    {
        menuId: <%= item.getMenuId() %>,
        restaurantId: <%= item.getRestaurantId() %>,
        itemName: "<%= item.getItemName().replace("\"", "\\\"") %>",
        description: "<%= item.getDescription() != null ? item.getDescription().replace("\"", "\\\"") : "" %>",
        price: <%= item.getPrice() %>,
        isAvailable: <%= item.isAvailable() %>,
        imagePath: "<%= item.getImage() != null ? item.getImage() : "" %>"
    }<%= (i < menuList.size() - 1) ? "," : "" %>
    <%
        }
    }
    %>
];

let filteredDishes = mockDishes;

// Render Menu Cards
function renderMenu(dishes) {
    const container = document.getElementById('menu-items-container');
    if (!container) return;
    
    container.innerHTML = "";
    
    if (dishes.length === 0) {
        container.innerHTML = `
            <div style="text-align: center; padding: 4rem; color: var(--text-secondary);">
                <h3>No Items Available</h3>
                <p>This restaurant's menu will be updated soon.</p>
            </div>
        `;
        return;
    }
    
    const menuSection = document.createElement('div');
    menuSection.className = 'menu-category-section';
    
    const sectionTitle = document.createElement('h2');
    sectionTitle.className = 'category-heading';
    sectionTitle.textContent = "All Menu Items";
    menuSection.appendChild(sectionTitle);
    
    dishes.forEach(dish => {
        const card = document.createElement('div');
        card.className = `dish-card ${!dish.isAvailable ? 'out-of-stock' : ''}`;
        
        // Check quantity in cart
        const qty = currentCartState.items[dish.menuId] || 0;
        
        let actionBtnHtml = '';
        if (!dish.isAvailable) {
            actionBtnHtml = `<button class="dish-add-btn disabled" disabled>Out of Stock</button>`;
        } else if (qty > 0) {
            actionBtnHtml = `
                <div class="dish-qty-control">
                    <button onclick="decrementDish(${dish.menuId})">-</button>
                    <span>${qty}</span>
                    <button onclick="incrementDish(${dish.menuId})">+</button>
                </div>
            `;
        } else {
            actionBtnHtml = `<button class="dish-add-btn" onclick="addDishToCart(${dish.menuId})">ADD <i class="fa-solid fa-plus" style="font-size: 0.75rem;"></i></button>`;
        }
        
        card.innerHTML = `
            <div class="dish-details">
                <h3 class="dish-title">${dish.itemName}</h3>
                <p class="dish-price">${formatPrice(dish.price)}</p>
                <p class="dish-desc">${dish.description}</p>
            </div>
            <div class="dish-img-section">
                <img src="${dish.imagePath}" alt="${dish.itemName}">
                <div class="dish-action-container">
                    ${actionBtnHtml}
                </div>
            </div>
        `;
        
        menuSection.appendChild(card);
    });
    
    container.appendChild(menuSection);
}

// Initialize cart state from server-side JSP values
let currentCartState = {
    quantity: <%= cartQuantity %>,
    subtotal: <%= cartSubtotal %>,
    items: <%= cartItemsJson.toString() %>
};

// Card Actions binding using AJAX background request
window.addDishToCart = function(menuId) {
    const dish = mockDishes.find(d => d.menuId === menuId);
    if (!dish) return;
    
    // Perform background AJAX fetch to add item to server session
    fetch(`cartServlet?action=add&menuId=${menuId}&quantity=1&restaurantId=${dish.restaurantId}&ajax=true`)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                // Update client state
                currentCartState.quantity = data.cartQuantity;
                currentCartState.subtotal = data.cartSubtotal;
                currentCartState.items = data.items;
                
                // Update header cart badge
                const badge = document.querySelector('.cart-badge');
                if (badge) {
                    badge.textContent = data.cartQuantity;
                    badge.style.display = data.cartQuantity > 0 ? 'inline-block' : 'none';
                } else if (data.cartQuantity > 0) {
                    const cartIcon = document.querySelector('.cart-icon-container');
                    if (cartIcon) {
                        const newBadge = document.createElement('span');
                        newBadge.className = 'cart-badge';
                        newBadge.textContent = data.cartQuantity;
                        cartIcon.appendChild(newBadge);
                    }
                }
                
                // Re-render menu to update card quantities
                renderMenu(filteredDishes);
                
                // Update floating drawer details
                updateCartDrawer();
            }
        })
        .catch(err => {
            console.error('Error adding dish to cart:', err);
            // Fallback: standard redirect
            window.location.href = `cartServlet?action=add&menuId=${menuId}&quantity=1&restaurantId=${dish.restaurantId}`;
        });
};

window.incrementDish = function(menuId) {
    const currentQty = currentCartState.items[menuId] || 0;
    const newQty = currentQty + 1;
    
    fetch(`cartServlet?action=update&menuId=${menuId}&quantity=${newQty}&ajax=true`)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                // Update client state
                currentCartState.quantity = data.cartQuantity;
                currentCartState.subtotal = data.cartSubtotal;
                currentCartState.items = data.items;
                
                // Update header cart badge
                const badge = document.querySelector('.cart-badge');
                if (badge) {
                    badge.textContent = data.cartQuantity;
                    badge.style.display = data.cartQuantity > 0 ? 'inline-block' : 'none';
                }
                
                // Re-render menu to update card quantities
                renderMenu(filteredDishes);
                
                // Update floating drawer details
                updateCartDrawer();
            }
        })
        .catch(err => console.error('Error incrementing dish:', err));
};

window.decrementDish = function(menuId) {
    const currentQty = currentCartState.items[menuId] || 0;
    const newQty = currentQty - 1;
    
    const action = newQty <= 0 ? 'delete' : 'update';
    const url = action === 'delete' 
        ? `cartServlet?action=delete&menuId=${menuId}&ajax=true` 
        : `cartServlet?action=update&menuId=${menuId}&quantity=${newQty}&ajax=true`;
        
    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                // Update client state
                currentCartState.quantity = data.cartQuantity;
                currentCartState.subtotal = data.cartSubtotal;
                currentCartState.items = data.items;
                
                // Update header cart badge
                const badge = document.querySelector('.cart-badge');
                if (badge) {
                    badge.textContent = data.cartQuantity;
                    badge.style.display = data.cartQuantity > 0 ? 'inline-block' : 'none';
                }
                
                // Re-render menu to update card quantities
                renderMenu(filteredDishes);
                
                // Update floating drawer details
                updateCartDrawer();
            }
        })
        .catch(err => console.error('Error decrementing dish:', err));
};

// Cart Drawer Updates
function updateCartDrawer() {
    const drawer = document.getElementById('cart-drawer');
    const drawerCount = document.getElementById('drawer-item-count');
    const drawerSubtotal = document.getElementById('drawer-subtotal');
    
    // Render floating drawer bar based on current session cart state
    if (drawer) {
        if (currentCartState.quantity > 0) {
            drawer.classList.add('visible');
            if (drawerCount) drawerCount.textContent = `${currentCartState.quantity} item${currentCartState.quantity > 1 ? 's' : ''}`;
            if (drawerSubtotal) drawerSubtotal.textContent = `₹${Math.round(currentCartState.subtotal)}`;
        } else {
            drawer.classList.remove('visible');
        }
    }
}

// Initial Loader
document.addEventListener('DOMContentLoaded', () => {
    // Render list (info is pre-rendered by JSP)
    renderMenu(filteredDishes);
    updateCartDrawer();
});

</script>
</body>
</html>
