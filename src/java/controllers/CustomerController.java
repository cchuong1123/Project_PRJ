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

        if ("addCustomer".equals(action)) {
            request.setAttribute("activePage", "customers");
            request.getRequestDispatcher("views/customer-form.jsp").forward(request, response);
            return;
        }

        if ("editCustomer".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer customer = new CustomerDAO().getCustomerById(id);
            request.setAttribute("customer", customer);
            request.setAttribute("activePage", "customers");
            request.getRequestDispatcher("views/customer-form.jsp").forward(request, response);
            return;
        }

        if ("addVehicle".equals(action)) {
            request.setAttribute("customerID", request.getParameter("cid"));
            request.setAttribute("activePage", "customers");
            request.getRequestDispatcher("views/vehicle-form.jsp").forward(request, response);
            return;
        }

        if ("editVehicle".equals(action)) {
            int vid = Integer.parseInt(request.getParameter("vid"));
            Vehicle vehicle = new VehicleDAO().getVehicleById(vid);
            request.setAttribute("vehicle", vehicle);
            request.setAttribute("customerID", request.getParameter("cid"));
            request.setAttribute("activePage", "customers");
            request.getRequestDispatcher("views/vehicle-form.jsp").forward(request, response);
            return;
        }

        // List / Search
        String keyword = request.getParameter("keyword");
        CustomerDAO dao = new CustomerDAO();
        List<Customer> allCustomers;
        if (keyword != null && !keyword.trim().isEmpty()) {
            allCustomers = dao.searchCustomers(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            allCustomers = dao.getAllCustomers();
        }

        // Pagination (10 per page)
        int pageSize = 10;
        int totalItems = allCustomers.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                /* ignore */ }
        }
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<Customer> customers = allCustomers.subList(fromIndex, toIndex);

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCustomers", totalItems);

        // Load vehicles for expanded customer
        String expandIdStr = request.getParameter("expandId");
        if (expandIdStr != null) {
            int expandId = Integer.parseInt(expandIdStr);
            List<Vehicle> vehicles = new VehicleDAO().getVehiclesByCustomer(expandId);
            request.setAttribute("expandId", expandId);
            request.setAttribute("vehicles", vehicles);
        }

        request.setAttribute("customers", customers);
        request.setAttribute("activePage", "customers");
        RequestDispatcher rd = request.getRequestDispatcher("views/customers.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("addCustomer".equals(action)) {
            String phone = request.getParameter("phone");
            CustomerDAO custDao = new CustomerDAO();
            // Check duplicate phone
            Customer existing = custDao.getCustomerByPhone(phone);
            if (existing != null) {
                response.sendRedirect("Customers?error=phone_exists");
                return;
            }
            Customer c = new Customer();
            c.setFullName(request.getParameter("fullName"));
            c.setPhone(phone);
            c.setAddress(request.getParameter("address"));
            c.setEmail(request.getParameter("email"));
            custDao.addCustomer(c);
            response.sendRedirect("Customers");

        } else if ("editCustomer".equals(action)) {
            int customerId = Integer.parseInt(request.getParameter("customerID"));
            String phone = request.getParameter("phone");
            CustomerDAO custDao = new CustomerDAO();
            // Check duplicate phone (exclude self)
            Customer existing = custDao.getCustomerByPhone(phone);
            if (existing != null && existing.getCustomerID() != customerId) {
                response.sendRedirect("Customers?error=phone_exists");
                return;
            }
            Customer c = new Customer();
            c.setCustomerID(customerId);
            c.setFullName(request.getParameter("fullName"));
            c.setPhone(phone);
            c.setAddress(request.getParameter("address"));
            c.setEmail(request.getParameter("email"));
            custDao.updateCustomer(c);
            response.sendRedirect("Customers");

        } else if ("addVehicle".equals(action)) {
            int cid = Integer.parseInt(request.getParameter("customerID"));
            String plate = request.getParameter("licensePlate");
            VehicleDAO vehDao = new VehicleDAO();
            // Check duplicate plate
            Vehicle existingV = vehDao.getVehicleByPlate(plate);
            if (existingV != null) {
                response.sendRedirect("Customers?expandId=" + cid + "&error=plate_exists");
                return;
            }
            Vehicle v = new Vehicle();
            v.setCustomerID(cid);
            v.setLicensePlate(plate);
            v.setBrand(request.getParameter("brand"));
            v.setModel(request.getParameter("model"));
            v.setManufactureYear(Integer.parseInt(request.getParameter("manufactureYear")));
            vehDao.addVehicle(v);
            response.sendRedirect("Customers?expandId=" + cid);

        } else if ("editVehicle".equals(action)) {
            int cid = Integer.parseInt(request.getParameter("customerID"));
            int vid = Integer.parseInt(request.getParameter("vehicleID"));
            String plate = request.getParameter("licensePlate");
            VehicleDAO vehDao = new VehicleDAO();
            // Check duplicate plate (exclude self)
            Vehicle existingV = vehDao.getVehicleByPlate(plate);
            if (existingV != null && existingV.getVehicleID() != vid) {
                response.sendRedirect("Customers?expandId=" + cid + "&error=plate_exists");
                return;
            }
            Vehicle v = new Vehicle();
            v.setVehicleID(vid);
            v.setLicensePlate(plate);
            v.setBrand(request.getParameter("brand"));
            v.setModel(request.getParameter("model"));
            v.setManufactureYear(Integer.parseInt(request.getParameter("manufactureYear")));
            vehDao.updateVehicle(v);
            response.sendRedirect("Customers?expandId=" + cid);

        } else {
            response.sendRedirect("Customers");
        }
    }
}
