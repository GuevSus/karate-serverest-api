# Proyecto de Automatización de APIs con Karate Framework - ServeRest

Este proyecto contiene una suite de pruebas automatizadas de extremo a extremo (E2E) para los endpoints de la API **ServeRest** (`/usuarios`), desarrollada utilizando **Karate Framework**. 

La suite valida escenarios mediante flujos felices (`@happy-path`), negativos (`@negative`) y alternativos, asegurando el correcto funcionamiento del CRUD de usuarios, la integridad de los datos mediante esquemas JSON y la estabilidad ante peticiones inválidas sin dejar registros duplicados en ejecuciones sucesivas.

---

## Requisitos Previos e Instalación

Para poder clonar, compilar y ejecutar este proyecto desde cero en tu máquina local, necesitas instalar y configurar las siguientes herramientas esenciales de Backend:

### 1. Instalar Java Development Kit (JDK)
Karate requiere **Java 17 o superior** para ejecutarse de forma nativa.
* **Verificación:** Abre tu terminal (PowerShell o CMD) y comprueba que esté bien instalado con:
  ```
  java -version
  ```
  
* **Configuración Clave:** Asegúrate de tener la variable de entorno `JAVA_HOME` apuntando a la ruta de instalación de tu JDK.

### 2. Instalar Apache Maven

Maven es el gestor de dependencias que descargará Karate, JUnit y compilará todo el proyecto automáticamente a través del archivo `pom.xml`.

* **Verificación:** Comprueba la instalación en tu terminal con:
```
mvn -v
```


* **Configuración Clave:** Añade la carpeta `bin` de Maven a las Variables de Entorno del Sistema en el `PATH`.

---

## Guía de Inicio Rápido (Comandos de Configuración)

Una vez instalados los prerequisitos, sigue estos pasos en tu terminal para poner en marcha el proyecto:

### 1. Clonar el repositorio

```
git clone https://github.com/GuevSus/karate-serverest-api.git

```

### 2. Navegar a la carpeta del proyecto

```
cd karate-serverest-api
```

### 3. Descargar dependencias e inicializar el entorno

Antes de correr las pruebas, limpia cualquier compilación previa y descarga todas las librerías de Karate declaradas en el `pom.xml` ejecutando:

```
mvn clean compile
```

*(Este comando creará la carpeta local `target/` y descargará las dependencias de Karate de forma automatizada).*

---

## Estructura Detallada del Proyecto (Convención camelCase)

El diseño del proyecto sigue la arquitectura oficial recomendada por Karate y las convenciones de nomenclatura nativas de Java, estructurando los recursos de la siguiente manera:

```
karate-serverest/
├── src/test/java/
│   ├── karate/
│   │   ├── helpers/
│   │   │   └── testData.js           # LÓGICA JS: Generación dinámica de payloads únicos con timestamps
│   │   ├── users/
│   │   │   ├── schemas/
│   │   │   │   └── userSchema.json   # CONTRATOS: Esquemas JSON estrictos para validación de tipos
│   │   │   ├── createUser.feature    # PRUEBAS: Escenarios optimizados para POST /usuarios
│   │   │   ├── deleteUser.feature    # PRUEBAS: Escenarios optimizados para DELETE /usuarios
│   │   │   ├── getUser.feature       # PRUEBAS: Escenarios optimizados para GET /usuarios
│   │   │   └── updateUser.feature    # PRUEBAS: Escenarios optimizados para PUT /usuarios
│   │   ├── helpers.feature           # REUTILIZACIÓN: Hook modular para dar de alta usuarios previos
│   │   └── TestRunner.java           # MOTOR: Clase ejecutora de JUnit 5 para integrar con Maven
│   └── karate-config.js              # CONFIGURACIÓN: Variables globales, entornos y timeouts de la suite
├── .gitignore                        # PROTECCIÓN: Filtro para evitar subir carpetas temporales (target/)
├── pom.xml                           # CONFIGURACIÓN MAVEN: Dependencias del proyecto (Karate Core, JUnit)
└── Readme.md                         # DOCUMENTACIÓN: Guía técnica del framework

```

---

## Características de Diseño Avanzadas

### 1. Datos Dinámicos Anti-Colisión (`testData.js`)

