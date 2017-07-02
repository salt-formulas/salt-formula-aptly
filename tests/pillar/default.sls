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
      mirantis_openstack_xenial_salt_testing:
        source: http://apt-mk.mirantis.com/xenial/
        distribution: testing
        component: salt
        architectures: amd64
        gpgkeys:
          - A76882D3
        publisher:
          component: salt-testing
          distributions:
            - ubuntu-xenial/mcp1.0
        comment: salt-testing
      mirantis_openstack_xenial_salt:
        source: http://apt-mk.mirantis.com/xenial/
        distribution: stable
        component: salt
        architectures: amd64
        gpgkeys:
          - |
             -----BEGIN PGP PUBLIC KEY BLOCK-----
             Version: GnuPG v1

             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
             sIYyjtcwJrHue5Xn8UPSLkE=
             =xUw4
             -----END PGP PUBLIC KEY BLOCK-----
        publisher:
          component: salt
          distributions:
            - ubuntu-xenial/mcp1.0
        comment: salt-stable
    mirror_update:
      enabled: true
      hour: 2
      minute: random
    gpg_passphrase: passphrase
    gpg_private_key: |
      -----BEGIN PGP PRIVATE KEY BLOCK-----
      Version: BCPG C# v1.6.1.0

      lQOsBFjjpiUBCADMp/x13InHXlyQGLDqmXMZrBr5+Qc1fc1Mp2asW1WcxlmA4fMf
      OOLoQUlMoyl61WL46ldGzRH1wG7UNT6Zoi+3IqOQTr+jMJrspR2YQKSc5jb+yXPf
      q6p4wxe3emSc7MiYgyspHYjaUpX0A4uWgUB7rlTUPoPU3aDjygSwK8Oxsa1qsw9M
      3buDrt9ZOU9HDkL5I1zXZ2VIUYGvgrR666EWxbPXfoJTwVimblcw1CdJ5s0js2p4
      X75jnsNhKaFTM5jziQWrUmRjCQ9HfQq27BeIMR0BqzA+Lr5UW6y1i1yMEVAtmRjY
      SyC5GP9SUCxsflU56t1OjaKSHgZB7dQIkTpFABEBAAH/AwMCmDb/2n/TZx9goSSD
      lSRmAWiuEXSqFNJt+ilNYz4+AWxjabc5Yo9Yp7YA9YhtHNo8XLvpd+ORRjna+eCn
      ZT8mADfJmVEsLMMtgl0IRj84utEggRM2yTz1TXpgEZlhkBPufB/q+JqC8cZ5qgqc
      jT5gpAgu/aqGlwrww95zsiNPHyvLh00qYhYIie4E9Eoesma5szfXscdcrH55yk7X
      E75tXd1lGVihH1hMixpAzeMPQtqyf3VATkRJizFmVfDhTFnr3F98DvlsikkT0QiA
      DHlQ3P9efuSxfbW7FdB36BmwwD2zqW1rsY6+amx9GFq0jjmT6dr1BPzdB0SP/zmC
      ise/YwjgzdsJi8cfn+6A/ybW7QL/qiVCVxVXxmdWeIOhM3c3gBOAEItfTdgheMTp
      0+eiC67YwiPhd3uP4VkVkdu4HbiRhbqS2xo0XMU2pdpgQS3nbpPgjOJy2d/zWOIT
      um36botJhKGSAR+5ZR4ymwEbmu8XRh+bfL/1yP24ajlRAcycgMQ84CKsguo3IMBT
      SJTdPNZXQ9x6aCyO9a78YwDyT/o8OLU7idKlmrsMfJp5z8y+OeiqAe6FdbsqzyHa
      XBmwUmsglgVI+NZf5500/fDMh8dx7tS5bHKUnguJSOIzRF+4XAmkB5Z9atZDKHch
      Pu8HoGH3EfL53V8RNan60o6viQy/9X1l5Pj/YfccsIaYnZVODfjwPCbwZNBGp0Zi
      sJHyw6WthV0ar1owyY0nIdiis8r7wKn1n1grZW4XRfkO4UmDn1bcNmkIOe2PQ7xg
      Fi7rZQVRRfhe0/gY/42Kh/cj1+VKY//R5t9E29VvLVfok9QYLLvGPSZAvR80SxVj
      SU4NYC1H4KCUzpThyWnaYqo+YaDkhKKQ5UAjxtPKxrQAiQEcBBABAgAGBQJY46Yl
      AAoJEPW/luvR6iT5CwoH/19/jvNqDE6p/YNZmUF3nT0S4WEQ50EjPPOYBA18jN6e
      /9Wqe4RRxGJhE4VvFBPXDprFrenMI5dts4gXltQU8HOQjAZa5LTehwpvx7cRqlK8
      tRdQzJrTsYYJlbdpN5yS/wq990HWijyFDYtXSQUKldZhtKS1QiQUtaG0oMSJSb/8
      xZqpB80D1X6WTNAJS5BawqSclopoDnWe5gPBptJ3Bq/VNY+icQIhh4uAQY/KM8v9
      AClvbSspsgiMssct0ItHWdZNqicII6TA4yTOQa9Jo1euH8nBA2PQcaAuI9luypBB
      fyXfDcG/SajyPSgqkryxbqyYSf6WQ8WfN2ZSCEfNWdQ=
      =tY0L
      -----END PGP PRIVATE KEY BLOCK-----
    gpg_public_key: |
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      Version: BCPG C# v1.6.1.0

      mQENBFjjpiUBCADMp/x13InHXlyQGLDqmXMZrBr5+Qc1fc1Mp2asW1WcxlmA4fMf
      OOLoQUlMoyl61WL46ldGzRH1wG7UNT6Zoi+3IqOQTr+jMJrspR2YQKSc5jb+yXPf
      q6p4wxe3emSc7MiYgyspHYjaUpX0A4uWgUB7rlTUPoPU3aDjygSwK8Oxsa1qsw9M
      3buDrt9ZOU9HDkL5I1zXZ2VIUYGvgrR666EWxbPXfoJTwVimblcw1CdJ5s0js2p4
      X75jnsNhKaFTM5jziQWrUmRjCQ9HfQq27BeIMR0BqzA+Lr5UW6y1i1yMEVAtmRjY
      SyC5GP9SUCxsflU56t1OjaKSHgZB7dQIkTpFABEBAAG0AIkBHAQQAQIABgUCWOOm
      JQAKCRD1v5br0eok+QsKB/9ff47zagxOqf2DWZlBd509EuFhEOdBIzzzmAQNfIze
      nv/VqnuEUcRiYROFbxQT1w6axa3pzCOXbbOIF5bUFPBzkIwGWuS03ocKb8e3EapS
      vLUXUMya07GGCZW3aTeckv8KvfdB1oo8hQ2LV0kFCpXWYbSktUIkFLWhtKDEiUm/
      /MWaqQfNA9V+lkzQCUuQWsKknJaKaA51nuYDwabSdwav1TWPonECIYeLgEGPyjPL
      /QApb20rKbIIjLLHLdCLR1nWTaonCCOkwOMkzkGvSaNXrh/JwQNj0HGgLiPZbsqQ
      QX8l3w3Bv0mo8j0oKpK8sW6smEn+lkPFnzdmUghHzVnU
      =FoXV
      -----END PGP PUBLIC KEY BLOCK-----
