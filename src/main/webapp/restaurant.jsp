<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafood.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants - Tapify Food</title>
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
        .search-banner-section {
            background: linear-gradient(180deg, rgba(252, 128, 25, 0.04) 0%, rgba(18, 15, 13, 0) 100%);
            padding: 3rem 2rem 2rem 2rem;
            text-align: center;
        }

        .search-container {
            max-width: 600px;
            margin: 1.5rem auto 0 auto;
            position: relative;
        }

        .search-container i {
            position: absolute;
            left: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.1rem;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border-radius: 30px;
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            font-family: var(--font-body);
            font-size: 1rem;
            transition: all var(--transition-fast);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--accent-orange);
            box-shadow: 0 0 15px var(--glow-orange);
            background-color: var(--bg-tertiary);
        }

        /* Promo Carousel */
        .promo-carousel {
            padding: 1rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .carousel-heading {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .carousel-track {
            display: flex;
            gap: 1.5rem;
            overflow-x: auto;
            padding-bottom: 1rem;
            scroll-behavior: smooth;
            scrollbar-width: none; /* Firefox */
        }
        
        .carousel-track::-webkit-scrollbar {
            display: none; /* Safari/Chrome */
        }

        .promo-card {
            flex: 0 0 300px;
            height: 140px;
            border-radius: 16px;
            background: linear-gradient(135deg, #fc8019 0%, #ff9f00 100%);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: white;
            cursor: pointer;
            transition: transform var(--transition-fast);
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(252, 128, 25, 0.2);
        }

        .promo-card:hover {
            transform: scale(1.03);
        }

        .promo-card::after {
            content: '';
            position: absolute;
            right: -20px;
            bottom: -20px;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .promo-tag {
            background-color: rgba(0, 0, 0, 0.25);
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.2rem 0.6rem;
            border-radius: 20px;
            align-self: flex-start;
            text-transform: uppercase;
        }

        .promo-title {
            font-family: var(--font-heading);
            font-size: 1.2rem;
            font-weight: 700;
            line-height: 1.3;
        }

        .promo-code {
            font-size: 0.8rem;
            font-weight: 500;
            opacity: 0.9;
        }

        /* Filter Panel */
        .filter-panel {
            max-width: 1200px;
            margin: 2rem auto 0 auto;
            padding: 0 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1.5rem;
        }

        .filter-btn {
            background-color: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            font-size: 0.85rem;
            font-weight: 500;
            padding: 0.5rem 1.2rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .filter-btn:hover {
            border-color: var(--text-primary);
            color: var(--text-primary);
        }

        .filter-btn.active {
            background-color: rgba(252, 128, 25, 0.1);
            border-color: var(--accent-orange);
            color: var(--accent-orange);
            box-shadow: 0 0 10px var(--glow-orange);
        }

        /* Restaurant Grid */
        .restaurant-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-top: 2rem;
        }
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
        .search-banner-section {
            background: linear-gradient(180deg, rgba(252, 128, 25, 0.04) 0%, rgba(18, 15, 13, 0) 100%);
            padding: 3rem 2rem 2rem 2rem;
            text-align: center;
        }

        .search-container {
            max-width: 600px;
            margin: 1.5rem auto 0 auto;
            position: relative;
        }

        .search-container i {
            position: absolute;
            left: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.1rem;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border-radius: 30px;
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            font-family: var(--font-body);
            font-size: 1rem;
            transition: all var(--transition-fast);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--accent-orange);
            box-shadow: 0 0 15px var(--glow-orange);
            background-color: var(--bg-tertiary);
        }

        /* Promo Carousel */
        .promo-carousel {
            padding: 1rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .carousel-heading {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .carousel-track {
            display: flex;
            gap: 1.5rem;
            overflow-x: auto;
            padding-bottom: 1rem;
            scroll-behavior: smooth;
            scrollbar-width: none; /* Firefox */
        }
        
        .carousel-track::-webkit-scrollbar {
            display: none; /* Safari/Chrome */
        }

        .promo-card {
            flex: 0 0 300px;
            height: 140px;
            border-radius: 16px;
            background: linear-gradient(135deg, #fc8019 0%, #ff9f00 100%);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: white;
            cursor: pointer;
            transition: transform var(--transition-fast);
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(252, 128, 25, 0.2);
        }

        .promo-card:hover {
            transform: scale(1.03);
        }

        .promo-card::after {
            content: '';
            position: absolute;
            right: -20px;
            bottom: -20px;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .promo-tag {
            background-color: rgba(0, 0, 0, 0.25);
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.2rem 0.6rem;
            border-radius: 20px;
            align-self: flex-start;
            text-transform: uppercase;
        }

        .promo-title {
            font-family: var(--font-heading);
            font-size: 1.2rem;
            font-weight: 700;
            line-height: 1.3;
        }

        .promo-code {
            font-size: 0.8rem;
            font-weight: 500;
            opacity: 0.9;
        }

        /* Filter Panel */
        .filter-panel {
            max-width: 1200px;
            margin: 2rem auto 0 auto;
            padding: 0 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1.5rem;
        }

        .filter-btn {
            background-color: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            font-size: 0.85rem;
            font-weight: 500;
            padding: 0.5rem 1.2rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .filter-btn:hover {
            border-color: var(--text-primary);
            color: var(--text-primary);
        }

        .filter-btn.active {
            background-color: rgba(252, 128, 25, 0.1);
            border-color: var(--accent-orange);
            color: var(--accent-orange);
            box-shadow: 0 0 10px var(--glow-orange);
        }

        /* Restaurant Grid */
        .restaurant-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-top: 2rem;
        }

        #restaurant-grid .restaurant-card-link {
            flex: 0 0 calc(25% - 1.5rem); /* Default 4 in a row on desktop */
            min-width: 250px;
            display: flex;
            text-decoration: none;
            color: inherit;
            transition: all var(--transition-medium);
        }

        @media (max-width: 1200px) {
            #restaurant-grid .restaurant-card-link {
                flex: 0 0 calc(33.333% - 1.34rem); /* 3 in a row */
            }
        }

        @media (max-width: 900px) {
            #restaurant-grid .restaurant-card-link {
                flex: 0 0 calc(50% - 1rem); /* 2 in a row */
            }
        }

        @media (max-width: 600px) {
            #restaurant-grid .restaurant-card-link {
                flex: 0 0 100%; /* 1 in a row on mobile */
            }
        }

        .restaurant-card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            overflow: hidden;
            transition: all var(--transition-medium);
            display: flex;
            flex-direction: column;
            width: 100%;
            height: auto;
            position: relative;
        }

        .restaurant-card:hover {
            transform: scale(1.02) translateY(-6px);
            background-color: var(--bg-tertiary);
            border-color: var(--border-hover);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.6);
        }

        .restaurant-img {
            position: relative;
            width: 100%;
            height: 160px;
            overflow: hidden;
            border-bottom: 1px solid var(--border-color);
        }

        .restaurant-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform var(--transition-medium);
            background-color: #2c241e;
        }

        .restaurant-card:hover .restaurant-img img {
            transform: scale(1.05);
        }

        .restaurant-card.is-closed {
            opacity: 0.65;
        }
        
        .restaurant-card.is-closed:hover {
            transform: none;
            border-color: var(--border-color);
            box-shadow: none;
        }
        
        .restaurant-card.is-closed:hover img {
            transform: none;
        }

        .restaurant-card .card-content {
            padding: 1.2rem;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            gap: 0.6rem;
        }

        .restaurant-card .card-content h3 {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.1rem;
        }

        .restaurant-card .card-content .cuisine {
            font-size: 0.85rem;
            color: var(--accent-orange);
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .restaurant-card .card-content .details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin: 0.2rem 0;
        }

        .restaurant-card .card-content .location {
            font-size: 0.85rem;
            color: var(--text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.4rem;
        }

        .restaurant-card .card-content .rating {
            display: inline-flex;
            align-self: flex-start;
            align-items: center;
            gap: 0.25rem;
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 700;
            background-color: #1b8a5a;
        }

        .status {
            position: absolute;
            top: 0.8rem;
            right: 0.8rem;
            padding: 0.25rem 0.6rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            z-index: 5;
        }

        .status.open {
            background-color: #1b8a5a;
            color: white;
        }

        .status.closed {
            background-color: #c62828;
            color: white;
        }
        
        .card-discount {
            position: absolute;
            top: 0.8rem;
            left: 0.8rem;
            background: linear-gradient(90deg, #fc8019 0%, #ff9f00 100%);
            color: white;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.6rem;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            z-index: 5;
        }

        /* Responsive Overrides for Restaurants Page */
        @media (max-width: 768px) {
            .search-banner-section {
                padding: 2rem 1.2rem 1.5rem 1.2rem;
            }
            .search-container {
                margin-top: 1rem;
            }
            .search-input {
                padding: 0.8rem 1rem 0.8rem 2.6rem;
                font-size: 0.95rem;
            }
            .search-container i {
                left: 1rem;
            }
            .promo-carousel {
                padding: 0.8rem 1.2rem;
            }
            .promo-card {
                flex: 0 0 260px;
                height: 120px;
                padding: 1.2rem;
            }
            .promo-title {
                font-size: 1.05rem;
            }
            .filter-panel {
                padding: 0 1.2rem 1rem 1.2rem;
                gap: 0.6rem;
                justify-content: center;
            }
            .filter-panel span {
                width: 100%;
                text-align: center;
                margin-bottom: 0.4rem;
            }
            .filter-btn {
                padding: 0.4rem 1rem;
                font-size: 0.8rem;
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
                <li class="cart-nav-item">
                    <a href="cart.html" class="cart-icon-container">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span>Cart</span>
                        <span class="cart-badge" style="display: none;">0</span>
                    </a>
                </li>
            </ul>
        </div>
    </header>

    <!-- Search Section -->
    <section class="search-banner-section">
        <h1 style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 800;">Craving something delicious?</h1>
        <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 0.3rem;">Order from local kitchens and street vendors delivered in a tap.</p>
        <div class="search-container">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="search-bar" class="search-input" placeholder="Search for restaurants, cuisines, or dishes...">
        </div>
    </section>

    <!-- Filters and Grid Container -->
    <main class="container" style="padding-top: 0;">
        <div class="filter-panel">
            <span style="font-family: var(--font-heading); font-weight: 700; font-size: 1.1rem; margin-right: auto;">Explore Restaurants</span>
            <button class="filter-btn" id="btn-filter-fast">
                <i class="fa-solid fa-bolt"></i> Fast Delivery
            </button>
            <button class="filter-btn" id="btn-filter-rating">
                <i class="fa-solid fa-star"></i> Ratings 4.0+
            </button>
            <button class="filter-btn" id="btn-filter-active">
                <i class="fa-solid fa-door-open"></i> Open Now
            </button>
        </div>

        <!-- Dynamic Restaurant Grid -->
        <div class="restaurant-grid" id="restaurant-grid">
            <%
            List<Restaurant> allRestaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
            if (allRestaurants != null && !allRestaurants.isEmpty()) {
                for (Restaurant restaurant : allRestaurants) {
            %>
            <a href="<%= restaurant.isActive() ? "menu?restaurantId=" + restaurant.getRestaurantId() : "javascript:void(0)" %>" class="restaurant-card-link" data-id="<%= restaurant.getRestaurantId() %>" data-name="<%= restaurant.getName() %>" data-cuisine="<%= restaurant.getCuisineType() %>" data-time="<%= restaurant.getDeliveryTime() %>" data-rating="<%= restaurant.getRating() %>" data-active="<%= restaurant.isActive() %>">
                <div class="restaurant-card <%= !restaurant.isActive() ? "is-closed" : "" %>">
                    <div class="restaurant-img">
                        <img src="<%= restaurant.getImagePath() %>" alt="Restaurant">
                        <span class="status <%= restaurant.isActive() ? "open" : "closed" %>"><%= restaurant.isActive() ? "OPEN" : "CLOSED" %></span>
                        <div class="card-discount">50% OFF up to ₹100</div>
                    </div>
                    <div class="card-content">
                        <h3><%= restaurant.getName() %></h3>
                        <p class="cuisine"><%= restaurant.getCuisineType() %></p>
                        <div class="details">
                            <span>⏰ <%= restaurant.getDeliveryTime() %> mins</span>
                            <span>₹300 for two</span>
                        </div>
                        <p class="location">📍 <%= restaurant.getAddress() %></p>
                        <span class="rating">⭐ <%= restaurant.getRating() %></span>
                    </div>
                </div>
            </a>
            <%
                }
            } else {
            %>
            <div style="grid-column: 1/-1; text-align: center; padding: 4rem 2rem; color: var(--text-secondary); width: 100%;">
                <i class="fa-solid fa-magnifying-glass" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                <h3>No Restaurants Found</h3>
                <p style="font-size: 0.95rem; margin-top: 0.5rem;">There are no restaurants registered in the database.</p>
            </div>
            <%
            }
            %>
        </div>
        </main>

    <!-- Footer -->
    <footer>
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
    <!-- Global Helpers and Restaurant Logic -->
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
// Restaurants Controller - Filters, Sorting, and Search

let activeFilters = {
    searchQuery: "",
    fastDelivery: false,
    rating4Plus: false,
    activeOnly: false
};

// Filter and Sort Engine
function applyFiltersAndSort() {
    const cards = document.querySelectorAll('#restaurant-grid .card');
    let visibleCount = 0;
    
    cards.forEach(card => {
        const name = card.getAttribute('data-name').toLowerCase();
        const cuisine = card.getAttribute('data-cuisine').toLowerCase();
        const time = parseInt(card.getAttribute('data-time'));
        const rating = parseFloat(card.getAttribute('data-rating'));
        const isActive = card.getAttribute('data-active') === 'true';
        
        let show = true;
        
        // Search filter
        if (activeFilters.searchQuery.trim().length > 0) {
            const query = activeFilters.searchQuery.toLowerCase();
            if (!name.includes(query) && !cuisine.includes(query)) {
                show = false;
            }
        }
        
        // Fast delivery filter (< 20 mins)
        if (activeFilters.fastDelivery && time > 20) {
            show = false;
        }
        
        // Rating 4.0+ filter
        if (activeFilters.rating4Plus && rating < 4.0) {
            show = false;
        }
        
        // Active / Open only filter
        if (activeFilters.activeOnly && !isActive) {
            show = false;
        }
        
        if (show) {
            card.style.display = 'flex';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
    });

    // Handle No Results state
    const grid = document.getElementById('restaurant-grid');
    let noResultsMsg = document.getElementById('no-results-message');
    
    if (visibleCount === 0) {
        if (!noResultsMsg) {
            noResultsMsg = document.createElement('div');
            noResultsMsg.id = 'no-results-message';
            noResultsMsg.style.cssText = 'grid-column: 1/-1; text-align: center; padding: 4rem 2rem; color: var(--text-secondary); width: 100%;';
            noResultsMsg.innerHTML = `
                <i class="fa-solid fa-magnifying-glass" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                <h3>No Restaurants Found</h3>
                <p style="font-size: 0.95rem; margin-top: 0.5rem;">Try adjusting your keywords or filters.</p>
            `;
            grid.appendChild(noResultsMsg);
        }
    } else {
        if (noResultsMsg) {
            noResultsMsg.remove();
        }
    }
}

// Bind HTML events
document.addEventListener('DOMContentLoaded', () => {
    // Add click listeners to cards
    const cards = document.querySelectorAll('#restaurant-grid .restaurant-card-link');
    cards.forEach(card => {
        card.addEventListener('click', (e) => {
            const isActive = card.getAttribute('data-active') === 'true';
            if (!isActive) {
                e.preventDefault();
            }
        });
    });

    // Search Listener
    const searchBar = document.getElementById('search-bar');
    if (searchBar) {
        searchBar.addEventListener('input', (e) => {
            activeFilters.searchQuery = e.target.value;
            applyFiltersAndSort();
        });
    }
    
    // Filter Buttons
    const filterFast = document.getElementById('btn-filter-fast');
    const filterRating = document.getElementById('btn-filter-rating');
    const filterActive = document.getElementById('btn-filter-active');
    
    if (filterFast) {
        filterFast.addEventListener('click', () => {
            activeFilters.fastDelivery = !activeFilters.fastDelivery;
            filterFast.classList.toggle('active', activeFilters.fastDelivery);
            applyFiltersAndSort();
        });
    }
    
    if (filterRating) {
        filterRating.addEventListener('click', () => {
            activeFilters.rating4Plus = !activeFilters.rating4Plus;
            filterRating.classList.toggle('active', activeFilters.rating4Plus);
            applyFiltersAndSort();
        });
    }
    
    if (filterActive) {
        filterActive.addEventListener('click', () => {
            activeFilters.activeOnly = !activeFilters.activeOnly;
            filterActive.classList.toggle('active', activeFilters.activeOnly);
            applyFiltersAndSort();
        });
    }
});

</script>
</body>
</html>
