package com.instafood.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;
import com.instafood.daoimpl.UserDAOImpl;
import com.instafood.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String role = req.getParameter("role");

        String hashpw = BCrypt.hashpw(password, BCrypt.gensalt(12));

        User user = new User(name, hashpw, email, address, role);

        UserDAOImpl userDAOImpl = new UserDAOImpl();
        int res = userDAOImpl.addUser(user);

        if (res == 1) {
            resp.sendRedirect("login.html");
        } else {
            resp.sendRedirect("register.html?error=true");
        }
    }
}
