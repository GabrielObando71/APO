<%@ page import="java.util.ArrayList" %>
<%@ page import="com.mycompany.gimnasio.Producto" %>
<%@ page import="com.mycompany.gimnasio.GestionarProductos" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ArrayList<Producto> productos = GestionarProductos.listarProductos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Productos - Gimnasio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .sidebar {
            height: 100vh; background: #343a40; color: white; padding-top: 1rem;
        }
        .sidebar a {
            color: white; text-decoration: none; display: block; padding: 0.7rem 1rem; border-radius: 8px;
        }
        .sidebar a:hover { background: #495057; }
        .container-main { padding: 2rem; }
        .table-container {
            background: white; border-radius: 12px;
            padding: 1.5rem; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .modal-content { border-radius: 12px; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- SIDEBAR -->
        <nav class="col-md-2 sidebar d-flex flex-column">
            <h4 class="text-center mb-4"><i class="bi bi-person-bounding-box"></i> Gimnasio</h4>
            <a href="index.jsp"><i class="bi bi-house-door"></i> Inicio</a>
            <a href="productos.jsp"><i class="bi bi-bag-fill"></i> Productos</a>
            <a href="index.jsp"><i class="bi bi-people"></i> Socios</a>
        </nav>

        <!-- CONTENIDO PRINCIPAL -->
        <main class="col-md-10 container-main">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-bag-fill"></i> Gestión de Productos</h2>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalAgregar">
                    <i class="bi bi-plus-circle"></i> Agregar Producto
                </button>
            </div>

            <div class="table-container">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Precio</th>
                            <th>Cantidad</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if(productos != null && !productos.isEmpty()) {
                            for(Producto p : productos) {
                    %>
                        <tr>
                            <td><%= p.getCodigo() %></td>
                            <td><%= p.getNombre() %></td>
                            <td>$<%= p.getPrecio() %></td>
                            <td><%= p.getCantidad() %></td>
                            <td>
                                <button class="btn btn-warning btn-sm" 
                                    data-bs-toggle="modal"
                                    data-bs-target="#modalActualizar"
                                    data-codigo="<%= p.getCodigo() %>"
                                    data-nombre="<%= p.getNombre() %>"
                                    data-precio="<%= p.getPrecio() %>"
                                    data-cantidad="<%= p.getCantidad() %>">
                                    <i class="bi bi-pencil-square"></i> Editar
                                </button>
                                <button class="btn btn-danger btn-sm" 
                                    onclick="confirmarEliminacion('<%= p.getCodigo() %>')">
                                    <i class="bi bi-trash3"></i> Eliminar
                                </button>
                            </td>
                        </tr>
                    <% }} else { %>
                        <tr><td colspan="5" class="text-center">No hay productos disponibles.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<!-- MODAL AGREGAR -->
<div class="modal fade" id="modalAgregar" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form action="AgregarProducto" method="post" class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Agregar Producto</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input class="form-control mb-2" name="codigo" placeholder="Código" required>
        <input class="form-control mb-2" name="nombre" placeholder="Nombre" required>
        <input class="form-control mb-2" name="precio" placeholder="Precio" required type="number" step="0.01">
        <input class="form-control mb-2" name="cantidad" placeholder="Cantidad" required type="number">
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-success">Guardar</button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL ACTUALIZAR -->
<div class="modal fade" id="modalActualizar" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form action="ActualizarProducto" method="post" class="modal-content">
      <div class="modal-header bg-warning text-white">
        <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Actualizar Producto</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input id="codigoAct" name="codigo" class="form-control mb-2" readonly>
        <input id="nombreAct" name="nombre" class="form-control mb-2">
        <input id="precioAct" name="precio" class="form-control mb-2" type="number" step="0.01">
        <input id="cantidadAct" name="cantidad" class="form-control mb-2" type="number">
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-warning">Actualizar</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Modal actualizar
    var modalActualizar = document.getElementById('modalActualizar');
    modalActualizar.addEventListener('show.bs.modal', function(event){
        var button = event.relatedTarget;
        document.getElementById('codigoAct').value = button.getAttribute('data-codigo');
        document.getElementById('nombreAct').value = button.getAttribute('data-nombre');
        document.getElementById('precioAct').value = button.getAttribute('data-precio');
        document.getElementById('cantidadAct').value = button.getAttribute('data-cantidad');
    });

    function confirmarEliminacion(codigo){
        if(confirm("¿Seguro que deseas eliminar el producto con código " + codigo + "?")){
            window.location.href = "EliminarProducto?codigo=" + codigo;
        }
    }
</script>
</body>
</html>
