
package com.tap.DAOimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserDao;
import com.tap.modell.User;
import com.tap.utility.dbconnection.DBConnection;

public class UserDaoImpl implements UserDao {

    // Convert ResultSet into User object
    private User mapUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(rs.getInt("userId"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));

        return user;
    }

    // 1. Add User
    @Override
    public void addUser(User user) {

        String sql = "INSERT INTO user "
                + "(username, password, email, phone, address, role) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. Get User by ID
    @Override
    public User getUser(int userId) {

        String sql = "SELECT * FROM user WHERE userId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // 3. Update User
    @Override
    public void updateUser(User user) {

        String sql = "UPDATE user SET "
                + "username = ?, password = ?, email = ?, "
                + "phone = ?, address = ?, role = ? "
                + "WHERE userId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getUserId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 4. Delete User
    @Override
    public void deleteUser(int userId) {

        String sql = "DELETE FROM user WHERE userId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 5. Get All Users
    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        String sql = "SELECT * FROM user";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    // 6. Existing Login Method (Legacy Compatibility)
    @Override
    public User getUserByUsernameAndPassword(
            String username, String password) {

        String sql = "SELECT * FROM user "
                + "WHERE username = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // 7. Check Whether Username or Email Already Exists
    @Override
    public boolean accountExists(String username, String email)
            throws SQLException {

        String sql = "SELECT userId FROM user "
                + "WHERE username = ? OR email = ? LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // 8. Register New Customer
    @Override
    public boolean registerUser(User user)
            throws SQLException {

        String sql = "INSERT INTO user "
                + "(username, password, email, phone, address, role) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());

            // New registrations always receive CUSTOMER role
            ps.setString(6, "CUSTOMER");

            return ps.executeUpdate() == 1;
        }
    }

    // 9. Find User by Username for Secure Login
    @Override
    public User getUserByUsername(String username)
            throws SQLException {

        String sql = "SELECT * FROM user "
                + "WHERE username = ? LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }

        return null;
    }

    // 10. Upgrade Existing Password to Secure Hash
    @Override
    public boolean updatePassword(
            int userId, String hashedPassword)
            throws SQLException {

        String sql = "UPDATE user SET password = ? "
                + "WHERE userId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() == 1;
        }
    }
}
