async function login() {
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;

  const res = await fetch('/api/auth/login', {
    method: 'POST',
    credentials: 'include',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
  });

  const data = await res.json();

  if (data.user) {
    sessionStorage.setItem('userRole', data.user.role);

    document.querySelector('.container').style.display = 'none';
    //document.querySelector('.adminPanel').style.display = 'none';
    mostrarPanelPorRol(data.user.role);

    document.getElementById('rolInfo').textContent = `Rol: ${data.user.role}`;
  } else {
    alert('Login incorrecto');
  }
}
  
  function mostrarPanelPorRol(role) {
    console.log(`Mostrando panel para el rol: ${role}`);
    document.getElementById('clientePanel').style.display = role === 'cliente' ? 'block' : 'none';
    document.getElementById('vendedorPanel').style.display = role === 'vendedor' ? 'block' : 'none';
    document.getElementById('adminPanel').style.display = role === 'administrador' ? 'block' : 'none';
  }
  
  async function buscarRepuestos() {
    const nombre = document.getElementById('filtroNombre').value;
    const res = await fetch(`/api/repuestos?nombre=${encodeURIComponent(nombre)}`, {
      credentials: 'include'
    });
    const data = await res.json();
  
    const lista = document.getElementById('resultados');
    lista.innerHTML = '';
    data.forEach(rep => {
      const li = document.createElement('li');
      li.textContent = `ID:${rep.id} - ${rep.nombre} - $${rep.precio}`;
      lista.appendChild(li);
    });
  }
  
  async function comprar() {
    const repuesto_id = document.getElementById('repuestoID').value;
    const cantidad = document.getElementById('cantidad').value;
  
    const res = await fetch('/api/transacciones/comprar', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ repuesto_id, cantidad })
    });
  
    const data = await res.json();
    alert(data.message || 'Compra realizada');
  }
  
  async function verMisVentas() {
    const res = await fetch('/api/transacciones/mis-ventas', {
      credentials: 'include'
    });
    const data = await res.json();
  
    const list = document.getElementById('ventasList');
    list.innerHTML = '';
    data.forEach(v => {
      const li = document.createElement('li');
      li.textContent = `${v.repuesto} - Cant: ${v.cantidad} - Estado: ${v.estado}`;
      list.appendChild(li);
    });
  }
  
  app.post('/api/admin/crear-vendedor', async (req, res) => {
    const { name, email, password } = req.body;
  
    try {
      await connection.execute(
        'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, "vendedor")',
        [name, email, password]
      );
      res.json({ message: 'Vendedor creado correctamente' });
    } catch (err) {
      if (err.code === 'ER_DUP_ENTRY') {
        res.json({ message: 'El correo ya está registrado' });
      } else {
        console.error(err);
        res.status(500).json({ message: 'Error al crear vendedor' });
      }
    }
  });
  
  
function crearVendedor() {
  document.getElementById('modalCrearVendedor').style.display = 'flex';
}

function cerrarModal() {
  document.getElementById('modalCrearVendedor').style.display = 'none';
  document.getElementById('crearVendedorResultado').textContent = '';
}

async function enviarCrearVendedor() {
  const name = document.getElementById('vendedorNombre').value;
  const email = document.getElementById('vendedorEmail').value;
  const password = document.getElementById('vendedorPassword').value;

  const res = await fetch('/api/admin/crear-vendedor', {
    method: 'POST',
    credentials: 'include',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, email, password })
  });

  const data = await res.json();
  document.getElementById('crearVendedorResultado').textContent = data.message;

  if (data.message.includes('creado')) {
    setTimeout(() => cerrarModal(), 1500);
  }
}