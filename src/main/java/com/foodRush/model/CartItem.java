package com.foodRush.model;

import java.io.Serializable;

public class CartItem implements Serializable {
	private static final long serialVersionUID = 1L;

	private int menuID;
	private int restaurantID;
	private String itemName;
	private double unitPrice;
	private int quantity;
	private String imagePath;
	private String category;
	private boolean veg;

	public CartItem() {
	}

	public CartItem(int menuID, int restaurantID, String itemName, double unitPrice, int quantity, String imagePath, String category, boolean veg) {
		this.menuID = menuID;
		this.restaurantID = restaurantID;
		this.itemName = itemName;
		this.unitPrice = unitPrice;
		this.quantity = quantity;
		this.imagePath = imagePath;
		this.category = category;
		this.veg = veg;
	}

	public int getMenuID() {
		return menuID;
	}

	public void setMenuID(int menuID) {
		this.menuID = menuID;
	}

	public int getRestaurantID() {
		return restaurantID;
	}

	public void setRestaurantID(int restaurantID) {
		this.restaurantID = restaurantID;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public double getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public boolean isVeg() {
		return veg;
	}

	public void setVeg(boolean veg) {
		this.veg = veg;
	}

	public double getItemTotal() {
		return this.unitPrice * this.quantity;
	}

	@Override
	public String toString() {
		return "CartItem [menuID=" + menuID + ", restaurantID=" + restaurantID + ", itemName=" + itemName
				+ ", unitPrice=" + unitPrice + ", quantity=" + quantity + ", itemTotal=" + getItemTotal() + "]";
	}
}
