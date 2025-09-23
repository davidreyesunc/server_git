
# Generar la Autoridad de Certificación (CA)
#-subj: Permite especificar los campos del sujeto:
# /C: Código de país (Country)      /ST: Estado o provincia (State)     /L: Localidad (Locality)    /O: Organización (Organization)
# /CN: Nombre común (Common Name), en este caso, el nombre de la CA
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout certs/ca.key -out certs/ca.crt -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_CA"

# Generar el Certificado del Servidor (Mosquitto)
# Crear una clave privada para el servidor
openssl genrsa -out certs/server.key 2048
# Generar una solicitud de firma de certificado (CSR)
openssl req -new -key certs/server.key -out certs/server.csr -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_Broker"
# Firmar el CSR con la clave de la CA para obtener el certificado del servidor
# server.key: Clave privada del servidor
# server.crt: Certificado público del servidor
openssl x509 -req -days 3650 -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/server.crt

# Generar el Certificado de un Cliente (una estación meteorológica)
# Crear una clave privada para un cliente
openssl genrsa -out certs/client.key 2048
# Generar una solicitud de firma de certificado (CSR)
openssl req -new -key certs/client.key -out certs/client.csr -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_Client"
 # Firmar el CSR con la clave de la CA para obtener el certificado del cliente
# client.key: Clave privada del cliente
# client.crt: Certificado público del cliente
openssl x509 -req -days 3650 -in certs/client.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/client.crt
