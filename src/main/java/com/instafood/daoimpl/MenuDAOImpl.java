package com.instafood.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.instafood.dao.MenuDAO;
import com.instafood.model.Menu;
import com.instafood.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    Connection con = DBConnection.getConnection();

    // INSERT
    @Override
    public int addMenu(Menu menu) {

        String query =
        "INSERT INTO menu(restaurantId,itemName,description,price,isAvailable,image) VALUES(?,?,?,?,?,?)";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImage());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // FETCH SINGLE MENU
    @Override
    public Menu getMenuById(int id) {

        String query =
                "SELECT * FROM menu WHERE menuId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                Menu menu = new Menu(

                        rs.getInt("menuId"),
                        rs.getInt("restaurantId"),
                        rs.getString("itemName"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getBoolean("isAvailable"),
                        rs.getString("image")
                );

                return menu;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // FETCH SINGLE MENU (COMPATIBILITY)
    @Override
    public Menu getMenu(int menuId) {
        return getMenuById(menuId);
    }

    // FETCH ALL MENUS
    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        String query = "SELECT * FROM menu";

        try {

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(query);

            while(rs.next()) {

                Menu menu = new Menu(

                        rs.getInt("menuId"),
                        rs.getInt("restaurantId"),
                        rs.getString("itemName"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getBoolean("isAvailable"),
                        rs.getString("image")
                );

                menus.add(menu);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menus;
    }

    // UPDATE MENU
    @Override
    public int updateMenu(Menu menu) {

        String query =
        "UPDATE menu SET restaurantId=?, itemName=?, description=?, price=?, isAvailable=?, image=? WHERE menuId=?";

        try {

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImage());

            ps.setInt(7, menu.getMenuId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // DELETE MENU
    @Override
    public int deleteMenu(int id) {

        String query =
                "DELETE FROM menu WHERE menuId=?";

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

    // FETCH BY RESTAURANT ID
    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {
        List<Menu> menus = new ArrayList<>();
        String query = "SELECT * FROM menu WHERE restaurantId=?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Menu menu = new Menu(
                        rs.getInt("menuId"),
                        rs.getInt("restaurantId"),
                        rs.getString("itemName"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getBoolean("isAvailable"),
                        rs.getString("image")
                );
                menus.add(menu);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return menus;
    }
}
