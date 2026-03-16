package dal;

import models.RepairOrder;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RepairOrderDAO extends DBContext {

    private static final String SELECT_ALL =
            "SELECT ro.*, v.LicensePlate, ISNULL(v.Brand,'') + ' ' + ISNULL(v.Model,'') AS VehicleInfo, "
            + "c.FullName AS CustomerName, c.Phone AS CustomerPhone, u.FullName AS MechanicName, "
            + "ISNULL((SELECT SUM(op.Quantity * op.UnitPrice) FROM OrderParts op WHERE op.OrderID = ro.OrderID), 0) AS PartsTotal "
            + "FROM RepairOrders ro "
            + "JOIN Vehicles v ON ro.VehicleID = v.VehicleID "
            + "JOIN Customers c ON v.CustomerID = c.CustomerID "
            + "JOIN Users u ON ro.MechanicID = u.UserID ";

    public List<RepairOrder> getAllOrders() {
        List<RepairOrder> list = new ArrayList<>();
        String sql = SELECT_ALL + "ORDER BY ro.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<RepairOrder> getOrdersByStatus(String status) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = SELECT_ALL + "WHERE ro.Status = ? ORDER BY ro.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public RepairOrder getOrderById(int id) {
        String sql = SELECT_ALL + "WHERE ro.OrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { return mapRow(rs); }
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean addOrder(RepairOrder o) {
        String sql = "INSERT INTO RepairOrders (VehicleID, MechanicID, Status, Description, LaborCost) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, o.getVehicleID());
            ps.setInt(2, o.getMechanicID());
            ps.setString(3, o.getStatus() != null ? o.getStatus() : "Tiếp nhận");
            ps.setString(4, o.getDescription());
            ps.setDouble(5, o.getLaborCost());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateStatus(int orderID, String status) {
        String sql = "UPDATE RepairOrders SET Status = ? WHERE OrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateOrder(RepairOrder o) {
        String sql = "UPDATE RepairOrders SET VehicleID = ?, MechanicID = ?, Description = ?, LaborCost = ? WHERE OrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, o.getVehicleID());
            ps.setInt(2, o.getMechanicID());
            ps.setString(3, o.getDescription());
            ps.setDouble(4, o.getLaborCost());
            ps.setInt(5, o.getOrderID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deleteOrder(int id) {
        // Restore stock for all parts in this order, then delete
        try {
            // 1. Restore stock quantities
            PreparedStatement psGet = connection.prepareStatement(
                    "SELECT PartID, Quantity FROM OrderParts WHERE OrderID = ?");
            psGet.setInt(1, id);
            ResultSet rs = psGet.executeQuery();
            PreparedStatement psStock = connection.prepareStatement(
                    "UPDATE Parts SET StockQty = StockQty + ? WHERE PartID = ?");
            while (rs.next()) {
                psStock.setInt(1, rs.getInt("Quantity"));
                psStock.setInt(2, rs.getInt("PartID"));
                psStock.addBatch();
            }
            psStock.executeBatch();

            // 2. Delete order parts
            PreparedStatement ps1 = connection.prepareStatement("DELETE FROM OrderParts WHERE OrderID = ?");
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // 3. Delete invoices
            PreparedStatement ps2 = connection.prepareStatement("DELETE FROM Invoices WHERE OrderID = ?");
            ps2.setInt(1, id);
            ps2.executeUpdate();

            // 4. Delete order
            PreparedStatement ps3 = connection.prepareStatement("DELETE FROM RepairOrders WHERE OrderID = ?");
            ps3.setInt(1, id);
            return ps3.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public List<RepairOrder> searchOrders(String keyword) {
        List<RepairOrder> list = new ArrayList<>();
        String sql = SELECT_ALL + "WHERE c.FullName LIKE ? OR v.LicensePlate LIKE ? OR c.Phone LIKE ? ORDER BY ro.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (SQLException ex) {
            Logger.getLogger(RepairOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    private RepairOrder mapRow(ResultSet rs) throws SQLException {
        RepairOrder o = new RepairOrder();
        o.setOrderID(rs.getInt("OrderID"));
        o.setVehicleID(rs.getInt("VehicleID"));
        o.setMechanicID(rs.getInt("MechanicID"));
        o.setStatus(rs.getString("Status"));
        o.setDescription(rs.getString("Description"));
        o.setLaborCost(rs.getDouble("LaborCost"));
        o.setCreatedAt(rs.getTimestamp("CreatedAt"));
        o.setVehiclePlate(rs.getString("LicensePlate"));
        o.setVehicleInfo(rs.getString("VehicleInfo"));
        o.setCustomerName(rs.getString("CustomerName"));
        o.setCustomerPhone(rs.getString("CustomerPhone"));
        o.setMechanicName(rs.getString("MechanicName"));
        try { o.setPartsTotal(rs.getDouble("PartsTotal")); } catch (SQLException e) { /* PartsTotal not in query */ }
        return o;
    }
}
