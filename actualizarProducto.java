package Servlets;

import com.mycompany.gimnasio.Producto;
import com.mycompany.gimnasio.GestionarProductos;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/ActualizarProducto")
public class actualizarProducto extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String cantidadStr = request.getParameter("cantidad");

        if (codigo == null || codigo.isEmpty() ||
            nombre == null || nombre.isEmpty() ||
            precioStr == null || precioStr.isEmpty()) {

            response.sendRedirect("productos.jsp?error=campos");
            return;
        }

        try {
            double precio = Double.parseDouble(precioStr);
            int cantidad = (cantidadStr != null && !cantidadStr.isEmpty())
                    ? Integer.parseInt(cantidadStr)
                    : 1;

            Producto producto = new Producto(codigo, nombre, precio);
            producto.setCantidad(cantidad);

            boolean actualizado = GestionarProductos.actualizarProducto(producto);

            if (actualizado) {
                response.sendRedirect("productos.jsp?exito=actualizado");
            } else {
                response.sendRedirect("productos.jsp?error=noExiste");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("productos.jsp?error=precio");
        }
    }
}