package com.foodRush.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.UserDAO;
import com.foodRush.model.User;
import com.foodRush.util.DBConnection;

public class UserDAOImpl implements UserDAO {

	private static final String INSERT_QUERY = "INSERT into user(name, email, password, phone, role, address, createdDate, lastloginDate) "
			+ "values(?,?,?,?,?,?,?,?)";
	
	private static final String SELECT_QUERY = "SELECT * FROM user where id= ? ";
	
	private static final String UPDATE_QUERY = "UPDATE user SET name=?, email=?, password=?, phone=?, role=?, address=? WHERE id=?";
	
	private static final String DELETE_QUERY = "DELETE FROM user WHERE id = ?";
	
	private static final String SELECTALL_QUERY = "SELECT * FROM user";
	
	private static final String SELECT_BY_EMAIL_QUERY = "SELECT * FROM user WHERE email = ?";

	private static final String SELECT_BY_PHONE_QUERY = "SELECT * FROM user WHERE phone = ?";

	private static final String UPDATE_PASSWORD_QUERY = "UPDATE user SET password = ? WHERE id = ?";

	@Override
	public void addUser(User user) {
		if (user == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY, java.sql.Statement.RETURN_GENERATED_KEYS)) {
			
			pstmt.setString(1, sanitizeString(user.getName(), 100, "User"));
			pstmt.setString(2, sanitizeString(user.getEmail(), 150, "user@foodrush.com"));
			pstmt.setString(3, sanitizeString(user.getPassword(), 255, "password123"));
			if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
				pstmt.setString(4, sanitizeString(user.getPhone().trim(), 15, null));
			} else {
				pstmt.setNull(4, java.sql.Types.VARCHAR);
			}
			pstmt.setString(5, normalizeRole(user.getRole()));
			pstmt.setString(6, sanitizeString(user.getAddress(), 255, "Bangalore"));
			pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
			pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
			
			int i = pstmt.executeUpdate();
			if (i > 0) {
				try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						user.setId(generatedKeys.getInt(1));
					}
				}
			}
			System.out.println(i + " row inserted with ID: " + user.getId());
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public User getUser(int id) {
		User user = null;
		
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY)) {
			
			pstmt.setInt(1, id);
			
			try (ResultSet result = pstmt.executeQuery()) {
				user = extractUsersResultSet(result);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return user;
	}

	@Override
	public void updateUser(User user) {
		if (user == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY)) {
			
			pstmt.setString(1, sanitizeString(user.getName(), 100, "User"));
			pstmt.setString(2, sanitizeString(user.getEmail(), 150, "user@foodrush.com"));
			pstmt.setString(3, sanitizeString(user.getPassword(), 255, "password123"));
			if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
				pstmt.setString(4, sanitizeString(user.getPhone().trim(), 15, null));
			} else {
				pstmt.setNull(4, java.sql.Types.VARCHAR);
			}
			pstmt.setString(5, normalizeRole(user.getRole()));
			pstmt.setString(6, sanitizeString(user.getAddress(), 255, "Bangalore"));
			pstmt.setInt(7, user.getId());
			
			int i = pstmt.executeUpdate();
			System.out.println(i + " row effected for user ID: " + user.getId());
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private String normalizeRole(String role) {
		if (role == null || role.trim().isEmpty()) {
			return "CUSTOMER";
		}
		String r = role.trim().toUpperCase();
		if (r.contains("ADMIN") || r.contains("MANAGER") || r.contains("SUPER")) {
			return "ADMIN";
		}
		if (r.contains("DRIVER") || r.contains("DELIVERY")) {
			return "DRIVER";
		}
		return "CUSTOMER";
	}

	private String sanitizeString(String str, int maxLen, String defaultValue) {
		if (str == null || str.trim().isEmpty()) {
			return defaultValue;
		}
		String s = str.trim();
		return (s.length() > maxLen) ? s.substring(0, maxLen) : s;
	}

	@Override
	public void deleteUser(int id) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY)) {
			
			pstmt.setInt(1, id);
			int i = pstmt.executeUpdate();
			System.out.println(i + " row deleted");
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<User> getAllUsers() {
		List<User> al = null;
		
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstm = connection.prepareStatement(SELECTALL_QUERY);
			 ResultSet result = pstm.executeQuery()) {
			
			al = extractAllUserResultSet(result);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return al;
	}
	
	@Override
	public User getUserByEmail(String email) {
		User user = null;
		
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_EMAIL_QUERY)) {
			
			pstmt.setString(1, email);
			
			try (ResultSet result = pstmt.executeQuery()) {
				user = extractUsersResultSet(result);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return user;
	}

	@Override
	public User getUserByPhone(String phone) {
		if (phone == null || phone.trim().isEmpty()) {
			return null;
		}
		User user = null;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_PHONE_QUERY)) {
			
			pstmt.setString(1, phone.trim());
			try (ResultSet result = pstmt.executeQuery()) {
				user = extractUsersResultSet(result);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}

	@Override
	public boolean updateUserPassword(int userId, String newHashedPassword) {
		if (userId <= 0 || newHashedPassword == null || newHashedPassword.trim().isEmpty()) {
			return false;
		}
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_PASSWORD_QUERY)) {
			
			pstmt.setString(1, newHashedPassword);
			pstmt.setInt(2, userId);
			int rows = pstmt.executeUpdate();
			return rows > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	private List<User> extractAllUserResultSet(ResultSet res) throws SQLException {
		List<User> al = new ArrayList<User>();
		
		while (res.next()) {
			int id = res.getInt(1);
			String name = res.getString(2);
			String email = res.getString(3);
			String password = res.getString(4);
			String phone = res.getString(5);
			String role = res.getString(6);
			String address = res.getString(7);
			Timestamp createDate = res.getTimestamp(8);
			Timestamp lastLoginDate = res.getTimestamp(9);
			
			User user = new User(id, name, email, password, phone, role, address, createDate, lastLoginDate);
			al.add(user);
		}
		return al;
	}

	private User extractUsersResultSet(ResultSet res) throws SQLException {
		User user = null;
		if (res.next()) {
			int id = res.getInt(1);
			String name = res.getString(2);
			String email = res.getString(3);
			String password = res.getString(4);
			String phone = res.getString(5);
			String role = res.getString(6);
			String address = res.getString(7);
			Timestamp createDate = res.getTimestamp(8);
			Timestamp lastLoginDate = res.getTimestamp(9);
			
			user = new User(id, name, email, password, phone, role, address, createDate, lastLoginDate); 
		}
		return user;
	}
}
