package controllers;

import dal.CustomerDAO;
import dal.VehicleDAO;
import models.Customer;
import models.Vehicle;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class CustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new CustomerDAO().deleteCustomer(id);
            response.sendRedirect("Customers");
            return;
        }

        if ("deleteVehicle".equals(action)) {
            int vid = Integer.parseInt(request.getParameter("vid"));
            int cid = Integer.parseInt(request.getParameter("cid"));
            new VehicleDAO().deleteVehicle(vid);
            response.sendRedirect("Customers?expandId=" + cid);
            return;
        }

        // List / Search
        String keyword = request.getParameter("keyword");
        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers;
        if (keyword != null && !keyword.trim().isEmpty()) {
            customers = dao.searchCustomers(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            customers = dao.getAllCustomers();
        }

        // Load vehicles for expanded customer
        String expandIdStr = request.getParameter("expandId");
        if (expandIdStr != null) {
            int expandId = Integer.parseInt(expandIdStr);
            List<Vehicle> vehicles = new VehicleDAO().getVehiclesByCustomer(expandId);
            request.setAttribute("expandId", expandId);
            request.setAttribute("vehicles", vehicles);
        }

        request.setAttribute("customers", customers);
        RequestDispatcher rd = request.getRequestDispatcher("views/customers.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("addCustomer".equals(action)) {
            Customer c = new Customer();
            c.setFullName(request.getParameter("fullName"));
            c.setPhone(request.getParameter("phone"));
            c.setAddress(request.getParameter("address"));
            c.setEmail(request.getParameter("email"));
            new CustomerDAO().addCustomer(c);
            response.sendRedirect("Customers");

        } else if ("editCustomer".equals(action)) {
            Customer c = new Customer();
            c.setCustomerID(Integer.parseInt(request.getParameter("customerID")));
            c.setFullName(request.getParameter("fullName"));
            c.setPhone(request.getParameter("phone"));
            c.setAddress(request.getParameter("address"));
            c.setEmail(request.getParameter("email"));
            new CustomerDAO().updateCustomer(c);
            response.sendRedirect("Customers");

        } else if ("addVehicle".equals(action)) {
            int cid = Integer.parseInt(request.getParameter("customerID"));
            Vehicle v = new Vehicle();
            v.setCustomerID(cid);
            v.setLicensePlate(request.getParameter("licensePlate"));
            v.setBrand(request.getParameter("brand"));
            v.setModel(request.getParameter("model"));
            v.setManufactureYear(Integer.parseInt(request.getParameter("manufactureYear")));
            new VehicleDAO().addVehicle(v);
            response.sendRedirect("Customers?expandId=" + cid);

        } else if ("editVehicle".equals(action)) {
            int cid = Integer.parseInt(request.getParameter("customerID"));
            Vehicle v = new Vehicle();
            v.setVehicleID(Integer.parseInt(request.getParameter("vehicleID")));
            v.setLicensePlate(request.getParameter("licensePlate"));
            v.setBrand(request.getParameter("brand"));
            v.setModel(request.getParameter("model"));
            v.setManufactureYear(Integer.parseInt(request.getParameter("manufactureYear")));
            new VehicleDAO().updateVehicle(v);
            response.sendRedirect("Customers?expandId=" + cid);

        } else {
            response.sendRedirect("Customers");
        }
    }
}
