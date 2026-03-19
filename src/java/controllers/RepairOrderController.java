package controllers;

import dal.*;
import models.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public class RepairOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            models.User u = (models.User) request.getSession().getAttribute("user");
            if (u != null && "mechanic".equals(u.getRole())) {
                response.sendRedirect("Orders");
                return;
            }
            int id = Integer.parseInt(request.getParameter("id"));
            new RepairOrderDAO().deleteOrder(id);
            response.sendRedirect("Orders");
            return;
        }

        if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            showDetail(request, response, id);
            return;
        }

        if ("removePart".equals(action)) {
            models.User u = (models.User) request.getSession().getAttribute("user");
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            if (u != null && "mechanic".equals(u.getRole())) {
                response.sendRedirect("Orders?action=detail&id=" + orderId);
                return;
            }
            int partId = Integer.parseInt(request.getParameter("partId"));
            new OrderPartDAO().removePart(orderId, partId);
            response.sendRedirect("Orders?action=detail&id=" + orderId);
            return;
        }

        if ("createOrder".equals(action)) {
            models.User u = (models.User) request.getSession().getAttribute("user");
            if (u != null && "mechanic".equals(u.getRole())) {
                response.sendRedirect("Orders");
                return;
            }
            request.setAttribute("allVehicles", new VehicleDAO().getAllVehicles());
            request.setAttribute("mechanics", new UserDAO().getMechanics());
            request.setAttribute("activePage", "orders");
            request.getRequestDispatcher("views/order-form.jsp").forward(request, response);
            return;
        }

        if ("addPart".equals(action)) {
            String orderId = request.getParameter("orderId");
            models.User u = (models.User) request.getSession().getAttribute("user");
            if (u != null && "mechanic".equals(u.getRole())) {
                response.sendRedirect("Orders?action=detail&id=" + orderId);
                return;
            }
            request.setAttribute("orderID", orderId);
            request.setAttribute("allParts", new PartDAO().getAllParts());
            request.setAttribute("activePage", "orders");
            request.getRequestDispatcher("views/order-add-part.jsp").forward(request, response);
            return;
        }

        // List / Filter / Search
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        RepairOrderDAO dao = new RepairOrderDAO();
        List<RepairOrder> allOrders;

        if (keyword != null && !keyword.trim().isEmpty()) {
            allOrders = dao.searchOrders(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else if (status != null && !status.isEmpty()) {
            allOrders = dao.getOrdersByStatus(status);
            request.setAttribute("filterStatus", status);
        } else {
            allOrders = dao.getAllOrders();
        }

        // Mechanic logic: Only see their own assigned orders
        models.User u = (models.User) request.getSession().getAttribute("user");
        if (u != null && "mechanic".equals(u.getRole())) {
            int myMechanicId = u.getUserID();
            allOrders = allOrders.stream()
                    .filter(o -> o.getMechanicID() == myMechanicId)
                    .collect(java.util.stream.Collectors.toList());
        }

        // Pagination (10 per page)
        int pageSize = 10;
        int totalItems = allOrders.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1)
            totalPages = 1;

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                /* ignore */ }
        }
        if (currentPage < 1)
            currentPage = 1;
        if (currentPage > totalPages)
            currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<RepairOrder> orders = allOrders.subList(fromIndex, toIndex);

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalItems);

        request.setAttribute("orders", orders);
        request.setAttribute("activePage", "orders");

        RequestDispatcher rd = request.getRequestDispatcher("views/orders.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            models.User u = (models.User) request.getSession().getAttribute("user");
            if (u != null && "mechanic".equals(u.getRole())) {
                response.sendRedirect("Orders");
                return;
            }
            RepairOrder o = new RepairOrder();
            o.setVehicleID(Integer.parseInt(request.getParameter("vehicleID")));
            o.setMechanicID(Integer.parseInt(request.getParameter("mechanicID")));
            o.setDescription(request.getParameter("description"));
            o.setLaborCost(0);
            o.setStatus("Tiếp nhận");
            if (u != null) {
                o.setCreatedBy(u.getUserID());
            }
            new RepairOrderDAO().addOrder(o);
            response.sendRedirect("Orders");

        } else if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("orderID"));
            String newStatus = request.getParameter("newStatus");
            models.User u = (models.User) request.getSession().getAttribute("user");
            if (u != null && "mechanic".equals(u.getRole()) && "Hoàn thành".equals(newStatus)) {
                response.sendRedirect("Orders?action=detail&id=" + id);
                return;
            }
            new RepairOrderDAO().updateStatus(id, newStatus);
            response.sendRedirect("Orders?action=detail&id=" + id);

        } else if ("addPart".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderID"));
            models.User u = (models.User) request.getSession().getAttribute("user");
            if (u != null && "mechanic".equals(u.getRole())) {
                response.sendRedirect("Orders?action=detail&id=" + orderId);
                return;
            }
            int partId = Integer.parseInt(request.getParameter("partID"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            // Get current unit price and warranty months from Parts table
            Part part = new PartDAO().getPartById(partId);
            // Backend stock validation
            if (part == null || qty > part.getStockQty()) {
                response.sendRedirect("Orders?action=detail&id=" + orderId);
                return;
            }
            double price = part.getUnitPrice();
            // Auto-calculate warranty end date
            String warrantyEndDate = null;
            if (part.getWarrantyMonths() > 0) {
                warrantyEndDate = LocalDate.now().plusMonths(part.getWarrantyMonths()).toString();
            }
            new OrderPartDAO().addPart(orderId, partId, qty, price, warrantyEndDate);
            response.sendRedirect("Orders?action=detail&id=" + orderId);

        } else if ("updateWarranty".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderID"));
            int partId = Integer.parseInt(request.getParameter("partID"));
            String warrantyEndDate = request.getParameter("warrantyEndDate");
            new OrderPartDAO().updateWarrantyEndDate(orderId, partId, warrantyEndDate);
            response.sendRedirect("Orders?action=detail&id=" + orderId);

        } else if ("createInvoice".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderID"));
            String paymentMethod = request.getParameter("paymentMethod");
            double laborCost = Double.parseDouble(request.getParameter("laborCost"));
            // Update laborCost on the order
            RepairOrder order = new RepairOrderDAO().getOrderById(orderId);
            order.setLaborCost(laborCost);
            new RepairOrderDAO().updateOrder(order);
            // Calculate total: labor + parts
            double partsTotal = new OrderPartDAO().getTotalPartsAmount(orderId);
            double total = laborCost + partsTotal;
            new InvoiceDAO().createInvoice(orderId, total, paymentMethod);
            // Auto update status to "Hoàn thành"
            new RepairOrderDAO().updateStatus(orderId, "Hoàn thành");
            response.sendRedirect("Orders?action=detail&id=" + orderId);

        } else if ("updateOrder".equals(action)) {
            RepairOrder o = new RepairOrder();
            o.setOrderID(Integer.parseInt(request.getParameter("orderID")));
            o.setVehicleID(Integer.parseInt(request.getParameter("vehicleID")));
            o.setMechanicID(Integer.parseInt(request.getParameter("mechanicID")));
            o.setDescription(request.getParameter("description"));
            o.setLaborCost(Double.parseDouble(request.getParameter("laborCost")));
            new RepairOrderDAO().updateOrder(o);
            response.sendRedirect("Orders?action=detail&id=" + o.getOrderID());

        } else {
            response.sendRedirect("Orders");
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws ServletException, IOException {
        RepairOrder order = new RepairOrderDAO().getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("Orders");
            return;
        }
        List<OrderPart> orderParts = new OrderPartDAO().getPartsByOrder(orderId);
        double partsTotal = new OrderPartDAO().getTotalPartsAmount(orderId);
        Invoice invoice = new InvoiceDAO().getByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderParts", orderParts);
        request.setAttribute("partsTotal", partsTotal);
        request.setAttribute("grandTotal", order.getLaborCost() + partsTotal);
        request.setAttribute("invoice", invoice);
        request.setAttribute("allParts", new PartDAO().getAllParts());
        request.setAttribute("allVehicles", new VehicleDAO().getAllVehicles());
        request.setAttribute("mechanics", new UserDAO().getMechanics());

        request.setAttribute("activePage", "order-detail");
        RequestDispatcher rd = request.getRequestDispatcher("views/order-detail.jsp");
        rd.forward(request, response);
    }
}
