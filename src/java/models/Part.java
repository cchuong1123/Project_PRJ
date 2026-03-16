package models;

public class Part {
    private int partID;
    private String partName;
    private String sku;
    private int stockQty;
    private double importPrice;
    private double unitPrice;
    private int minStock;
    private int warrantyMonths;

    public Part() {
    }

    public Part(int partID, String partName, String sku, int stockQty, double importPrice, double unitPrice, int minStock, int warrantyMonths) {
        this.partID = partID;
        this.partName = partName;
        this.sku = sku;
        this.stockQty = stockQty;
        this.importPrice = importPrice;
        this.unitPrice = unitPrice;
        this.minStock = minStock;
        this.warrantyMonths = warrantyMonths;
    }

    public int getPartID() { return partID; }
    public void setPartID(int partID) { this.partID = partID; }

    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public double getImportPrice() { return importPrice; }
    public void setImportPrice(double importPrice) { this.importPrice = importPrice; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getMinStock() { return minStock; }
    public void setMinStock(int minStock) { this.minStock = minStock; }

    public int getWarrantyMonths() { return warrantyMonths; }
    public void setWarrantyMonths(int warrantyMonths) { this.warrantyMonths = warrantyMonths; }
}
