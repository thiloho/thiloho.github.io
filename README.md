# thilohoholt.com

This is the source code for my personal website, which was built using the Astro web framework.

In addition to the website itself, the repository includes Nix files (`flake.nix` and `server/*.nix`), which are used to configure the self-hosted services listed on the website (https://thilohohlt.com/services) and to easily locally deploy to the corresponding NixOS server.

## Main commands

- Use the command `npm run dev` to start the Astro development server
- Run `npm run format` to format the web code with Prettier
- Run `nix develop` to enter the dev shell, which includes packages for Nix language support and formatting
- Run `nix run .#deploy-server` to evaluate if the current configuration builds successfully. If so, it will deploy the changes to the remote NixOS server

For good IDE support (e.g., NixOS option completions in `default.nix`), use the `jnoortheen.nix-ide` VSCode extension with the following settings:

```json
{
  "nix.enableLanguageServer": true,
  "nix.serverPath": "nil",
  "nix.serverSettings": {
    "nixd": {
      "formatting": {
        "command": ["nixfmt"]
      }
    }
  }
}
```
