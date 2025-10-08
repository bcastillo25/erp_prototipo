import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "prueba4.db";

  //Tablas
  //Users
  String users = 
  "CREATE TABLE users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, email TEXT UNIQUE, password TEXT)";
  //Productos
  String products = 
  "CREATE TABLE products (codigo TEXT PRIMARY KEY NOT NULL, producto TEXT NOT NULL, cantidad INTEGER NOT NULL, precio DECIMAL(6,2) NOT NULL, proid INTEGER NOT NULL, FOREIGN KEY(proid) REFERENCES categoria(id) ON DELETE CASCADE)";
  //Activos
  String activos = 
  "CREATE TABLE activos (codigo TEXT PRIMARY KEY NOT NULL, activo TEXT NOT NULL, ubicacion TEXT NOT NULL, fechaIng TEXT DEFAULT CURRENT_TIMESTAMP, estado TEXT NOT NULL)";
  //Proveedores
  String proveedores = 
  "CREATE TABLE proveedores (ruc TEXT PRIMARY KEY NOT NULL, empresa TEXT NOT NULL, direccion TEXT NOT NULL, email TEXT NOT NULL, telefono TEXT NOT NULL)";
  //Mantenimiento
  String mantenimiento = 
  "CREATE TABLE mantenimiento (manId INTEGER PRIMARY KEY AUTOINCREMENT, equipo TEXT NOT NULL, fechaSal TEXT DEFAULT CURRENT_TIMESTAMP, estado TEXT NOT NULL)";
  //Recursos Humanos
  String rrhh = 
  "CREATE TABLE rrhh (cedula TEXT PRIMARY KEY NOT NULL, nombre TEXT NOT NULL, cargo TEXT NOT NULL, fechaIng TEXT DEFAULT CURRENT_TIMESTAMP, salario DECIMAL(4,2) NOT NULL, estado TEXT NOT NULL)";
  //Clientes
  String clientes = 
  "CREATE TABLE clientes (cedula TEXT PRIMARY KEY NOT NULL, nombre TEXT NOT NULL, apellido TEXT NOT NULL, direccion TEXT NOT NULL, email TEXT NOT NULL, telefono TEXT NOT NULL)";
  //Categoria
  String categoria = 
  "CREATE TABLE categoria (id INTEGER PRIMARY KEY AUTOINCREMENT, categoria TEXT NOT NULL)";
  //Ventas
  String facturaventa =
  "CREATE TABLE facturaventa (id INTEGER PRIMARY KEY AUTOINCREMENT, fecha TEXT, subtotal REAL, iva REAL, total REAL, clienteid INTEGER, FOREIGN KEY(clienteid) REFERENCES clientes(cedula))";
  String facturavendet = 
  "CREATE TABLE facturavendet (id INTEGER PRIMARY KEY AUTOINCREMENT, cantidad INTEGER NOT NULL, preciouni REAL, subtotal REAL, facid INTEGER, proid INTEGER, FOREIGN KEY(facid) REFERENCES facturaventa(id) ON DELETE CASCADE, FOREIGN KEY(proid) REFERENCES products(codigo))";
  //Compras
  String facturacompra =
  "CREATE TABLE facturacompra (id INTEGER PRIMARY KEY AUTOINCREMENT, fecha TEXT, subtotal REAL, iva REAL, total REAL, provid INTEGER, FOREIGN KEY(provid) REFERENCES proveedores(ruc))";
  String facturacomdet = 
  "CREATE TABLE facturacomdet (id INTEGER PRIMARY KEY AUTOINCREMENT, cantidad INTEGER NOT NULL, preciouni REAL, subtotal REAL, facid INTEGER, proid INTEGER, FOREIGN KEY(facid) REFERENCES facturacompra(id) ON DELETE CASCADE, FOREIGN KEY(proid) REFERENCES products(codigo))";

  //Our connection is ready

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async{
      await db.execute('PRAGMA foreign_keys = ON;');
      await db.execute(users);
      await db.execute(products);
      await db.execute(activos);
      await db.execute(proveedores);
      await db.execute(mantenimiento);
      await db.execute(rrhh);
      await db.execute(clientes);
      await db.execute(categoria);
      await db.execute(facturaventa);
      await db.execute(facturavendet);
      await db.execute(facturacompra);
      await db.execute(facturacomdet);
    });
  }

  //authentication
  Future<bool> login(Users user) async{
    final Database db = await initDB();
    var res = await db.rawQuery(
      "select * from users where email = '${user.email}' AND password = '${user.password}' ");
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //email validater
  Future<bool> usuarioExiste(String email) async {
    final Database db = await initDB();
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty;
  }

  //update password
  Future<void> actualizarPassword(String email, String nuevo) async {
    final Database db = await initDB();
    await db.update('users', {'password': nuevo}, where: 'email = ?', whereArgs: [email]);
  }

  //Create user
  Future<int> createUser(Users user) async{
    final Database db = await initDB();
    return db.insert('users', user.toJson());
  }

  // Get current User
  Future<Users?> getUser(String email) async{
    final Database db = await initDB();
    var res = await db.query("users", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty? Users.fromJson(res.first):null;
  }

  //Get users
  Future<List<Users>> getUsers() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('users');
    return result.map((e) => Users.fromJson(e)).toList();
  }

  //Delete user
  Future<int> deleteUser(int id) async {
    final Database db = await initDB();
    return db.delete('users', where: 'usrId = ?', whereArgs: [id]);
  }

  //Update user
  Future<int> updateUser(password) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update users set password = ?',
      [password]
    );
  }

  Future<bool> existeCodigo(String codigo) async {
    final db = await initDB();
    final res = await db.query(
      'products', where: 'codigo = ?', whereArgs: [codigo],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  //Metodos CRUD Productos
  Future<List<Inventariodb>> searchProduct(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from products where producto LIKE ? OR proid LIKE ?", ["%$keyword%", "%$keyword%"]);
    return searchResult.map((e) => Inventariodb.fromJson(e)).toList();
  }

  Future<List<Inventariodb>> getProducts() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('products');
    return result.map((e) => Inventariodb.fromJson(e)).toList();
  }

  Future<int> createProduct(Inventariodb product) async {
    final Database db = await initDB();
    return db.insert('products', product.toJson());
  }

  Future<int> deleteProduct(String id) async {
    final Database db = await initDB();
    return db.delete('products', where: 'codigo = ?', whereArgs: [id]);
  }

  Future<int> updateProduct(producto, proid, cantidad, precio, codigo) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update products set producto = ?, proid = ?, cantidad = ?, precio = ? where codigo = ?',
      [producto, proid, cantidad, precio, codigo]
    );
  }

  Future<void> updateStock(String codigo, int stock) async{
    final Database db = await initDB();
    await db.update('products', {'cantidad': stock}, where: 'codigo = ?', whereArgs: [codigo]);
  }

  Future<List<Map<String, dynamic>>> getClientesVentas() async {
    final Database db = await initDB();
    return await db.query('clientes');
  }

  Future<List<Map<String, dynamic>>> getProveedoresCompra() async {
    final Database db = await initDB();
    return await db.query('proveedores');
  }

  // Métodos CRUD producto
  Future<List<Map<String, dynamic>>> getProductosVentas() async {
    final Database db = await initDB();
    return await db.query('products');
  }

  //Metodos CRUD Activos
    Future<List<Activosdb>> searchActivo(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from activos where activo LIKE ? OR codigo LIKE ? OR estado = LIKE ?", ["%$keyword%", "%$keyword%", "%$keyword%"]);
    return searchResult.map((e) => Activosdb.fromJson(e)).toList();
  }

  Future<int> createActivo(Activosdb activo) async {
    final Database db = await initDB();
    return db.insert('activos', activo.toJson());
  }

  Future<List<Activosdb>> getActivo() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('activos');
    return result.map((e) => Activosdb.fromJson(e)).toList();
  }

  Future<int> deleteActivo(String id) async {
    final Database db = await initDB();
    return db.delete('activos', where: 'codigo = ?', whereArgs: [id]);
  }

  Future<int> updateActivo(activo, ubicacion, fecha, estado, codigo) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update activos set activo = ?, ubicacion = ?, fechaIng = ?, estado = ? where codigo = ?',
      [activo, ubicacion, fecha, estado, codigo]
    );
  }
  //Metodos CRUD Proveedores
    Future<List<Proveedoresdb>> searchProveedores(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from proveedores where empresa LIKE ? OR ruc LIKE ?", ["%$keyword%", "%$keyword%"]);
    return searchResult.map((e) => Proveedoresdb.fromJson(e)).toList();
  }

  Future<int> createProveedores(Proveedoresdb proveedores) async {
    final Database db = await initDB();
    return db.insert('proveedores', proveedores.toJson());
  }

  Future<List<Proveedoresdb>> getProveedores() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('proveedores');
    return result.map((e) => Proveedoresdb.fromJson(e)).toList();
  }

  Future<int> deleteProveedores(String id) async {
    final Database db = await initDB();
    return db.delete('proveedores', where: 'ruc = ?', whereArgs: [id]);
  }

  Future<int> updateProveedores(empresa, direccion, email, telefono, ruc) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update proveedores set empresa = ?, direccion = ?, email = ?, telefono = ? where ruc = ?',
      [empresa, direccion, email, telefono, ruc]
    );
  }
  //Metodos CRUD Mantenimiento
    Future<List<Mantenimientodb>> searchMantenimiento(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from mantenimiento where equipo LIKE ? OR estado LIKE ?", ["%$keyword%", "%$keyword%"]);
    return searchResult.map((e) => Mantenimientodb.fromJson(e)).toList();
  }

  Future<List<Mantenimientodb>> getMantenimientos() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('mantenimiento');
    return result.map((e) => Mantenimientodb.fromJson(e)).toList();
  }

  Future<int> createMantenimiento(Mantenimientodb equipo) async {
    final Database db = await initDB();
    return db.insert('mantenimiento', equipo.toJson());
  }

  Future<int> deleteMantenimiento(int id) async {
    final Database db = await initDB();
    return db.delete('mantenimiento', where: 'manId = ?', whereArgs: [id]);
  }

  Future<int> updateMantenimiento(equipo, fechaSal, estado, manId) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update mantenimiento set equipo = ?, fechaSal = ?, estado = ? where manId = ?',
      [equipo, fechaSal, estado, manId]
    );
  }
  //Metodos CRUD Recursos Humanos
    Future<List<Rrhhdb>> searchRecursosH(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from rrhh where cedula LIKE ? OR nombre LIKE ? OR estado LIKE ?", ["%$keyword%", "%$keyword%", "%$keyword%"]);
    return searchResult.map((e) => Rrhhdb.fromJson(e)).toList();
  }

  Future<int> createRecursosH(Rrhhdb recursosH) async {
    final Database db = await initDB();
    return db.insert('rrhh', recursosH.toJson());
  }

  Future<List<Rrhhdb>> getRecursosH() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('rrhh');
    return result.map((e) => Rrhhdb.fromJson(e)).toList();
  }

  Future<int> deleteRecursosH(String id) async {
    final Database db = await initDB();
    return db.delete('rrhh', where: 'cedula = ?', whereArgs: [id]);
  }

  Future<int> updateRecursosH(nombre, cargo, salario, estado, cedula) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update rrhh set nombre = ?, cargo = ?, salario = ?, estado = ? where cedula = ?',
      [nombre, cargo, salario, estado, cedula]
    );
  }
  //Metodos CRUD Clientes
    Future<List<Clientesdb>> searchCliente(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from clientes where nombre LIKE ? OR cedula LIKE ?", ["%$keyword%", "%$keyword%"]);
    return searchResult.map((e) => Clientesdb.fromJson(e)).toList();
  }

  Future<int> createCliente(Clientesdb cliente) async {
    final Database db = await initDB();
    return db.insert('clientes', cliente.toJson());
  }

  Future<List<Clientesdb>> getCliente() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('clientes');
    return result.map((e) => Clientesdb.fromJson(e)).toList();
  }

  Future<int> deleteCliente(String id) async {
    final Database db = await initDB();
    return db.delete('clientes', where: 'cedula = ?', whereArgs: [id]);
  }

  Future<int> updateCliente(nombre, apellido, direccion, email, telefono, cedula) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update clientes set nombre = ?, apellido = ?, direccion = ?, email = ?, telefono = ? where cedula = ?',
      [nombre, apellido, direccion, email, telefono, cedula]
    );
  }
  //Metodos CRUD Categoria
    Future<List<Categoria>> searchCategoria(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from categoria where categoria LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => Categoria.fromJson(e)).toList();
  }

  Future<List<Categoria>> getCategorias() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('categoria');
    return result.map((e) => Categoria.fromJson(e)).toList();
  }

  Future<int> createCategoria(Categoria categoria) async {
    final Database db = await initDB();
    return db.insert('categoria', categoria.toJson());
  }

  Future<int> deleteCategoria(String id) async {
    final Database db = await initDB();
    return db.delete('categoria', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCategoria(categoria, id) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update categoria set categoria = ? where id = ?',
      [categoria, id]
    );
  }
  // Metodos CRUD FacturaCabecera
    Future<List<Facturaventadb>> searchFactura(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from facturaveta where id or clienteid LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => Facturaventadb.fromJson(e)).toList();
  }

  Future<List<Facturaventadb>> getFacturas() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('facturaventa');
    return result.map((e) => Facturaventadb.fromJson(e)).toList();
  }

  Future<int> createFactura(Facturaventadb factura) async {
    final Database db = await initDB();
    return db.insert('facturaventa', factura.toJson());
  }

  Future<int> deleteFactura(String id) async {
    final Database db = await initDB();
    return db.delete('facturaventa', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFactura(facturaventa, id) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update facturaventa set clienteid = ? where id = ?',
      [categoria, id]
    );
  }
  // Metodos CRUD FacturaDetalleVenta
    Future<List<Facturavendetdb>> searchFacturaDetalleVenta(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from facturavendet where id or facid LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => Facturavendetdb.fromJson(e)).toList();
  }

  Future<List<Facturavendetdb>> getFacturaDetalle() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('facturavendet');
    return result.map((e) => Facturavendetdb.fromJson(e)).toList();
  }

  Future<int> createFacturaDetalleVenta(Facturavendetdb factura) async {
    final Database db = await initDB();
    return db.insert('facturavendet', factura.toJson());
  }

  Future<int> deleteFacturaDetalleVenta(String id) async {
    final Database db = await initDB();
    return db.delete('facturavendet', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFacturaDetalleVenta(facturavendet, id) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update facturavendet set proid = ?, cantidad = ? where id = ?',
      [categoria, id]
    );
  }
  // Metodos CRUD FacturaCabeceraCompra
    Future<List<Facturacompradb>> searchFacturaCompra(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from facturacompra where id or provid LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => Facturacompradb.fromJson(e)).toList();
  }

  Future<List<Facturacompradb>> getFacturaCompra() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('facturacompra');
    return result.map((e) => Facturacompradb.fromJson(e)).toList();
  }

  Future<int> createFacturaCompra(Facturacompradb factura) async {
    final Database db = await initDB();
    return db.insert('facturacompra', factura.toJson());
  }

  Future<int> deleteFacturaCompra(String id) async {
    final Database db = await initDB();
    return db.delete('facturacompra', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFacturaCompra(facturacompra, id) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update facturacompra set provid = ? where id = ?',
      [categoria, id]
    );
  }
  // Metodos CRUD FacturaCabecera
    Future<List<Facturacomdetdb>> searchFacturaDetalleCompra(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.
      rawQuery("select * from facturacomdet where id or facid LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => Facturacomdetdb.fromJson(e)).toList();
  }

  Future<List<Facturacomdetdb>> getFacturaDetalleCompra() async {  
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('facturacomdet');
    return result.map((e) => Facturacomdetdb.fromJson(e)).toList();
  }

  Future<int> createFacturaDetalleCompra(Facturacomdetdb factura) async {
    final Database db = await initDB();
    return db.insert('facturacomdet', factura.toJson());
  }

  Future<int> deleteFacturaDetalleCompra(String id) async {
    final Database db = await initDB();
    return db.delete('facturacomdet', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFacturaDetalleCompra(facturacomdet, id) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'update facturacomdet set proid = ?, cantidad = ? where id = ?',
      [categoria, id]
    );
  }
}