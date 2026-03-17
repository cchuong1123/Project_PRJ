package controllers;

import dal.InvoiceDAO;
import models.Invoice;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }

        String filterType = request.getParameter("filterType");
        if (filterType == null || filterType.isEmpty()) {
            filterType = "month"; // default: this month
        }

        LocalDate today = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String fromDate;
        String toDate;
        String filterLabel;

        switch (filterType) {
            case "today":
                fromDate = today.format(fmt);
                toDate = today.format(fmt);
                filterLabel = "Hôm nay (" + today.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + ")";
                break;

            case "week":
                LocalDate monday = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
                LocalDate sunday = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
                fromDate = monday.format(fmt);
                toDate = sunday.format(fmt);
                filterLabel = "Tuần này (" + monday.format(DateTimeFormatter.ofPattern("dd/MM"))
                            + " - " + sunday.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + ")";
                break;

            case "custom":
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                if (fromDate == null || fromDate.isEmpty()) {
                    fromDate = today.format(fmt);
                }
                if (toDate == null || toDate.isEmpty()) {
                    toDate = today.format(fmt);
                }
                LocalDate from = LocalDate.parse(fromDate);
                LocalDate to = LocalDate.parse(toDate);
                filterLabel = "Từ " + from.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                            + " đến " + to.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                break;

            case "month":
            default:
                filterType = "month";
                String yearParam = request.getParameter("year");
                String monthParam = request.getParameter("month");
                int year = (yearParam != null && !yearParam.isEmpty()) ? Integer.parseInt(yearParam) : today.getYear();
                int month = (monthParam != null && !monthParam.isEmpty()) ? Integer.parseInt(monthParam) : today.getMonthValue();
                LocalDate firstDay = LocalDate.of(year, month, 1);
                LocalDate lastDay = firstDay.with(TemporalAdjusters.lastDayOfMonth());
                fromDate = firstDay.format(fmt);
                toDate = lastDay.format(fmt);
                filterLabel = "Tháng " + month + "/" + year;
                break;
        }

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        double revenue = invoiceDAO.getRevenueByDateRange(fromDate, toDate);
        int totalInvoices = invoiceDAO.getTotalInvoicesByDateRange(fromDate, toDate);
        List<Invoice> invoices = invoiceDAO.getInvoicesByDateRange(fromDate, toDate);
        double avgRevenue = totalInvoices > 0 ? revenue / totalInvoices : 0;

        request.setAttribute("revenue", revenue);
        request.setAttribute("totalInvoices", totalInvoices);
        request.setAttribute("avgRevenue", avgRevenue);
        request.setAttribute("invoices", invoices);
        request.setAttribute("filterType", filterType);
        request.setAttribute("filterLabel", filterLabel);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("activePage", "reports");

        RequestDispatcher rd = request.getRequestDispatcher("views/reports.jsp");
        rd.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Report Controller";
    }
}
