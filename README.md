
# 🎉 App de Carnets Virtuales SENA

¡Bienvenido a la aplicación móvil de carnets virtuales desarrollada para los aprendices del Centro de Formación SENA! Esta app, construida con **Flutter**, está diseñada para facilitar el registro, gestión y validación de carnets virtuales de los aprendices, integrándose con un sistema administrativo existente y una base de datos PostgreSQL. El objetivo es proporcionar una solución segura, práctica y mayormente funcional sin conexión, mejorando la experiencia de los aprendices y el control de acceso en el centro.

## 🚀 ¿Qué es esta app?

Esta aplicación móvil permite a los aprendices registrados en el Centro de Formación SENA crear y gestionar su carnet virtual de manera sencilla. Utilizando su número de identificación único (previamente validado en la base de datos institucional), los aprendices pueden registrar sus datos personales, subir una foto de perfil, establecer una contraseña y generar un carnet virtual que incluye un código de barras basado en su número de identificación. Además, la app soporta el registro de dispositivos personales (como tablets o cargadores) para su validación en el centro.

El sistema está diseñado para interoperar con una aplicación de escritorio en Java, utilizada por los instructores y guardias de seguridad, que escanea los códigos de barras para validar el ingreso de aprendices y sus equipos. Ambos sistemas comparten una base de datos PostgreSQL, asegurando una sincronización eficiente de los datos.

## ✨ Características Principales

- **🔒 Registro Seguro**: Solo los aprendices con números de identificación registrados en el SENA pueden crear una cuenta. La validación se realiza contra una base de datos preexistente.
- **🖼️ Carnet Virtual**: Genera un carnet digital con foto, datos personales y un código de barras (basado en el número de identificación), replicando el formato físico utilizado por instructores.
- **🌐 Modo Offline**: Una vez registrado, el carnet se almacena localmente en el dispositivo, permitiendo su uso sin conexión para mayor accesibilidad.
- **💻 Gestión de Dispositivos**: Los aprendices pueden registrar equipos portátiles y accesorios, los cuales quedan vinculados a su perfil para validación en el centro.
- **🎨 Interfaz Intuitiva**: Diseño limpio y amigable, optimizado para dispositivos Android, con un flujo de registro guiado.
- **📊 Integración con PostgreSQL**: Conexión con una base de datos central para almacenar y consultar datos de aprendices y dispositivos.

## 🛠 Tecnologías Utilizadas

- **Flutter**: Framework para el desarrollo de la app móvil con una UI nativa y multiplataforma.
- **Dart**: Lenguaje de programación para la lógica de la app.
- **PostgreSQL**: Base de datos relacional para almacenar información de aprendices y dispositivos.
- **Hive**: Almacenamiento local para soporte offline.
- **Image Picker**: Integración para subir fotos de perfil.

## 🎯 Propósito y Contexto

Esta app fue desarrollada como una extensión del sistema administrativo del Centro de Formación SENA, que ya cuenta con una aplicación de escritorio en Java para la validación de códigos de barras por parte de guardias de seguridad. La app móvil agiliza el proceso de registro de aprendices, permitiendo que:
- Los instructores añadan nuevos números de identificación a la base de datos.
- Los aprendices generen sus carnets virtuales y registren sus equipos desde sus dispositivos.
- Los guardias validen el acceso escaneando los códigos de barras, sin necesidad de modificar la app de escritorio existente.

La base de datos inicial será proporcionada por la institución con los números de identificación de los aprendices inscritos, y la app se encarga de completar los datos adicionales (nombre, foto, etc.) durante el registro.

## 📱 Lógica de la App Móvil

La app móvil implementa la siguiente lógica basada en los diseños existentes:
1. **Validación de Identificación**: Al ingresar un número de identificación, la app consulta la base de datos PostgreSQL para verificar su existencia. Si no existe, se muestra un mensaje de error.
2. **Registro de Datos**: Una vez validado, el aprendiz completa su nombre, programa, ficha, tipo de sangre, foto y contraseña. Estos datos se guardan localmente (Hive) y se sincronizan con PostgreSQL.
3. **Generación de Carnet**: Se crea un carnet virtual con los datos ingresados y un código de barras generado a partir del `id_identificacion`.
4. **Registro de Dispositivos**: El aprendiz puede añadir dispositivos, que se almacenan en la tabla `dispositivos` y quedan disponibles offline.
5. **Modo Offline**: Los datos del carnet y dispositivos se almacenan localmente, permitiendo su uso sin conexión tras el registro inicial.

## 👨‍💻 Desarrollo y Derechos de Creación

Esta aplicación fue desarrollada y creada por **Duvan Yair Arciniegas Gerena (AxchiSan)**, aprendiz del Tecnólogo en Análisis y Desarrollo de Software en el **Centro Agroempresarial del Oriente SENA**, ubicado en Vélez, Santander. Todo el código y diseño reflejan su esfuerzo y dedicación para mejorar los procesos del centro de formación.

## 🤝 Contribuciones

Este proyecto está abierto a mejoras y colaboraciones. Si deseas contribuir:
- Revisa las [issues](https://github.com/axchisan/AppGestionCarnetsSENA/issues) para tareas pendientes.
- Envía un pull request con tus cambios.
- Sigue las guías de estilo y documenta tus aportes.

## 📜 Licencia

Este proyecto está bajo la licencia [MIT](LICENSE), permitiendo su uso y modificación siempre que se mantenga el aviso de copyright.

## 🙌 Agradecimientos

Agradecemos al equipo del Centro de Formación SENA por su apoyo y a la comunidad Flutter por las herramientas que hacen posible esta app.

## 📸 Capturas de Pantalla

![Screenshot_1751317031](https://github.com/user-attachments/assets/e357dc63-1e02-401c-8d48-c2a4a69e4893)
![Screenshot_1751316978](https://github.com/user-attachments/assets/87d61da4-6791-4196-84e7-c59fbfc8feb6)
![Screenshot_1751316972](https://github.com/user-attachments/assets/f3599dc1-f5a1-46a0-ac08-8f28243703f5)
![Screenshot_1751316944](https://github.com/user-attachments/assets/5fedaeba-d439-4d7b-932b-5c624b397660)
![Screenshot_1751316939](https://github.com/user-attachments/assets/78955f06-a811-4a90-9d1d-39e9e6846247)
![Screenshot_1751316904](https://github.com/user-attachments/assets/10a2b93b-a194-4430-bdc9-44e4c1234d0f)
![Screenshot_1751316892](https://github.com/user-attachments/assets/f1c98338-7a80-46b7-88cf-6c627ec1d952)
