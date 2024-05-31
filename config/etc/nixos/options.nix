{lib, ...}: {
  options.local = {
    ansibleUser = lib.mkOption {
      type = lib.types.str;
    };

    direct = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };

    useVirtualPHC = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    wireguard = lib.mkOption {
      default = {};
      type = lib.types.attrs;
    };
  };
}
