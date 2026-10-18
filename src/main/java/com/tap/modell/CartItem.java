package com.tap.modell;

public class CartItem {

    private Menu menu;
    private int quantity;


    // =========================
    // DEFAULT CONSTRUCTOR
    // =========================

    public CartItem() {
    }


    // =========================
    // PARAMETERIZED CONSTRUCTOR
    // =========================

    public CartItem(Menu menu, int quantity) {
        this.menu = menu;
        this.quantity = quantity;
    }


    // =========================
    // GET MENU
    // =========================

    public Menu getMenu() {
        return menu;
    }


    // =========================
    // SET MENU
    // =========================

    public void setMenu(Menu menu) {
        this.menu = menu;
    }


    // =========================
    // GET QUANTITY
    // =========================

    public int getQuantity() {
        return quantity;
    }


    // =========================
    // SET QUANTITY
    // =========================

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    // =========================
    // GET TOTAL PRICE
    // =========================

    public double getTotalPrice() {

        return menu.getPrice() * quantity;
    }
}