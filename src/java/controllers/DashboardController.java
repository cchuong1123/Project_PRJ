package controllers;

import models.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

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
        request.setAttribute("activePage", "dashboard");
        RequestDispatcher rd = request.getRequestDispatcher("views/dashboard.jsp");
        rd.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Dashboard Controller";
    }
}
