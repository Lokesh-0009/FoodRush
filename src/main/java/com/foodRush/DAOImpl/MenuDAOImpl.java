package com.foodRush.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.MenuDAO;
import com.foodRush.model.Menu;
import com.foodRush.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

	private static final String INSERT_QUERY =
			"INSERT INTO menu(RestaurantID, ItemName, Description, Price, "
			+ "IsAvailable, Category, CreatedAt, UpdatedAt, imagePath) "
			+ "VALUES(?,?,?,?,?,?,?,?,?)";

	private static final String SELECT_QUERY =
			"SELECT * FROM menu WHERE MenuID = ?";

	private static final String UPDATE_QUERY =
			"UPDATE menu SET ItemName=?, Description=?, Price=?, "
			+ "IsAvailable=?, Category=?, UpdatedAt=?, imagePath=? "
			+ "WHERE MenuID=?";

	private static final String DELETE_QUERY =
			"UPDATE menu SET DeletedAt=? WHERE MenuID=?";

	private static final String SELECTALL_QUERY =
			"SELECT * FROM menu WHERE DeletedAt IS NULL";

	private static final String SELECT_BY_RESTAURANT_QUERY =
			"SELECT * FROM menu WHERE RestaurantID = ? AND DeletedAt IS NULL";

	@Override
	public void addMenu(Menu menu) {
		if (menu == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY)) {

			pstmt.setInt(1, menu.getRestaurantID());
			pstmt.setString(2, sanitizeString(menu.getItemName(), 150, "Dish Item"));
			pstmt.setString(3, sanitizeString(menu.getDescription(), 500, ""));
			pstmt.setDouble(4, menu.getPrice() > 0 ? menu.getPrice() : 100.0);
			pstmt.setInt(5, menu.getIsAvailable() != 0 ? 1 : 0);
			pstmt.setString(6, sanitizeString(menu.getCategory(), 100, "Main Course"));

			Timestamp currentTime = new Timestamp(System.currentTimeMillis());
			pstmt.setTimestamp(7, currentTime);
			pstmt.setTimestamp(8, currentTime);
			pstmt.setString(9, sanitizeString(menu.getImagePath(), 255, "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=80"));

			int i = pstmt.executeUpdate();
			System.out.println(i + " row inserted for menu: " + menu.getItemName());

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Menu getMenu(int menuID) {
		Menu menu = null;

		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY)) {

			pstmt.setInt(1, menuID);

			try (ResultSet result = pstmt.executeQuery()) {
				menu = extractMenuResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return menu;
	}

	@Override
	public void updateMenu(Menu menu) {
		if (menu == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY)) {

			pstmt.setString(1, sanitizeString(menu.getItemName(), 150, "Dish Item"));
			pstmt.setString(2, sanitizeString(menu.getDescription(), 500, ""));
			pstmt.setDouble(3, menu.getPrice() > 0 ? menu.getPrice() : 100.0);
			pstmt.setInt(4, menu.getIsAvailable() != 0 ? 1 : 0);
			pstmt.setString(5, sanitizeString(menu.getCategory(), 100, "Main Course"));
			pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(7, sanitizeString(menu.getImagePath(), 255, "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=80"));
			pstmt.setInt(8, menu.getMenuID());

			int i = pstmt.executeUpdate();
			System.out.println(i + " row effected for menu ID: " + menu.getMenuID());

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
	public void deleteMenu(int menuID) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY)) {

			pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
			pstmt.setInt(2, menuID);

			int i = pstmt.executeUpdate();
			System.out.println(i + " row deleted");

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private static final String SELECTALL_FALLBACK_QUERY =
			"SELECT * FROM menu";

	private static final String SELECT_BY_RESTAURANT_FALLBACK_QUERY =
			"SELECT * FROM menu WHERE RestaurantID = ?";

	@Override
	public List<Menu> getAllMenus() {
		List<Menu> al = new ArrayList<Menu>();

		try (Connection connection = DBConnection.getConnection()) {
			if (connection == null) return al;

			try (PreparedStatement pstmt = connection.prepareStatement(SELECTALL_QUERY);
				 ResultSet result = pstmt.executeQuery()) {
				al = extractAllMenuResultSet(result);
			} catch (SQLException e) {
				try (PreparedStatement pstmtFallback = connection.prepareStatement(SELECTALL_FALLBACK_QUERY);
					 ResultSet resultFallback = pstmtFallback.executeQuery()) {
					al = extractAllMenuResultSet(resultFallback);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	@Override
	public List<Menu> getAllMenusByRestaurantID(int restaurantID) {
		List<Menu> al = new ArrayList<Menu>();

		try (Connection connection = DBConnection.getConnection()) {
			if (connection == null) return al;

			try (PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_RESTAURANT_QUERY)) {
				pstmt.setInt(1, restaurantID);
				try (ResultSet result = pstmt.executeQuery()) {
					al = extractAllMenuResultSet(result);
				}
			} catch (SQLException e) {
				try (PreparedStatement pstmtFallback = connection.prepareStatement(SELECT_BY_RESTAURANT_FALLBACK_QUERY)) {
					pstmtFallback.setInt(1, restaurantID);
					try (ResultSet resultFallback = pstmtFallback.executeQuery()) {
						al = extractAllMenuResultSet(resultFallback);
					}
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	private List<Menu> extractAllMenuResultSet(ResultSet res) throws SQLException {
		List<Menu> al = new ArrayList<Menu>();

		while (res.next()) {
			Menu menu = extractMenuFromRow(res);
			if (menu != null) {
				al.add(menu);
			}
		}

		return al;
	}

	private Menu extractMenuResultSet(ResultSet res) throws SQLException {
		if (res.next()) {
			return extractMenuFromRow(res);
		}
		return null;
	}

	private Menu extractMenuFromRow(ResultSet res) {
		try {
			int menuID = getIntSafe(res, "MenuID", 1);
			int restaurantID = getIntSafe(res, "RestaurantID", 2);
			String itemName = getStringSafe(res, "ItemName", 3);
			String description = getStringSafe(res, "Description", 4);
			double price = getDoubleSafe(res, "Price", 5);
			int isAvailable = getIntSafe(res, "IsAvailable", 6);
			String category = getStringSafe(res, "Category", 7);
			Timestamp createdAt = getTimestampSafe(res, "CreatedAt");
			Timestamp updatedAt = getTimestampSafe(res, "UpdatedAt");
			Timestamp deletedAt = getTimestampSafe(res, "DeletedAt");
			String imagePath = getStringSafe(res, "imagePath", 0);

			return new Menu(
					menuID,
					restaurantID,
					itemName,
					description,
					price,
					isAvailable,
					category,
					createdAt,
					updatedAt,
					deletedAt,
					imagePath
			);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private int getIntSafe(ResultSet res, String colName, int fallbackIndex) {
		try {
			return res.getInt(colName);
		} catch (Exception e) {
			try { return res.getInt(fallbackIndex); } catch (Exception ex) { return 0; }
		}
	}

	private String getStringSafe(ResultSet res, String colName, int fallbackIndex) {
		try {
			String val = res.getString(colName);
			if (val != null) return val;
		} catch (Exception ignored) {}

		if (fallbackIndex > 0) {
			try {
				return res.getString(fallbackIndex);
			} catch (Exception ignored) {}
		}
		return "";
	}

	private double getDoubleSafe(ResultSet res, String colName, int fallbackIndex) {
		try {
			return res.getDouble(colName);
		} catch (Exception e) {
			try { return res.getDouble(fallbackIndex); } catch (Exception ex) { return 0.0; }
		}
	}

	private Timestamp getTimestampSafe(ResultSet res, String colName) {
		try {
			return res.getTimestamp(colName);
		} catch (Exception e) {
			return null;
		}
	}
}
