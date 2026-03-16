package models;

public class OrderPart {
    private int orderID;
    private int partID;
    private int quantity;
    private double unitPrice;
    private String warrantyEndDate; // yyyy-MM-dd

    // JOIN fields
    private String partName;
    private String sku;
    private int warrantyMonths; // from Parts table

    public OrderPart() {
    }

    public int getOrderID() { return orderID; }
    public void setOrderID(int orderID) { this.orderID = orderID; }

    public int getPartID() { return partID; }
    public void setPartID(int partID) { this.partID = partID; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public String getWarrantyEndDate() { return warrantyEndDate; }
    public void setWarrantyEndDate(String warrantyEndDate) { this.warrantyEndDate = warrantyEndDate; }

    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public int getWarrantyMonths() { return warrantyMonths; }
    public void setWarrantyMonths(int warrantyMonths) { this.warrantyMonths = warrantyMonths; }

    public double getTotal() { return quantity * unitPrice; }
}
