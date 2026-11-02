# nix-web

Reproducible Nix development environment for Web CTF challenges and security research.

Supports `x86_64-linux` and `aarch64-linux`.

## Environments

| Environment | Packages                                                        |
|-------------|-----------------------------------------------------------------|
| `default`   | Burp Suite Community, curl, HTTPie, TShark                      |
| `full`      | Default packages + PayloadsAllTheThings, SecLists and wordlists |

### Usage

Enter the default environment:

```bash
nix develop github:sagittarius-a/nix-web
```

Enter the full environment:

```bash
nix develop github:sagittarius-a/nix-web#full
```

Use Fish as the interactive shell:

```bash
nix develop github:sagittarius-a/nix-web -c fish
```

Execute a single command:

```bash
nix develop github:sagittarius-a/nix-web -c tshark --version
```

## Environment variables

| Variable          | Description                                                         |
|-------------------|---------------------------------------------------------------------|
| `name`            | Nix development shell name (`nix-web-env` or `nix-web-full`)        |
| `IN_NIX_SHELL`    | Indicates that the current environment is a Nix shell               |
| `FONTCONFIG_FILE` | Path to the Nix-generated Fontconfig configuration                  |
| `SECLISTS`        | Path to SecLists (full environment only, if configured)             |
| `PAYLOADS`        | Path to PayloadsAllTheThings (full environment only, if configured) |

### Java / Burp Suite

On Gentoo ARM64, Burp Suite encountered two Java errors:

```text
Cannot load com.sun.java.swing.plaf.gtk.GTKLookAndFeel
```

```text
Fontconfig head is null, check your fonts or fonts configuration
```

The development shell uses a self-contained Fontconfig configuration, generated using `pkgs.makeFontsConf` and a Nix-provided font package.

If the GTK Look & Feel issue persists, launch Burp using Java's Metal theme:

```bash
env _JAVA_OPTIONS="-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel" burpsuite
```

`_JAVA_OPTIONS` is a workaround, not a required environment variable for every Java application.

### Troubleshooting

Check the Fontconfig configuration:

```bash
echo "$FONTCONFIG_FILE"
fc-match sans-serif
```

Check the Java environment:

```bash
env | grep -E '^(JAVA_TOOL_OPTIONS|_JAVA_OPTIONS|JDK_JAVA_OPTIONS|FONTCONFIG_FILE)='
```

TShark may require additional system-level permissions for live packet capture. Reading existing PCAP files requires no special capture privileges.

## Home Manager

The flake exposes `homeModules.default` for persistent installation of the default toolset.

Example:

```nix
modules = [
  nix-web.homeModules.default
];
```

The consuming Nixpkgs configuration must permit the unfree `burpsuite` package.
