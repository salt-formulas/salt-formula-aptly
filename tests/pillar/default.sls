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
    mirror_update:
      enabled: true
      hour: 2
      minute: random
      http_proxy: "http://1.2.3.4:8000"
      https_proxy: "https://1.2.3.4:8000"
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
