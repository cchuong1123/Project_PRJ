package controllers;

import models.User;
import models.Part;
import dal.InvoiceDAO;
import dal.RepairOrderDAO;
import dal.PartDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);

        // --- Lấy số liệu thực ---
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        // 1. Doanh thu hôm nay
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        double todayRevenue = invoiceDAO.getRevenueByDateRange(today, today);
        request.setAttribute("todayRevenue", todayRevenue);

        // 2. Hóa đơn hôm nay
        int todayInvoices = invoiceDAO.getTotalInvoicesByDateRange(today, today);
        request.setAttribute("todayInvoices", todayInvoices);

        // 3. Xe đang sửa (status = "Đang sửa")
        RepairOrderDAO orderDAO = new RepairOrderDAO();
        int repairingCount = orderDAO.getOrdersByStatus("Đang sửa").size();
        request.setAttribute("repairingCount", repairingCount);

        // 4. Cảnh báo tồn kho
        PartDAO partDAO = new PartDAO();
        List<Part> allParts = partDAO.getAllParts();
        List<Part> lowStock = new ArrayList<>();
        List<Part> outOfStock = new ArrayList<>();
        for (Part p : allParts) {
            if (p.getStockQty() == 0) {
                outOfStock.add(p);
            } else if (p.getStockQty() <= p.getMinStock()) {
                lowStock.add(p);
            }
        }
        request.setAttribute("lowStockParts", lowStock);
        request.setAttribute("outOfStockParts", outOfStock);

        request.setAttribute("activePage", "dashboard");
        RequestDispatcher rd = request.getRequestDispatcher("views/dashboard.jsp");
        rd.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Dashboard Controller";
    }
}
