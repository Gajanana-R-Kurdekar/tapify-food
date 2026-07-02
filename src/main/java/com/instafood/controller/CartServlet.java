package com.instafood.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafood.daoimpl.MenuDAOImpl;
import com.instafood.model.Cart;
import com.instafood.model.CartItem;
import com.instafood.model.Menu;

/**
 * Controller servlet to handle all Cart activities (add, update, delete).
 * Maps to /cartServlet.
 */
@WebServlet("/cartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 1. Retrieve or Initialize Session and Cart
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // Restaurant Boundary Check
        String restaurantIdParam = request.getParameter("restaurantId");
        if (restaurantIdParam != null && !restaurantIdParam.trim().isEmpty()) {
            try {
                Integer currentRestaurantId = Integer.valueOf(restaurantIdParam.trim());
                Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");

                // If adding from a different restaurant, reset the cart
                if (sessionRestaurantId != null && !sessionRestaurantId.equals(currentRestaurantId)) {
                    cart.clear();
                }
                session.setAttribute("restaurantId", currentRestaurantId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 2. Action Routing
        String action = request.getParameter("action");
        if (action != null) {
            try {
                switch (action) {
                    case "add":
                        handleAddAction(request, session, cart);
                        break;
                    case "update":
                        handleUpdateAction(request, cart);
                        break;
                    case "delete":
                        handleDeleteAction(request, cart);
                        break;
                    default:
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 3. Handle AJAX response or standard redirect
        String isAjax = request.getParameter("ajax");
        if ("true".equalsIgnoreCase(isAjax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            int totalQty = 0;
            double subtotal = 0.0;
            StringBuilder itemsJson = new StringBuilder("{");
            
            if (cart != null) {
                boolean first = true;
                for (CartItem item : cart.getItems().values()) {
                    totalQty += item.getQuantity();
                    subtotal += item.getTotalPrice();
                    
                    if (!first) {
                        itemsJson.append(",");
                    }
                    itemsJson.append(String.format("\"%d\":%d", item.getMenuId(), item.getQuantity()));
                    first = false;
                }
            }
            itemsJson.append("}");
            
            String jsonResponse = String.format(
                "{\"status\":\"success\", \"cartQuantity\":%d, \"cartSubtotal\":%.2f, \"items\":%s}",
                totalQty,
                subtotal,
                itemsJson.toString()
            );
            response.getWriter().write(jsonResponse);
            return;
        }

        response.sendRedirect("cart.jsp");
    }

    private void handleAddAction(HttpServletRequest request, HttpSession session, Cart cart) {
        String menuIdStr = request.getParameter("menuId");
        String quantityStr = request.getParameter("quantity");

        if (menuIdStr != null && !menuIdStr.trim().isEmpty() &&
            quantityStr != null && !quantityStr.trim().isEmpty()) {
            
            try {
                int menuId = Integer.parseInt(menuIdStr.trim());
                int quantity = Integer.parseInt(quantityStr.trim());

                MenuDAOImpl menuDAO = new MenuDAOImpl();
                Menu menu = menuDAO.getMenu(menuId);

                if (menu != null) {
                    int itemRestaurantId = menu.getRestaurantId();
                    Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");

                    // Secondary safety check: compare menu restaurantId with session restaurantId
                    if (sessionRestaurantId != null && !sessionRestaurantId.equals(itemRestaurantId)) {
                        cart.clear();
                    }

                    // Instantiate new CartItem with image metadata
                    CartItem cartItem = new CartItem(
                        menuId,
                        itemRestaurantId,
                        menu.getItemName(),
                        menu.getPrice(),
                        quantity,
                        menu.getImage()
                    );
                    cart.addItem(cartItem);

                    // Explicitly update the restaurantId stored in the session
                    session.setAttribute("restaurantId", itemRestaurantId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

    private void handleUpdateAction(HttpServletRequest request, Cart cart) {
        String menuIdStr = request.getParameter("menuId");
        String quantityStr = request.getParameter("quantity");

        if (menuIdStr != null && !menuIdStr.trim().isEmpty() &&
            quantityStr != null && !quantityStr.trim().isEmpty()) {
            
            try {
                int menuId = Integer.parseInt(menuIdStr.trim());
                int quantity = Integer.parseInt(quantityStr.trim());

                if (quantity <= 0) {
                    cart.removeItem(menuId);
                } else {
                    cart.updateItem(menuId, quantity);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

    private void handleDeleteAction(HttpServletRequest request, Cart cart) {
        String menuIdStr = request.getParameter("menuId");

        if (menuIdStr != null && !menuIdStr.trim().isEmpty()) {
            try {
                int menuId = Integer.parseInt(menuIdStr.trim());
                cart.removeItem(menuId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }
}
