package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.mycompany.gimnasio.Socio;
import com.mycompany.gimnasio.GestionarSocio;

/**
 * Servlet encargado de eliminar un socio.
 * Este servlet permite eliminar un socio de la lista de socios usando su número de cédula.
 * Cuando se llama al servlet con un método GET y se envía un parámetro `cedula` del socio,
 * este es eliminado mediante la clase `GestionarSocio`.
 */
@WebServlet(name = "eliminarSocio", urlPatterns = {"/eliminarSocio"})
public class eliminarSocio extends HttpServlet {

    /**
     * Procesa las solicitudes generales que llegan al servlet.
     * Este método se llama cuando se inicia el servlet, pero en este caso solo
     * establece el tipo de contenido de la respuesta en HTML con codificación UTF-8.
     *
     * @param request  El objeto HttpServletRequest que contiene la solicitud del cliente
     * @param response El objeto HttpServletResponse que contiene la respuesta al cliente
     * @throws ServletException Si ocurre un error en el procesamiento del servlet
     * @throws IOException      Si ocurre un error de entrada/salida
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    /**
     * Maneja las solicitudes GET para eliminar un socio mediante su cédula.
     * Obtiene la cédula del socio desde los parámetros de la solicitud, llama al método de eliminación
     * en la clase `GestionarSocio` y redirige al usuario a la página principal.
     *
     * @param request  El objeto HttpServletRequest que contiene los datos enviados por el cliente
     * @param response El objeto HttpServletResponse utilizado para enviar la respuesta al cliente
     * @throws ServletException En caso de que ocurra un error en el procesamiento del servlet
     * @throws IOException      En caso de que ocurra un error de entrada/salida
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Llama al método processRequest para configuraciones iniciales (opcional)
        processRequest(request, response);

        // 1. Obtiene la cédula del socio desde los parámetros de la solicitud
        String cedula = request.getParameter("cedula");

        // 2. Llama al método `eliminarSocioPorCedula` de la clase `GestionarSocio` para eliminar el socio
        GestionarSocio.eliminarSocio(cedula);

        // 3. Indica que la acción de eliminación se realizó exitosamente al establecer un atributo en la solicitud
        request.setAttribute("accionEliminar", "true");

        // 4. Redirige al usuario de vuelta a la página principal (index.jsp) después de la eliminación
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
