package com.foodRush.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.OrderItemDAO;
import com.foodRush.model.OrderItem;
import com.foodRush.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

	private static final String INSERT_QUERY =
			"INSERT INTO orderitem(OrderID, MenuID, Quantity, ItemTotal) "
			+ "VALUES(?,?,?,?)";

	private static final String SELECT_QUERY =
			"SELECT * FROM orderitem WHERE OrderItemID = ?";

	private static final String UPDATE_QUERY =
			"UPDATE orderitem SET Quantity=?, ItemTotal=? "
			+ "WHERE OrderItemID=?";

	private static final String DELETE_QUERY =
			"DELETE FROM orderitem WHERE OrderItemID = ?";

	private static final String SELECTALL_QUERY =
			"SELECT * FROM orderitem";

	private static final String SELECT_BY_ORDER_QUERY =
			"SELECT * FROM orderitem WHERE OrderID = ?";

	@Override
	public void addOrderItem(OrderItem orderItem) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY)) {

			pstmt.setInt(1, orderItem.getOrderID());
			pstmt.setInt(2, orderItem.getMenuID());
			pstmt.setInt(3, orderItem.getQuantity());
			pstmt.setDouble(4, orderItem.getItemTotal());

			int i = pstmt.executeUpdate();
			System.out.println(i + " row inserted");

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public OrderItem getOrderItem(int orderItemID) {
		OrderItem orderItem = null;

		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY)) {

			pstmt.setInt(1, orderItemID);

			try (ResultSet result = pstmt.executeQuery()) {
				orderItem = extractOrderItemResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return orderItem;
	}

	@Override
	public void updateOrderItem(OrderItem orderItem) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY)) {

			pstmt.setInt(1, orderItem.getQuantity());
			pstmt.setDouble(2, orderItem.getItemTotal());
			pstmt.setInt(3, orderItem.getOrderItemID());

			int i = pstmt.executeUpdate();
			System.out.println(i + " row effected");

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteOrderItem(int orderItemID) {
		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY)) {

			pstmt.setInt(1, orderItemID);

			int i = pstmt.executeUpdate();
			System.out.println(i + " row deleted");

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<OrderItem> getAllOrderItems() {
		List<OrderItem> al = null;

		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECTALL_QUERY);
			 ResultSet result = pstmt.executeQuery()) {

			al = extractAllOrderItemResultSet(result);

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	@Override
	public List<OrderItem> getOrderItemsByOrderId(int orderID) {
		List<OrderItem> al = new ArrayList<OrderItem>();

		try (Connection connection = DBConnection.getConnection();
			 PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_ORDER_QUERY)) {

			pstmt.setInt(1, orderID);

			try (ResultSet result = pstmt.executeQuery()) {
				al = extractAllOrderItemResultSet(result);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return al;
	}

	private List<OrderItem> extractAllOrderItemResultSet(ResultSet res) throws SQLException {
		List<OrderItem> al = new ArrayList<OrderItem>();

		while (res.next()) {
			int orderItemID = res.getInt(1);
			int orderID = res.getInt(2);
			int menuID = res.getInt(3);
			int quantity = res.getInt(4);
			double itemTotal = res.getDouble(5);

			OrderItem orderItem = new OrderItem(
					orderItemID,
					orderID,
					menuID,
					quantity,
					itemTotal
			);

			al.add(orderItem);
		}

		return al;
	}

	private OrderItem extractOrderItemResultSet(ResultSet res) throws SQLException {
		OrderItem orderItem = null;

		if (res.next()) {
			int orderItemID = res.getInt(1);
			int orderID = res.getInt(2);
			int menuID = res.getInt(3);
			int quantity = res.getInt(4);
			double itemTotal = res.getDouble(5);

			orderItem = new OrderItem(
					orderItemID,
					orderID,
					menuID,
					quantity,
					itemTotal
			);
		}

		return orderItem;
	}
}