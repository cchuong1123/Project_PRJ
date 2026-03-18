package dal;

import models.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO extends DBContext {

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserID(rs.getInt("UserID"));
        u.setUsername(rs.getString("Username"));
        u.setPassword(rs.getString("Password"));
        u.setFullName(rs.getString("FullName"));
        u.setRole(rs.getString("Role"));
        u.setIsActive(rs.getBoolean("IsActive"));
        u.setHireDate(rs.getDate("HireDate"));
        return u;
    }

    /**
     * Authenticate user by username and password.
     * Only returns active users (IsActive = 1).
     */
    public User login(String username, String password) {
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive, HireDate "
                + "FROM Users "
                + "WHERE Username = ? AND Password = ? AND IsActive = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<User> getMechanics() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive, HireDate "
                + "FROM Users WHERE Role = 'mechanic' AND IsActive = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive, HireDate "
                + "FROM Users WHERE Role != 'admin' ORDER BY UserID";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public User getUserById(int id) {
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive, HireDate "
                + "FROM Users WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public void updateUser(User u) {
        String sql = "UPDATE Users SET FullName = ?, Role = ?, HireDate = ? WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getRole());
            ps.setDate(3, u.getHireDate());
            ps.setInt(4, u.getUserID());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void toggleActive(int userId, boolean isActive) {
        String sql = "UPDATE Users SET IsActive = ? WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void addUser(User u) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Role, IsActive, HireDate) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getRole());
            ps.setBoolean(5, u.isIsActive());
            ps.setDate(6, u.getHireDate());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive, HireDate "
                + "FROM Users WHERE Username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}