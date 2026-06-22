package com.instafood.dao;

import java.util.List;

import com.instafood.model.Restaurant;

public interface RestaurantDAO {

    // INSERT
    int addRestaurant(Restaurant restaurant);

    // FETCH SINGLE RESTAURANT
    Restaurant getRestaurantById(int id);

    // FETCH ALL RESTAURANTS
    List<Restaurant> getAllRestaurants();

    // UPDATE RESTAURANT
    int updateRestaurant(Restaurant restaurant);

    // DELETE RESTAURANT
    int deleteRestaurant(int id);
}
