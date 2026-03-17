package controllers;

import dal.PartDAO;
import models.Part;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class PartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new PartDAO().deletePart(id);
            response.sendRedirect("Parts");
            return;
        }

        if ("addPart".equals(action)) {
            request.setAttribute("activePage", "parts");
            request.getRequestDispatcher("views/part-form.jsp").forward(request, response);
            return;
        }

        if ("editPart".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Part part = new PartDAO().getPartById(id);
            request.setAttribute("part", part);
            request.setAttribute("activePage", "parts");
            request.getRequestDispatcher("views/part-form.jsp").forward(request, response);
            return;
        }

        // List / Search
        String keyword = request.getParameter("keyword");
        PartDAO dao = new PartDAO();
        List<Part> allParts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            allParts = dao.searchParts(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            allParts = dao.getAllParts();
        }

        // kiem tra hang hoa
        int inStockCount = 0;
        int lowStockCount = 0;
        int outOfStockCount = 0;

        for (Part p : allParts) {
            if (p.getStockQty() == 0) {
                outOfStockCount++;
            } else if (p.getStockQty() <= p.getMinStock()) {
                lowStockCount++;
                inStockCount++;
            } else {
                inStockCount++;
            }
        }

        // Pagination (10 per page)
        int pageSize = 10;
        int totalItems = allParts.size();
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
        List<Part> parts = allParts.subList(fromIndex, toIndex);

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalParts", totalItems);

        request.setAttribute("inStockCount", inStockCount);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("outOfStockCount", outOfStockCount);

        request.setAttribute("parts", parts);
        request.setAttribute("activePage", "parts");
        RequestDispatcher rd = request.getRequestDispatcher("views/parts.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("addPart".equals(action)) {
            Part p = new Part();
            p.setPartName(request.getParameter("partName"));
            p.setSku(request.getParameter("sku"));
            p.setStockQty(Integer.parseInt(request.getParameter("stockQty")));
            p.setImportPrice(Double.parseDouble(request.getParameter("importPrice")));
            p.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
            p.setMinStock(Integer.parseInt(request.getParameter("minStock")));
            String wm = request.getParameter("warrantyMonths");
            p.setWarrantyMonths(wm != null && !wm.isEmpty() ? Integer.parseInt(wm) : 0);
            new PartDAO().addPart(p);
            response.sendRedirect("Parts");

        } else if ("editPart".equals(action)) {
            Part p = new Part();
            p.setPartID(Integer.parseInt(request.getParameter("partID")));
            p.setPartName(request.getParameter("partName"));
            p.setSku(request.getParameter("sku"));
            p.setStockQty(Integer.parseInt(request.getParameter("stockQty")));
            p.setImportPrice(Double.parseDouble(request.getParameter("importPrice")));
            p.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
            p.setMinStock(Integer.parseInt(request.getParameter("minStock")));
            String wm = request.getParameter("warrantyMonths");
            p.setWarrantyMonths(wm != null && !wm.isEmpty() ? Integer.parseInt(wm) : 0);
            new PartDAO().updatePart(p);
            response.sendRedirect("Parts");

        } else {
            response.sendRedirect("Parts");
        }
    }
}
