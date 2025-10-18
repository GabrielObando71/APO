package servlets;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.mycompany.gimnasio.Socio;
import com.mycompany.gimnasio.GestionarSocio;

/**
 * Servlet para agregar un nuevo socio al gimnasio.
 * Este servlet recibe los datos desde un formulario JSP, guarda la imagen del socio (si existe)
 * y agrega la información al ArrayList gestionado por la clase gestionarSocio.
 */
@WebServlet(name = "agregarSocio", urlPatterns = {"/agregarSocio"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,  // Umbral de archivo: 2MB
        maxFileSize = 1024 * 1024 * 10,                // Tamaño máximo de archivo: 10MB
        maxRequestSize = 1024 * 1024 * 50)             // Tamaño máximo de solicitud: 50MB
public class agregarSocio extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Maneja las solicitudes POST enviadas desde un formulario JSP.
     * Este método valida los datos, guarda la imagen en el servidor,
     * evita duplicaciones por cédula y agrega el nuevo socio al sistema.
     *
     * @param request  Objeto HttpServletRequest con los datos del formulario.
     * @param response Objeto HttpServletResponse para enviar respuesta al cliente.
     * @throws ServletException Si ocurre un error en el procesamiento del servlet.
     * @throws IOException Si ocurre un error de entrada/salida.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Obtener los parámetros del formulario
        String nombre = request.getParameter("nombre");
        String edad = request.getParameter("edad");
        String plan = request.getParameter("plan");
        String cedula = request.getParameter("cedula");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");
        String fechaInscripcion = request.getParameter("fechaInscripcion");
        boolean activo = request.getParameter("activo") != null;
        double saldoPendiente = Double.parseDouble(request.getParameter("saldoPendiente"));
        Part filePart = request.getPart("imagen"); // Imagen del socio (opcional)

        // 2️⃣ Guardar la imagen (si el usuario cargó una)
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "imagenes";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            File file = new File(uploadDir, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // 3️⃣ Obtener la lista de socios
        ArrayList<Socio> misSocios = GestionarSocio.getMisSocios();

        // 4️⃣ Validar duplicación por cédula
        for (Socio s : misSocios) {
            if (s.getCedula().equals(cedula)) {
                // Enviar mensaje de error al JSP si la cédula ya existe
                request.setAttribute("accionDuplicacionCedula", "true");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
        }

        // 5️⃣ Agregar el nuevo socio
        GestionarSocio.agregarSocio(nombre, edad, plan, cedula, telefono, correo,
                                    direccion, fechaInscripcion, activo, saldoPendiente);

        // 6️⃣ Establecer bandera de éxito
        request.setAttribute("accionAgregar", "true");

        // 7️⃣ Redirigir al JSP principal
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
