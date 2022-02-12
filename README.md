# Fish VS Code

A [Fish] plugin that augments the [VS Code] CLI.

## Installation

Use [Fisher]:

```fish
fisher install mk12/fish-vscode
```

## Usage

Just use the `code` function. This does two new things on top of the regular VS Code CLI:

- On macOS, it uses `open -b com.microsoft.VSCode` which is faster and avoids a dock animation.
- On Linux, if `~/.vscode-server` exists, it assumes you're ssh'd to a server and tries to open the file in your local VS Code client.

## License

© 2022 Mitchell Kember

Fish VS Code is available under the MIT License; see [LICENSE](LICENSE.md) for details.

[Fish]: https://fishshell.com
[Fisher]: https://github.com/jorgebucaran/fisher
[VS Code]: https://code.visualstudio.com
