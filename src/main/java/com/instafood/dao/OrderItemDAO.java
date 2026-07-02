package com.instafood.dao;

import java.util.List;

import com.instafood.model.OrderItem;

public interface OrderItemDAO {

    // INSERT
    int addOrderItem(OrderItem orderItem);

    // FETCH SINGLE ORDER ITEM
    OrderItem getOrderItemById(int id);

    // FETCH ALL ORDER ITEMS
    List<OrderItem> getAllOrderItems();

    // UPDATE ORDER ITEM
    int updateOrderItem(OrderItem orderItem);

    // DELETE ORDER ITEM
    int deleteOrderItem(int id);

    // FETCH ORDER ITEMS BY ORDER ID
    List<OrderItem> getOrderItemsByOrderId(int orderId);
}
