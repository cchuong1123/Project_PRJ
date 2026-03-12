package models;

public class Vehicle {
    private int vehicleID;
    private int customerID;
    private String licensePlate;
    private String brand;
    private String model;
    private int manufactureYear;
    private String customerName; // JOIN field

    public Vehicle() {
    }

    public Vehicle(int vehicleID, int customerID, String licensePlate, String brand, String model, int manufactureYear) {
        this.vehicleID = vehicleID;
        this.customerID = customerID;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.manufactureYear = manufactureYear;
    }

    public int getVehicleID() { return vehicleID; }
    public void setVehicleID(int vehicleID) { this.vehicleID = vehicleID; }

    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public int getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(int manufactureYear) { this.manufactureYear = manufactureYear; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
}
