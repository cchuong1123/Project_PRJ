package models;

public class Part {
    private int partID;
    private String partName;
    private String sku;
    private int stockQty;
    private double unitPrice;
    private int minStock;

    public Part() {
    }

    public Part(int partID, String partName, String sku, int stockQty, double unitPrice, int minStock) {
        this.partID = partID;
        this.partName = partName;
        this.sku = sku;
        this.stockQty = stockQty;
        this.unitPrice = unitPrice;
        this.minStock = minStock;
    }

    public int getPartID() { return partID; }
    public void setPartID(int partID) { this.partID = partID; }

    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getMinStock() { return minStock; }
    public void setMinStock(int minStock) { this.minStock = minStock; }
}
