package dal;

import models.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO extends DBContext {

    /**
     * Authenticate user by username and password.
     * Only returns active users (IsActive = 1).
     */
    public User login(String username, String password) {
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive "
                + "FROM Users "
                + "WHERE Username = ? AND Password = ? AND IsActive = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setFullName(rs.getString("FullName"));
                user.setRole(rs.getString("Role"));
                user.setIsActive(rs.getBoolean("IsActive"));
                return user;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public java.util.List<User> getMechanics() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT UserID, Username, Password, FullName, Role, IsActive "
                + "FROM Users WHERE Role = 'mechanic' AND IsActive = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setRole(rs.getString("Role"));
                list.add(u);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}