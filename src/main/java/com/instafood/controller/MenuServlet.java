package com.instafood.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.instafood.daoimpl.RestaurantDAOImpl;
import com.instafood.daoimpl.MenuDAOImpl;
import com.instafood.model.Restaurant;
import com.instafood.model.Menu;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String restaurantIdStr = req.getParameter("restaurantId");
        int restaurantId = 1; // Default fallback
        if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantIdStr);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Fetch Restaurant details
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

        // Fetch Menu items
        MenuDAOImpl menuDAO = new MenuDAOImpl();
        List<Menu> menuList = menuDAO.getMenuByRestaurantId(restaurantId);

        // Bind attributes
        req.setAttribute("restaurant", restaurant);
        req.setAttribute("menuList", menuList);

        // Forward to menu.jsp
        RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
        rd.forward(req, res);
    }
}
