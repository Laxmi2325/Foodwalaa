package com.tap.DAOimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDao;
import com.tap.modell.Restaurant;
import com.tap.utility.dbconnection.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private Connection con;

    // Add Restaurant
    @Override
    public void addRestaurant(Restaurant restaurant) {

        String query = "INSERT INTO restaurant "
                + "(name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imagePath) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            con = DBConnection.getConnection();

            PreparedStatement pstmt = con.prepareStatement(query);

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());

            pstmt.executeUpdate();

            System.out.println("Restaurant added successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get Restaurant by ID
    @Override
    public Restaurant getRestaurant(int restaurantId) {

        String query = "SELECT * FROM restaurant WHERE restaurantId = ?";

        Restaurant restaurant = null;

        try {
            con = DBConnection.getConnection();

            PreparedStatement pstmt = con.prepareStatement(query);

            pstmt.setInt(1, restaurantId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {

                restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setName(rs.getString("name"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setDeliveryTime(rs.getInt("deliveryTime"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setAdminUserId(rs.getInt("adminUserId"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setActive(rs.getBoolean("isActive"));
                restaurant.setImagePath(rs.getString("imagePath"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    // Update Restaurant
    @Override
    public void updateRestaurant(Restaurant restaurant) {

        String query = "UPDATE restaurant SET "
                + "name = ?, cuisineType = ?, deliveryTime = ?, "
                + "address = ?, adminUserId = ?, rating = ?, "
                + "isActive = ?, imagePath = ? "
                + "WHERE restaurantId = ?";

        try {
            con = DBConnection.getConnection();

            PreparedStatement pstmt = con.prepareStatement(query);

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());
            pstmt.setInt(9, restaurant.getRestaurantId());

            pstmt.executeUpdate();

            System.out.println("Restaurant updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete Restaurant
    @Override
    public void deleteRestaurant(int restaurantId) {

        String query = "DELETE FROM restaurant WHERE restaurantId = ?";

        try {
            con = DBConnection.getConnection();

            PreparedStatement pstmt = con.prepareStatement(query);

            pstmt.setInt(1, restaurantId);

            pstmt.executeUpdate();

            System.out.println("Restaurant deleted successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get All Restaurants
    @Override
    public List<Restaurant> getAllRestaurants() {

        String query = "SELECT * FROM restaurant";

        List<Restaurant> restaurantList = new ArrayList<>();

        try {
            con = DBConnection.getConnection();

            PreparedStatement pstmt = con.prepareStatement(query);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                Restaurant restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setName(rs.getString("name"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setDeliveryTime(rs.getInt("deliveryTime"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setAdminUserId(rs.getInt("adminUserId"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setActive(rs.getBoolean("isActive"));
                restaurant.setImagePath(rs.getString("imagePath"));

                restaurantList.add(restaurant);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurantList;
    }
}
