
{ pkgs }:

let
  common = with pkgs; [
    burpsuite
    curl
    httpie
    wireshark-cli
  ];

  full = with pkgs; [
    payloadsallthethings
    seclists
    wordlists
  ];
in
{
  inherit common full;
}

