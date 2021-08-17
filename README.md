# My AWS EKS

## Description

This project spins up a decent EKS cluster for demos, development or testing.
In theory you could scale it up to production too if your apps are stateful
and can tolerate using spot instances - but it's really meant to be for short/medium term environments that you spin up or down at need.

It currently features:

* Custom VPC Setup.
