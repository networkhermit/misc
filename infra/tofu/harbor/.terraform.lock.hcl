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
  version     = "2.13.2"
  constraints = ">= 2.13.0, ~> 2.13.2"
  hashes = [
    "h1:awziMwD7imC6roJl4BkZQACDxPdonmfcjymgHpmUXXg=",
    "zh:06e13e0a75a36b5da0da9b02ae6d17cdef7cc83f260a33a08716570b1f74bc60",
    "zh:4066e37caa4804314e11e0a75b1cbad462aec6b6bf520a603c286dd429820a8f",
    "zh:557576ae38792fe31c0551474bd67b80b7553ac99759f9570edf0b6c5600ed4b",
    "zh:7719589f6ac0c9d1c5d82505d4cf166f9f8f0213d9fda779a4adcfa1b17bd75d",
    "zh:7ccbb99857c5bc6727d0462efb530682c46c890e0ff5a137bb1d0775f17f779a",
    "zh:917a412b942fb0feee707b488e2c3d7cf6dee2aa2d3172c0673362f38f160068",
    "zh:bfb4e65d8494f640fd5c7c3b799bac9ebf59ee2fd01a1c9c76080e07ecfd5d31",
    "zh:c1b308165157c89ac77bb62b0af88f08aec8aef8252b15cf6d741212027b7124",
    "zh:e924ee98b2402669b76d01dcc2b85fa1e30f2f8e8803785b9c70220cc4af94bf",
    "zh:ec690745b6dc44ffba1e89ff87dc7ef1180be8c2752b7f3d0683ba45a55dc47c",
  ]
}

provider "registry.opentofu.org/hashicorp/tls" {
  version     = "4.0.5"
  constraints = "~> 4.0.5"
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
  version     = "6.2.1"
  constraints = "~> 6.2.1"
  hashes = [
    "h1:ip7024qn1ewDqlNucxh07DHvuhSLZSqtTGewxNLeYYU=",
    "zh:172aa5141c525174f38504a0d2e69d0d16c0a0b941191b7170fe6ae4d7282e30",
    "zh:1a098b731fa658c808b591d030cc17cc7dfca1bf001c3c32e596f8c1bf980e9f",
    "zh:245d6a1c7e632d8ae4bdd2da2516610c50051e81505cf420a140aa5fa076ea90",
    "zh:43c61c230fb4ed26ff1b04b857778e65be3d8f80292759abbe2a9eb3c95f6d97",
    "zh:59bb7dd509004921e4322a196be476a2f70471b462802f09d03d6ce96f959860",
    "zh:5cb2ab8035d015c0732107c109210243650b6eb115e872091b0f7b98c2763777",
    "zh:69d2a6acfcd686f7e859673d1c8a07fc1fc1598a881493f19d0401eb74c0f325",
    "zh:77f36d3f46911ace5c50dee892076fddfd64a289999a5099f8d524c0143456d1",
    "zh:87df41097dfcde72a1fbe89caca882af257a4763c2e1af669c74dcb8530f9932",
    "zh:899dbe621f32d58cb7c6674073a6db8328a9db66eecfb0cc3fc13299fd4e62e7",
    "zh:ad2eb7987f02f7dd002076f65a685730705d04435313b5cf44d3a6923629fb29",
    "zh:b2145ae7134dba893c7f74ad7dfdc65fdddf6c7b1d0ce7e2f3baa96212322fd8",
    "zh:bd6bae3ac5c3f96ad9219d3404aa006ef1480e9041d4c95df1808737e37d911b",
    "zh:e89758b20ae59f1b9a6d32c107b17846ddca9634b868cf8f5c927cbb894b1b1f",
  ]
}
