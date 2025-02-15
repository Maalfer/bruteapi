BruteApi es una herramienta en Bash diseñada para realizar pruebas de autenticación contra una API utilizando diferentes métodos de autenticación. Permite probar contraseñas de manera automatizada a partir de un archivo de texto (passwords.txt), permitiendo seleccionar entre los siguientes métodos:

Basic Auth (requiere usuario y contraseña)
Bearer Token (envía un token en el encabezado)
API Key en el encabezado
API Key en la URL
El script solicita al usuario la URL de la API, el archivo de contraseñas y el método de autenticación deseado. Luego, realiza intentos iterativos actualizando dinámicamente la contraseña en pantalla sin llenar la terminal de texto innecesario.

Si se encuentra una contraseña válida, se muestra un mensaje de éxito en verde. En caso contrario, continúa iterando hasta probar todas las opciones disponibles.

![image](https://github.com/user-attachments/assets/6860aea4-7865-472a-b498-89599cc137da)
