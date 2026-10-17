package com.foodRush.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.DriverDAO;
import com.foodRush.model.Driver;
import com.foodRush.util.DBConnection;

public class DriverDAOImpl implements DriverDAO {

	private static final String BASE_SELECT =
			"SELECT d.driverID, d.userID, d.vehicleType, d.vehicleNumber, d.licenseNumber, d.status, d.rating, "
			+ "d.createdAt, d.updatedAt, u.name, u.phone, u.email "
			+ "FROM driver d "
			+ "JOIN user u ON d.userID = u.id ";

	private static final String INSERT_QUERY =
			"INSERT INTO driver(userID, vehicleType, vehicleNumber, licenseNumber, status, rating) "
			+ "VALUES(?,?,?,?,?,?)";

	private static final String SELECT_BY_ID = BASE_SELECT + "WHERE d.driverID = ?";

	private static final String SELECT_BY_USER_ID = BASE_SELECT + "WHERE d.userID = ?";

	private static final String SELECT_ALL = BASE_SELECT + "ORDER BY d.driverID ASC";

	private static final String SELECT_AVAILABLE = BASE_SELECT + "WHERE d.status = 'AVAILABLE' ORDER BY d.driverID ASC";

	private static final String UPDATE_QUERY =
			"UPDATE driver SET vehicleType=?, vehicleNumber=?, licenseNumber=?, status=?, rating=? "
			+ "WHERE driverID=?";

	private static final String UPDATE_STATUS =
			"UPDATE driver SET status=? WHERE driverID=?";

	private static final String DELETE_QUERY =
			"DELETE FROM driver WHERE driverID=?";

	@Override
	public int addDriver(Driver driver) {
		int generatedId = 0;
		if (driver == null) return 0;

		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setInt(1, driver.getUserID());
			pstmt.setString(2, (driver.getVehicleType() != null) ? driver.getVehicleType() : "Bike");
			pstmt.setString(3, (driver.getVehicleNumber() != null) ? driver.getVehicleNumber() : "KA-01-XX-0000");
			pstmt.setString(4, driver.getLicenseNumber());
			pstmt.setString(5, (driver.getStatus() != null) ? driver.getStatus() : "AVAILABLE");
			pstmt.setDouble(6, (driver.getRating() > 0) ? driver.getRating() : 5.0);

			int affected = pstmt.executeUpdate();
			if (affected > 0) {
				try (ResultSet rs = pstmt.getGeneratedKeys()) {
					if (rs.next()) {
						generatedId = rs.getInt(1);
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return generatedId;
	}

	@Override
	public Driver getDriver(int driverID) {
		Driver driver = null;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_ID)) {

			pstmt.setInt(1, driverID);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					driver = mapDriver(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return driver;
	}

	@Override
	public Driver getDriverByUserId(int userID) {
		Driver driver = null;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_USER_ID)) {

			pstmt.setInt(1, userID);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					driver = mapDriver(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return driver;
	}

	@Override
	public List<Driver> getAllDrivers() {
		List<Driver> list = new ArrayList<>();
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_ALL);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				list.add(mapDriver(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Driver> getAvailableDrivers() {
		List<Driver> list = new ArrayList<>();
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_AVAILABLE);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				list.add(mapDriver(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void updateDriver(Driver driver) {
		if (driver == null) return;
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY)) {

			pstmt.setString(1, driver.getVehicleType());
			pstmt.setString(2, driver.getVehicleNumber());
			pstmt.setString(3, driver.getLicenseNumber());
			pstmt.setString(4, driver.getStatus());
			pstmt.setDouble(5, driver.getRating());
			pstmt.setInt(6, driver.getDriverID());

			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateDriverStatus(int driverID, String status) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_STATUS)) {

			pstmt.setString(1, status);
			pstmt.setInt(2, driverID);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteDriver(int driverID) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY)) {

			pstmt.setInt(1, driverID);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private Driver mapDriver(ResultSet rs) throws SQLException {
		int driverID = rs.getInt("driverID");
		int userID = rs.getInt("userID");
		String vehicleType = rs.getString("vehicleType");
		String vehicleNumber = rs.getString("vehicleNumber");
		String licenseNumber = rs.getString("licenseNumber");
		String status = rs.getString("status");
		double rating = rs.getDouble("rating");
		Timestamp createdAt = rs.getTimestamp("createdAt");
		Timestamp updatedAt = rs.getTimestamp("updatedAt");
		String name = rs.getString("name");
		String phone = rs.getString("phone");
		String email = rs.getString("email");

		return new Driver(driverID, userID, vehicleType, vehicleNumber, licenseNumber,
				status, rating, createdAt, updatedAt, name, phone, email);
	}
}
