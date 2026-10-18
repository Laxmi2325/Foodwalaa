package com.tap.DAOimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderDao;
import com.tap.modell.Order;
import com.tap.utility.dbconnection.DBConnection;

public class OrderDaoImpl implements OrderDao {

    // Add Order
    @Override
    public int addOrder(Order order) {

        String query = "INSERT INTO orders "
                + "(userId, restaurantId, orderDate, totalAmount, status, paymentMode) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        int generatedOrderId = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(
                     query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setString(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMode());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {

                if (rs.next()) {
                    generatedOrderId = rs.getInt(1);
                }
            }

            System.out.println("Order added successfully. Order ID: " + generatedOrderId);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }

    // Get Order by ID
    @Override
    public Order getOrder(int orderId) {

        String query = "SELECT * FROM orders WHERE orderId = ?";

        Order order = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setOrderDate(rs.getString("orderDate"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    // Update Order
    @Override
    public void updateOrder(Order order) {

        String query = "UPDATE orders SET "
                + "userId = ?, restaurantId = ?, orderDate = ?, "
                + "totalAmount = ?, status = ?, paymentMode = ? "
                + "WHERE orderId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setString(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMode());
            pstmt.setInt(7, order.getOrderId());

            pstmt.executeUpdate();

            System.out.println("Order updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete Order
    @Override
    public void deleteOrder(int orderId) {

        String query = "DELETE FROM orders WHERE orderId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderId);

            pstmt.executeUpdate();

            System.out.println("Order deleted successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get All Orders
    @Override
    public List<Order> getAllOrders() {

        String query = "SELECT * FROM orders";

        List<Order> orderList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                Order order = new Order();

                order.setOrderId(rs.getInt("orderId"));
                order.setUserId(rs.getInt("userId"));
                order.setRestaurantId(rs.getInt("restaurantId"));
                order.setOrderDate(rs.getString("orderDate"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMode(rs.getString("paymentMode"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }

    // Get Orders by User ID
    @Override
    public List<Order> getOrdersByUserId(int userId) {

        String query = "SELECT * FROM orders WHERE userId = ?";

        List<Order> orderList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    Order order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setOrderDate(rs.getString("orderDate"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));

                    orderList.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }

    // Get Orders by Restaurant ID
    @Override
    public List<Order> getOrdersByRestaurantId(int restaurantId) {

        String query = "SELECT * FROM orders WHERE restaurantId = ?";

        List<Order> orderList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    Order order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setOrderDate(rs.getString("orderDate"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));

                    orderList.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }
}