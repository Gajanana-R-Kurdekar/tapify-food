package com.instafood.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Manages the collection of cart items using an in-memory HashMap data structure.
 */
public class Cart {
    private Map<Integer, CartItem> items;

    // Constructor
    public Cart() {
        this.items = new HashMap<>();
    }

    /**
     * Adds an item to the cart. If the item already exists, its quantity is incremented.
     * @param item the CartItem to add
     */
    public void addItem(CartItem item) {
        if (items.containsKey(item.getMenuId())) {
            CartItem existingItem = items.get(item.getMenuId());
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
        } else {
            items.put(item.getMenuId(), item);
        }
    }

    /**
     * Updates the quantity of a specific item in the cart.
     * @param menuId the ID of the menu item
     * @param quantity the new quantity
     */
    public void updateItem(int menuId, int quantity) {
        if (items.containsKey(menuId)) {
            items.get(menuId).setQuantity(quantity);
        }
    }

    /**
     * Removes an item from the cart.
     * @param menuId the ID of the menu item to remove
     */
    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    /**
     * Returns the underlying map of items in the cart.
     * @return the map of menuId to CartItem
     */
    public Map<Integer, CartItem> getItems() {
        return items;
    }

    /**
     * Clears all items from the cart.
     */
    public void clear() {
        items.clear();
    }
}
