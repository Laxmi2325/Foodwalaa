package com.tap.DAOimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderItemDao;
import com.tap.modell.OrderItem;
import com.tap.utility.dbconnection.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    // Add Order Item
    @Override
    public void addOrderItem(OrderItem orderItem) {

        String query = "INSERT INTO order_item "
                + "(orderId, menuId, totalAmount) "
                + "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setDouble(3, orderItem.getTotalAmount());

            pstmt.executeUpdate();

            System.out.println("Order item added successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get Order Item by ID
    @Override
    public OrderItem getOrderItem(int orderItemId) {

        String query = "SELECT * FROM order_item WHERE orderItemId = ?";

        OrderItem orderItem = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderItemId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    orderItem = new OrderItem();

                    orderItem.setOrderItemId(rs.getInt("orderItemId"));
                    orderItem.setOrderId(rs.getInt("orderId"));
                    orderItem.setMenuId(rs.getInt("menuId"));
                    orderItem.setTotalAmount(rs.getDouble("totalAmount"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    // Update Order Item
    @Override
    public void updateOrderItem(OrderItem orderItem) {

        String query = "UPDATE order_item SET "
                + "orderId = ?, menuId = ?, totalAmount = ? "
                + "WHERE orderItemId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setDouble(3, orderItem.getTotalAmount());
            pstmt.setInt(4, orderItem.getOrderItemId());

            pstmt.executeUpdate();

            System.out.println("Order item updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete Order Item
    @Override
    public void deleteOrderItem(int orderItemId) {

        String query = "DELETE FROM order_item WHERE orderItemId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderItemId);

            pstmt.executeUpdate();

            System.out.println("Order item deleted successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get All Order Items
    @Override
    public List<OrderItem> getAllOrderItems() {

        String query = "SELECT * FROM order_item";

        List<OrderItem> orderItemList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                OrderItem orderItem = new OrderItem();

                orderItem.setOrderItemId(rs.getInt("orderItemId"));
                orderItem.setOrderId(rs.getInt("orderId"));
                orderItem.setMenuId(rs.getInt("menuId"));
                orderItem.setTotalAmount(rs.getDouble("totalAmount"));

                orderItemList.add(orderItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItemList;
    }

    // Get Order Items by Order ID
    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        String query = "SELECT * FROM order_item WHERE orderId = ?";

        List<OrderItem> orderItemList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    OrderItem orderItem = new OrderItem();

                    orderItem.setOrderItemId(rs.getInt("orderItemId"));
                    orderItem.setOrderId(rs.getInt("orderId"));
                    orderItem.setMenuId(rs.getInt("menuId"));
                    orderItem.setTotalAmount(rs.getDouble("totalAmount"));

                    orderItemList.add(orderItem);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItemList;
    }
}