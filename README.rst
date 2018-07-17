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

Define s3 endpoint:

.. code-block:: yaml

    parameters:
      aptly:
        server:
          endpoint:
            mys3endpoint:
              engine: s3
              awsAccessKeyID: xxxx
              awsSecretAccessKey: xxxx
              bucket: test


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
             sources: false
             pkg_dir: /var/lib/aptly/incoming/myrepo/pkgs
             changes_dir: /var/lib/aptly/incoming/myrepo/changes
             remove_files: true
             gpgkeys:
               - 8F759C86
             publisher:
               component: mycomponent
               distributions:
                 - nightly/trusty

Basic Aptly server mirrors

.. code-block:: yaml

     aptly:
       server:
         mirror:
           mirror_name:
             source: http://example.com/debian
             distribution: xenial
             components: main
             architectures: amd64
             gpgkeys:
               - 460F3999
             filter: "!(Name (% *-dbg))"
             filter_with_deps: true
             publisher:
               component: example
               distributions:
                 - xenial/repo/nightly
                 - "s3:aptcdn:xenial/repo/nightly"


Aptly server publish

.. code-block:: yaml

     aptly:
       server:
         mirror:
           debian_jessie:
             source: http://deb.debian.org/debian/
             distribution: jessie
             update: true
             snapshots:
               - name: debian_jessie-20180215
         repo:
           myrepo:
             distribution: jessie
             component: main
             architectures: amd64,armhf
             comment: "Myrepo specific packages"
             snapshots:
               - name: myrepo-20180215
         publish:
           - snapshot: debian_jessie-20180215
             prefix: dev/debian
             distribution: jessie
             component: main
           - snapshot: myrepo-20180215
             prefix: dev/myrepo
             distribution: jessie
             component: main


Proxy environment variables (optional) in cron job for mirroring script

.. code-block:: yaml

  aptly:
    server:
      enabled: true
      ...
      mirror_update:
        enabled: true
        http_proxy: "http://1.2.3.4:8000"
        https_proxy: "http://1.2.3.4:8000"
      ...

Read more
=========

* http://www.aptly.info/doc/configuration/

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-aptly/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-aptly

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
