package com.tap.DAO;

import java.util.List;
import com.tap.modell.Menu;

public interface MenuDao {

    void addMenu(Menu menu);

    Menu getMenu(int menuId);

    void updateMenu(Menu menu);

    void deleteMenu(int menuId);

    List<Menu> getAllMenus();

    List<Menu> getMenusByRestaurantId(int restaurantId);
}