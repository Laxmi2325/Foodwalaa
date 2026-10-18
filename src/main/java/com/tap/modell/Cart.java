
package com.tap.modell;

import java.util.ArrayList;
import java.util.List;

public class Cart {

    private List<CartItem> items;

    // Default Constructor
    public Cart() {
        items = new ArrayList<>();
    }

    // =========================
    // ADD ITEM
    // =========================

    public void addItem(Menu menu) {

        for (CartItem item : items) {

            if (item.getMenu().getMenuId() == menu.getMenuId()) {

                item.setQuantity(item.getQuantity() + 1);

                return;
            }
        }

        CartItem cartItem = new CartItem(menu, 1);

        items.add(cartItem);
    }

    // =========================
    // UPDATE ITEM
    // =========================

    public void updateItem(int menuId, int quantity) {

        if (quantity <= 0) {
            removeItem(menuId);
            return;
        }

        for (CartItem item : items) {

            if (item.getMenu().getMenuId() == menuId) {

                item.setQuantity(quantity);

                return;
            }
        }
    }

    // =========================
    // REMOVE ITEM
    // =========================

    public void removeItem(int menuId) {

        items.removeIf(item ->
            item.getMenu().getMenuId() == menuId
        );
    }

    // =========================
    // CLEAR CART
    // =========================

    public void clearCart() {

        items.clear();
    }

    // =========================
    // GET ITEMS
    // =========================

    public List<CartItem> getItems() {

        return items;
    }

    // =========================
    // GET TOTAL PRICE
    // =========================

    public double getTotalPrice() {

        double total = 0;

        for (CartItem item : items) {

            total += item.getTotalPrice();
        }

        return total;
    }

    // =========================
    // GET TOTAL QUANTITY
    // =========================

    public int getTotalQuantity() {

        int totalQuantity = 0;

        for (CartItem item : items) {

            totalQuantity += item.getQuantity();
        }

        return totalQuantity;
    }

    // =========================
    // CHECK EMPTY
    // =========================

    public boolean isEmpty() {

        return items.isEmpty();
    }
}
