{nixpkgs,...}:
{
  orangePiZero2 = nixosConfigurations.orangePiZero2.config.system.build.sdImage;
}
