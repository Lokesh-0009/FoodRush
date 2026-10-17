package com.foodRush.model;

import java.io.Serializable;

public class OrderItem implements Serializable {
	private static final long serialVersionUID = 1L;

	private int orderItemID;
	private int orderID;
	private int menuID;
	private int quantity;
	private double itemTotal;

	public OrderItem() {

	}

	public OrderItem(int orderID, int menuID, int quantity, double itemTotal) {

		this.orderID = orderID;
		this.menuID = menuID;
		this.quantity = quantity;
		this.itemTotal = itemTotal;
	}

	public OrderItem(int orderItemID, int orderID, int menuID,
			int quantity, double itemTotal) {

		this.orderItemID = orderItemID;
		this.orderID = orderID;
		this.menuID = menuID;
		this.quantity = quantity;
		this.itemTotal = itemTotal;
	}

	public int getOrderItemID() {
		return orderItemID;
	}

	public void setOrderItemID(int orderItemID) {
		this.orderItemID = orderItemID;
	}

	public int getOrderID() {
		return orderID;
	}

	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}

	public int getMenuID() {
		return menuID;
	}

	public void setMenuID(int menuID) {
		this.menuID = menuID;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getItemTotal() {
		return itemTotal;
	}

	public void setItemTotal(double itemTotal) {
		this.itemTotal = itemTotal;
	}

	@Override
	public String toString() {

		return "OrderItem [orderItemID=" + orderItemID
				+ ", orderID=" + orderID
				+ ", menuID=" + menuID
				+ ", quantity=" + quantity
				+ ", itemTotal=" + itemTotal + "]";
	}
}