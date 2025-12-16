# Avance del Proyecto – Sistema de Presupuesto Personal

## 1. Introducción

El presente documento describe el estado actual de avance del proyecto **Sistema de Presupuesto Mensual Personal**, desarrollado como parte de la asignatura *Teoria de Bases de Datos I*.

El objetivo de este documento es detallar de forma clara y honesta:
- Las funcionalidades completamente implementadas
- Los componentes parcialmente implementados
- Los elementos pendientes
- Las decisiones técnicas tomadas durante el desarrollo

El proyecto sigue una arquitectura de tres capas: **Base de Datos, Backend y Presentación**, priorizando que la lógica de negocio resida en la base de datos mediante procedimientos almacenados, funciones y triggers.

---

## 2. Estado General del Proyecto

| Capa | Estado |
|-----|------|
| Base de Datos (SQL Anywhere 17) | Implementada |
| Backend (ASP.NET Core + ODBC) | Implementada |
| Reportería (Power BI) | Parcialmente implementada |
| Frontend (UI Web) | Pendiente (Swagger documentado como alternativa) |

---

## 3. Base de Datos

### 3.1 Motor de Base de Datos

- Motor: **SQL Anywhere 17**
- Despliegue: Máquina Virtual en Azure
- Inicialización manual del servidor mediante `dbsrv17`
- Conexión vía TCP/IP

El motor fue asignado como parte de los requerimientos del proyecto y soporta completamente:
- Procedimientos almacenados
- Funciones
- Triggers
- Transacciones

---

### 3.2 Modelo de Datos

Entidades principales implementadas:
- Usuarios
- Presupuestos
- Categorías
- Subcategorías
- Detalles de Presupuesto
- Transacciones
- Obligaciones Fijas
- Metas de Ahorro
- Alertas

Todas las tablas incluyen los **campos de auditoría obligatorios**:
- `creado_por`
- `creado_en`
- `modificado_por`
- `modificado_en`

---

### 3.3 Procedimientos Almacenados

Se implementaron procedimientos almacenados para:

- CRUD completo de todas las entidades principales
- Lógica de negocio compleja

Ejemplos de procedimientos implementados:
- Creación y validación de presupuestos
- Registro de transacciones con validación de vigencia
- Cálculo de balances mensuales
- Cálculo de ejecución presupuestaria

Se priorizó que la **lógica de negocio resida en la base de datos**, cumpliendo el principio establecido en el proyecto.

---

### 3.4 Funciones

Se implementaron funciones reutilizables para:
- Cálculo de montos ejecutados
- Porcentajes de ejecución
- Promedios históricos de gasto
- Resúmenes por categoría y subcategoría
- ETC, todas las funciones requeridas fueron implementadas

Estas funciones son utilizadas tanto por procedimientos almacenados como por la capa de reportería.

---

### 3.5 Triggers

Se implementaron los triggers requeridos para automatizar reglas críticas:
- Creación automática de subcategoría por defecto al crear una categoría
- Actualización automática de metas de ahorro

Los triggers garantizan consistencia y automatización en tiempo real.

---

## 4. Backend (ASP.NET Core)

### 4.1 Arquitectura

El backend fue desarrollado utilizando **ASP.NET Core**, aplicando una arquitectura basada en:
- Entidades
- Interfaces
- Repositorios
- Controladores

Durante la defensa me hizo el comentario que no se cerraban las conexiones utilizadas en los repositorios, pero ya que estoy utilizando la estructura `using var conn`, ODBC automaticamente hace dispose de la variable de la conexion al finalizar el procedimiento, haciendo que usar un `.Close()` sea redundante

---

### 4.2 Conexión a Base de Datos

La conexión a SQL Anywhere se realiza mediante **ODBC**, ya que:
- SQL Anywhere expone drivers ODBC oficiales
- .NET ofrece soporte nativo y estable para ODBC
- Permite desacoplar el backend del motor específico

El backend invoca **procedimientos almacenados y funciones**, delegando la lógica compleja a la base de datos.

---

### 4.3 Endpoints

Se implementaron endpoints REST para:
- Gestión de usuarios
- Categorías y subcategorías
- Presupuestos y detalles
- Transacciones
- Obligaciones
- Metas de ahorro

La API fue documentada y probada mediante **Swagger**, el cual se utilizó como interfaz funcional para demostrar el sistema en ejecución.

---

## 5. Reportería

### 5.1 Herramienta Utilizada

Se utilizó **Power BI Desktop** como herramienta de reportería alternativa, debido a:
- Limitaciones de compatibilidad directa entre SQL Anywhere y Metabase
- Problemas técnicos con drivers JDBC en Jasper Reports y Superset, ambas herramientas no tienen soporte para una base de datos creada con SQL Anywhere 17

Power BI permitió:
- Conexión directa vía ODBC
- Ejecución de consultas SQL 
- Visualización clara de datos reales del sistema

---

### 5.2 Estado de Reportes

- Reporte 1 (Resumen mensual): Completado
- Reportes 2 (Distribución de Gastos por Categoría): Completado
- Reportes 3-6: Pendientes

Las consultas base y funciones necesarias para los reportes ya se encuentran implementadas en la base de datos.

---

## 6. Frontend

El frontend web completo no fue implementado.

No obstante:
- Se diseñó la arquitectura backend preparada para consumo por un frontend
- Se demostró la funcionalidad del sistema mediante Swagger
- La capa de presentación puede ser implementada sin cambios en la base de datos o backend

---

## 7. Trabajo Pendiente

- Implementación del frontend web (UI)
- Finalización de los 4 Reportes que quedaron pendientes

