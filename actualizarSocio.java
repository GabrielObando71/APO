/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import com.mycompany.gimnasio.Socio;
import com.mycompany.gimnasio.GestionarSocio;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet encargado de actualizar los datos de un socio existente
 * mediante la cédula como identificador.
 * 
 * Recibe los parámetros desde un formulario JSP y llama al método
 * GestionarSocio.actualizarSocio(...) realizando las conversiones necesarias.
 */
@WebServlet(name = "actualizarSocio", urlPatterns = {"/actualizarSocio"})
public class actualizarSocio extends HttpServlet {

    /**
     * Procesa las solicitudes (tanto GET como POST).
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================================
        // 1️⃣ - Obtener parámetros desde el formulario JSP
        // ==========================================================
        String cedula = request.getParameter("cedula");
        String nombre = request.getParameter("nombre");
        String edad = request.getParameter("edad"); // ahora es String
        String plan = request.getParameter("plan");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");
        String fechaInscripcion = request.getParameter("fechaInscripcion");
        String activoStr = request.getParameter("activo");
        String saldoStr = request.getParameter("saldoPendiente");

        // ==========================================================
        // 2️⃣ - Validar que exista el socio
        // ==========================================================
        Socio socioExistente = GestionarSocio.buscarSocio(cedula);

        if (socioExistente == null) {
            // No se encontró el socio → mensaje de error
            request.setAttribute("mensaje", "⚠️ No se encontró un socio con la cédula: " + cedula);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // ==========================================================
        // 3️⃣ - Realizar conversiones necesarias
        // ==========================================================
        boolean activo = false;
        double saldoPendiente = 0.0;

        try {
            if (saldoStr != null && !saldoStr.isEmpty()) {
                saldoPendiente = Double.parseDouble(saldoStr);
            }
            if (activoStr != null) {
                activo = Boolean.parseBoolean(activoStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error en los formatos numéricos: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // ==========================================================
        // 4️⃣ - Llamar al método de actualización con los tipos correctos
        // ==========================================================
        try {
            GestionarSocio.actualizarSocio(
                cedula,
                nombre,
                edad,  // ahora se pasa como String
                plan,
                telefono,
                correo,
                direccion,
                fechaInscripcion,
                activo,
                saldoPendiente
            );

            // ==========================================================
            // 5️⃣ - Confirmación de éxito
            // ==========================================================
            request.setAttribute("mensaje", "✅ El socio con cédula " + cedula + " fue actualizado correctamente.");
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            // ==========================================================
            // 6️⃣ - Manejo de errores
            // ==========================================================
            request.setAttribute("mensaje", "❌ Error al actualizar el socio: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    // ==========================================================
    // Métodos doGet y doPost que llaman a processRequest()
    // ==========================================================

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para actualizar la información de un socio existente.";
    }
}
