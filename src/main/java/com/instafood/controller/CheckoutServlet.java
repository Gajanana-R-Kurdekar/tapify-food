package com.instafood.controller;

import java.io.IOException;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafood.daoimpl.UserDAOImpl;
import com.instafood.daoimpl.OrderTableDAOImpl;
import com.instafood.daoimpl.OrderItemDAOImpl;
import com.instafood.model.User;
import com.instafood.model.Cart;
import com.instafood.model.CartItem;
import com.instafood.model.OrderTable;
import com.instafood.model.OrderItem;

/**
 * Controller servlet to handle processing checkout and placing orders.
 * Maps to /checkoutServlet.
 */
@WebServlet("/checkoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session and Authentication Verification
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.html");
            return;
        }

        // 2. Cart Verification
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        // 3. Process Address Update
        String address = request.getParameter("address");
        if (address != null && !address.trim().isEmpty()) {
            address = address.trim();
            if (!address.equalsIgnoreCase(user.getAddress())) {
                user.setAddress(address);
                try {
                    UserDAOImpl userDAO = new UserDAOImpl();
                    userDAO.updateUser(user);
                    session.setAttribute("user", user);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // 4. Retrieve Form Parameters
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "Cash_On_Delivery";
        } else {
            paymentMethod = paymentMethod.trim();
        }

        // 5. Calculate Order Totals
        double subtotal = 0.0;
        int restaurantId = 0;
        
        for (CartItem item : cart.getItems().values()) {
            subtotal += item.getTotalPrice();
            if (restaurantId == 0) {
                restaurantId = item.getRestaurantId();
            }
        }
        
        // Secondary fallback for restaurant ID from session
        if (restaurantId == 0) {
            Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");
            if (sessionRestaurantId != null) {
                restaurantId = sessionRestaurantId;
            }
        }

        double deliveryFee = 40.0;
        double tax = subtotal * 0.05; // 5% GST
        double grandTotal = subtotal + deliveryFee + tax;

        // 6. Create OrderTable Entry
        OrderTable order = new OrderTable();
        order.setUserId(user.getUserId());
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(grandTotal);
        order.setStatus("Pending");
        order.setPaymentMethod(paymentMethod);
        order.setRestaurantId(restaurantId);

        try {
            OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
            int orderId = orderDAO.addOrder(order);

            // 7. Insert OrderItem rows if Order was successfully created
            if (orderId > 0) {
                OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
                
                for (CartItem cartItem : cart.getItems().values()) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setQuantity(cartItem.getQuantity());
                    orderItem.setItemTotal(cartItem.getTotalPrice());
                    orderItem.setMenuId(cartItem.getMenuId());
                    
                    orderItemDAO.addOrderItem(orderItem);
                }

                // 8. Clear Cart and associated session metadata
                cart.clear();
                session.removeAttribute("restaurantId");
                
                // 9. Redirect to confirmation page
                response.sendRedirect("orderConfirmation.jsp?orderId=" + orderId);
            } else {
                response.sendRedirect("checkout.jsp?error=order_creation_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=exception_occurred");
        }
    }
}
