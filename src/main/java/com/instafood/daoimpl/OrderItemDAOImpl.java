package com.instafood.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.instafood.dao.OrderItemDAO;
import com.instafood.model.OrderItem;
import com.instafood.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    Connection con = DBConnection.getConnection();

    // INSERT
    @Override
    public int addOrderItem(OrderItem orderItem) {

        String query =
        "INSERT INTO orderitem(orderId,quantity,itemTotal,menuId) VALUES(?,?,?,?)";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getQuantity());
            ps.setDouble(3, orderItem.getItemTotal());
            ps.setInt(4, orderItem.getMenuId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // FETCH SINGLE ORDER ITEM
    @Override
    public OrderItem getOrderItemById(int id) {

        String query =
                "SELECT * FROM orderitem WHERE orderItemId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                OrderItem orderItem = new OrderItem(

                        rs.getInt("orderItemId"),
                        rs.getInt("orderId"),
                        rs.getInt("quantity"),
                        rs.getDouble("itemTotal"),
                        rs.getInt("menuId")
                );

                return orderItem;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // FETCH ALL ORDER ITEMS
    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        String query = "SELECT * FROM orderitem";

        try {

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(query);

            while(rs.next()) {

                OrderItem orderItem = new OrderItem(

                        rs.getInt("orderItemId"),
                        rs.getInt("orderId"),
                        rs.getInt("quantity"),
                        rs.getDouble("itemTotal"),
                        rs.getInt("menuId")
                );

                orderItems.add(orderItem);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    // UPDATE ORDER ITEM
    @Override
    public int updateOrderItem(OrderItem orderItem) {

        String query =
        "UPDATE orderitem SET orderId=?, quantity=?, itemTotal=?, menuId=? WHERE orderItemId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getQuantity());
            ps.setDouble(3, orderItem.getItemTotal());
            ps.setInt(4, orderItem.getMenuId());

            ps.setInt(5, orderItem.getOrderItemId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // DELETE ORDER ITEM
    @Override
    public int deleteOrderItem(int id) {

        String query =
                "DELETE FROM orderitem WHERE orderItemId=?";

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
