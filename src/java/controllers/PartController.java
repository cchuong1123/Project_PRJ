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

        // List / Search
        String keyword = request.getParameter("keyword");
        PartDAO dao = new PartDAO();
        List<Part> parts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            parts = dao.searchParts(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            parts = dao.getAllParts();
        }

        request.setAttribute("parts", parts);
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
