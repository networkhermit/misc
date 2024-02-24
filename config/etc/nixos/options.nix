{lib, ...}: {
  options = {
    local.ansibleUser = lib.mkOption {
      type = lib.types.str;
    };

    local.direct = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };

    local.wireguard = lib.mkOption {
      default = {};
      type = lib.types.attrs;
    };
  };
}
