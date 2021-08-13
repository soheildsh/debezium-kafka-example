# Mysql to postgresql data pipline example
A simple way to try how to downstream a mysql database to a postgresql using debezium cdc tool.

You can make a data pipline using [debezium](https://debezium.io/) to detect changes in the source database (mysql in this case) and stream them to [apache kafka](https://kafka.apache.org/), and then use these log changes to make a sync sink database (postgresql in this case).

I have used the confluent kafka stack docker-compose to build the kafka stuff, but some services are not used in this example such as schema-registry and etc. But they will be used in further commits.

For the source database I have used the [debezium example mysql database image](https://hub.docker.com/r/debezium/example-mysql) which is populated and there is no need to change anything.

For the sink database I have used [postgresql 9.5 alpine image](https://hub.docker.com/_/postgres) which is empty but by running the code it should be populated with data from the source database. 

To connect kafka topics to sink database, I have used [JDBC sink connector](https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/index.html).

## Requirements

You should have docker installed on your machine.

## Installation

Use the docker-compose file to create needed docker containers. Make sure required ports in the file are not busy, And note that if you are using this file for the first time some download may be needed and it could take a while depending on your internet speed.

```bash
sudo docker-compose up -d
```
Check if the service is running by going to this address on your browser:
[Confluent Control Center](http://127.0.0.1:9021/)

if every thing was ok and you had a healthy cluster shown there, then you can proceed to below section.

Then in order to create a kafka connect connector to read the source data run:

```bash
curl -s -X POST -H "Content-Type: application/json" -d @source.json http://127.0.0.1:8083/connectors | jq
```
You should wait a little, so that kafka can take all the changes from the inital snapshot 

Then you can send the three kafka connect sink json configurations by running these commands:
```bash
curl -s -X POST -H "Content-Type: application/json" -d @address_customer_product_sink.json http://127.0.0.1:8083/connectors | jq
```
```bash
curl -s -X POST -H "Content-Type: application/json" -d @products_on_hand_sink.json http://127.0.0.1:8083/connectors | jq
```
```bash
curl -s -X POST -H "Content-Type: application/json" -d @orders_sink.json http://127.0.0.1:8083/connectors | jq
```

## Usage
You can connect to mysql and postgresql database with any UI that you prefer and see what's going on there.

you can find the databases with these connection configs:

mysql source database: host=localhost, username=root, password=debezium, port=3306

postgresql sink database: host=localhost, username=postgres, password=postgres, port=5432

You can also access the databases in your terminal using:



```bash
docker exec -it mysql /bin/bash
mysql -u root -pdebezium
use inventory;
show tables;
```
and in another terminal
```bash
sudo docker exec -it postgres /bin/bash
psql -h localhost -p 5432 -U postgres
\dt
```

you can see that there are exact tables from mysql built in postgresql database. you can make any change you want on mysql data and see the results in postgresql. try anything you can and give me feedback.


Note: The geom table on mysql database is not on the sink database, because it contains geo data types which are not supported by the jdbc sink connector.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)