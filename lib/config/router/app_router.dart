import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:go_router/go_router.dart';
import 'package:erp_prototipo/presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),

    GoRoute(
      path: '/user',
      builder: (context, state) => const ViewUsers(), 
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),

    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPassword(),
    ),

    GoRoute(
      path: '/rest-password',
      builder: (context, state) => const RestPassword(),
    ),

    GoRoute(
      path: '/verifit',
      builder: (context, state) => const VerifitEmail(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
    ),

    GoRoute(
      path: '/inventario',
      builder: (context, state) => const Inventario(),
    ),
    GoRoute(
      path: '/new-inventario',
      builder: (context, state) {
        final producto = state.extra as Inventariodb?;
        return NewInventario(producto: producto);
      },
    ),

    GoRoute(
      path: '/finanzas',
      builder: (context, state) => const Finanzas(),
    ),

    GoRoute(
      path: '/ingresos',
      builder: (context, state) => const Ingresos(),
    ),

    GoRoute(
      path: '/egresos',
      builder: (context, state) => const Egresos(),
    ),

    GoRoute(
      path: '/compras',
      builder: (context, state) => const Compras(),
    ),

    GoRoute(
      path: '/new-compras',
      builder: (context, state) => const NewCompras(),
    ),

    GoRoute(
      path: '/ventas',
      builder: (context, state) => const Ventas(),
    ),

    GoRoute(
      path: '/new-ventas',
      builder: (context, state) => const NewVentas(),
    ),

    GoRoute(
      path: '/rrhh',
      builder: (context, state) => const RecursosHumanos(),
    ),

    GoRoute(
      path: '/new-rrhh',
      builder: (context, state) {
        final recursos = state.extra as Rrhhdb?;
        return NewRecursosHumanos(recursos: recursos);
      },
    ),

    GoRoute(
      path: '/activos',
      builder: (context, state) => const Activo(),
    ),

    GoRoute(
      path: '/new-activos',
      builder: (context, state) {
        final activo = state.extra as Activosdb?;
        return NewActivo(activo: activo);
      },
    ),

    GoRoute(
      path: '/clientes',
      builder: (context, state) => const Clientes(),
    ),

    GoRoute(
      path: '/new-clientes',
      builder: (context, state) {
        final cliente = state.extra as Clientesdb?;
        return NewClientes(clientes: cliente);
      },
    ),

    GoRoute(
      path: '/proveedores',
      builder: (context, state) => const Proveedores(),
    ),

    GoRoute(
      path: '/new-proveedores',
      builder: (context, state) {
        final proveedor = state.extra as Proveedoresdb?;
        return NewProveedores(proveedor: proveedor);
      },
    ),

    GoRoute(
      path: '/mantenimiento',
      builder: (context, state) => const Mantenimiento(),
    ),

    GoRoute(
      path: '/new-mantenimiento',
      builder: (context, state) {
        final mantenimiento = state.extra as Mantenimientodb?;
        return NewMantenimiento(mantenimiento: mantenimiento);
      },
    ),

    GoRoute(
      path: '/categoria',
      builder: (context, state) => const Categorias(),
    ),

    GoRoute(
      path: '/newcategoria',
      builder: (context, state) => const NewCategoria(),
    ),

]);