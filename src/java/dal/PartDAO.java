package dal;

import models.Part;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PartDAO extends DBContext {

    public List<Part> getAllParts() {
        List<Part> list = new ArrayList<>();
        String sql = "SELECT * FROM Parts ORDER BY PartID DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(PartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Part getPartById(int id) {
        String sql = "SELECT * FROM Parts WHERE PartID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<Part> searchParts(String keyword) {
        List<Part> list = new ArrayList<>();
        String sql = "SELECT * FROM Parts WHERE PartName LIKE ? OR SKU LIKE ? ORDER BY PartID DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(PartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean addPart(Part p) {
        String sql = "INSERT INTO Parts (PartName, SKU, StockQty, ImportPrice, UnitPrice, MinStock, WarrantyMonths) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getPartName());
            ps.setString(2, p.getSku());
            ps.setInt(3, p.getStockQty());
            ps.setDouble(4, p.getImportPrice());
            ps.setDouble(5, p.getUnitPrice());
            ps.setInt(6, p.getMinStock());
            ps.setInt(7, p.getWarrantyMonths());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updatePart(Part p) {
        String sql = "UPDATE Parts SET PartName = ?, SKU = ?, StockQty = ?, ImportPrice = ?, UnitPrice = ?, MinStock = ?, WarrantyMonths = ? WHERE PartID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getPartName());
            ps.setString(2, p.getSku());
            ps.setInt(3, p.getStockQty());
            ps.setDouble(4, p.getImportPrice());
            ps.setDouble(5, p.getUnitPrice());
            ps.setInt(6, p.getMinStock());
            ps.setInt(7, p.getWarrantyMonths());
            ps.setInt(8, p.getPartID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deletePart(int id) {
        String sql = "DELETE FROM Parts WHERE PartID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PartDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    private Part mapRow(ResultSet rs) throws SQLException {
        Part p = new Part();
        p.setPartID(rs.getInt("PartID"));
        p.setPartName(rs.getString("PartName"));
        p.setSku(rs.getString("SKU"));
        p.setStockQty(rs.getInt("StockQty"));
        p.setImportPrice(rs.getDouble("ImportPrice"));
        p.setUnitPrice(rs.getDouble("UnitPrice"));
        p.setMinStock(rs.getInt("MinStock"));
        p.setWarrantyMonths(rs.getInt("WarrantyMonths"));
        return p;
    }
}
