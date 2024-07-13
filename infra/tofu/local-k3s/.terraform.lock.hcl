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
  version     = "2.14.0"
  constraints = ">= 2.14.0, ~> 2.14.0"
  hashes = [
    "h1:ibK3MM61pVjBwBcrro56OLTHwUhhNglvGG9CloLvliI=",
    "zh:1c84ca8c274564c46497e89055139c7af64c9e1a8dd4f1cd4c68503ac1322fb8",
    "zh:211a763173934d30c2e49c0cc828b1e34a528b0fdec8bf48d2bb3afadd4f9095",
    "zh:3dca0b703a2f82d3e283a9e9ca6259a3b9897b217201f3cddf430009a1ca00c9",
    "zh:40c5cfd48dcef54e87129e19d31c006c2e3309ee6c09d566139eaf315a59a369",
    "zh:6f23c00ca1e2663e2a208a7491aa6dbe2604f00e0af7e23ef9323206e8f2fc81",
    "zh:77f8cfc4888600e0d12da137bbdb836de160db168dde7af26c2e44cf00cbf057",
    "zh:97b99c945eafa9bafc57c3f628d496356ea30312c3df8dfac499e0f3ff6bf0c9",
    "zh:a01cfc53e50d5f722dc2aabd26097a8e4d966d343ffd471034968c2dc7a8819d",
    "zh:b69c51e921fe8c91e38f4a82118d0b6b0f47f6c71a76f506fde3642ecbf39911",
    "zh:fb8bfc7b8106bef58cc5628c024103f0dd5276d573fe67ac16f343a2b38ecee8",
  ]
}

provider "registry.opentofu.org/hashicorp/tls" {
  version     = "4.0.5"
  constraints = "4.0.5"
  hashes = [
    "h1:zEH0OgSkeXDqNWzmOUWDczrUwyyujAHvnbW79qdxVMI=",
    "zh:05a7dc3ac92005485714f87541ad6d0d478988b478c5774227a7d39b01660050",
    "zh:547e0def44080456169bf77c21037aa6dc9e7f3e644a8f6a2c5fc3e6c15cf560",
    "zh:6842b03d050ae1a4f1aaed2a2b1ca707eae84ae45ae492e4bb57c3d48c26e1f1",
    "zh:6ced0a9eaaba12377f3a9b08df2fd9b83ae3cb357f859eb6aecf24852f718d9a",
    "zh:766bcdf71a7501da73d4805d05764dcb7c848619fa7c04b3b9bd514e5ce9e4aa",
    "zh:84cc8617ce0b9a3071472863f43152812e5e8544802653f636c866ef96f1ed34",
    "zh:b1939e0d44c89315173b78228c1cf8660a6924604e75ced7b89e45196ce4f45e",
    "zh:ced317916e13326766427790b1d8946c4151c4f3b0efd8f720a3bc24abe065fa",
    "zh:ec9ff3412cf84ba81ca88328b62c17842b803ef406ae19152c13860b356b259c",
    "zh:ff064f0071e98702e542e1ce00c0465b7cd186782fe9ccab8b8830cac0f10dd4",
  ]
}

provider "registry.opentofu.org/integrations/github" {
  version     = "6.2.3"
  constraints = "~> 6.2.3"
  hashes = [
    "h1:nHTegsQYYUJZbaTnU1aMJBgnZUbR2zsfCl7DsL/kZjQ=",
    "zh:05874671652a260b12d784cc46b0eea156f493a5f12e00368d1f6cb319156257",
    "zh:0c7a3cae5a66e5c5efc3b25ba646a0d46bfe1fd3edba1f5a75f51aede85a9d1b",
    "zh:174310010d08f13e36e53ff18e44a21dd040c89884ef190a192c6ce27926a912",
    "zh:23d1d8731e518354ce6a83419f49101aece63882b0ca7c489f3c598cc6ea5d5e",
    "zh:4e88953816daf11ab1681c32c7988d4e29476fc44f0959fe03173532cf5044de",
    "zh:6fab07734ccf27f5afee4442abae2d33245eabf35519032ce1e2aad6961a640a",
    "zh:7b2f324b918e161c892c29ee80d36c48ca8b891b8047e132fc701ca741e5ae72",
    "zh:8ef4f0d691ade98082ef1f6b36e556468e5ab26e60021f0de0fb22e3acdfd990",
    "zh:8f0f3e139faa8f2b9075bb9978dd683f4bab5ac91171bbb969addd04d7f0b90f",
    "zh:97cb6d7fdf640237cc2f0ab830db8f878770968c59fd28298e9dddb8b9e6294d",
    "zh:a17038d8747c6bb660e4c5981e8ffbbc33c66ba164868fd35d442e7f828a1e01",
    "zh:aa9f4b7d947f7b11277b4e9ba7147f5594cf60a6589b7aac4344f73d1400d1c0",
    "zh:c780b951e14d583ef6ffef9a934831b56ee157c50ed8e969c676a636810f7db1",
    "zh:d8497bb2986fd76107b7208b33cc39281797164fdea09453e987b969a461befb",
    "zh:fbd1fee2c9df3aa19cf8851ce134dea6e45ea01cb85695c1726670c285797e25",
  ]
}
