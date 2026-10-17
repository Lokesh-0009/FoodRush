package com.foodRush.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

	private static String url = "jdbc:mysql://localhost:3306/foodrush_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	private static String userName = "root";
	private static String password = "password";

	static {
		loadConfiguration();
	}

	public static synchronized void loadConfiguration() {
		InputStream in = null;
		try {
			ClassLoader tcl = Thread.currentThread().getContextClassLoader();
			if (tcl != null) {
				in = tcl.getResourceAsStream("db.properties");
				if (in == null) in = tcl.getResourceAsStream("/db.properties");
			}
			if (in == null && DBConnection.class.getClassLoader() != null) {
				in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
				if (in == null) in = DBConnection.class.getClassLoader().getResourceAsStream("/db.properties");
			}
			if (in == null) {
				in = DBConnection.class.getResourceAsStream("/db.properties");
				if (in == null) in = DBConnection.class.getResourceAsStream("db.properties");
			}
			if (in != null) {
				Properties props = new Properties();
				props.load(in);
				if (props.getProperty("db.url") != null && !props.getProperty("db.url").trim().isEmpty()) {
					url = props.getProperty("db.url").trim();
				}
				if (props.getProperty("db.user") != null && !props.getProperty("db.user").trim().isEmpty()) {
					userName = props.getProperty("db.user").trim();
				}
				if (props.getProperty("db.password") != null) {
					password = props.getProperty("db.password").trim();
				}
			} else {
				if (System.getenv("DB_URL") != null) url = System.getenv("DB_URL");
				if (System.getenv("DB_USER") != null) userName = System.getenv("DB_USER");
				if (System.getenv("DB_PASSWORD") != null) password = System.getenv("DB_PASSWORD");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try { in.close(); } catch (Exception ignored) {}
			}
		}
	}

	public static Connection getConnection() {
		Connection connection = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			connection = DriverManager.getConnection(url, userName, password);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		return connection;
	}
}
