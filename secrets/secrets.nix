let
  nixos-racknerd-zifan = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJuhVjL9qFOmvr0WIDJSYSkgcQlGoJXd8O5cTQmSXBNKlj/aC1iVNwVpTL/xH/h6j3PJkTQoQgMKA8y/RTSItVvodRxTuGJOBh6Od3Z/Zm5LtMeDb1QjlY6Hhkey9wZ4QKgasRapZIvf7Rd0GJ01pZmM82FsbnPeESsfwYUBz/ee/rE/kySOkGBHjFMGNy7tWLlPOuchzJtf5JPZq22x2cVSRMIzJl+BMv7h+jArOcqWOKx/NxOcMwVJQk8RvONJQNUI774qz7bxYTVU9VIr2ltRWQ4brZglNYjdyyut5cR1yM9uOJg7hKuy/QP2IunzjxeDlJ4sWLUq5vAPTvtwEqjktitkha6yG/q2ZcHQDbl5Lu53zgnOmRZ8x1W1i2llAlV+COLaHFUZX9vGNkpATHShBX5xxrMUAn5mRoGHAuioQW4SPkkWEnrhlQrL4iqFZyrfXduGMMPlWvn6Er/HCi4/JSFG3y3bntvJ4SQaKTMkBsWwAqVG/qN6AritwYkS0= zifan@nixos";
  nixos-hentzner-zifan = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgdCxrHQGKaoV3GtLX5/joCDZz7+ULNpJm4388UYKE+wCaEkVDafy2/AhErCOi9jdd5+i7h6GGSrHu6m/TPhnyQsbJh1n+Uj2u8YsCvfW5+a9qXaki8MFXXss9m2yVyB8o4/sSPIG3f3AkpoQeLydiqxJRi4+sU4YN2M+dCuDMAGD+7mFyghlwF3TSs02YhIicyx0twAyK5LDLMJ3McU/QtwO19z/uItb3DzNs2jyQ70k6voThI+xM7npm8eDyzyEFiDfZlaBWT0jEnjSEjna7FamJUXqT8nQTtSb/1aWiLTJnqOjZTL8wpv16GovPZrg2qWDFjZeRLeidazFexCMXGV++H8V4ruEpN8E2z1G2t3z28miL29stzU28eNekNF9eQWeEjEKfmY1+Me0f/tDjNMR6tn9Mj/ibD8eZ4DtW14X96UPBHoOn84CNulWdCBB/7ioqXLyXj1E5Bq5V0GPK6Uz8+B3hj1CAAzZRpy9BJcMqaevri0HlHMqaDwZDwdE= zifan@nixos";
  m1-macbook = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbZqo2WJ5GeKWwFp9WaAeIIZh9DKNUvmF0bhB+nTiUPZCReuRY6CtxUl/C3j2cU6BxcVY1t4R41IvIwG5CLz9mnHJshv4I2F8y20NrBqZyL5n6DM5CRhzRXonZohdHP8eheTePajLI9z7PHdyD/OaVLch2nStpv7q343mbuK+9nknbRj77J53tDUPqoMaH/8QLtqPksEi8PLtBdaW0afTmikR24Jzt4bDTLPuTIvVvAqipjyGsH14AhuovYOjw35HFORAwA/nhNp2qjVVz04qFnt12B5ZEjGcDMItqWqOp5hdn0ukUQ8tEs9ScayDT9FnJPRtjRuQSa6GjlGn7+c/oR6xsdvKZ9uCApzMnpP04YjnCuF+rAJ9lhIKPvXLWB1g7viM4579umIM2BmU1njLz7Bgj2dATU2TGcpPMT5mpXp9vUmP3kP6+MUCI1pL1Q0fI+ilpmnT7kB5Lihf0vXOYBlLI1hvTAKiJY/A/xUdd5ZYtGvKxhZkF1rDB/Fnl268= zifanhua@Zifans-MacBook-Pro.local";
  users = [
    nixos-racknerd-zifan
    nixos-hentzner-zifan
    m1-macbook
  ];

  nixos-racknerd-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4r5wzxVmjmq+7/nDAKMPxFyyF00ztcxXKgZ5DWrObu root@nixos";
  nixos-hentzner-system = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCGBMRyO/NBrD/5h+hUidavoPVBQoczbaO1LeUl5erWmkmFcIQ0K/yV6i2foF9/07YxaLTZNtOb5SQx8IUBg++oymk+CsZnGjEZqC8VQtIItVYqdZ+UBjF4X9YOOfYnPGkbOmveox+ODSNWMZ9FI52y0N0kZG+PcmpVeVPvXxfii8OMwQprn+gOKJ86iD/qhJmIS1r4IKAueFoX/H0Rh2kSDsdczS0ft8m9sJaV0TBzEZbqbbgIX0SxcaYGmHSM/L40218RkDEGsbSk6Jntvf7E6VftTMgjDRswbKuMNwWXjy0g5h5EWjWZct5kkdXsqT4kc3gWyY3HRuUlr7s/uQs4FNzbjSp02POZSAhSvJhmUHxKfTaaRrNPc6Y0qDZ9bKLR0f7Dg/CpXvwrpQoFzfwxNNtS4xYt25Da/kyoQyWh7NJHc0mHhUcSJSuOGthawo4GvaYjC9FmQpvxITiIqS0QGhTNiPLe+VXegCXvawK//DJNWUWANs6wU3W1pVm8FRSdjnFrSodwjWh4RYMH/Djo4a+6g6CvThNtzAe1tQsbHg3eh4TmR0JRCvyeo0JOlfNMiuTcpaTdv3u2DEH7HEFyU1Wfe8l9DIz2zArCeFAxOkof3r6x1ZLfDXNmLLr5ex944NbN31arTJulG25I1QAv2SqfI4JxJtFQfWX/YQt/dQ== root@nixos";
  systems = [
    nixos-hentzner-system
    nixos-racknerd-system
  ];
in
{
  "hetzner-webdav-secrets".publicKeys = systems ++ users;
  "cloudflare-email-api-key".publicKeys = systems ++ users;
  "v2ray-config".publicKeys = systems ++ users;
  "hysteria-obfs".publicKeys = systems ++ users;
  "hysteria-alpn".publicKeys = systems ++ users;
  "tailscale-key".publicKeys = systems ++ users;
}
