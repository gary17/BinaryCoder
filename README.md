# BinaryCoder

## Purpose

This repository is meant as an educational resource on the subject of using software design patterns in iOS apps written in Swift.

## Problem

Working with network-aware apps sometimes requires sending complex data (thus data consisting of multiple, independent pieces of information) over wireless WAN (Wide Area Network) connections (e.g., cellular). While text-based data structure expression formats such as JSON or XML get the job done adequately, they might not be appropriate in all situations, due to verbosity of text-based data transmission (one character of text is at least 1 byte of data, with even up to 4 bytes per code point in case of UNICODE, UTF-32) - for example in case of lighter, embedded systems, where memory, CPU time and battery power are in very short supply. Under such circumstances, serializing data to a binary format that is platform-independent (e.g., big-endian vs. little-endian) and transmitting data over a binary band (e.g., the WebSocket communications protocol), becomes necessary.

## Solution

BinaryCoder is a small, sample utility library based on Swift Manual Memory Management and Byte-Order Utilities that allows for serializing and deserializing data to and from a binary format.

## Components

|         | File | Purpose |
----------|------|----------
:octocat: | [BinaryCoder.swift](BinaryCoder.playground/Sources/BinaryCoder.swift) | a sample utility library for serializing and deserializing data to and from a binary format
:octocat: | [Contents.swift](BinaryCoder.playground/Contents.swift) | a sample Xcode playground with usage samples
