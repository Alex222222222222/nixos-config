{...}:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEbWF5tOP9ul4s/rAfx615yEb0z9yjEtiX254rFcdS/ zifan@nixos"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbZqo2WJ5GeKWwFp9WaAeIIZh9DKNUvmF0bhB+nTiUPZCReuRY6CtxUl/C3j2cU6BxcVY1t4R41IvIwG5CLz9mnHJshv4I2F8y20NrBqZyL5n6DM5CRhzRXonZohdHP8eheTePajLI9z7PHdyD/OaVLch2nStpv7q343mbuK+9nknbRj77J53tDUPqoMaH/8QLtqPksEi8PLtBdaW0afTmikR24Jzt4bDTLPuTIvVvAqipjyGsH14AhuovYOjw35HFORAwA/nhNp2qjVVz04qFnt12B5ZEjGcDMItqWqOp5hdn0ukUQ8tEs9ScayDT9FnJPRtjRuQSa6GjlGn7+c/oR6xsdvKZ9uCApzMnpP04YjnCuF+rAJ9lhIKPvXLWB1g7viM4579umIM2BmU1njLz7Bgj2dATU2TGcpPMT5mpXp9vUmP3kP6+MUCI1pL1Q0fI+ilpmnT7kB5Lihf0vXOYBlLI1hvTAKiJY/A/xUdd5ZYtGvKxhZkF1rDB/Fnl268= zifanhua@Zifans-MacBook-Pro.local"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCLAlaehHvpkghZNbT1EhQPod4KM9wxqeZOLr8Yxo/Vfvf4JjvnCuRBX/bjzfRDI2j4FQe8fAZM7B48XaehOZN4QjgkrbAbGQuMjaevbNdtSkXVM0b2L5NYTSmHFuzIUCRa50mTD3hgJJBsuGhHblZvqiPwFQjGCoUp+IXc8hVpYyohiz/V8SoDekDTGBOw8Z/VqzsGV9Trn2kdB9KCtpCEt3/ofGJwRC4nbIwIESG3f8nzAgGUWlgSq/ordn7GeH2Fu6aqTOEg03UKivLo31luZmmXNb7uBgKl8NW0G4dW4Khdv3IdbjnLP8Q+qa+z3ZH15t5YTpbEPe38bTrEJH/5EBohr/Yc3RaMHs1fMgY/zuKmP5z55/PzeRF8RkFtMjfcjZ0xmS0FfZNwtE6E8EpDRhtM6E8TFIac2A+JdcKjY4lVOZPbIB5TQeePcpi2WwocDvAmo7KJTnRUh319IYbxLRRuTzedO8mpqqvVfCZ4JfC6Q82C515CWWBWn4IkITc="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgdCxrHQGKaoV3GtLX5/joCDZz7+ULNpJm4388UYKE+wCaEkVDafy2/AhErCOi9jdd5+i7h6GGSrHu6m/TPhnyQsbJh1n+Uj2u8YsCvfW5+a9qXaki8MFXXss9m2yVyB8o4/sSPIG3f3AkpoQeLydiqxJRi4+sU4YN2M+dCuDMAGD+7mFyghlwF3TSs02YhIicyx0twAyK5LDLMJ3McU/QtwO19z/uItb3DzNs2jyQ70k6voThI+xM7npm8eDyzyEFiDfZlaBWT0jEnjSEjna7FamJUXqT8nQTtSb/1aWiLTJnqOjZTL8wpv16GovPZrg2qWDFjZeRLeidazFexCMXGV++H8V4ruEpN8E2z1G2t3z28miL29stzU28eNekNF9eQWeEjEKfmY1+Me0f/tDjNMR6tn9Mj/ibD8eZ4DtW14X96UPBHoOn84CNulWdCBB/7ioqXLyXj1E5Bq5V0GPK6Uz8+B3hj1CAAzZRpy9BJcMqaevri0HlHMqaDwZDwdE="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnYWX7CjhTORHbVQYqldCwvYhNi8IBYUDi+vB53sU+H"
  ];
in
{
  users.users.zifan.openssh.authorizedKeys.keys = keys;
  users.users.root.openssh.authorizedKeys.keys = keys;
}