package com.instafood.dao;

import java.util.List;

import com.instafood.model.OrderTable;

public interface OrderTableDAO {

    // INSERT
    int addOrder(OrderTable order);

    // FETCH SINGLE ORDER
    OrderTable getOrderById(int id);

    // FETCH ALL ORDERS
    List<OrderTable> getAllOrders();

    // UPDATE ORDER
    int updateOrder(OrderTable order);

    // DELETE ORDER
    int deleteOrder(int id);

    // FETCH ORDERS BY USER ID
    List<OrderTable> getOrdersByUserId(int userId);
}
