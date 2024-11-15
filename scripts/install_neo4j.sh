#!/bin/bash
# Adding Neo4j Repo which is compatible with RHEL9, you can just populate the repo file directly
rpm --import https://debian.neo4j.com/neotechnology.gpg.key
cat << EOF >  /etc/yum.repos.d/neo4j.repo
[neo4j]
name=Neo4j RPM Repository
baseurl=https://yum.neo4j.com/stable/5
enabled=1
gpgcheck=1
EOF
# Installing Neo4j 5+
# Either 
 # interactive
 # yum -y install neo4j-enterprise-5.25.1
 # non-interactive
NEO4J_ACCEPT_LICENSE_AGREEMENT=yes yum -y install neo4j-enterprise-5.25.1
# Enable as a service for reboots
systemctl enable neo4j
# Start as a service for reboots
systemctl start neo4j
