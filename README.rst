=====
Usage
=====

The Aptly formula configures and installs the Aptly server and client.

The available states include:

* ``aptly.server``
* ``aptly.publisher``

The available metadata include:

* ``metadata.aptly.server.single``
* ``metadata.aptly.client.publisher``

This file provides the sample configurations for different use cases.

* Reclass examples:

  * The basic Aptly server configuration without repositories or mirrors:

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

  * The definition of an s3 endpoint:

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


* Pillar examples:

  * The Aptly server basic configuration:

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
                 publisher:
                   component: mycomponent
                   distributions:
                     - nightly/trusty

  * The Aptly server mirrors configuration:

    .. code-block:: yaml

         aptly:
           server:
             mirror:
               mirror_name:
                 source: http://example.com/debian
                 distribution: xenial
                 components: main
                 architectures: amd64
                 gpgkeys: 460F3999
                 filter: "!(Name (% *-dbg))"
                 filter_with_deps: true
                 publisher:
                   component: example
                   distributions:
                     - xenial/repo/nightly
                     - "s3:aptcdn:xenial/repo/nightly"


  * The definition of the proxy environment variables in cron job for
    mirroring script:

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

**Read more**

* http://www.aptly.info/doc/configuration/

**Documentation and bugs**

* http://salt-formulas.readthedocs.io/
   Learn how to install and update salt-formulas

* https://github.com/salt-formulas/salt-formula-ntp/issues
   In the unfortunate event that bugs are discovered, report the issue to the
   appropriate issue tracker. Use the Github issue tracker for a specific salt
   formula

* https://launchpad.net/salt-formulas
   For feature requests, bug reports, or blueprints affecting the entire
   ecosystem, use the Launchpad salt-formulas project

* https://launchpad.net/~salt-formulas-users
   Join the salt-formulas-users team and subscribe to mailing list if required

* https://github.com/salt-formulas/salt-formula-aptly
   Develop the salt-formulas projects in the master branch and then submit pull
   requests against a specific formula

* #salt-formulas @ irc.freenode.net
   Use this IRC channel in case of any questions or feedback which is always
   welcome
