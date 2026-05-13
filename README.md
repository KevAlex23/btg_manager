# BTG - Administrador de Fondos

Proyecto desarrollado en Flutter para la gestión simulada de fondos de inversión. La aplicación permite visualizar saldos, suscribirse o cancelar fondos, y revisar el historial de transacciones. 

## Arquitectura

Se implementó **Clean Architecture** para separar claramente las responsabilidades del código y facilitar el mantenimiento a futuro.

*   `domain/`: Contiene la lógica de negocio pura. Entidades principales (`Fund`, `Transaction`, `UserBalance`) y los contratos/interfaces de los repositorios.
*   `data/`: Implementación de los repositorios. Como no hay un backend real conectado, se construyó un `MockApiAdapter` que utiliza un singleton (`LocalStorageMock`) para simular persistencia en memoria, latencia de red controlada e IDs únicos usando `uuid`.
*   `presentation/`: Toda la capa visual, dividida meticulosamente entre pantallas (`screens`) y componentes reutilizables (`widgets`).

## Manejo de Estado

Se usó el patrón **BLoC** (Business Logic Component) mediante el paquete `flutter_bloc`. Los flujos están divididos en tres blocs principales para no mezclar dependencias:
1.  `BalanceBloc`: Controla la carga y actualización del saldo general.
2.  `FundBloc`: Maneja la lista de fondos disponibles y la lógica de validación para suscribirse o cancelar.
3.  `TransactionBloc`: Registra y provee la lista de movimientos luego de cada acción.

La inyección de dependencias (repositorios y blocs) se maneja globalmente en la raíz del proyecto usando `get_it`.

## Interfaz y Diseño (UI/UX)

La aplicación fue construida sin depender de librerías de UI externas pesadas, armando un sistema de diseño propio basado en componentes:

*   **Responsividad:** Se usó `MediaQuery` para adaptar los grids y las tablas de historial. El diseño pasa de filas (Row) en escritorio a columnas (Column) en algunas vistas, asegurando que se vea bien en mobile, tablet y web.
*   **Colores y Tema:** En lugar de colores quemados en el código, se creó una clase estática `AppColors` inspirada en escalas de grises y colores semánticos, estandarizando toda la vista.
*   **Navegación:** `go_router` para manejo de rutas limpias, especialmente útil si se compila para Web.
*   **Alertas:** `alert_info` para notificar de manera sencilla los eventos de suscripción.

## Para ejecutarlo

1. Clonar el repositorio.
2. Ejecutar `flutter pub get` para instalar dependencias.
3. Ejecutar `flutter run -d chrome` (soporta web y móvil).