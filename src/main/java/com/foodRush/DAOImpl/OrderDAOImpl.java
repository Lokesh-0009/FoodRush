package com.foodRush.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.OrderDAO;
import com.foodRush.model.Orders;
import com.foodRush.util.DBConnection;
import com.foodRush.model.OrderItem;

public class OrderDAOImpl implements OrderDAO {

	private static final String INSERT_QUERY = "INSERT INTO orders(UserID, RestaurantID, OrderDate, TotalAmount, "
			+ "Status, PaymentMethod, Payment_Status) "
			+ "VALUES(?,?,?,?,?,?,?)";

	private static final String SELECT_QUERY = "SELECT * FROM orders WHERE OrderID = ?";

	private static final String UPDATE_QUERY = "UPDATE orders SET Status=?, PaymentMethod=?, Payment_Status=? "
			+ "WHERE OrderID=?";

	private static final String DELETE_QUERY = "DELETE FROM orders WHERE OrderID = ?";

	private static final String SELECTALL_QUERY = "SELECT * FROM orders";

	private static final String SELECT_BY_USER_QUERY = "SELECT * FROM orders WHERE UserID = ? ORDER BY OrderDate DESC";

	private static final String SELECT_BY_RESTAURANT_QUERY = "SELECT * FROM orders WHERE RestaurantID = ? ORDER BY OrderDate DESC";

	@Override
	public int addOrder(Orders order) {
		int generatedId = 0;
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setInt(1, order.getUserID());
			pstmt.setInt(2, order.getRestaurantID());
			pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pstmt.setDouble(4, order.getTotalAmount());
			pstmt.setString(5, normalizeStatus(order.getStatus()));
			pstmt.setString(6, normalizePaymentMethod(order.getPaymentMethod()));
			pstmt.setString(7, normalizePaymentStatus(order.getPaymentStatus()));

			int affectedRows = pstmt.executeUpdate();
			if (affectedRows > 0) {
				try (ResultSet rs = pstmt.getGeneratedKeys()) {
					if (rs.next()) {
						generatedId = rs.getInt(1);
					}
				}
			}
			System.out.println(affectedRows + " row inserted, OrderID: " + generatedId);

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return generatedId;
	}

