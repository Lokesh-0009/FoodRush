package com.foodRush.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Driver implements Serializable {
	private static final long serialVersionUID = 1L;

	private int driverID;
	private int userID;
	private String vehicleType;
	private String vehicleNumber;
	private String licenseNumber;
	private String status; // "AVAILABLE", "BUSY", "OFFLINE"
	private double rating;
	private Timestamp createdAt;
	private Timestamp updatedAt;

	// Joined user details for easy display without separate queries
	private String name;
	private String phone;
	private String email;

	public Driver() {
	}

	public Driver(int driverID, int userID, String vehicleType, String vehicleNumber,
			String licenseNumber, String status, double rating) {
		this.driverID = driverID;
		this.userID = userID;
		this.vehicleType = vehicleType;
		this.vehicleNumber = vehicleNumber;
		this.licenseNumber = licenseNumber;
		this.status = status;
		this.rating = rating;
	}

	public Driver(int driverID, int userID, String vehicleType, String vehicleNumber,
			String licenseNumber, String status, double rating,
			Timestamp createdAt, Timestamp updatedAt, String name, String phone, String email) {
		this.driverID = driverID;
		this.userID = userID;
		this.vehicleType = vehicleType;
		this.vehicleNumber = vehicleNumber;
		this.licenseNumber = licenseNumber;
		this.status = status;
		this.rating = rating;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
		this.name = name;
		this.phone = phone;
		this.email = email;
	}

	public int getDriverID() {
		return driverID;
	}

	public void setDriverID(int driverID) {
		this.driverID = driverID;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public String getVehicleType() {
		return vehicleType;
	}

	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}

	public String getVehicleNumber() {
		return vehicleNumber;
	}

	public void setVehicleNumber(String vehicleNumber) {
		this.vehicleNumber = vehicleNumber;
	}

	public String getLicenseNumber() {
		return licenseNumber;
	}

	public void setLicenseNumber(String licenseNumber) {
		this.licenseNumber = licenseNumber;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Override
	public String toString() {
		return "Driver [driverID=" + driverID + ", userID=" + userID + ", vehicleType=" + vehicleType
				+ ", vehicleNumber=" + vehicleNumber + ", licenseNumber=" + licenseNumber + ", status=" + status
				+ ", rating=" + rating + ", name=" + name + ", phone=" + phone + "]";
	}
}
