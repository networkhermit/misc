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
  version     = "6.2.2"
  constraints = "~> 6.2.2"
  hashes = [
    "h1:3gbrNGsK0dQ5zpN0qeHm3uNdWJl+f760+VtV2GJZ8Vg=",
    "zh:43d7e5f1e11d67e38ca717016d209d6d9a6fa03321b489f91984351bfb143b69",
    "zh:46e788395034b410bf59dfa43eb748a3d81ecfd23fc442349990fd7d92bd856a",
    "zh:5234b7d5c5817ff7ebec29756050708372a071a701e2c8236e714a0bd29ef160",
    "zh:74c485a241cc8e8cb99f988d38116fb14e51de896761fc9ca35a34ca5c999a7e",
    "zh:7606789521c50937913ea13f851150828b5f9b8804ba80c5b2538c0b019339d8",
    "zh:760fb0e74590459689c7159456b6e76f165634f7d0f89f5572d56b57d387f645",
    "zh:7979d9085d809bb7d0db2c67e6c3443d1c18d12e51b72220dcb4cc5e883cd64a",
    "zh:8bed25d8199bf8b2e7ccf67edc1a4a2fc041bd490b2c11565c669b80be43896c",
    "zh:9ff82a6279fb7ae0cd9e44f1e73b64dd2aeca43d4d3096f3f2866b1ebbcb9431",
    "zh:a886055ecd63ccb9b880e3c3301c0eca9acb108580d12519617554ae2be9a393",
    "zh:c1f20386704919c7964a95daffcb29f494efb061abc28469840df4532833cecf",
    "zh:cb6e9c4e33d6a57770073867e174c09c0eed401ee70473a688d20cb1cf0394f7",
    "zh:f89ca130cc90b87dc25d036fe8f8cadb6fb53dc33368a032c5cee6275f3bcddc",
    "zh:f94a2d1174091f04ed361192cdda9503baa3d161849d4f218c55a96bfb1ea33d",
    "zh:fbd1fee2c9df3aa19cf8851ce134dea6e45ea01cb85695c1726670c285797e25",
  ]
}
