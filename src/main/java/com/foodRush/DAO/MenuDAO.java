package com.foodRush.DAO;

import java.util.List;

import com.foodRush.model.Menu;

public interface MenuDAO {

	void addMenu(Menu menu);

	Menu getMenu(int menuID);

	void updateMenu(Menu menu);

	void deleteMenu(int menuID);

	List<Menu> getAllMenus();

	List<Menu> getAllMenusByRestaurantID(int restaurantID);

}
