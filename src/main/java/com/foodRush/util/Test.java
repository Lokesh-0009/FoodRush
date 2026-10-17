package com.foodRush.util;

import java.sql.Connection;

public class Test {
	public static void main(String[] args) {
		try (Connection conn = DBConnection.getConnection()) {
			if (conn != null && !conn.isClosed()) {
				System.out.println("FoodRush Database Connection established successfully!");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
