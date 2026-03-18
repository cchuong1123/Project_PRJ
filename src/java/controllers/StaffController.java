package controllers;

import dal.UserDAO;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class StaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = dao.getUserById(id);
            request.setAttribute("editUser", user);
            request.setAttribute("activePage", "staff");
            request.getRequestDispatcher("views/staff-form.jsp").forward(request, response);
            return;
        }

        if ("add".equals(action)) {
            request.setAttribute("activePage", "staff");
            request.getRequestDispatcher("views/staff-form.jsp").forward(request, response);
            return;
        }

        // Default: list all users
        List<User> allUsers = dao.getAllUsers();

        // Pagination (10 per page)
        int pageSize = 10;
        int totalItems = allUsers.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) { /* ignore */ }
        }
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<User> users = allUsers.subList(fromIndex, toIndex);

        request.setAttribute("users", users);
        request.setAttribute("totalUsers", totalItems);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("activePage", "staff");
        request.getRequestDispatcher("views/staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("add".equals(action)) {
            String username = request.getParameter("username");
            // Check duplicate username
            if (dao.getUserByUsername(username) != null) {
                response.sendRedirect("Staff?error=username_exists");
                return;
            }
            User u = new User();
            u.setUsername(username);
            u.setPassword(request.getParameter("password"));
            u.setFullName(request.getParameter("fullName"));
            u.setRole(request.getParameter("role"));
            u.setIsActive(true);
            String hireDateStr = request.getParameter("hireDate");
            if (hireDateStr != null && !hireDateStr.isEmpty()) {
                u.setHireDate(Date.valueOf(hireDateStr));
            } else {
                u.setHireDate(new Date(System.currentTimeMillis()));
            }
            dao.addUser(u);
            response.sendRedirect("Staff");

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("userID"));
            User u = new User();
            u.setUserID(id);
            u.setFullName(request.getParameter("fullName"));
            u.setRole(request.getParameter("role"));
            String hireDateStr = request.getParameter("hireDate");
            if (hireDateStr != null && !hireDateStr.isEmpty()) {
                u.setHireDate(Date.valueOf(hireDateStr));
            }
            dao.updateUser(u);
            response.sendRedirect("Staff");

        } else if ("toggleActive".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean currentActive = Boolean.parseBoolean(request.getParameter("currentActive"));

            // Prevent locking own account
            User sessionUser = (User) request.getSession().getAttribute("user");
            if (sessionUser != null && sessionUser.getUserID() == id) {
                response.sendRedirect("Staff");
                return;
            }

            dao.toggleActive(id, !currentActive);
            response.sendRedirect("Staff");

        } else {
            response.sendRedirect("Staff");
        }
    }
}
