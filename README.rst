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
             sources: false
             publisher:
               component: mycomponent
               distributions:
                 - nightly/trusty

Use GPG key from pillar or url
------------------------------

.. code-block:: yaml
           mirantis_openstack_xenial_salt:
             source: http://apt-mk.mirantis.com/xenial/
             distribution: stable
             components: salt
             architectures: amd64
           ...
             gpgkeys:
               - A76882D3
           ...
               - |
                  -----BEGIN PGP PUBLIC KEY BLOCK-----
                  Version: GnuPG v1

                  mQINBFWBfCIBEADf6lnsY9v4rf/x0ribkFlnHnsv1/yD+M+YgZoQxYdf6b7M4/PY
                  zZ/c3uJt4l1vR3Yoocfc1VgtBNfA1ussBqXdmyRBMO1LKdQWnurNxWLW7CwcyNke
                  xeBfhjOqA6tIIXMfor7uUrwlIxJIxK+jc3C3nhM46QZpWX5d4mlkgxKh1G4ZRj4A
                  mEo2NduLUgfmF+gM1MmAbU8ekzciKet4TsM64WAtHyYllGKvuFSdBjsewO3McuhR
                  i1Desb5QdfIU4p3gkIa0EqlkkqX4rowo5qUnl670TNTTZHaz0MxCBoYaGbGhS7gZ
                  6/PLm8fJHmU/phst/QmOY76a5efZWbhhnlyYLIB8UjywN+VDqwkNk9jLUSXHTakh
                  dnL4OuGoNpIzms8juVFlnuOmx+FcfbHMbhAc7aPqFK+6J3YS4kJSfeHWJ6cTGoU1
                  cLWEhsbU3Gp8am5fnh72RJ7v2sTe/rvCuVtlNufi5SyBPcEUZoxFVWAC/hMeiWzy
                  drBIVC73raf+A+OjH8op9XfkVj6czxQ/451soe3jvCDGgTXPLlts+P5WhgWNpDPa
                  fOfTHn/2o7NwoM7Vp+BQYKAQ78phsolvNNhf+g51ntoLUbxAGKZYzQ5RPsKo+Hq6
                  96UCFkqhSABk0DvM0LtquzZ+sNoipd02w8EaxQzelDJxvPFGigo1uqGoiQARAQAB
                  tCdDbG91ZGxhYiBTaWduaW5nIEtleSA8aW5mb0B0Y3BjbG91ZC5ldT6JAjgEEwEC
                  ACIFAlWBfCICGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJECQAhQmnaILT
                  WH8P/ivk/bVA7ngC4IJQemedRgg/5oFspwzJ2RHmGSLru6U0kVYmrJBqUBX5mzCo
                  eJNXu6ZK7cBV3gEtrDRNT3BXM+F0l3WhoUTHsf4/l+V+pMP3CqFnSmJYxxXwQomX
                  c/QGk98IoiVRSXapeCmLie1Ct/tQV4jdxqamOXpREUOGzJMV4A9hkPbmHwOMtVu0
                  rOq3pWl8VZncGZyIcK2cgJMYKSUNOaGSj7hunQgu2nk6Z8q6d7igQ5sufz4EqNhU
                  QEGxylHcy/nRWfWDzBed/iLpdICGJc+WdogfxzS5puXcqHUgO7tGTdjcnzoCkLc0
                  KszrlsgtbDh/kikuToZe1nQBC267B7A7YMSkeqF392ub9twlaNVFFLd5kMajDkyS
                  ZCOfZ3RKrEyZetM/e37qQolg9azKlX9a5Dxj4i1NqU+WaUbiomZDQzynKrFO2FJU
                  dEJxwVLtAjpmnp+5C8LxzLLs778nTsCqCoS8CP091QdBqJOckVPbe0HQ3ild5Pi/
                  0G7p4YxpHAWq5MqUvlJa/Dy+w8ZbrtZw35rOwNW+eWXIgn2PuO0w8MC5JE+6QG8d
                  1ib3v4jRe8yeua8bvIK9f5t34DqWixT7zi4ki/99NgGKaX/VoUU911uNICcAPtAy
                  aVs+5j05FrHjwx+u+4fAnhCwEYOlk8SRsexnsfx2lYU2y1D5tCx0Y3BjbG91ZCBz
                  aWduaW5nIGtleSA8YXV0b2J1aWxkQHRjcGNsb3VkLmV1PokCHAQQAQIABgUCVa12
                  awAKCRBoCCObnHLmGwleD/0TgEwWWIVJu9ViqxaMdB7ZkXPA9uCWA0Jf9Rd2Qadt
                  dDiLhpAUEfxtmIkZxuF0KGUyVMxFIlKwTEuJCQJcX5XAlj0DwleR9CvM2Sx7pOZh
                  N2CC1hsru8H/rRFwLFdECpcQVFzJwuD4bESOkfcZ1hBeH9OzGdJYukUem1Tu/ySo
                  TtmeQPdxM37FwM5WePq8Q/JssaNRQeGLWc+tOWDMM/E8BGunQON3f2EbLQ9gVy0L
                  2KYENumHtbqF0CjFC0XrPB2c700oB8SFtwogci65xXxCPlKpy1ACKe3I9GpqZmFc
                  5TXnjrWBH8rIHHOefFzqT13W7aUOreu/UWslv+h3BDBN77f/+KYFmOKLuSFIJUid
                  ytshkHbrwHN11IzUTmXWGYGmuN/zkj+1R/L2NrL/RjUBB7lFFzeZ2v91aJtLyK/m
                  /vmUjtxK2Jbkntmghd3LqYsV9hLPqKCuofK/PlakaMOnEzsRXDvOgETNejJb4/WZ
                  czCl21YSANxf2kfS1NAVGUpO+U8E/36sF235p1l9uEb3+vfNdLhEVC0X0SdMtMKd
                  8F+maf/CzVfjAaK+XyoMDDbEk234IVmKli+xtg6CnfsM9LEKAB8osqE0FCsF4yvM
                  UBluZ3ri6T9GZA3jC65HEsZHJQsks95RJ5Au4x7pcyNKMp/V1MkV86HmzGjMkcXS
                  J4kCOwQTAQIAJQIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AFAlWj4K8CGQEA
                  CgkQJACFCadogtPm9xAAl1D1RUY1mttjKk+8KI3tUmgtqLaIGUcB4TPbIhQpFy23
                  TJd6BnnEaGZ+HSCj3lp/dBoq1xxCqHCziKA04IpPaLpGJf8cqaKOpQpW1ErlSxT6
                  nCQWFrHFxZreBTljKqW3fvRBXNAquj0krJEwv19/3SsQ+CJI2Zkq/HPDw9eJOCu0
                  WcJMPVtAq2SmaDigh1jtFcFoWZ7uFFMQPIWit/RCPkDfkFaf6lbYZ/nnvWON9OAg
                  zWciGJjCp5a7vMyCpTRy6bgNPqM61omCe0iQ4yIcqANXhRYS/DBnjKr9YaDKnlKN
                  Ugd1WRE8QzErQznH/plgISQ+df+8Iunp3SBr/jj1604yyM1Wxppn1+dAoTBU1OPF
                  GVd3mCEYHUe+v0iTZ69C2c1ISmp2MjciGyE/UPbW9ejUIXtFJAJovZjn6P3glyIQ
                  B3wqAW6JE+xEBWH7Ix+Uv6YNAFfj3UO6vNjtuGbTCWYDCEJRkdmeE7QdTYDo7Pxg
                  Pl1t6xMGPLOBdYNJTEojvRYBTt+6iw0eZ+MCUdUFNeaseQh0p1RgqM9/7t75QCNL
                  l1oO+Cfu4vNef/Tpd3LHcUoQhQ2OViOVFbq1/Yu/natWDPDcXb3peTcNHOjmXAob
                  oWbzrDkxj5z7vcJ9LMEXviP6Fb/iXDmJh74/o6Agc8efb0WTmFjPFFtMCHrinb+5
                  Ag0EVYF8IgEQALUVS2GESQ+F1S4b0JIO1M2tVBXiH4N56eUzcDXxXbSZgCgx4aWh
                  k5vJQu7M11gtqIoiRbmuFpUmDOG/kB7DxBZPn8WqcBKpky6GUP/A/emaAZTwNQdc
                  DAhDfoBkJdhVz0D2jnkBffYL055p/r1Ers+iTTNOas/0uc50C32xR823rQ2Nl6/f
                  fIM6JqfQenhRvqUWPj9oqESHMsqEdceSwS/VC7RN4xQXJXfEWu2q4Ahs62RmvCXn
                  Tw1AsPcpysoBoo8IW+V1MVQEZuAJRn2AGO/Q7uY9TR4guHb3wXRfZ3k0KVUsyqqd
                  usJiT3DxxBw6GcKdOH6t41Ys3eYgOrc+RcSdcHYSpxaLvEIhwzarZ+mqcp3gz/Jk
                  PlXS2tx2l6NZHcgReOM7IhqMuxzBbpcrsbBmLBemC+u7hoPTjUdTHKEwvWaeXL4v
                  gsqQBbEeKmXep5sZg3kHtpXzY9ZfPQrtGB8vHGrfaZIcCKuXwZWGL5GGWKw3TSP4
                  fAIAjLxLf5MyyXcsugbai2OY/H4sAuvJHsmGtergGknuR+iFdt5el1wgRKP1r1Kd
                  mvMmwsSayc6eSEKd689x3zsmAtnhYM31oMkPdeYRbnN15gLG7vcsVe4jug0YTqQt
                  2WGnhwjBA0i2qfTorXemWChsxKllvY9aB3ST8I6RMat0kS08FMD+Ced/ABEBAAGJ
                  Ah8EGAECAAkFAlWBfCICGwwACgkQJACFCadogtNicA/9HOM402VGHlmuYPcrvETh
                  HqMKKOTtNFsrrPp67dGYaT8TGTgy1OG4Oys2y+hrwqnUK6dXJxX2/RBfRuO/gw65
                  RCfC9nWeMkqJTjHJCKNTYfXN4O4ag444UZPcOMq+IyiWF3/sh674zCkCm5DQ/FH8
                  IJ8Yn4jMoxe7G48PCGtgcJKXo8NBzxwXJH4DCdk7rNdrbrnCwObG8h6530WrmzKu
                  yFCJQP5JA0MSx23J2OrK2YmVMhTeO0czJ8fRip9We9/qAfZGUEW+sey+nLmT5OJq
                  04alVa9g2a4nXxzDy84+hRXQNUeCRYn/ys8d8q9HZNv3K36HlILcuWazNTTh0cuW
                  upBdSlIEuWbIdbknYpGsmS1cPeGi0bdoLZv90BIVmdOS/vXP02fGUblyANciKcBP
                  RhOI+z6hzwdZ+QvjPbxZUig5XuvqBhIHoRtMBJdf24ysFuf/d4uZzTC8T4rUQO+L
                  29bt8riT0dg6cHVwC0VH89FaO1FduvsCtAwdAgxSzOMBECNOmVBThIiWdLnns107
                  Rp4FECk+l2UCjl7zwGqJqcd1BQK+UgZwVG2UV11CrhopKU5oGL84n5DaO2n6Rv8w
                  VdrtMKvqi7EkgvZpY0IHJ7rp0Gzrv0qmwJaUFCWFogITNyijb1JVsUgDTMhAkEgE
                  sIYyjtcwJrHue5Xn8UPSLkE=
                  =xUw4
                  -----END PGP PUBLIC KEY BLOCK-----
           ...
             publisher:
               component: salt
               distributions:
                 - ubuntu-xenial/mcp1.0


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
