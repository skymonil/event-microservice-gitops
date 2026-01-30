# 1. Use the official Strimzi Kafka 4.0.0 base (Required for Strimzi 0.50+)
FROM quay.io/strimzi/kafka:0.50.0-kafka-4.0.0

USER root:root

# 2. Create the plugins directory
RUN mkdir -p /opt/kafka/plugins/debezium

# 3. Download the Debezium Postgres Connector
# (Using Debezium 2.5.0 which is stable; you can swap for 2.5.4 or 2.6)
RUN curl -L -o /tmp/debezium.tar.gz https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.5.4.Final/debezium-connector-postgres-2.5.4.Final-plugin.tar.gz \
    && tar -xvf /tmp/debezium.tar.gz -C /opt/kafka/plugins/debezium --strip-components=1 \
    && rm /tmp/debezium.tar.gz

USER 1001