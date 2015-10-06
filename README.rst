=====
Aptly
=====

Install and configure Aptly server and client.

Available states
================

.. contents::
    :local:

``aptly.server``
----------------

Setup aptly server

``aptly.publisher``
-------------------

Setup aptly publisher

Available metadata
==================

.. contents::
    :local:

``metadata.aptly.server.single``
--------------------------------

Setup basic server


``metadata.aptly.client.publisher``
-----------------------------------

Setup aptly publisher client

Configuration parameters
========================


Example reclass
===============

Basic Aptly server with no repos or mirrors.

.. code-block:: yaml

     classes:
     - service.aptly.server.single
     parameters:
        aptly:
          server:
            enabled: true
            secure: true
            gpg_keypair_id: A76882D3
            gpg_passphrase:
            gpg_public_key: |
              -----BEGIN PGP PUBLIC KEY BLOCK-----
              Version: GnuPG v1
              ...
            gpg_private_key: |
              -----BEGIN PGP PRIVATE KEY BLOCK-----
              Version: GnuPG v1
              ...

Example pillar
==============

.. code-block:: yaml

     aptly:
       server:
         enabled: true
         repo:
           myrepo:
             distribution: trusty
             component: main
             architectures: amd64
             comment: "Custom components"
             publisher:
               component: mycomponent
               distributions:
                 - nightly/trusty

Read more
=========

* http://www.aptly.info/doc/configuration/
