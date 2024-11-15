### Instructions to create Neo4j self-signed certificate:
#1. Update lines: 19-21 Cert Name and 42,83,87,92,97,105 Server IP
#2. Save the script to a file: `configure_neo4j_ssl.sh`.
#3. Make the script executable:
#   chmod +x configure_neo4j_ssl.sh
#4. Run the script with root privileges:
#   sudo ./configure_neo4j_ssl.sh
# SCRIPT
#!/bin/bash
# Variables
CERT_DIR="/etc/neo4j/certificates"
BOLT_CERT_DIR="$CERT_DIR/bolt"
HTTPS_CERT_DIR="$CERT_DIR/https"
KEY_FILE="neo4j-selfsigned.key"
CERT_FILE="neo4j-selfsigned.crt"
CSR_FILE="neo4j.csr"
NEO4J_CONF="/etc/neo4j/neo4j.conf"
now=date +%s

# Restart Neo4j service
echo "Stopping Neo4j service..."
sudo systemctl stop neo4j

# Backup neo4j configuration file
sudo cp /etc/neo4j/neo4j.conf /home/azureadmin/neo4j-$now.conf.bak

# Install OpenSSL if not already installed
if ! command -v openssl &> /dev/null; then
    echo "OpenSSL not found, installing..."
    sudo yum install -y openssl
else
    echo "OpenSSL is already installed"
fi

# Generate a private key without a passphrase

echo "Generating private key..."
openssl genpkey -algorithm RSA -out $KEY_FILE

# Generate a Certificate Signing Request (CSR)

echo "Generating CSR..."
openssl req -new -key $KEY_FILE -out $CSR_FILE \
    -subj "/C=US/ST=VA/L=VA/O=VA/OU=OIT/CN=10.125.58.148/emailAddress=sdpplatmanteam@va.gov"

# Generate a self-signed certificate

echo "Generating self-signed certificate..."
openssl x509 -req -days 365 -in $CSR_FILE -signkey $KEY_FILE -out $CERT_FILE

# Create directories for certificates

echo "Creating directories for certificates..."
sudo mkdir -p $BOLT_CERT_DIR
sudo mkdir -p $HTTPS_CERT_DIR

# Move certificates to appropriate directories

echo "Moving certificates to appropriate directories..."
sudo cp $KEY_FILE $BOLT_CERT_DIR/
sudo cp $CERT_FILE $BOLT_CERT_DIR/
sudo cp $KEY_FILE $HTTPS_CERT_DIR/
sudo cp $CERT_FILE $HTTPS_CERT_DIR/

# Set permissions

echo "Setting permissions..."
sudo chown -R neo4j:neo4j $CERT_DIR
sudo chmod 600 $BOLT_CERT_DIR/$KEY_FILE
sudo chmod 600 $HTTPS_CERT_DIR/$KEY_FILE

# Configure Neo4j

echo "Configuring Neo4j..."
sudo bash -c "cat <<EOF >> $NEO4J_CONF

# Configure HTTPS

dbms.ssl.policy.bolt.enabled=true
dbms.ssl.policy.bolt.base_directory=$BOLT_CERT_DIR
dbms.ssl.policy.bolt.private_key=$KEY_FILE
dbms.ssl.policy.bolt.public_certificate=$CERT_FILE

dbms.ssl.policy.https.enabled=true
dbms.ssl.policy.https.base_directory=$HTTPS_CERT_DIR
dbms.ssl.policy.https.private_key=$KEY_FILE
dbms.ssl.policy.https.public_certificate=$CERT_FILE
dbms.ssl.policy.https.client_auth=NONE

# HTTPS Connector. There can be zero or one HTTPS connectors

server.http.enabled=false

server.https.enabled=true
server.https.listen_address=0.0.0.0:443
# server.https.advertised_address=10.125.58.148:7473

server.bolt.enabled=true
server.bolt.listen_address=0.0.0.0:7687
server.bolt.advertised_address=10.125.58.148:7687

EOF"

# Restart Neo4j service

echo "Restarting Neo4j service..."
sudo systemctl restart neo4j

# Verify the configuration

echo "Verifying the configuration..."
sudo tail -f /var/log/neo4j/neo4j.log

echo "Self-signed certificate for Neo4j configured successfully."