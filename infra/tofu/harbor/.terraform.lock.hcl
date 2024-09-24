# This file is maintained automatically by "tofu init".
# Manual edits may be lost in future updates.

provider "registry.opentofu.org/fluxcd/flux" {
  version     = "1.3.0"
  constraints = ">= 1.3.0, ~> 1.3.0"
  hashes = [
    "h1:QS/4t5bXr0nlBfTj9CclBuWLqq64m1MpRCTEqnCNoi8=",
    "zh:3cd796472b0b3125ae7cd2097e68e9fa2f9abbef8f629326a9138ef9a4607ec3",
    "zh:3efe1aba8bec2dbacd90877245bbdca43455c19883f1cef0c3bc0ed80de399ea",
    "zh:48da143b7f2225a5f0e809ce2918578a8ffac043c72e2f49c7077b6c922b4361",
    "zh:49e2b02a59d70c62ed246760b534b5eca910a0652e2709a9c4889341d84f3cbd",
    "zh:5b1a633bb00a9054d9110775221a3d10a582a1a7d19efe3dc27022d1d7ffd7e0",
    "zh:5e379ae01d86d9ad4db256549d9f0b0752f4fb8b9c5bdd9c1fb499d82bb57aa3",
    "zh:626296b4fa6674d9daab2e274b61f8c3c11e89d315480ec750b06d9addee5d4e",
    "zh:63fbfe3eff24bdb5bb7cb1a690f5baea54945d3bb2b221d4f01f36faa92ad6ef",
    "zh:849b5edbdf4a36ab63e175c4b99866cb691e03c4a6a0749cc8781ccf6d8090e2",
    "zh:a506d18d692575523103c59b9d2ab5b2373580e998ca28bd9665b98e2709126c",
    "zh:a5d1e2126e9ed60cb5968ac7ceba3d423a817eecbefc13d5f144557987ff8cf9",
    "zh:c7618ea66e01138a4e197fc3342f8948e73513b8eb90ad6c2c5e745f40b442b8",
    "zh:e281ce8b034a925f10f7beb2dbc59795a03cf06527be2bba4b432b7a8cd1c8b9",
    "zh:ecb7908d82879a1914f4cbdd54787ba1c3e08f43de8d503b77e2245cb5570294",
  ]
}

provider "registry.opentofu.org/hashicorp/helm" {
  version     = "2.15.0"
  constraints = ">= 2.15.0, ~> 2.15.0"
  hashes = [
    "h1:Cak4To+L1FxO1qkb2Gaonyjtdpu+vglc6NHynyUHylw=",
    "zh:21394ae3ec6f8ccda74688f8aeb979c03c9c52b60b5d0ada10521b5a75ae85af",
    "zh:248ba25e309432dc7a2a6049da9178731ae3884be1761c4e349c844ce5159d82",
    "zh:30dd6046b239f8b3788958475ad4db9b956c99ea71a0492fe6f2380d8d711ffc",
    "zh:40691066592cdd396226ff0ecd4153dce91799375282c3c8a13fdf21d616c73b",
    "zh:54b16f5ac335903f6bd6c7ba03c66b894940511a0d16c6ad92a16fe9ef80aaa8",
    "zh:9af1702deec999a8ba5fa379de6eb515bf8b045bb02a7f24e3aa1a559f88ec12",
    "zh:d057a371798b526b32d6985baaaf6e8126f14f23e1ebd65b44b970064c7790e5",
    "zh:de6fa77b4763ccdcf8d5546d54609299e3b0a2cfe3446e62d5cfa7806e2aa003",
    "zh:e2a21a57031a97abd3a61c09ffa84f4aae451329e876c2cd6597e02947ca1008",
    "zh:f8d12702874a935e0e2397bdb050f4d4c0d83fb4c0a9c7dfd1b49257605149bd",
  ]
}

provider "registry.opentofu.org/hashicorp/tls" {
  version     = "4.0.6"
  constraints = "~> 4.0.6"
  hashes = [
    "h1:EJoUGDo7L52Iu22cA1KCndJ9B1Rrfd75wyZzsScEnc0=",
    "zh:4b53b372767e5068d9bbfc89199201c1ae4283dde2f0c301974f8abb4215791f",
    "zh:5b4c308bd074c6d0bd560220e6ee10a9859ca9a1f29a59367b0477a740ff265e",
    "zh:674dd6bc85597677e160ee601d88b21c5a974759a658769812d2904bd94bc042",
    "zh:6ccc1c448349b56677ba66112aec7e0a58eb827f66209ca5f4077b81cce240fb",
    "zh:8aa6e13a5d722b74230937ea21e8b4994e53340d95b5691cf6cf3518b9f38e6e",
    "zh:8b27e55e4c7fa887774860113b95c8f7f68804b002fa47f0eb8e3a485997287e",
    "zh:a430b5a3e8753d8f61784de49e538ac4abed19fb665fccd8a10b55402fe9f076",
    "zh:b07c978c335ae9fc12f9c221629610775e4ae36691ed4e7ba258d275dd58a243",
    "zh:bbec8cb1efc84ee3026c793956a4a4cd0ece20b89d2d4f7d954c68e7f6d596d0",
    "zh:e684e247424188dc3b500a543b1a8046d1c0ec08c2a90aedca0c4f6bb56bedbd",
  ]
}

provider "registry.opentofu.org/integrations/github" {
  version     = "6.3.0"
  constraints = "~> 6.3.0"
  hashes = [
    "h1:LEs8NwSWwYGHxmbJvGT1w3XeAM6pogAmskY8XavuWDs=",
    "zh:04fe3b820fe8c247b98b9d6810b8bb84d3e8ac08054faf450c42489815ef4bfa",
    "zh:24096b2d16208d1411a58bdb8df8cd9f0558fb9054ffeb95c4e7e90a9a34f976",
    "zh:2b27332adf8d08fbdc08b5f55e87691bce02c311219e6deb39c08753bd93db6d",
    "zh:335dd6c2d50fcdce2ef0cc194465fdf9df1f5fdecc805804c78df30a4eb2e11e",
    "zh:383a6879565969dbdf5405b651cd870c09c615dbd3df2554e5574d39d161c98c",
    "zh:4903038a6bc605f372e1569695db4a2e2862e1fc6cf4faf9e13c5f8f4fa2ed94",
    "zh:4cc4dffbee8b28102d38abe855b7440d4f4226261b43fda2ec289b48c3de1537",
    "zh:57c30c6fe0b64fa86906700ceb1691562b62f2b1ef0404952aeb4092acb6acb3",
    "zh:7bf518396fb00e4f55c406f2ffb5583b43278682a92f0864a0c47e3a74627bbb",
    "zh:93c2c5cb90f74ad3c0874b7f7d8a866f28a852f0eda736c6aef8ce65d4061f4d",
    "zh:9562a82a6193a2db110fb34d1aceeedb27c0a640058dce9c31b37b17eeb5f4e7",
    "zh:ac97f2d111703a219f27fcbf5e89460ea98f9168badcc0913c8b214a37f76814",
    "zh:c882af4d33b761ec198cedac212ab1c114d97540119dc97daca38021ab3edd0a",
    "zh:c9ffd0a37f07a93af02a1caa90bfbea27a952d3e5badf4aab866ec71cdb184a3",
    "zh:fbd1fee2c9df3aa19cf8851ce134dea6e45ea01cb85695c1726670c285797e25",
  ]
}
