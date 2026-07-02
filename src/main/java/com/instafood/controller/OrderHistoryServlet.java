package com.instafood.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafood.daoimpl.OrderTableDAOImpl;
import com.instafood.model.OrderTable;
import com.instafood.model.User;

/**
 * Controller servlet to handle fetching user's order history.
 * Maps to /orderHistory.
 */
@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session and Authentication Verification
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.html");
            return;
        }

        // 2. Fetch User Orders
        try {
            OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
            List<OrderTable> ordersList = orderDAO.getOrdersByUserId(user.getUserId());
            
            // Set request attribute for the JSP page
            request.setAttribute("ordersList", ordersList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Forward to view page
        RequestDispatcher rd = request.getRequestDispatcher("orderHistory.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
