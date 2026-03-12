package dal;

import models.OrderPart;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderPartDAO extends DBContext {

    public List<OrderPart> getPartsByOrder(int orderID) {
        List<OrderPart> list = new ArrayList<>();
        String sql = "SELECT op.*, p.PartName, p.SKU FROM OrderParts op "
                + "JOIN Parts p ON op.PartID = p.PartID WHERE op.OrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderPart op = new OrderPart();
                op.setOrderID(rs.getInt("OrderID"));
                op.setPartID(rs.getInt("PartID"));
                op.setQuantity(rs.getInt("Quantity"));
                op.setUnitPrice(rs.getDouble("UnitPrice"));
                op.setPartName(rs.getString("PartName"));
                op.setSku(rs.getString("SKU"));
                list.add(op);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderPartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean addPart(int orderID, int partID, int quantity, double unitPrice) {
        // Use MERGE to handle duplicate (update quantity if exists)
        String sql = "MERGE OrderParts AS target "
                + "USING (VALUES (?, ?, ?, ?)) AS source (OrderID, PartID, Quantity, UnitPrice) "
                + "ON target.OrderID = source.OrderID AND target.PartID = source.PartID "
                + "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + source.Quantity "
                + "WHEN NOT MATCHED THEN INSERT (OrderID, PartID, Quantity, UnitPrice) "
                + "VALUES (source.OrderID, source.PartID, source.Quantity, source.UnitPrice);";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderID);
            ps.setInt(2, partID);
            ps.setInt(3, quantity);
            ps.setDouble(4, unitPrice);
            ps.executeUpdate();

            // Decrease stock
            PreparedStatement ps2 = connection.prepareStatement(
                    "UPDATE Parts SET StockQty = StockQty - ? WHERE PartID = ? AND StockQty >= ?");
            ps2.setInt(1, quantity);
            ps2.setInt(2, partID);
            ps2.setInt(3, quantity);
            ps2.executeUpdate();

            return true;
        } catch (SQLException ex) {
            Logger.getLogger(OrderPartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean removePart(int orderID, int partID) {
        try {
            // Return stock first
            PreparedStatement psGet = connection.prepareStatement(
                    "SELECT Quantity FROM OrderParts WHERE OrderID = ? AND PartID = ?");
            psGet.setInt(1, orderID);
            psGet.setInt(2, partID);
            ResultSet rs = psGet.executeQuery();
            if (rs.next()) {
                int qty = rs.getInt("Quantity");
                PreparedStatement psStock = connection.prepareStatement(
                        "UPDATE Parts SET StockQty = StockQty + ? WHERE PartID = ?");
                psStock.setInt(1, qty);
                psStock.setInt(2, partID);
                psStock.executeUpdate();
            }

            PreparedStatement ps = connection.prepareStatement(
                    "DELETE FROM OrderParts WHERE OrderID = ? AND PartID = ?");
            ps.setInt(1, orderID);
            ps.setInt(2, partID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderPartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public double getTotalPartsAmount(int orderID) {
        String sql = "SELECT ISNULL(SUM(Quantity * UnitPrice), 0) AS Total FROM OrderParts WHERE OrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { return rs.getDouble("Total"); }
        } catch (SQLException ex) {
            Logger.getLogger(OrderPartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
}
