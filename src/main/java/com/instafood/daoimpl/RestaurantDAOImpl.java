package com.instafood.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.instafood.dao.RestaurantDAO;
import com.instafood.model.Restaurant;
import com.instafood.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    Connection con = DBConnection.getConnection();

    // INSERT
    @Override
    public int addRestaurant(Restaurant restaurant) {

        String query =
        "INSERT INTO restaurant(name,cuisineType,deliveryTime,address,rating,isActive,imagePath) VALUES(?,?,?,?,?,?,?)";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.isActive());
            ps.setString(7, restaurant.getImagePath());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // FETCH SINGLE RESTAURANT
    @Override
    public Restaurant getRestaurantById(int id) {

        String query =
                "SELECT * FROM restaurant WHERE restaurantId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                Restaurant restaurant = new Restaurant(

                        rs.getInt("restaurantId"),
                        rs.getString("name"),
                        rs.getString("cuisineType"),
                        rs.getInt("deliveryTime"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getBoolean("isActive"),
                        rs.getString("imagePath")
                );

                return restaurant;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // FETCH ALL RESTAURANTS
    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        String query = "SELECT * FROM restaurant";

        try {

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(query);

            while(rs.next()) {

                Restaurant restaurant = new Restaurant(

                        rs.getInt("restaurantId"),
                        rs.getString("name"),
                        rs.getString("cuisineType"),
                        rs.getInt("deliveryTime"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getBoolean("isActive"),
                        rs.getString("imagePath")
                );

                restaurants.add(restaurant);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    // UPDATE RESTAURANT
    @Override
    public int updateRestaurant(Restaurant restaurant) {

        String query =
        "UPDATE restaurant SET name=?, cuisineType=?, deliveryTime=?, address=?, rating=?, isActive=?, imagePath=? WHERE restaurantId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.isActive());
            ps.setString(7, restaurant.getImagePath());

            ps.setInt(8, restaurant.getRestaurantId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // DELETE RESTAURANT
    @Override
    public int deleteRestaurant(int id) {

        String query =
                "DELETE FROM restaurant WHERE restaurantId=?";

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
}
