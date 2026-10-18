package com.tap.DAO;

import java.sql.SQLException;
import java.util.List;

import com.tap.modell.User;

public interface UserDao {

    // Add User
    void addUser(User user);

    // Get User by ID
    User getUser(int userId);

    // Update User
    void updateUser(User user);

    // Delete User
    void deleteUser(int userId);

    // Get All Users
    List<User> getAllUsers();

    // Login / Get User by username and password
    User getUserByUsernameAndPassword(String username, String password);

	boolean updatePassword(int userId, String hashedPassword) throws SQLException;

	boolean registerUser(User user) throws SQLException;

	User getUserByUsername(String username) throws SQLException;

	boolean accountExists(String username, String email) throws SQLException;
}