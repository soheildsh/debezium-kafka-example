FROM confluentinc/cp-kafka-connect-base

RUN  confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0 \
   && confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
