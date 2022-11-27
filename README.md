# Ruby on Rails (maas-backend)

## MaaS Backend

Este proyecto es el backend de la aplicación MaaS, la cual es una aplicación de gestión de horarios de un equipo de trabajo.

Entidades:

Usuarios: Los usuarios son los empleados de la empresa, los cuales tienen un nombre, un apellido, un email y una contraseña. En otras palabras son los ingenieros encargados de monitorear los servicios.

Clientes: Los clientes son las empresas que contratan los servicios de la empresa, los cuales tienen un nombre. Estos clientes pueden tener varios servicios.

Servicios: Son los servicios que cada cliente tiene que necesitan ser monitoreados.

Turnos: Para cada servicio se debe asignar un turno, el cual tiene un nombre, una fecha de inicio y una fecha de fin. Cada servicio tiene como máximo 7 turnos. Cada turno tiene un horario de inicio y un horario de fin. Estos turnos estan disponibles el tiempo que dure el servicio, este tiempo se establece al crear el servicio.

Disponibilidades: Cada usuario puede marcar n cantidad de disponibilidades, las cuales tienen un horario de inicio y un horario de fin. Estas disponibilidades son para que el usuario pueda ser asignado a un turno.

Asignaciones: Cada usuario puede ser asignado a un turno dependiendo de sus disponibilidades. Cada asignación tiene un horario de inicio y un horario de fin. Cada asignación tiene un usuario y un turno.


# Pasos para correr el proyecto
* Ruby version: 3.0.4
* Rails version: 7.0.4
* Database: Postgres

Nota: es recomendable tener docker y docker-compose instalado en el equipo de igual forma se puede correr el proyecto sin docker.

## Generar imagenes de docker

```bash
docker-compose build
```

## Crear base de datos

Nota: en este caso puede salir una advertencia o error en la terminal, pero no afecta al funcionamiento del proyecto.

```bash
docker-compose run api rails db:create
```
## Correr migraciones

```bash
docker-compose run api rails db:migrate
```

## Correr seeders

```bash
docker-compose run api rails db:seed
```

## Correr proyecto

```bash
docker-compose up
```
