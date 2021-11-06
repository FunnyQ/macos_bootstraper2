# macOS bootstraper

## Usage

下載這個 repo，在 shell 中執行 `exe/macos`。已在全新的 macOS 環境（新電腦 or 剛 clean install 完）中測試過。

## Notice

- 先執行 `安裝基本系統軟體` 選項。若 oh-my-zsh 安裝完 script 就被中斷，可以再執行一次，確定 ruby 和 nodejs 有成功安裝。
- `建立開發環境` 選項會安裝開發所需的軟體。清單可參考 `lib/macos/scripts/setup_dev_env.sh`。
  - cask 的部分可依需求自行增減
  - mas 會從 mac app store 下載 apps，一樣請依需求自行增減。（macOS 12 之後 mas 暫時無法使用，會略過）
- `設定 macOS 的系統偏好` 會將一些常用的 finder, dock 設定一次做完，特別是突破極限的 keyboard repeat 速度。

## PATH 設定

若使用 Apple Silicon Macs，目前建議讓 x86 的 homebrew bins 優先於 arm64，因此 PATH 的設定可能會是

```sh
# .zshrc for example
export PATH='/usr/local/homebrew/bin:/opt/homebrew/bin:$PATH'
```

也可以透過 `uname -m` 指令取得目前的 CPU 架構，依狀況決定是否將 `/opt/homebrew/bin` 加入 PATH。（這個 script 若在 x86_64 cpu 上執行，不會安裝 arm64 版本的 homebrew）

> Note: 現在（2021-11-06）重新安裝，應該不再需要在 PATH 上對 arm64 homebrew 做特殊處理了。

## Alias

建議以下幾個 alias 可以加入自己的 `.zshrc`

```sh
if [[ $(uname -m) == "arm64" ]]; then
  # e.g. `xbrew install exa`
  alias xbrew="arch -x86_64 /usr/local/homebrew/bin/brew"
  # e.g. `abrew install readline`
  alias abrew="arch -arm64 /opt/homebrew/bin/brew"
  # e.g. `x86 asdf install rust 1.49.0`
  alias x86="arch -x86_64"
  # e.g. `arn asdf install ruby 3.0.1`
  alias arm="arch -arm64"
fi
```
