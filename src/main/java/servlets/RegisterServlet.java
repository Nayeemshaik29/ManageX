package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // DB credentials
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/task_management_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "Nayeem@2003";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName"); // ✅ fixed
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            String sql = "INSERT INTO users (username, password, full_name, email, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);   // later hash with BCrypt
            ps.setString(3, fullName);
            ps.setString(4, email);
            ps.setString(5, role);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                // ✅ Registration successful
                response.sendRedirect("register.jsp?success=1");
            } else {
                // ❌ Insert failed
                response.sendRedirect("register.jsp?error=insert_failed");
            }

            con.close();
        } catch (SQLIntegrityConstraintViolationException dupEx) {
            // ⚠️ Duplicate username/email → show friendly message
            response.sendRedirect("register.jsp?error=duplicate");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=db_error");
        }
    }
}
