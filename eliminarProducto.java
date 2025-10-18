package Servlets;

import com.mycompany.gimnasio.GestionarProductos;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet encargado de eliminar un producto existente.
 * Recibe el código del producto por parámetro y lo elimina de la lista.
 * Redirige a productos.jsp mostrando el resultado.
 * 
 * @author Gabriel
 */
@WebServlet("/eliminarProducto")
public class eliminarProducto extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = request.getParameter("codigo");

        if (codigo == null || codigo.isEmpty()) {
            // Código no válido
            response.sendRedirect("productos.jsp?error=codigo");
            return;
        }

        boolean eliminado = GestionarProductos.eliminarProducto(codigo);

        if (eliminado) {
            response.sendRedirect("productos.jsp?exito=eliminado");
        } else {
            response.sendRedirect("productos.jsp?error=noExiste");
        }
    }
}
