# AWS MSK Infrastructure

### Introduction

This project provisions an MSK cluster. I need to add Terraform layers (a technique to separate big Terraform projects). Environments are to be completed, at the moment there is only one `dev` environment.

### How to deploy
First you need to create an environment with its remote state (an S3 bucket).
First setup your AWS_PROFILE environment variable, then export a project and an
`environ` variable which will hold the name of the terraform environment.
Run `make create-state` from the root of the project to create a Terraform remote state on S3.
Check the Makefile to understand how to run the project but it is very similar
to the basic Terraform workflow:
```
make init
make plan
make apply
```

### TODO
* Documentation
* Add layers
* Complete environments
* Add containers deployment to be used as Kafka producers and consumers
* Kafka security
* Kafka autoscaling

Check modules/msk to see how Kafka is installed.

### Outputs

bootstrap_brokers =
bootstrap_brokers_tls =
  b-1.example.opi5eg.c3.kafka.eu-west-1.amazonaws.com:9094
  b-2.example.opi5eg.c3.kafka.eu-west-1.amazonaws.com:9094
  b-3.example.opi5eg.c3.kafka.eu-west-1.amazonaws.com:9094
zookeeper_connect_string = 192.168.0.160:2181,192.168.2.32:2181,192.168.1.30:2181
