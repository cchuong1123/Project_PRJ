package dal;

import models.Invoice;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InvoiceDAO extends DBContext {

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