	@Override
	public Orders getOrder(int orderID) {
		Orders order = null;

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY)) {

			pstmt.setInt(1, orderID);

			try (ResultSet result = pstmt.executeQuery()) {
				order = extractOrderResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return order;
	}

	@Override
	public void updateOrder(Orders order) {
		if (order == null)
			return;
		String sql = "UPDATE orders SET Status=?, PaymentMethod=?, Payment_Status=?, driverID=? WHERE OrderID=?";
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql)) {

			pstmt.setString(1, normalizeStatus(order.getStatus()));
			pstmt.setString(2, normalizePaymentMethod(order.getPaymentMethod()));
			pstmt.setString(3, normalizePaymentStatus(order.getPaymentStatus()));
			if (order.getDriverID() != null && order.getDriverID() > 0) {
				pstmt.setInt(4, order.getDriverID());
			} else {
				pstmt.setNull(4, java.sql.Types.INTEGER);
			}
			pstmt.setInt(5, order.getOrderID());

			int i = pstmt.executeUpdate();
			System.out.println(i + " row effected");

			// If delivered, free up driver
			if ("DELIVERED".equalsIgnoreCase(normalizeStatus(order.getStatus())) && order.getDriverID() != null
					&& order.getDriverID() > 0) {
				try (PreparedStatement dStmt = connection
						.prepareStatement("UPDATE driver SET status = 'AVAILABLE' WHERE driverID = ?")) {
					dStmt.setInt(1, order.getDriverID());
					dStmt.executeUpdate();
				} catch (SQLException ignore) {
				}
			}

		} catch (SQLException e) {
			// Fallback in case driverID column is missing in legacy schema
			try (Connection connection = DBConnection.getConnection();
					PreparedStatement pstmt = connection.prepareStatement(
							"UPDATE orders SET Status=?, PaymentMethod=?, Payment_Status=? WHERE OrderID=?")) {
				pstmt.setString(1, normalizeStatus(order.getStatus()));
				pstmt.setString(2, normalizePaymentMethod(order.getPaymentMethod()));
				pstmt.setString(3, normalizePaymentStatus(order.getPaymentStatus()));
				pstmt.setInt(4, order.getOrderID());
				pstmt.executeUpdate();
			} catch (SQLException e2) {
				e2.printStackTrace();
			}
		}
	}

	private String normalizeStatus(String status) {
		if (status == null || status.trim().isEmpty()) {
			return "PLACED";
		}
		String s = status.trim().toUpperCase().replace(" ", "_").replace("-", "_");
		if (s.equals("OUT_FOR_DELIVERY") || s.equals("OUTFORDELIVERY") || s.equals("ON_ROUTE")
				|| s.equals("DISPATCHED")) {
			return "OUT_FOR_DELIVERY";
		} else if (s.equals("PREPARING") || s.equals("COOKING") || s.equals("ACCEPTED") || s.equals("IN_PREPARATION")) {
			return "PREPARING";
		} else if (s.equals("DELIVERED") || s.equals("COMPLETED")) {
			return "DELIVERED";
		} else if (s.equals("CONFIRMED")) {
			return "CONFIRMED";
		} else if (s.equals("CANCELLED") || s.equals("CANCELED")) {
			return "CANCELLED";
		} else if (s.equals("PLACED") || s.equals("PENDING") || s.equals("CREATED")) {
			return "PLACED";
		}
		return "PLACED";
	}

	private String normalizePaymentMethod(String method) {
		if (method == null || method.trim().isEmpty()) {
			return "COD";
		}
		String m = method.trim().toUpperCase();
		if (m.contains("CARD") || m.contains("DEBIT") || m.contains("CREDIT")) {
			return "CARD";
		} else if (m.contains("UPI") || m.contains("GPAY") || m.contains("PHONEPE") || m.contains("PAYTM")) {
			return "UPI";
		}
		return "COD";
	}

	private String normalizePaymentStatus(String status) {
		if (status == null || status.trim().isEmpty()) {
			return "PENDING";
		}
		String ps = status.trim().toUpperCase();
		if (ps.equals("PAID") || ps.equals("SUCCESS") || ps.equals("COMPLETED")) {
			return "PAID";
		} else if (ps.equals("FAILED")) {
			return "FAILED";
		} else if (ps.equals("REFUNDED")) {
			return "REFUNDED";
		}
		return "PENDING";
	}

	@Override
	public void deleteOrder(int orderID) {
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY)) {

			pstmt.setInt(1, orderID);

			int i = pstmt.executeUpdate();
			System.out.println(i + " row deleted");

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Orders> getAllOrders() {
		List<Orders> al = new ArrayList<Orders>();

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(SELECTALL_QUERY);
				ResultSet result = pstmt.executeQuery()) {

			al = extractAllOrderResultSet(result);

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	@Override
	public List<Orders> getOrdersByUserId(int userID) {
		List<Orders> al = new ArrayList<Orders>();

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_USER_QUERY)) {

			pstmt.setInt(1, userID);

			try (ResultSet result = pstmt.executeQuery()) {
				al = extractAllOrderResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	@Override
	public List<Orders> getOrdersByRestaurantId(int restaurantID) {
		List<Orders> al = new ArrayList<Orders>();

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_RESTAURANT_QUERY)) {

			pstmt.setInt(1, restaurantID);

			try (ResultSet result = pstmt.executeQuery()) {
				al = extractAllOrderResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	private List<Orders> extractAllOrderResultSet(ResultSet res) throws SQLException {
		List<Orders> al = new ArrayList<Orders>();
		while (res.next()) {
			al.add(mapOrder(res));
		}
		return al;
	}

	private Orders extractOrderResultSet(ResultSet res) throws SQLException {
		if (res.next()) {
			return mapOrder(res);
		}
		return null;
	}

	private Orders mapOrder(ResultSet res) throws SQLException {
		int orderID = res.getInt("OrderID");
		int userID = res.getInt("UserID");
		int restaurantID = res.getInt("RestaurantID");
		Timestamp orderDate = res.getTimestamp("OrderDate");
		double totalAmount = res.getDouble("TotalAmount");
		String status = res.getString("Status");
		String paymentMethod = res.getString("PaymentMethod");
		String paymentStatus = res.getString("Payment_Status");

		Orders order = new Orders(
				orderID,
				userID,
				restaurantID,
				orderDate,
				totalAmount,
				status,
				paymentMethod,
				paymentStatus);

		try {
			int driverID = res.getInt("driverID");
			if (!res.wasNull() && driverID > 0) {
				order.setDriverID(driverID);
			}
		} catch (SQLException ignore) {
			// Column might not exist in an older schema
		}

		return order;
	}

	@Override
	public void assignDriver(int orderID, int driverID) {
		String sql = "UPDATE orders SET driverID = ?, status = 'OUT_FOR_DELIVERY' WHERE orderID = ?";
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql)) {

			if (driverID > 0) {
				pstmt.setInt(1, driverID);
			} else {
				pstmt.setNull(1, java.sql.Types.INTEGER);
			}
			pstmt.setInt(2, orderID);
			pstmt.executeUpdate();

			// Mark driver status as BUSY
			if (driverID > 0) {
				try (PreparedStatement dStmt = connection
						.prepareStatement("UPDATE driver SET status = 'BUSY' WHERE driverID = ?")) {
					dStmt.setInt(1, driverID);
					dStmt.executeUpdate();
				} catch (SQLException ignore) {
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Orders> getOrdersByDriverId(int driverID) {
		List<Orders> al = new ArrayList<>();
		String sql = "SELECT * FROM orders WHERE driverID = ? ORDER BY orderDate DESC";
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql)) {

			pstmt.setInt(1, driverID);
			try (ResultSet result = pstmt.executeQuery()) {
				al = extractAllOrderResultSet(result);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return al;
	}

	@Override
	public int createOrderWithItems(Orders order, List<OrderItem> items) {
		int generatedId = 0;
		String insertOrderItemQuery = "INSERT INTO orderitem(OrderID, MenuID, Quantity, ItemTotal) VALUES(?,?,?,?)";

		try (Connection connection = DBConnection.getConnection()) {
			if (connection == null)
				return 0;
			connection.setAutoCommit(false);

			try (PreparedStatement orderPstmt = connection.prepareStatement(INSERT_QUERY,
					Statement.RETURN_GENERATED_KEYS)) {
				orderPstmt.setInt(1, order.getUserID());
				orderPstmt.setInt(2, order.getRestaurantID());
				orderPstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
				orderPstmt.setDouble(4, order.getTotalAmount());
				orderPstmt.setString(5, normalizeStatus(order.getStatus()));
				orderPstmt.setString(6, normalizePaymentMethod(order.getPaymentMethod()));
				orderPstmt.setString(7, normalizePaymentStatus(order.getPaymentStatus()));

				int affectedRows = orderPstmt.executeUpdate();
				if (affectedRows > 0) {
					try (ResultSet rs = orderPstmt.getGeneratedKeys()) {
						if (rs.next()) {
							generatedId = rs.getInt(1);
						}
					}
				}

				if (generatedId > 0 && items != null && !items.isEmpty()) {
					try (PreparedStatement itemPstmt = connection.prepareStatement(insertOrderItemQuery)) {
						for (OrderItem item : items) {
							itemPstmt.setInt(1, generatedId);
							itemPstmt.setInt(2, item.getMenuID());
							itemPstmt.setInt(3, item.getQuantity());
							itemPstmt.setDouble(4, item.getItemTotal());
							itemPstmt.addBatch();
						}
						itemPstmt.executeBatch();
					}
				}

				connection.commit();
			} catch (SQLException e) {
				connection.rollback();
				e.printStackTrace();
				return 0;
			} finally {
				connection.setAutoCommit(true);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return generatedId;
	}
}