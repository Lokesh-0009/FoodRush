package com.foodRush.DAO;

import java.util.List;

import com.foodRush.model.Orders;

public interface OrderDAO {
	
	int addOrder(Orders order);

	Orders getOrder(int orderID);

	void updateOrder(Orders order);

	void deleteOrder(int orderID);

	List<Orders> getAllOrders();

	List<Orders> getOrdersByUserId(int userID);

	List<Orders> getOrdersByRestaurantId(int restaurantID);

	int createOrderWithItems(Orders order, List<com.foodRush.model.OrderItem> items);

	void assignDriver(int orderID, int driverID);

	List<Orders> getOrdersByDriverId(int driverID);
}
