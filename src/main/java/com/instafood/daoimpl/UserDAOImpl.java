package com.instafood.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.instafood.dao.UserDAO;
import com.instafood.model.User;
import com.instafood.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    Connection con = DBConnection.getConnection();

    // INSERT
    @Override
    public int addUser(User user) {
    	
        String query =
        "INSERT INTO user(userName,password,email,address,role,createDate,lastLoginDate) VALUES(?,?,?,?,?,?,?)";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setString(1, user.getUserName());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getRole());

            // NEW FIELDS
            if (user.getCreateDate() != null) {
                ps.setTimestamp(6, user.getCreateDate());
            } else {
                ps.setTimestamp(6, new java.sql.Timestamp(System.currentTimeMillis()));
            }

            if (user.getLastLoginDate() != null) {
                ps.setTimestamp(7, user.getLastLoginDate());
            } else {
                ps.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
            }

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // FETCH SINGLE USER
    @Override
    public User getUserById(int id) {

        String query =
                "SELECT * FROM user WHERE userId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                User user = new User(

                        rs.getInt("userId"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("role"),

                        // NEW FIELDS
                        rs.getTimestamp("createDate"),
                        rs.getTimestamp("lastLoginDate")
                );

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // FETCH ALL USERS
    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        String query = "SELECT * FROM user";

        try {

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(query);

            while(rs.next()) {

            	User user = new User(

            	        rs.getInt("userId"),
            	        rs.getString("userName"),
            	        rs.getString("password"),
            	        rs.getString("email"),
            	        rs.getString("address"),
            	        rs.getString("role"),
            	        rs.getTimestamp("createDate"),
            	        rs.getTimestamp("lastLoginDate")
            	);

                users.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }

    // UPDATE USER
    @Override
    public int updateUser(User user) {

        String query =
        "UPDATE user SET userName=?, password=?, email=?, address=?, role=?, createDate=?, lastLoginDate=? WHERE userId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setString(1, user.getUserName());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getRole());

            // NEW FIELDS
            ps.setTimestamp(6, user.getCreateDate());
            ps.setTimestamp(7, user.getLastLoginDate());

            ps.setInt(8, user.getUserId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // DELETE USER
    @Override
    public int deleteUser(int id) {

        String query =
                "DELETE FROM user WHERE userId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, id);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // FETCH USER BY EMAIL
    @Override
    public User getUserByEmail(String email) {
        String query = "SELECT * FROM user WHERE email=?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("userId"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("role"),
                        rs.getTimestamp("createDate"),
                        rs.getTimestamp("lastLoginDate")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
