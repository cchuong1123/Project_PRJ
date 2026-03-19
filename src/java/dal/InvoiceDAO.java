package dal;

import models.Invoice;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InvoiceDAO extends DBContext {

    /**
     * Get total revenue between two dates (inclusive).
     * 
     * @param fromDate format yyyy-MM-dd
     * @param toDate   format yyyy-MM-dd
     */
    public double getRevenueByDateRange(String fromDate, String toDate) {
        String sql = "SELECT ISNULL(SUM(TotalAmount), 0) AS Revenue FROM Invoices "
                + "WHERE CAST(PaidAt AS DATE) >= ? AND CAST(PaidAt AS DATE) <= ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("Revenue");
            }
        } catch (SQLException ex) {
            Logger.getLogger(InvoiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Get count of invoices between two dates (inclusive).
     */
    public int getTotalInvoicesByDateRange(String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) AS Total FROM Invoices "
                + "WHERE CAST(PaidAt AS DATE) >= ? AND CAST(PaidAt AS DATE) <= ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(InvoiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Get list of invoices between two dates, joined with order + customer info.
     */
    public List<Invoice> getInvoicesByDateRange(String fromDate, String toDate) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, "
                + "ISNULL((SELECT SUM(op.Quantity * p.ImportPrice) "
                + "        FROM OrderParts op JOIN Parts p ON op.PartID = p.PartID "
                + "        WHERE op.OrderID = i.OrderID), 0) AS TotalCost "
                + "FROM Invoices i "
                + "WHERE CAST(i.PaidAt AS DATE) >= ? AND CAST(i.PaidAt AS DATE) <= ? "
                + "ORDER BY i.PaidAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Invoice inv = new Invoice();
                inv.setInvoiceID(rs.getInt("InvoiceID"));
                inv.setOrderID(rs.getInt("OrderID"));
                inv.setTotalAmount(rs.getDouble("TotalAmount"));
                inv.setPaymentMethod(rs.getString("PaymentMethod"));
                inv.setPaidAt(rs.getTimestamp("PaidAt"));
                inv.setCost(rs.getDouble("TotalCost"));
                inv.setProfit(inv.getTotalAmount() - inv.getCost());
                list.add(inv);
            }
        } catch (SQLException ex) {
            Logger.getLogger(InvoiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Invoice getByOrderId(int orderID) {
        String sql = "SELECT * FROM Invoices WHERE OrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Invoice inv = new Invoice();
                inv.setInvoiceID(rs.getInt("InvoiceID"));
                inv.setOrderID(rs.getInt("OrderID"));
                inv.setTotalAmount(rs.getDouble("TotalAmount"));
                inv.setPaymentMethod(rs.getString("PaymentMethod"));
                inv.setPaidAt(rs.getTimestamp("PaidAt"));
                return inv;
            }
        } catch (SQLException ex) {
            Logger.getLogger(InvoiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean createInvoice(int orderID, double totalAmount, String paymentMethod) {
        String sql = "INSERT INTO Invoices (OrderID, TotalAmount, PaymentMethod, PaidAt) VALUES (?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderID);
            ps.setDouble(2, totalAmount);
            ps.setString(3, paymentMethod);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(InvoiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
