package com.foodRush.model;

import java.io.Serializable;

public class Restaurant implements Serializable {
	private static final long serialVersionUID = 1L;

	private int restaurantID;
	private String name;
	private String cuisineType;
	private int deliveryTime;
	private String address;
	private int adminUserID;
	private double rating;
	private int isActive;
	private String imagePath;

	public Restaurant() {
		
	}

	public Restaurant(String name, String cuisineType, int deliveryTime, String address, double rating,
			int isActive) {
		super();
		this.name = name;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.rating = rating;
		this.isActive = isActive;
	}

	public Restaurant(String name, String cuisineType, int deliveryTime, String address, int adminUserID,
			double rating, int isActive, String imagePath) {
		super();
		this.name = name;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.adminUserID = adminUserID;
		this.rating = rating;
		this.isActive = isActive;
		this.imagePath = imagePath;
	}

	public Restaurant(int restaurantID, String name, String cuisineType, int deliveryTime, String address,
			int adminUserID, double rating, int isActive) {
		super();
		this.restaurantID = restaurantID;
		this.name = name;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.adminUserID = adminUserID;
		this.rating = rating;
		this.isActive = isActive;
	}

	public Restaurant(int restaurantID, String name, String cuisineType, int deliveryTime, String address,
			int adminUserID, double rating, int isActive, String imagePath) {
		super();
		this.restaurantID = restaurantID;
		this.name = name;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.adminUserID = adminUserID;
		this.rating = rating;
		this.isActive = isActive;
		this.imagePath = imagePath;
	}

	public int getRestaurantID() {
		return restaurantID;
	}

	public void setRestaurantID(int restaurantID) {
		this.restaurantID = restaurantID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCuisineType() {
		return cuisineType;
	}

	public void setCuisineType(String cuisineType) {
		this.cuisineType = cuisineType;
	}

	public int getDeliveryTime() {
		return deliveryTime;
	}

	public void setDeliveryTime(int deliveryTime) {
		this.deliveryTime = deliveryTime;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getAdminUserID() {
		return adminUserID;
	}

	public void setAdminUserID(int adminUserID) {
		this.adminUserID = adminUserID;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public int isActive() {
		return isActive;
	}

	public int getIsActive() {
		return isActive;
	}

	public void setActive(int isActive) {
		this.isActive = isActive;
	}

	public void setIsActive(int isActive) {
		this.isActive = isActive;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	@Override
	public String toString() {
		return "Restaurant [restaurantID=" + restaurantID + ", name=" + name + ", cuisineType=" + cuisineType
				+ ", deliveryTime=" + deliveryTime + ", address=" + address + ", adminUserID=" + adminUserID
				+ ", rating=" + rating + ", isActive=" + isActive + ", imagePath=" + imagePath + "]";
	}
	
}
