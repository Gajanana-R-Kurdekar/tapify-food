package com.instafood.dao;

import java.util.List;

import com.instafood.model.Menu;

public interface MenuDAO {

    // INSERT
    int addMenu(Menu menu);

    // FETCH SINGLE MENU
    Menu getMenuById(int id);

    // FETCH SINGLE MENU (COMPATIBILITY)
    Menu getMenu(int menuId);

    // FETCH ALL MENUS
    List<Menu> getAllMenus();

    // UPDATE MENU
    int updateMenu(Menu menu);

    // DELETE MENU
    int deleteMenu(int id);

    // FETCH BY RESTAURANT
    List<Menu> getMenuByRestaurantId(int restaurantId);
}
