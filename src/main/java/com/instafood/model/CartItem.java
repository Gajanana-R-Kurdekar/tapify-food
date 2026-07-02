package com.instafood.model;

/**
 * Represents individual items stored within the shopping cart.
 * Contains only checkout-relevant details.
 */
public class CartItem {
    private int menuId;
    private int restaurantId;
    private String name;
    private double price;
    private int quantity;
    private String image; // Added for display support in the UI

    // Default Constructor
    public CartItem() {
    }

    // Constructor without image
    public CartItem(int menuId, int restaurantId, String name, double price, int quantity) {
        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    // Constructor with image
    public CartItem(int menuId, int restaurantId, String name, double price, int quantity, String image) {
        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    // Getters and Setters
    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    /**
     * Calculates the total price for this item based on quantity.
     * @return quantity * price
     */
    public double getTotalPrice() {
        return this.quantity * this.price;
    }

    @Override
    public String toString() {
        return "CartItem [menuId=" + menuId + ", restaurantId=" + restaurantId + ", name=" + name + ", price=" + price
                + ", quantity=" + quantity + ", image=" + image + "]";
    }
}
