package com.tap.DAO;

import java.util.List;
import com.tap.modell.Restaurant;

public interface RestaurantDao {

    void addRestaurant(Restaurant restaurant);

    Restaurant getRestaurant(int restaurantId);

    void updateRestaurant(Restaurant restaurant);

    void deleteRestaurant(int restaurantId);

    List<Restaurant> getAllRestaurants();
}
