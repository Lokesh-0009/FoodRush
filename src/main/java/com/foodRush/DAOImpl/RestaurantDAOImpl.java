package com.foodRush.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.model.Restaurant;
import com.foodRush.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

	private static final String INSERT_QUERY =
			"INSERT INTO restaurant(name, cuisineType, deliveryTime, address, adminUserID, rating, isActive, imagePath) "
			+ "VALUES(?,?,?,?,?,?,?,?)";

	private static final String SELECT_QUERY =
			"SELECT * FROM restaurant WHERE restaurantID = ?";

	private static final String UPDATE_QUERY =
			"UPDATE restaurant SET name=?, cuisineType=?, deliveryTime=?, address=?, "
			+ "adminUserID=?, rating=?, isActive=?, imagePath=? WHERE restaurantID=?";

	private static final String DELETE_QUERY =
			"DELETE FROM restaurant WHERE restaurantID = ?";

	private static final String SELECTALL_QUERY =
			"SELECT * FROM restaurant";
	
	@Override
	public void addRestaurant(Restaurant restaurant) {
		if (restaurant == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY)) {

			pstmt.setString(1, sanitizeString(restaurant.getName(), 150, "Restaurant"));
			pstmt.setString(2, sanitizeString(restaurant.getCuisineType(), 100, "Multi-Cuisine"));
			pstmt.setInt(3, restaurant.getDeliveryTime() > 0 ? restaurant.getDeliveryTime() : 30);
			pstmt.setString(4, sanitizeString(restaurant.getAddress(), 255, "Bangalore"));
			pstmt.setInt(5, restaurant.getAdminUserID() > 0 ? restaurant.getAdminUserID() : 1);
			pstmt.setDouble(6, restaurant.getRating() > 0 ? restaurant.getRating() : 4.5);
			pstmt.setInt(7, restaurant.isActive());
			pstmt.setString(8, sanitizeString(restaurant.getImagePath(), 255, "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=80"));

			int i = pstmt.executeUpdate();
			System.out.println(i + " row inserted for restaurant: " + restaurant.getName());

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Restaurant getRestaurant(int restaurantID) {
		Restaurant restaurant = null;

		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY)) {

			pstmt.setInt(1, restaurantID);

			try (ResultSet result = pstmt.executeQuery()) {
				restaurant = extractRestaurantResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return restaurant;
	}

	@Override
	public void updateRestaurant(Restaurant restaurant) {
		if (restaurant == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY)) {

			pstmt.setString(1, sanitizeString(restaurant.getName(), 150, "Restaurant"));
			pstmt.setString(2, sanitizeString(restaurant.getCuisineType(), 100, "Multi-Cuisine"));
			pstmt.setInt(3, restaurant.getDeliveryTime() > 0 ? restaurant.getDeliveryTime() : 30);
			pstmt.setString(4, sanitizeString(restaurant.getAddress(), 255, "Bangalore"));
			pstmt.setInt(5, restaurant.getAdminUserID() > 0 ? restaurant.getAdminUserID() : 1);
			pstmt.setDouble(6, restaurant.getRating() > 0 ? restaurant.getRating() : 4.5);
			pstmt.setInt(7, restaurant.isActive());
			pstmt.setString(8, sanitizeString(restaurant.getImagePath(), 255, "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=80"));
			pstmt.setInt(9, restaurant.getRestaurantID());

			int i = pstmt.executeUpdate();
			System.out.println(i + " row effected for restaurant ID: " + restaurant.getRestaurantID());

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private String sanitizeString(String str, int maxLen, String defaultValue) {
		if (str == null || str.trim().isEmpty()) {
			return defaultValue;
		}
		String s = str.trim();
		return (s.length() > maxLen) ? s.substring(0, maxLen) : s;
	}

	@Override
	public void deleteRestaurant(int restaurantID) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY)) {

			pstmt.setInt(1, restaurantID);

			int i = pstmt.executeUpdate();
			System.out.println(i + " row deleted");

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Restaurant> getAllRestaurants() {
		List<Restaurant> al = new ArrayList<Restaurant>();

		Connection connection = DBConnection.getConnection();
		if (connection == null) {
			System.err.println("ERROR: DBConnection.getConnection() returned NULL! Check MySQL connection or missing mysql-connector.jar in WEB-INF/lib.");
			return al;
		}

		try (PreparedStatement pstmt = connection.prepareStatement(SELECTALL_QUERY);
			 ResultSet result = pstmt.executeQuery()) {

			al = extractAllRestaurantResultSet(result);

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (connection != null && !connection.isClosed()) {
					connection.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return al;
	}
	
	private List<Restaurant> extractAllRestaurantResultSet(ResultSet res) throws SQLException {
		List<Restaurant> al = new ArrayList<Restaurant>();

		while (res.next()) {
			int restaurantID = res.getInt("RestaurantID");
			String name = res.getString("Name");
			String cuisineType = res.getString("CuisineType");
			int deliveryTime = res.getInt("DeliveryTime");
			String address = res.getString("Address");
			int adminUserID = res.getInt("AdminUserID");
			double rating = res.getDouble("Rating");
			int isActive = res.getInt("IsActive");
			String imagePath = res.getString("imagePath");

			Restaurant restaurant = new Restaurant(restaurantID, name, cuisineType, deliveryTime, address, adminUserID, rating, isActive, imagePath);
			al.add(restaurant);
		}

		return al;
	}

	private Restaurant extractRestaurantResultSet(ResultSet res) throws SQLException {
		Restaurant restaurant = null;

		if (res.next()) {
			int restaurantID = res.getInt("RestaurantID");
			String name = res.getString("Name");
			String cuisineType = res.getString("CuisineType");
			int deliveryTime = res.getInt("DeliveryTime");
			String address = res.getString("Address");
			int adminUserID = res.getInt("AdminUserID");
			double rating = res.getDouble("Rating");
			int isActive = res.getInt("IsActive");
			String imagePath = res.getString("imagePath");

			restaurant = new Restaurant(restaurantID, name, cuisineType, deliveryTime, address, adminUserID, rating, isActive, imagePath);
		}
		return restaurant;
	}
}
