package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import models.User;

public class AuthFilter implements Filter {

    // role -> list of BLOCKED URLs
    private static final Map<String, List<String>> BLOCKED = new HashMap<>();

    static {
        BLOCKED.put("mechanic", Arrays.asList("/Customers", "/Parts", "/Reports", "/Staff", "/Dashboard"));
        BLOCKED.put("staff", Arrays.asList("/Reports", "/Staff"));
        // admin: no restrictions
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (!isLoggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login");
            return;
        }

        // Role-based access check
        User user = (User) session.getAttribute("user");
        String role = user.getRole();
        String uri = httpRequest.getServletPath(); // e.g. "/Reports"

        List<String> blockedUrls = BLOCKED.get(role);
        if (blockedUrls != null && blockedUrls.contains(uri)) {
            if ("mechanic".equals(role)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/Orders");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/Dashboard");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
