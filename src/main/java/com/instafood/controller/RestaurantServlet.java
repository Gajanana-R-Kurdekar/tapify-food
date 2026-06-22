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
import com.instafood.model.Restaurant;

@WebServlet("/home")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Instantiate the DAO implementation to query database
        RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();
        List<Restaurant> allRestaurants = restaurantDAOImpl.getAllRestaurants();
        
        // Print to console for verification / testing
        for (Restaurant rest : allRestaurants) {
            System.out.println(rest);
        }
        
        // Bind results list to request scope
        req.setAttribute("allRestaurants", allRestaurants);
        
        // Forward the request to restaurant.jsp
        RequestDispatcher rd = req.getRequestDispatcher("restaurant.jsp");
        rd.forward(req, res);
    }
}
