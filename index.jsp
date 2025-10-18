<%@page import="java.util.ArrayList"%>
<%@page import="com.mycompany.gimnasio.Socio"%>
<%@page import="com.mycompany.gimnasio.GestionarSocio"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Gimnasio</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            height: 100vh;
            background: #212529;
            color: white;
            padding-top: 1rem;
            position: fixed;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 0.8rem 1rem;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .sidebar a:hover {
            background: #495057;
        }
        .active {
            background: #0d6efd;
        }
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }
        .modal-content {
            border-radius: 12px;
        }
        .main-content {
            margin-left: 230px;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">

        <!-- ======================= SIDEBAR ======================= -->
        <nav class="col-md-2 sidebar d-flex flex-column">
            <h4 class="text-center mb-4"><i class="bi bi-dumbbell"></i> Gimnasio</h4>
            <a href="index.jsp" class="active"><i class="bi bi-people"></i> Socios</a>
            <a href="productos.jsp"><i class="bi bi-box-seam"></i> Productos</a>
            <a href="#"><i class="bi bi-graph-up"></i> Reportes</a>
            <a href="#"><i class="bi bi-gear"></i> Configuración</a>
        </nav>

        <!-- ======================= CONTENIDO PRINCIPAL ======================= -->
        <main class="col-md-10 offset-md-2 p-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-person-bounding-box"></i> Gestión de Socios</h2>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalAgregar">
                    <i class="bi bi-person-plus"></i> Agregar Socio
                </button>
            </div>

            <div class="table-container">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Cédula</th>
                            <th>Nombre</th>
                            <th>Edad</th>
                            <th>Plan</th>
                            <th>Teléfono</th>
                            <th>Correo</th>
                            <th>Activo</th>
                            <th>Saldo</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        ArrayList<Socio> socios = GestionarSocio.getMisSocios();
                        if (socios != null && !socios.isEmpty()) {
                            for (Socio s : socios) {
                    %>
                    <tr>
                        <td><%= s.getCedula() %></td>
                        <td><%= s.getNombre() %></td>
                        <td><%= s.getEdad() %></td>
                        <td><%= s.getPlan() %></td>
                        <td><%= s.getTelefono() %></td>
                        <td><%= s.getCorreo() %></td>
                        <td><%= s.isActivo() ? "Sí" : "No" %></td>
                        <td>$<%= s.getSaldoPendiente() %></td>
                        <td>
                            <button class="btn btn-warning btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#modalActualizar"
                                data-cedula="<%= s.getCedula() %>"
                                data-nombre="<%= s.getNombre() %>"
                                data-edad="<%= s.getEdad() %>"
                                data-plan="<%= s.getPlan() %>"
                                data-telefono="<%= s.getTelefono() %>"
                                data-correo="<%= s.getCorreo() %>"
                                data-activo="<%= s.isActivo() %>"
                                data-saldo="<%= s.getSaldoPendiente() %>">
                                <i class="bi bi-pencil-square"></i>
                            </button>

                            <button class="btn btn-danger btn-sm" onclick="confirmarEliminacion('<%= s.getCedula() %>')">
                                <i class="bi bi-trash3"></i>
                            </button>
                        </td>
                    </tr>
                    <% }} else { %>
                    <tr>
                        <td colspan="9" class="text-center text-muted">No hay socios registrados.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<!-- ======================= MODAL AGREGAR SOCIO ======================= -->
<div class="modal fade" id="modalAgregar" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <form action="agregarSocio" method="post" class="modal-content"  enctype="multipart/form-data">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title"><i class="bi bi-person-plus"></i> Agregar Socio</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-6">
            <label>Cédula:</label>
            <input class="form-control" name="cedula" required>
          </div>
          <div class="col-md-6">
            <label>Nombre:</label>
            <input class="form-control" name="nombre" required>
          </div>
          <div class="col-md-4">
            <label>Edad:</label>
            <input class="form-control" name="edad">
          </div>
          <div class="col-md-4">
            <label>Plan:</label>
            <input class="form-control" name="plan">
          </div>
          <div class="col-md-4">
            <label>Teléfono:</label>
            <input class="form-control" name="telefono">
          </div>
          <div class="col-md-6">
            <label>Correo:</label>
            <input class="form-control" type="email" name="correo">
          </div>
          <div class="col-md-6">
            <label>Dirección:</label>
            <input class="form-control" name="direccion">
          </div>
          <div class="col-md-6">
            <label>Fecha Inscripción:</label>
            <input class="form-control" type="date" name="fechaInscripcion">
          </div>
          <div class="col-md-3">
            <label>Activo:</label>
            <select class="form-select" name="activo">
              <option value="true">Sí</option>
              <option value="false">No</option>
            </select>
          </div>
          <div class="col-md-3">
            <label>Saldo Pendiente:</label>
            <input class="form-control" type="number" step="0.01" name="saldoPendiente">
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-success">Guardar</button>
      </div>
    </form>
  </div>
</div>

<!-- ======================= MODAL ACTUALIZAR ======================= -->
<div class="modal fade" id="modalActualizar" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <form action="actualizarSocio" method="post" class="modal-content" >
      <div class="modal-header bg-warning text-white">
        <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Actualizar Socio</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input id="cedulaAct" name="cedula" class="form-control mb-3" readonly>
        <div class="row g-3">
          <div class="col-md-6">
            <label>Nombre:</label>
            <input id="nombreAct" name="nombre" class="form-control">
          </div>
          <div class="col-md-3">
            <label>Edad:</label>
            <input id="edadAct" name="edad" class="form-control">
          </div>
          <div class="col-md-3">
            <label>Plan:</label>
            <input id="planAct" name="plan" class="form-control">
          </div>
          <div class="col-md-4">
            <label>Teléfono:</label>
            <input id="telefonoAct" name="telefono" class="form-control">
          </div>
          <div class="col-md-6">
            <label>Correo:</label>
            <input id="correoAct" name="correo" class="form-control">
          </div>
          <div class="col-md-2">
            <label>Activo:</label>
            <select id="activoAct" name="activo" class="form-select">
              <option value="true">Sí</option>
              <option value="false">No</option>
            </select>
          </div>
          <div class="col-md-4">
            <label>Saldo:</label>
            <input id="saldoAct" name="saldoPendiente" class="form-control">
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-warning text-white">Actualizar</button>
      </div>
    </form>
  </div>
</div>

<!-- ======================= SCRIPTS ======================= -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const modalActualizar = document.getElementById('modalActualizar');
  modalActualizar.addEventListener('show.bs.modal', event => {
    const button = event.relatedTarget;
    document.getElementById('cedulaAct').value = button.getAttribute('data-cedula');
    document.getElementById('nombreAct').value = button.getAttribute('data-nombre');
    document.getElementById('edadAct').value = button.getAttribute('data-edad');
    document.getElementById('planAct').value = button.getAttribute('data-plan');
    document.getElementById('telefonoAct').value = button.getAttribute('data-telefono');
    document.getElementById('correoAct').value = button.getAttribute('data-correo');
    document.getElementById('saldoAct').value = button.getAttribute('data-saldo');
    document.getElementById('activoAct').value = button.getAttribute('data-activo');
  });

  function confirmarEliminacion(cedula) {
    if (confirm("¿Seguro que deseas eliminar el socio con cédula " + cedula + "?")) {
      window.location.href = "eliminarSocio?cedula=" + cedula;
    }
  }
</script>

</body>
</html>
