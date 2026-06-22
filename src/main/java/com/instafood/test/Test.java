package com.instafood.test;
import java.sql.Timestamp;

import java.util.List;

import com.instafood.dao.UserDAO;
import com.instafood.dao.RestaurantDAO;
import com.instafood.dao.MenuDAO;
import com.instafood.dao.OrderTableDAO;
import com.instafood.dao.OrderItemDAO;

import com.instafood.daoimpl.UserDAOImpl;
import com.instafood.daoimpl.RestaurantDAOImpl;
import com.instafood.daoimpl.MenuDAOImpl;
import com.instafood.daoimpl.OrderTableDAOImpl;
import com.instafood.daoimpl.OrderItemDAOImpl;

import com.instafood.model.User;
import com.instafood.model.Restaurant;
import com.instafood.model.Menu;
import com.instafood.model.OrderTable;
import com.instafood.model.OrderItem;

public class Test{

    public static void main(String[] args) {
    	Timestamp createDate =
    	        new Timestamp(System.currentTimeMillis());

    	Timestamp lastLoginDate =
    	        new Timestamp(System.currentTimeMillis());

        // =============================================
        // USER CRUD OPERATIONS
        // =============================================

        UserDAO userDAO = new UserDAOImpl();

        // INSERT USER
        User user = new User(
                "Gaja",
                "1234",
                "gaja@gmail.com",
                "Bangalore",
                "admin",
                createDate,
                lastLoginDate
        );

        int result = userDAO.addUser(user);

        if(result > 0) {
            System.out.println("User Added Successfully");
        }

        // FETCH SINGLE USER
        System.out.println("Display of the user");
        User singleUser = userDAO.getUserById(1);

        System.out.println(singleUser);

        // FETCH ALL USERS
        List<User> users = userDAO.getAllUsers();

        for(User u : users) {

            System.out.println(u);
        }

        // UPDATE USER
        User updateUser = new User(

                1,
                "UpdatedName",
                "9999",
                "updated@gmail.com",
                "Mysore",
                "customer",
                createDate,
                lastLoginDate
        );

        userDAO.updateUser(updateUser);

        System.out.println("User Updated");

        // DELETE USER
        userDAO.deleteUser(2);

        System.out.println("User Deleted");

        // =============================================
        // RESTAURANT CRUD OPERATIONS
        // =============================================

        System.out.println("\n========== RESTAURANT ==========");

        RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

        // INSERT RESTAURANT
        Restaurant restaurant = new Restaurant(
                "Andhra Spice",
                "Biryani, Andhra",
                30,
                "Koramangala, Bangalore",
                4.5,
                true,
                "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80"
        );

        result = restaurantDAO.addRestaurant(restaurant);

        if(result > 0) {
            System.out.println("Restaurant Added Successfully");
        }

        // FETCH SINGLE RESTAURANT
        System.out.println("Display of the restaurant");
        Restaurant singleRestaurant = restaurantDAO.getRestaurantById(1);

        System.out.println(singleRestaurant);

        // FETCH ALL RESTAURANTS
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();

        for(Restaurant r : restaurants) {

            System.out.println(r);
        }

        // UPDATE RESTAURANT
        Restaurant updateRestaurant = new Restaurant(

                1,
                "Meghana Foods Updated",
                "Andhra Biryani",
                25,
                "Koramangala, Bangalore",
                4.8,
                true,
                "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80"
        );

        restaurantDAO.updateRestaurant(updateRestaurant);

        System.out.println("Restaurant Updated");

        // DELETE RESTAURANT
        // restaurantDAO.deleteRestaurant(2);
        // System.out.println("Restaurant Deleted");

        // =============================================
        // MENU CRUD OPERATIONS
        // =============================================

        System.out.println("\n========== MENU ==========");

        MenuDAO menuDAO = new MenuDAOImpl();

        // INSERT MENU
        Menu menu = new Menu(
                1,
                "Chicken Biryani",
                "Hyderabadi style chicken biryani with raita",
                299.00,
                true,
                "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=80"
        );

        result = menuDAO.addMenu(menu);

        if(result > 0) {
            System.out.println("Menu Added Successfully");
        }

        // FETCH SINGLE MENU
        System.out.println("Display of the menu");
        Menu singleMenu = menuDAO.getMenuById(1);

        System.out.println(singleMenu);

        // FETCH ALL MENUS
        List<Menu> menus = menuDAO.getAllMenus();

        for(Menu m : menus) {

            System.out.println(m);
        }

        // UPDATE MENU
        Menu updateMenu = new Menu(

                1,
                1,
                "Mutton Biryani",
                "Hyderabadi style mutton biryani with raita",
                399.00,
                true,
                "https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=400&q=80"
        );

        menuDAO.updateMenu(updateMenu);

        System.out.println("Menu Updated");

        // DELETE MENU
        // menuDAO.deleteMenu(2);
        // System.out.println("Menu Deleted");

        // =============================================
        // ORDER TABLE CRUD OPERATIONS
        // =============================================

        System.out.println("\n========== ORDER TABLE ==========");

        Timestamp orderDate =
                new Timestamp(System.currentTimeMillis());

        OrderTableDAO orderDAO = new OrderTableDAOImpl();

        // INSERT ORDER
        OrderTable order = new OrderTable(
                1,
                orderDate,
                599.00,
                "Pending",
                "UPI",
                1
        );

        result = orderDAO.addOrder(order);

        if(result > 0) {
            System.out.println("Order Added Successfully");
        }

        // FETCH SINGLE ORDER
        System.out.println("Display of the order");
        OrderTable singleOrder = orderDAO.getOrderById(1);

        System.out.println(singleOrder);

        // FETCH ALL ORDERS
        List<OrderTable> orders = orderDAO.getAllOrders();

        for(OrderTable o : orders) {

            System.out.println(o);
        }

        // UPDATE ORDER
        OrderTable updateOrder = new OrderTable(

                1,
                1,
                orderDate,
                799.00,
                "Confirmed",
                "Credit_Card",
                1
        );

        orderDAO.updateOrder(updateOrder);

        System.out.println("Order Updated");

        // DELETE ORDER
        // orderDAO.deleteOrder(2);
        // System.out.println("Order Deleted");

        // =============================================
        // ORDER ITEM CRUD OPERATIONS
        // =============================================

        System.out.println("\n========== ORDER ITEM ==========");

        OrderItemDAO orderItemDAO = new OrderItemDAOImpl();

        // INSERT ORDER ITEM
        OrderItem orderItem = new OrderItem(
                1,
                2,
                598.00,
                1
        );

        result = orderItemDAO.addOrderItem(orderItem);

        if(result > 0) {
            System.out.println("Order Item Added Successfully");
        }

        // FETCH SINGLE ORDER ITEM
        System.out.println("Display of the order item");
        OrderItem singleOrderItem = orderItemDAO.getOrderItemById(1);

        System.out.println(singleOrderItem);

        // FETCH ALL ORDER ITEMS
        List<OrderItem> orderItems = orderItemDAO.getAllOrderItems();

        for(OrderItem oi : orderItems) {

            System.out.println(oi);
        }

        // UPDATE ORDER ITEM
        OrderItem updateOrderItem = new OrderItem(

                1,
                1,
                3,
                897.00,
                1
        );

        orderItemDAO.updateOrderItem(updateOrderItem);

        System.out.println("Order Item Updated");

        // DELETE ORDER ITEM
        // orderItemDAO.deleteOrderItem(2);
        // System.out.println("Order Item Deleted");
    }
}