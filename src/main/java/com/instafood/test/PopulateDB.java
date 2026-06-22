package com.instafood.test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import com.instafood.util.DBConnection;

public class PopulateDB {
    public static void main(String[] args) {
        Connection con = DBConnection.getConnection();
        if (con == null) {
            System.err.println("Could not connect to database!");
            System.exit(1);
        }

        try {
            Statement st = con.createStatement();
            
            // Disable foreign key checks to truncate/drop tables safely
            System.out.println("Disabling foreign key checks...");
            st.execute("SET FOREIGN_KEY_CHECKS = 0");
            
            System.out.println("Truncating restaurant table...");
            st.execute("TRUNCATE TABLE restaurant");

            System.out.println("Truncating orderitem table...");
            st.execute("TRUNCATE TABLE orderitem");

            System.out.println("Truncating ordertable table...");
            st.execute("TRUNCATE TABLE ordertable");
            
            System.out.println("Recreating menu table...");
            st.execute("DROP TABLE IF EXISTS menu");
            st.execute(
                "CREATE TABLE `menu` (" +
                "  `menuId` int NOT NULL AUTO_INCREMENT," +
                "  `restaurantId` int NOT NULL," +
                "  `itemName` varchar(150) NOT NULL," +
                "  `description` text," +
                "  `price` decimal(10,2) NOT NULL," +
                "  `isAvailable` tinyint(1) DEFAULT '1'," +
                "  `image` varchar(255) DEFAULT NULL," +
                "  PRIMARY KEY (`menuId`)," +
                "  KEY `restaurantId` (`restaurantId`)," +
                "  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`restaurantId`) REFERENCES `restaurant` (`restaurantId`) ON DELETE CASCADE ON UPDATE CASCADE" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci"
            );
            
            st.execute("SET FOREIGN_KEY_CHECKS = 1");
            System.out.println("Foreign key checks re-enabled.");

            // Insert 8 premium restaurants with explicit IDs
            String insertRestQuery = "INSERT INTO restaurant (restaurantId, name, cuisineType, deliveryTime, address, rating, isActive, imagePath) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psRest = con.prepareStatement(insertRestQuery);

            Object[][] restaurants = {
                {1, "Meghana Foods", "Biryani, Andhra, North Indian", 30, "Koramangala, Bangalore", 4.5, true, "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80"},
                {2, "Burger Lounge", "Fast Food, Burgers, American", 20, "4, 100 Feet Road, Indiranagar, Bangalore", 4.2, true, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80"},
                {3, "Pizza Palazzo", "Italian, Pizza, Beverages", 30, "Commercial Street, Shivaji Nagar, Bangalore", 4.5, true, "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80"},
                {4, "The Wok House", "Chinese, Asian, Noodles", 22, "Inner Ring Road, Domlur, Bangalore", 4.0, true, "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=600&q=80"},
                {5, "Sweet Corner", "Desserts, Bakery, Ice Creams", 12, "Avenue Road, Majestic, Bangalore", 4.6, true, "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=600&q=80"},
                {6, "Spicy Tandoor", "North Indian, Tandoori Specialties", 35, "Hosur Road, Madiwala, Bangalore", 3.9, false, "https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80"},
                {7, "Healthy Greens", "Salads, Healthy Food, Fresh Juices", 18, "HAL 2nd Stage, Indiranagar, Bangalore", 4.3, true, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80"},
                {8, "Tapify Street Bites", "Street Food, Chaat, North Indian", 15, "12, MG Road, Indiranagar, Bangalore", 4.7, true, "https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=600&q=80"}
            };

            for (Object[] r : restaurants) {
                psRest.setInt(1, (Integer) r[0]);
                psRest.setString(2, (String) r[1]);
                psRest.setString(3, (String) r[2]);
                psRest.setInt(4, (Integer) r[3]);
                psRest.setString(5, (String) r[4]);
                psRest.setDouble(6, (Double) r[5]);
                psRest.setBoolean(7, (Boolean) r[6]);
                psRest.setString(8, (String) r[7]);
                
                psRest.executeUpdate();
                System.out.println("Inserted Restaurant: " + r[1]);
            }

            // Insert premium menu items for the restaurants
            String insertMenuQuery = "INSERT INTO menu (restaurantId, itemName, description, price, isAvailable, image) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psMenu = con.prepareStatement(insertMenuQuery);

            Object[][] menuItems = {
                // Restaurant 1 (Meghana Foods - Biryani)
                {1, "Meghana Special Chicken Biryani", "Famous spicy Andhra style chicken biryani served with salan and raita.", 320.00, true, "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=80"},
                {1, "Andhra Paneer Biryani", "Spiced paneer cubes slow cooked with fragrant basmati rice and signature spices.", 250.00, true, "https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=400&q=80"},
                {1, "Chicken 65", "Crispy, deep-fried spicy chicken chunks marinated with ginger, garlic, and red chillies.", 220.00, true, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?auto=format&fit=crop&w=400&q=80"},
                {1, "Andhra Chilli Chicken", "A classic spicy Andhra starter made by stir-frying chicken pieces with hot green chillies.", 240.00, true, "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 2 (Burger Lounge - Burgers)
                {2, "Classic Veg Burger", "Crispy vegetable patty with fresh lettuce, tomatoes, and house dressing.", 120.00, true, "https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80"},
                {2, "Double Cheese Crunch", "Thick vegetable patty stacked with double cheddar slices, butter pickles, and dressing.", 180.00, true, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80"},
                {2, "Spicy Grilled Chicken Burger", "Flame-seared chicken breast coated in hot peri peri spices, loaded with house cheese sauce.", 220.00, true, "https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=400&q=80"},
                {2, "Crispy French Fries", "Golden cut potatoes fried crunchy, salted and served with tomato ketchup packs.", 90.00, true, "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 3 (Pizza Palazzo - Italian/Pizza)
                {3, "Margherita Pizza", "Classic cheese pizza topped with fresh basil leaves, rich marinara sauce, and extra mozzarella.", 299.00, true, "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?auto=format&fit=crop&w=400&q=80"},
                {3, "Garden Delight Pizza", "Loaded pizza topped with crisp bell peppers, red onions, mushrooms, juicy tomatoes, and golden corn.", 379.00, true, "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=400&q=80"},
                {3, "Pepperoni Pizza", "Classic Italian pizza loaded with spicy pork pepperoni slices and mozzarella cheese.", 449.00, true, "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=400&q=80"},
                {3, "Garlic Bread Sticks", "Toasted bread sticks brushed with garlic butter and fresh herbs, served with dip.", 120.00, true, "https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 4 (The Wok House - Chinese)
                {4, "Veg Schezwan Noodles", "Spicy stir-fried Hakka noodles cooked with mixed veggies in a hot and spicy Schezwan sauce.", 160.00, true, "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=80"},
                {4, "Chicken Fried Rice", "Aromatic rice stir-fried in a wok with scrambled eggs, chicken chunks, spring onions, and soy sauce.", 190.00, true, "https://images.unsplash.com/photo-1603133872878-68550a5e7021?auto=format&fit=crop&w=400&q=80"},
                {4, "Gobi Manchurian", "Deep-fried cauliflower florets tossed in a sweet, spicy, and tangy Manchurian sauce.", 150.00, true, "https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=400&q=80"},
                {4, "Veg Hakka Noodles", "Classic stir-fried noodles tossed with cabbage, carrots, capsicum, and light soy sauce.", 140.00, true, "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 5 (Sweet Corner - Sweets/Desserts)
                {5, "Death by Chocolate", "A rich combination of chocolate cake, scoops of vanilla ice cream, hot chocolate fudge, and nuts.", 150.00, true, "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?auto=format&fit=crop&w=400&q=80"},
                {5, "Gulab Jamun (2 Pcs)", "Traditional soft milk-solid balls soaked in hot rose water flavored sugar syrup.", 60.00, true, "https://images.unsplash.com/photo-1605698339973-09351581143c?auto=format&fit=crop&w=400&q=80"},
                {5, "Chocolate Lava Cake", "Warm chocolate cake with a rich liquid chocolate center, served fresh.", 90.00, true, "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=400&q=80"},
                {5, "Rasgulla (2 Pcs)", "Spongy and sweet cottage cheese dumplings soaked in sugar syrup.", 50.00, true, "https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 6 (Spicy Tandoor - Tandoori/North Indian)
                {6, "Chicken Tandoori (Half)", "Chicken marinated in yogurt and spices, roasted to perfection in a tandoor clay oven.", 240.00, true, "https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=400&q=80"},
                {6, "Butter Naan", "Soft and pillowy flatbread baked in tandoor, brushed with warm melted butter.", 40.00, true, "https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&w=400&q=80"},
                {6, "Paneer Butter Masala", "Cottage cheese cubes cooked in a rich, creamy, tomato-based gravy with butter.", 180.00, true, "https://images.unsplash.com/photo-1625944230945-1b7dd3b949ab?auto=format&fit=crop&w=400&q=80"},
                {6, "Dal Makhani", "Black lentils and kidney beans slow cooked overnight, finished with butter and cream.", 160.00, true, "https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 7 (Healthy Greens - Salads/Juices)
                {7, "Caesar Salad", "Fresh iceberg lettuce, garlic croutons, and grated parmesan cheese tossed in classical Caesar dressing.", 170.00, true, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&q=80"},
                {7, "Greek Salad", "Cucumber, tomatoes, onions, olives, and feta cheese dressed with olive oil and oregano.", 160.00, true, "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80"},
                {7, "Fruit Salad", "A fresh selection of seasonal fresh fruits served chilled.", 120.00, true, "https://images.unsplash.com/photo-1519996521430-02b798c1d881?auto=format&fit=crop&w=400&q=80"},
                {7, "Detox Green Juice", "Cold pressed juice made from fresh cucumbers, spinach, celery, green apples, and mint leaves.", 110.00, true, "https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=400&q=80"},

                // Restaurant 8 (Tapify Street Bites - Street Food)
                {8, "Pani Puri (6 Pcs)", "Crispy hollow semolina puris filled with spicy mint water, sweet tamarind, and potato-chickpea mash.", 60.00, true, "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=400&q=80"},
                {8, "Samosa Pav", "Golden fried potato samosa served hot inside a soft bread bun with green and sweet chutneys.", 45.00, true, "https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?auto=format&fit=crop&w=400&q=80"},
                {8, "Special Pav Bhaji", "Mashed seasonal vegetables cooked in butter with local spices, served with two soft butter buns.", 120.00, true, "https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&w=400&q=80"},
                {8, "Dahi Vada", "Soft lentil dumplings soaked in cold sweetened yogurt, topped with chili powder and mint chutney.", 80.00, false, "https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=400&q=80"},
                {8, "Vada Pav (2 Pcs)", "Classic spicy potato dumpling inside toasted buns, laced with red garlic dry chutney.", 50.00, true, "https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&w=400&q=80"}
            };

            for (Object[] m : menuItems) {
                psMenu.setInt(1, (Integer) m[0]);
                psMenu.setString(2, (String) m[1]);
                psMenu.setString(3, (String) m[2]);
                psMenu.setDouble(4, (Double) m[3]);
                psMenu.setBoolean(5, (Boolean) m[4]);
                psMenu.setString(6, (String) m[5]);
                
                psMenu.executeUpdate();
                System.out.println("Inserted Menu Item: " + m[1] + " for Restaurant ID: " + m[0]);
            }

            System.out.println("Database successfully populated with premium restaurants and menu items!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
