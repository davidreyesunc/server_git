# RSA vs. ECDSA: What are the differences?
# https://nordvpn.com/es-mx/blog/ecdsa-vs-rsa/?srsltid=AfmBOoohkoptpXDELy8QUgYl2Sm1LJU9R6WxR8vzfdKE28GVdNTkpFNP

# ECDSA: 
#   - Claves más pequeñas con la misma seguridad que RSA -> Menos datos transmitos
#   - Más eficiente computacionalmente                   -> Menor sobrecarga en el Modem

echo "------------- Generando la Autoridad de Certificación (CA) -------------"
# Generar la Autoridad de Certificación (CA)
# Generar la clave privada de la CA (usando ECDSA)
# prime256v1: usar curva elíptica P-256
openssl ecparam -genkey -name prime256v1 -noout -out certs/ca.key
# Generar el certificado de la CA (autofirmado)
#-subj: Permite especificar los campos del sujeto:      /C: Código de país (Country)      /ST: Estado o provincia (State)    
# /L: Localidad (Locality)          /O: Organización (Organization)       /CN: Nombre común (Common Name), en este caso, el nombre de la CA
openssl req -new -x509 -sha256 -key certs/ca.key -out certs/ca.crt -days 3650 -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_CA"

echo "------------- Generando el Certificado del Servidor (broker Mosquitto) -------------"
# Generar el Certificado del Servidor (Mosquitto)
# Generar la clave privada para el servidor
openssl ecparam -genkey -name prime256v1 -noout -out certs/server.key
# Generar una solicitud de firma de certificado (CSR)
openssl req -new -sha256 -key certs/server.key -out certs/server.csr -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_Broker"
# Firmar el CSR con la clave de la CA para obtener el certificado del servidor
# server.key: Clave privada del servidor
# server.crt: Certificado público del servidor
# El subjectAltName es importante si el cliente verifica el hostname/IP. 
openssl x509 -req -sha256 -days 3650 -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/server.crt \
#            -extfile <(printf "subjectAltName=DNS:Meteo-Data-Server,IP:10.10.10.10") \
            -passin pass:laClaveDelBrokerMosquitto

echo "------------- Generando el Certificado del Cliente 01 (Estación Meteorológica 01) -------------"
# Generar el Certificado para el Primer Cliente (Estación Metorológica)
# Crear una clave privada para un cliente
openssl ecparam -genkey -name prime256v1 -noout -out certs/client_01.key
# Generar una solicitud de firma de certificado (CSR)
openssl req -new -sha256 -key certs/client_01.key -out certs/client_01.csr -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_Client_01"
 # Firmar el CSR con la clave de la CA para obtener el certificado del cliente
# client.key: Clave privada del cliente
# client.crt: Certificado público del cliente
openssl x509 -req -sha256 -days 3650 -in certs/client_01.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/client_01.crt \
            -passin pass:laClaveDelCliente_01

# Generar el Certificado para el Segunda Estación Metorológica
#openssl ecparam -genkey -name prime256v1 -noout -out certs/client_02.key
#openssl req -new -sha256 -key certs/client_02.key -out certs/client_02.csr -subj "/C=AR/ST=Cordoba/L=Cordoba/O=LH_FCEFyN_UNC/CN=Mosquitto_Client_02"
#openssl x509 -req -sha256 -days 3650 -in certs/client_02.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/client_02.crt \
#            -passin pass:laClaveDelCliente_02

echo "------------- Verificando Certificados -------------"
openssl x509 -in certs/ca.crt        -text -noout | grep "Public Key Algorithm"
openssl x509 -in certs/server.crt    -text -noout | grep "Public Key Algorithm"
openssl x509 -in certs/client_01.crt -text -noout | grep "Public Key Algorithm"

echo "------------- Verificando el Funcionamiento del Cifrado ECDHE-ECDSA-AES128-GCM-SHA256 -------------"
# Verificar que el servidor acepta la cipher suite ECDHE-ECDSA-AES128-GCM-SHA256
openssl s_client -connect localhost:8883 \
  -CAfile certs/ca.crt \
  -cert certs/client_01.crt \
  -key certs/client_01.key \
  -tls1_2 \
  -cipher ECDHE-ECDSA-AES128-GCM-SHA256