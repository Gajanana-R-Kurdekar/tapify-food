package com.instafood.model;

public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int quantity;
    private double itemTotal;
    private int menuId;

    // Default Constructor
    public OrderItem() {

    }

    // Constructor without ID
    public OrderItem(int orderId, int quantity,
                     double itemTotal, int menuId) {

        this.orderId = orderId;
        this.quantity = quantity;
        this.itemTotal = itemTotal;
        this.menuId = menuId;
    }

    // Constructor with ID
    public OrderItem(int orderItemId, int orderId,
                     int quantity, double itemTotal,
                     int menuId) {

        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.quantity = quantity;
        this.itemTotal = itemTotal;
        this.menuId = menuId;
    }

    // GETTERS AND SETTERS

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getItemTotal() {
        return itemTotal;
    }

    public void setItemTotal(double itemTotal) {
        this.itemTotal = itemTotal;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    @Override
    public String toString() {

        return orderItemId + " "
                + orderId + " "
                + quantity + " "
                + itemTotal + " "
                + menuId;
    }
}
