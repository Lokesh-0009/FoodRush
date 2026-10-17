package com.foodRush.DAO;

import java.util.List;

import com.foodRush.model.User;

public interface UserDAO {
	void addUser(User user);
	User getUser(int id);
	void updateUser(User user);
	void deleteUser(int id);
	List<User> getAllUsers();
	User getUserByEmail(String email);
	User getUserByPhone(String phone);
	boolean updateUserPassword(int userId, String newHashedPassword);
}
