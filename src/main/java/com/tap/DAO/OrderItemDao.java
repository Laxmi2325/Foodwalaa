package com.tap.DAO;

import java.util.List;

import com.tap.modell.OrderItem;

public interface OrderItemDao {

    // Add Order Item
    void addOrderItem(OrderItem orderItem);

    // Get Order Item by ID
    OrderItem getOrderItem(int orderItemId);

    // Update Order Item
    void updateOrderItem(OrderItem orderItem);

    // Delete Order Item
    void deleteOrderItem(int orderItemId);

    // Get All Order Items
    List<OrderItem> getAllOrderItems();

    // Get Order Items by Order ID
    List<OrderItem> getOrderItemsByOrderId(int orderId);
}