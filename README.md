# FAASOS Online Roll Restaurant Data Analysis

Welcome to the FAASOS online roll restaurant data analysis project! This repository contains SQL scripts to analyze various aspects of the FAASOS restaurant operations, customer orders, driver performance, and more.

## Table of Contents
- [Introduction](#introduction)
- [Setup](#setup)
- [Database Schema](#database-schema)
- [Queries](#queries)
  - [How many rolls were ordered?](#how-many-rolls-were-ordered)
  - [How many unique customer orders were made?](#how-many-unique-customer-orders-were-made)
  - [How many successful orders were made by the driver?](#how-many-successful-orders-were-made-by-the-driver)
  - [How many of each type of roll were delivered?](#how-many-of-each-type-of-roll-were-delivered)
  - [How many veg and non-veg rolls were ordered by each customer?](#how-many-veg-and-non-veg-rolls-were-ordered-by-each-customer)
  - [When was the maximum number of rolls delivered in a single delivery?](#when-was-the-maximum-number-of-rolls-delivered-in-a-single-delivery)
  - [Delivered rolls with changes and without changes](#delivered-rolls-with-changes-and-without-changes)
  - [Customers with both inclusions and exclusions](#customers-with-both-inclusions-and-exclusions)
  - [Total number of rolls ordered for each hour of the day](#total-number-of-rolls-ordered-for-each-hour-of-the-day)
  - [Total orders based on days of the week](#total-orders-based-on-days-of-the-week)
  - [Average time for drivers to arrive at FAASOS HQ](#average-time-for-drivers-to-arrive-at-faasos-hq)
  - [Relation between number of rolls and order preparation time](#relation-between-number-of-rolls-and-order-preparation-time)
  - [Average distance traveled for each customer](#average-distance-traveled-for-each-customer)
  - [Difference between longest and shortest delivery times](#difference-between-longest-and-shortest-delivery-times)
  - [Average speed for each driver for each order](#average-speed-for-each-driver-for-each-order)

## Introduction

FAASOS is an online roll restaurant that offers a variety of veg and non-veg rolls. This project includes a series of SQL queries to analyze different aspects of the restaurant's operations, including customer orders, driver performance, and order delivery times.

## Setup

To set up the database and insert sample data, run the following SQL scripts in your PostgreSQL environment:

