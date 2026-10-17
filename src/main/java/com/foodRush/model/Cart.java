package com.foodRush.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart implements Serializable {
	private static final long serialVersionUID = 1L;

	private Map<Integer, CartItem> items;
	private int restaurantID;
	private String restaurantName;
	private String couponCode;
	private double discountAmount;

	public Cart() {
		this.items = new LinkedHashMap<>();
		this.restaurantID = 0;
		this.restaurantName = "";
		this.couponCode = "";
		this.discountAmount = 0.0;
	}

	public boolean hasRestaurantConflict(int incomingRestaurantID) {
		return !items.isEmpty() && this.restaurantID > 0 && incomingRestaurantID > 0 && this.restaurantID != incomingRestaurantID;
	}

	public void addItem(CartItem item) {
		addItem(item, false);
	}

	public void addItem(CartItem item, boolean forceReset) {
		if (item == null) return;

		int incomingResId = item.getRestaurantID();

		if (forceReset) {
			// Unconditionally wipe all old items and previous discounts
			this.items.clear();
			this.couponCode = "";
			this.discountAmount = 0.0;
			if (incomingResId > 0) {
				this.restaurantID = incomingResId;
			}
		} else if (hasRestaurantConflict(incomingResId)) {
			// Conflict exists and not forceReset -> do not add
			return;
		} else if (items.isEmpty() || this.restaurantID == 0) {
			if (incomingResId > 0) {
				this.restaurantID = incomingResId;
			}
		}

		if (items.containsKey(item.getMenuID())) {
			CartItem existing = items.get(item.getMenuID());
			existing.setQuantity(existing.getQuantity() + item.getQuantity());
		} else {
			items.put(item.getMenuID(), item);
		}
	}

	public void updateQuantity(int menuID, int quantity) {
		if (items.containsKey(menuID)) {
			if (quantity <= 0) {
				removeItem(menuID);
			} else {
				items.get(menuID).setQuantity(quantity);
			}
		}
	}

	public void removeItem(int menuID) {
		items.remove(menuID);
		if (items.isEmpty()) {
			this.restaurantID = 0;
			this.restaurantName = "";
			this.couponCode = "";
			this.discountAmount = 0.0;
		}
	}

	public void clear() {
		items.clear();
		this.restaurantID = 0;
		this.restaurantName = "";
		this.couponCode = "";
		this.discountAmount = 0.0;
	}

	public Map<Integer, CartItem> getItems() {
		return items;
	}

	public Collection<CartItem> getCartItems() {
		return items.values();
	}

	public boolean isEmpty() {
		return items.isEmpty();
	}

	public int getTotalCount() {
		int count = 0;
		for (CartItem item : items.values()) {
			count += item.getQuantity();
		}
		return count;
	}

	public int getTotalQuantity() {
		return getTotalCount();
	}

	public double getItemTotal() {
		double total = 0;
		for (CartItem item : items.values()) {
			total += item.getItemTotal();
		}
		return total;
	}

	public double getDeliveryFee() {
		if (isEmpty()) return 0;
		return getItemTotal() >= 400 ? 0.0 : 40.0;
	}

	public double getPlatformFee() {
		if (isEmpty()) return 0;
		return 5.0;
	}

	public double getGstTax() {
		if (isEmpty()) return 0;
		return Math.round(getItemTotal() * 0.05);
	}

	public double getGrandTotal() {
		if (isEmpty()) return 0;
		double grand = getItemTotal() + getDeliveryFee() + getPlatformFee() + getGstTax() - discountAmount;
		return Math.max(0, grand);
	}

	public int getRestaurantID() {
		return restaurantID;
	}

	public void setRestaurantID(int restaurantID) {
		this.restaurantID = restaurantID;
	}

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public double getDiscountAmount() {
		return discountAmount;
	}

	public void setDiscountAmount(double discountAmount) {
		this.discountAmount = discountAmount;
	}
}
