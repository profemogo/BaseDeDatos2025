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
      mostrarPanelPorRol(data.user.role);
      document.querySelector('.container').style.display = 'none';
      document.getElementById('clientePanel').style.display = 'block';
      document.getElementById('rolInfo').textContent = `Rol: ${data.user.role}`;
    } else {
      alert('Login incorrecto');
    }
  }
  
  function mostrarPanelPorRol(role) {
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
  
  // Si ya está logueado
 // const savedRole = sessionStorage.getItem('userRole');
//   if (savedRole) {
//     mostrarPanelPorRol(savedRole);
//     document.querySelector('.container').style.display = 'none';
//     document.getElementById('clientePanel').style.display = 'block';
//     document.getElementById('rolInfo').textContent = `Rol: ${savedRole}`;
//   }
  