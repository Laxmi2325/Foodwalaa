package com.tap.DAOimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDao;
import com.tap.modell.Menu;
import com.tap.utility.dbconnection.DBConnection;

public class MenuDaoImpl implements MenuDao {

    // Add Menu
    @Override
    public void addMenu(Menu menu) {

        String query = "INSERT INTO menu "
                + "(restaurantId, itemName, description, price, isAvailable, imagePath) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());

            pstmt.executeUpdate();

            System.out.println("Menu added successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get Menu by ID
    @Override
    public Menu getMenu(int menuId) {

        String query = "SELECT * FROM menu WHERE menuId = ?";

        Menu menu = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, menuId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                    menu.setImagePath(rs.getString("imagePath"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    // Update Menu
    @Override
    public void updateMenu(Menu menu) {

        String query = "UPDATE menu SET "
                + "restaurantId = ?, itemName = ?, description = ?, "
                + "price = ?, isAvailable = ?, imagePath = ? "
                + "WHERE menuId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());
            pstmt.setInt(7, menu.getMenuId());

            pstmt.executeUpdate();

            System.out.println("Menu updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete Menu
    @Override
    public void deleteMenu(int menuId) {

        String query = "DELETE FROM menu WHERE menuId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, menuId);

            pstmt.executeUpdate();

            System.out.println("Menu deleted successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get All Menus
    @Override
    public List<Menu> getAllMenus() {

        String query = "SELECT * FROM menu";

        List<Menu> menuList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menuId"));
                menu.setRestaurantId(rs.getInt("restaurantId"));
                menu.setItemName(rs.getString("itemName"));
                menu.setDescription(rs.getString("description"));
                menu.setPrice(rs.getDouble("price"));
                menu.setAvailable(rs.getBoolean("isAvailable"));
                menu.setImagePath(rs.getString("imagePath"));

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }

    // Get Menus by Restaurant ID
    @Override
    public List<Menu> getMenusByRestaurantId(int restaurantId) {

        List<Menu> menuList = new ArrayList<>();

        String query = "SELECT * FROM menu WHERE restaurantId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                    menu.setImagePath(rs.getString("imagePath"));

                    menuList.add(menu);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }
}