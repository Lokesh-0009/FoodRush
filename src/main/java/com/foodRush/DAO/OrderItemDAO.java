package com.foodRush.DAO;

import java.util.List;

import com.foodRush.model.OrderItem;

public interface OrderItemDAO {

	void addOrderItem(OrderItem orderItem);

	OrderItem getOrderItem(int orderItemID);

	void updateOrderItem(OrderItem orderItem);

	void deleteOrderItem(int orderItemID);

	List<OrderItem> getAllOrderItems();

	List<OrderItem> getOrderItemsByOrderId(int orderID);
}
