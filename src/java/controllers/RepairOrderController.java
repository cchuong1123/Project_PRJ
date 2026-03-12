package controllers;

import dal.*;
import models.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class RepairOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
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
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int partId = Integer.parseInt(request.getParameter("partId"));
            new OrderPartDAO().removePart(orderId, partId);
            response.sendRedirect("Orders?action=detail&id=" + orderId);
            return;
        }

        // List / Filter / Search
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        RepairOrderDAO dao = new RepairOrderDAO();
        List<RepairOrder> orders;

        if (keyword != null && !keyword.trim().isEmpty()) {
            orders = dao.searchOrders(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else if (status != null && !status.isEmpty()) {
            orders = dao.getOrdersByStatus(status);
            request.setAttribute("filterStatus", status);
        } else {
            orders = dao.getAllOrders();
        }

        // Load data for "Tạo đơn" form
        request.setAttribute("allVehicles", new VehicleDAO().getAllVehicles());
        request.setAttribute("mechanics", new UserDAO().getMechanics());
        request.setAttribute("orders", orders);

        RequestDispatcher rd = request.getRequestDispatcher("views/orders.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            RepairOrder o = new RepairOrder();
            o.setVehicleID(Integer.parseInt(request.getParameter("vehicleID")));
            o.setMechanicID(Integer.parseInt(request.getParameter("mechanicID")));
            o.setDescription(request.getParameter("description"));
            o.setLaborCost(Double.parseDouble(request.getParameter("laborCost")));
            o.setStatus("Tiếp nhận");
            new RepairOrderDAO().addOrder(o);
            response.sendRedirect("Orders");

        } else if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("orderID"));
            String newStatus = request.getParameter("newStatus");
            new RepairOrderDAO().updateStatus(id, newStatus);
            response.sendRedirect("Orders?action=detail&id=" + id);

        } else if ("addPart".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderID"));
            int partId = Integer.parseInt(request.getParameter("partID"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            // Get current unit price from Parts table
            Part part = new PartDAO().getPartById(partId);
            double price = part != null ? part.getUnitPrice() : 0;
            new OrderPartDAO().addPart(orderId, partId, qty, price);
            response.sendRedirect("Orders?action=detail&id=" + orderId);

        } else if ("createInvoice".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderID"));
            String paymentMethod = request.getParameter("paymentMethod");
            // Calculate total: labor + parts
            RepairOrder order = new RepairOrderDAO().getOrderById(orderId);
            double partsTotal = new OrderPartDAO().getTotalPartsAmount(orderId);
            double total = order.getLaborCost() + partsTotal;
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

        RequestDispatcher rd = request.getRequestDispatcher("views/order-detail.jsp");
        rd.forward(request, response);
    }
}
