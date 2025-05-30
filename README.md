# Sistema de Gestión de Historias Médicas para un Consultorio de Obstetricia y Ginecología

## Descripción

Este proyecto consiste en una base de datos diseñada para el sistema de gestión de historias médicas de un consultorio especializado en obstetricia y ginecología. La base de datos está estructurada para almacenar de manera eficiente y organizada la información de los pacientes, desde sus datos personales y antecedentes médicos hasta los resultados de exámenes y los controles realizados durante sus citas.

## Estructura de la Base de Datos

La base de datos se compone de las siguientes tablas principales, cada una de las cuales guarda información específica relacionada con las pacientes:

*   **Paciente:** Almacena la información personal básica de cada paciente, como nombre, datos de contacto, fecha de nacimiento, etc.
*   **Telefono:** Guarda los números de teléfono de contacto de los pacientes, permitiendo múltiples números por paciente.
*   **Habito:** Registra los hábitos de cada paciente, como el consumo de alcohol, tabaco y café.
*   **ExamenFisico:** Almacena los resultados de los exámenes físicos realizados a los pacientes.
*   **Control:** Guarda información sobre los controles médicos realizados a los pacientes, incluyendo datos como la talla, el peso, la tensión arterial, etc.
*   **TipoInforme:** Define los diferentes tipos de informes que se pueden generar para los pacientes.
*   **Informe:** Almacena los informes generados a partir de los controles médicos, incluyendo las conclusiones.
*   **AntecedenteFamiliar:** Registra los antecedentes familiares relevantes para la salud de las pacientes.
*   **TipoSangre:** Define los diferentes tipos de sangre posibles.
*   **AntecedentePersonal:** Almacena los antecedentes personales de los pacientes, como enfermedades preexistentes o alergias.
*   **AntecedenteGinecologico:** Registra los antecedentes ginecológicos de los pacientes, incluyendo información sobre la menstruación, menarquia, menopausia, etc.
*   **AntecedenteObstetrico:** Almacena los antecedentes obstétricos de los pacientes, como el número de gestas, partos y abortos.
*   **AntecedenteOtro:** Permite registrar otros antecedentes médicos relevantes para los pacientes.

## Implementación en MySQL
Esta base de datos ha sido implementada utilizando **MySQL**, un sistema de gestión de bases de datos relacional (RDBMS) de código abierto. El archivo `.sql` incluido en este repositorio contiene el esquema completo de la base de datos, incluyendo las definiciones de las tablas, las relaciones entre ellas.

## Cómo Utilizar la Base de Datos
Para utilizar esta base de datos en un entorno MySQL, sigue estos pasos:

1.  **Instalar MySQL:** Si aún no tienes MySQL instalado, descárgalo e instálalo desde el sitio web oficial de MySQL ([https://www.mysql.com/](https://www.mysql.com/)).

2. **Clonar este Repositorio**
    ```bash
    git clone <URL a este repositorio>
    ```
    Cambiate a esta rama
    ```bash
    git switch ANDRE_MIRANDA_2025_01
    ```
 
3.  **Crear una Base de Datos:** Una vez que MySQL esté instalado, crea una **NUEVA** base de datos donde se importará el esquema.
    Si ya tienes una base de datos con el nombre **HistoriasMedicas**, elimininala previamente con (PRECAUCION, ESTE COMANDO ELIMINARA TODO EL CONTENIDO DE LA BASE DE DATOS CON NOMBRE HistoriasMedicas):
    ```bash
    mysql -u root -p -e "DROP DATABASE HistoriasMedicas;"
    ```
    Ahora si puedes crear la base de datos con:
    ```bash
    mysql -u root -p -e "CREATE DATABASE HistoriasMedicas;"
    ```

4.  **Cargar la estructura:** Importa el archivo `.sql` a la base de datos que creaste. Puedes hacerlo utilizando la línea de comandos:
    ```bash
    mysql -u <usuario> -p HistoriasMedicas < db/tablas.sql
    mysql -u <usuario> -p HistoriasMedicas < db/valores_defecto.sql
    mysql -u <usuario> -p HistoriasMedicas < db/funciones_procedimientos.sql
    mysql -u <usuario> -p HistoriasMedicas < db/vistas.sql
    mysql -u <usuario> -p HistoriasMedicas < db/roles.sql
    mysql -u <usuario> -p HistoriasMedicas < db/indices.sql
    mysql -u <usuario> -p HistoriasMedicas < db/transacciones.sql
    mysql -u <usuario> -p HistoriasMedicas < db/triggers.sql
    ```
    Reemplaza `<usuario>` con tu nombre de usuario de MySQL. Se te pedirá que introduzcas la contraseña.

5.  **Cargar datos de Prueba (opcional):** 
    ```bash
    mysql -u <usuario> -p HistoriasMedicas < valores_pruebas.sql
    ```

6.  **Explorar y Utilizar:** Una vez que la base de datos esté configurada, puedes comenzar a explorar las tablas, insertar datos y realizar consultas para gestionar la información de las pacientes.
