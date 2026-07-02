package com.instafood.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.instafood.dao.OrderTableDAO;
import com.instafood.model.OrderTable;
import com.instafood.util.DBConnection;

public class OrderTableDAOImpl implements OrderTableDAO {

    Connection con = DBConnection.getConnection();

    // INSERT
    @Override
    public int addOrder(OrderTable order) {

        String query =
        "INSERT INTO ordertable(userId,orderDate,totalAmount,status,paymentMethod,restaurantId) VALUES(?,?,?,?,?,?)";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, order.getUserId());
            ps.setTimestamp(2, order.getOrderDate());
            ps.setDouble(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getPaymentMethod());
            ps.setInt(6, order.getRestaurantId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                java.sql.ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    order.setOrderId(generatedId);
                    return generatedId;
                }
            }
            return affectedRows;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // FETCH SINGLE ORDER
    @Override
    public OrderTable getOrderById(int id) {

        String query =
                "SELECT * FROM ordertable WHERE orderId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                OrderTable order = new OrderTable(

                        rs.getInt("orderId"),
                        rs.getInt("userId"),
                        rs.getTimestamp("orderDate"),
                        rs.getDouble("totalAmount"),
                        rs.getString("status"),
                        rs.getString("paymentMethod"),
                        rs.getInt("restaurantId")
                );

                return order;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // FETCH ALL ORDERS
    @Override
    public List<OrderTable> getAllOrders() {

        List<OrderTable> orders = new ArrayList<>();

        String query = "SELECT * FROM ordertable";

        try {

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(query);

            while(rs.next()) {

                OrderTable order = new OrderTable(

                        rs.getInt("orderId"),
                        rs.getInt("userId"),
                        rs.getTimestamp("orderDate"),
                        rs.getDouble("totalAmount"),
                        rs.getString("status"),
                        rs.getString("paymentMethod"),
                        rs.getInt("restaurantId")
                );

                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    // UPDATE ORDER
    @Override
    public int updateOrder(OrderTable order) {

        String query =
        "UPDATE ordertable SET userId=?, orderDate=?, totalAmount=?, status=?, paymentMethod=?, restaurantId=? WHERE orderId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, order.getUserId());
            ps.setTimestamp(2, order.getOrderDate());
            ps.setDouble(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getPaymentMethod());
            ps.setInt(6, order.getRestaurantId());

            ps.setInt(7, order.getOrderId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // DELETE ORDER
    @Override
    public int deleteOrder(int id) {

        String query =
                "DELETE FROM ordertable WHERE orderId=?";

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

    // FETCH ORDERS BY USER ID
    @Override
    public List<OrderTable> getOrdersByUserId(int userId) {
        List<OrderTable> orders = new ArrayList<>();
        String query = "SELECT * FROM ordertable WHERE userId=? ORDER BY orderDate DESC";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderTable order = new OrderTable(
                    rs.getInt("orderId"),
                    rs.getInt("userId"),
                    rs.getTimestamp("orderDate"),
                    rs.getDouble("totalAmount"),
                    rs.getString("status"),
                    rs.getString("paymentMethod"),
                    rs.getInt("restaurantId")
                );
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }
}
