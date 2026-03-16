package dal;

import models.Vehicle;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VehicleDAO extends DBContext {

    public List<Vehicle> getVehiclesByCustomer(int customerID) {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT v.*, c.FullName AS CustomerName FROM Vehicles v "
                + "JOIN Customers c ON v.CustomerID = c.CustomerID "
                + "WHERE v.CustomerID = ? ORDER BY v.VehicleID DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(VehicleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT v.*, c.FullName AS CustomerName FROM Vehicles v "
                + "JOIN Customers c ON v.CustomerID = c.CustomerID ORDER BY v.VehicleID DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (SQLException ex) {
            Logger.getLogger(VehicleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean addVehicle(Vehicle v) {
        String sql = "INSERT INTO Vehicles (CustomerID, LicensePlate, Brand, Model, ManufactureYear) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, v.getCustomerID());
            ps.setString(2, v.getLicensePlate());
            ps.setString(3, v.getBrand());
            ps.setString(4, v.getModel());
            ps.setInt(5, v.getManufactureYear());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(VehicleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateVehicle(Vehicle v) {
        String sql = "UPDATE Vehicles SET LicensePlate = ?, Brand = ?, Model = ?, ManufactureYear = ? WHERE VehicleID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, v.getLicensePlate());
            ps.setString(2, v.getBrand());
            ps.setString(3, v.getModel());
            ps.setInt(4, v.getManufactureYear());
            ps.setInt(5, v.getVehicleID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(VehicleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deleteVehicle(int id) {
        String sql = "DELETE FROM Vehicles WHERE VehicleID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(VehicleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public Vehicle getVehicleByPlate(String plate) {
        String sql = "SELECT v.*, c.FullName AS CustomerName FROM Vehicles v "
                + "JOIN Customers c ON v.CustomerID = c.CustomerID WHERE v.LicensePlate = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, plate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(VehicleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private Vehicle mapRow(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setVehicleID(rs.getInt("VehicleID"));
        v.setCustomerID(rs.getInt("CustomerID"));
        v.setLicensePlate(rs.getString("LicensePlate"));
        v.setBrand(rs.getString("Brand"));
        v.setModel(rs.getString("Model"));
        v.setManufactureYear(rs.getInt("ManufactureYear"));
        try {
            v.setCustomerName(rs.getString("CustomerName"));
        } catch (SQLException e) {
            // CustomerName not in query
        }
        return v;
    }
}