Para evitar fallas por correos duplicados (`400 Bad Request`) en ejecuciones seguidas, el archivo `testData.js` utiliza el motor **GraalVM JavaScript** embebido en Karate para inyectar `timestamps` en tiempo real (`new Date().getTime()`). Esto genera credenciales únicas por milisegundo (ej. `admin_17173155@qa.com`) garantizando pruebas 100% independientes.

### 2. Centralización de Rutas (Principio DRY)

Se ha evitado la repetición innecesaria del comando `Given path 'usuarios'` en cada escenario. En su lugar, se configuró de manera global dentro del bloque `Background` de cada archivo `.feature`. Karate se encarga de concatenar dinámicamente los paths base con los parámetros de IDs de forma nativa (`And path userId`), incrementando radicalmente la legibilidad del Gherkin.

### 3. Tolerancia a Fallos y Red Estable

Debido a la naturaleza de la API de pruebas pública, se configuraron tiempos de espera optimizados de **5 segundos** (`connectTimeout` y `readTimeout` a 15000ms) en el archivo `karate-config.js`. Esto previene fallas falsas por latencia de red (`SocketTimeoutException`) y le brinda robustez a los pipelines de CI/CD.

### 4. Modularidad mediante Inyección de Precondiciones (`helpers.feature`)

Para probar los flujos de `GET`, `PUT` y `DELETE`, se requiere un ID de usuario existente en la base de datos de la API. En lugar de quemar un ID fijo en el código, el escenario llama dinámicamente a `helpers.feature` usando el comando `call read`, crea un usuario en milisegundos, captura su `_id` de respuesta y lo pasa como parámetro a la prueba actual de forma limpia.

---

## Ejecución de la Suite de Pruebas

Puedes lanzar las pruebas utilizando tu terminal de comandos.

> **Nota para usuarios de Windows (PowerShell):** Se ha envuelto todo el parámetro `-D` entre comillas dobles (ej. `"-Dkarate.options=..."`) para evitar que PowerShell rompa la sintaxis interna y genere el error de compilación de Maven `Unknown lifecycle phase`.

### A. Ejecución de toda la Suite

Compila el framework, limpia registros viejos de ejecuciones previas y corre todos los escenarios de prueba:

```
mvn clean test

```

### B. Ejecución Filtrada por Tags (Etiquetas de Negocio)

Si deseas aislar la ejecución utilizando las etiquetas semánticas de tus archivos de pruebas:

* **Correr solo flujos felices / exitosos (`@happy-path`):**
```
mvn test "-Dkarate.options=--tags @happy-path
```


* **Correr solo flujos de error o validaciones negativas (`@negative`):**
```
mvn test "-Dkarate.options=--tags @negative"

```


* **Correr solo pruebas críticas de humo (`@smoke`):**
```
mvn test "-Dkarate.options=--tags @smoke"
```



### C. Ejecución de Multi-Ambiente (Soporte Multi-Env)

El framework soporta conmutación dinámica de URLs base mediante propiedades del sistema:

```
mvn test "-Dkarate.env=cert"
```
**Nota:** el mecanismo de switching está implementado y funcional (`karate.env` cambia correctamente), pero actualmente los ambientes `dev`, `cert` y `qa` apuntan todos a la misma URL (`https://serverest.dev`), ya que es la única instancia pública disponible de la API. La estructura queda lista para el día en que existan URLs reales por ambiente.

### D. Ejecución de un archivo de prueba específico

Si deseas apuntar a un único archivo `.feature` sin correr el resto de la suite:

```
mvn test "-Dkarate.options=classpath:karate/users/createUser.feature"
```

---

## Reportes Automatizados

Una vez que finaliza cualquier comando de ejecución, Karate genera de forma nativa un reporte visual en formato HTML interactivo.

* **Ubicación del Reporte:** `target/karate-reports/karate-summary.html`
* **Cómo abrirlo:**
1. Dirígete a la carpeta `target/karate-reports/` en tu explorador de archivos.
2. Haz doble clic sobre el archivo `karate-summary.html`.
3. Se abrirá en tu navegador web mostrando el paso a paso exacto, los tiempos de respuesta de la API, los encabezados y los Payloads JSON reales enviados y recibidos.