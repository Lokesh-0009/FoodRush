package com.foodRush.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Orders implements Serializable {
	private static final long serialVersionUID = 1L;

	private int orderID;
	private int userID;
	private int restaurantID;
	private Timestamp orderDate;
	private double totalAmount;
	private String status;
	private String paymentMethod;
	private String paymentStatus;

	private Integer driverID;


	public Orders() {

	}


	public Orders(int userID, int restaurantID, double totalAmount,
			String status, String paymentMethod, String paymentStatus) {

		this.userID = userID;
		this.restaurantID = restaurantID;
		this.totalAmount = totalAmount;
		this.status = status;
		this.paymentMethod = paymentMethod;
		this.paymentStatus = paymentStatus;
	}


	public Orders(int orderID, int userID, int restaurantID,
			Timestamp orderDate, double totalAmount,
			String status, String paymentMethod, String paymentStatus) {

		this.orderID = orderID;
		this.userID = userID;
		this.restaurantID = restaurantID;
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.status = status;
		this.paymentMethod = paymentMethod;
		this.paymentStatus = paymentStatus;
	}

	public Orders(int orderID, int userID, int restaurantID, Integer driverID,
			Timestamp orderDate, double totalAmount,
			String status, String paymentMethod, String paymentStatus) {

		this.orderID = orderID;
		this.userID = userID;
		this.restaurantID = restaurantID;
		this.driverID = driverID;
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.status = status;
		this.paymentMethod = paymentMethod;
		this.paymentStatus = paymentStatus;
	}


	public int getOrderID() {
		return orderID;
	}

	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}


	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}


	public int getRestaurantID() {
		return restaurantID;
	}

	public void setRestaurantID(int restaurantID) {
		this.restaurantID = restaurantID;
	}

	public Integer getDriverID() {
		return driverID;
	}

	public void setDriverID(Integer driverID) {
		this.driverID = driverID;
	}


	public Timestamp getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Timestamp orderDate) {
		this.orderDate = orderDate;
	}


	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}


	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}


	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}


	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}


	@Override
	public String toString() {

		return "Order [orderID=" + orderID
				+ ", userID=" + userID
				+ ", restaurantID=" + restaurantID
				+ ", driverID=" + driverID
				+ ", orderDate=" + orderDate
				+ ", totalAmount=" + totalAmount
				+ ", status=" + status
				+ ", paymentMethod=" + paymentMethod
				+ ", paymentStatus=" + paymentStatus + "]";
	}
}