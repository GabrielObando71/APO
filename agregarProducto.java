package servlets;

import com.mycompany.gimnasio.Producto;
import com.mycompany.gimnasio.GestionarProductos;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet que maneja la creación de nuevos productos en el sistema.
 *
 * @author Gabriel
 */
@WebServlet("/AgregarProducto")
public class agregarProducto extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Capturamos los datos enviados desde el formulario ---
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");

        // Validación básica
        if (codigo == null || nombre == null || precioStr == null || codigo.isEmpty() || nombre.isEmpty()) {
            response.sendRedirect("productos.jsp?error=campos");
            return;
        }

        try {
            double precio = Double.parseDouble(precioStr);

            // Creamos el nuevo producto
            Producto nuevo = new Producto(codigo, nombre, precio);

            // Intentamos agregarlo
            boolean agregado = GestionarProductos.agregarProducto(nuevo);

            if (agregado) {
                response.sendRedirect("productos.jsp?exito=agregado");
            } else {
                response.sendRedirect("productos.jsp?error=existe");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("productos.jsp?error=precio");
        }
    }
}
