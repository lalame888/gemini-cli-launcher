# Gemini CLI Launcher
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows-blue.svg)

這是一個圖形化啟動器 (GUI Launcher)，用來簡化啟動 `gemini` 命令列工具的流程，支援 macOS 和 Windows 作業系統。

## 問題背景

直接使用 `gemini` CLI 工具時，可能需要先在終端機中手動設定特定的 Node.js 版本 (透過 `nvm` 或 `nvm-windows`)，並切換到正確的專案目錄。這個過程比較繁瑣。

本專案透過一個圖形介面，讓使用者可以一次性設定好所需環境，並提供「直接啟動」與「重置設定」的選項，大幅簡化了日常使用流程。

## 功能

本專案會產生兩個獨立的應用程式：

1.  **`Gemini CLI Launcher.app` (macOS) / `Gemini CLI Launcher.exe` (Windows)**: 
    *   提供圖形化介面，讓使用者設定 `nvm` (macOS) 或 `nvm-windows` (Windows) 版本和 `gemini` 專案目錄。
    *   可儲存設定，並提供「下次不再詢問」的選項，實現快速啟動。
    *   自動產生並執行 Shell/Batch 腳本，在新終端機視窗中完成環境設定並啟動 `gemini`。

2.  **`Reset Settings.app` (macOS) / `Reset Settings.exe` (Windows)**: 
    *   提供一個簡單、直覺的方式來刪除已儲存的設定。
    *   使用者點擊後，會彈出確認視窗，同意後即可將所有設定恢復到預設狀態。

## 核心技術簡介

本專案主要圍繞以下核心技術：

### NVM (Node Version Manager) / NVM-Windows

**NVM (Node Version Manager)** 是一個用於管理多個 Node.js 版本的工具。它允許你在不同的專案之間輕鬆切換 Node.js 版本，確保開發環境的隔離與穩定。

*   **macOS/Linux**：請參考 [NVM 官方 GitHub 頁面](https://github.com/nvm-sh/nvm) 上的指示進行安裝。通常會是類似以下的指令：
    ```bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    ```
    或者使用 `wget`：
    ```bash
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    ```
    *(請注意：`v0.39.7` 是撰寫本文時的穩定版本，你可以訪問 [NVM 官方 GitHub 頁面](https://github.com/nvm-sh/nvm) 查看最新版本。)*

    安裝後，請務必依照 NVM 的指示設定你的 shell 環境 (例如將 `source ~/.nvm/nvm.sh` 加入到 `.zshrc` 或 `.bash_profile`)。

*   **Windows**：請參考 [NVM-Windows 官方 GitHub 頁面](https://github.com/coreybutler/nvm-windows) 上的指示進行安裝。

    安裝後，請確保 `nvm` 指令在你的命令提示字元或 PowerShell 中可用。

**驗證安裝**：

要確認 NVM/NVM-Windows 是否已正確安裝，請執行以下指令：

```bash
nvm --version
```
如果顯示版本號，則表示安裝成功。如果看到「command not found」，請確保你已正確設定並載入 shell/環境變數。

### Gemini CLI

**Gemini CLI** 是一個命令列介面工具，本啟動器旨在簡化其在特定 Node.js 環境下的啟動流程。

**如何安裝 Gemini CLI**：

請使用以下指令全域安裝 Gemini CLI：

```bash
sudo npm install -g @google/gemini-cli
```

## 系統與建置需求 (macOS & Windows)

在開始之前，請確保你的系統已安裝以下軟體：

1.  **作業系統**:
    *   macOS 13 (Ventura) 或更高版本。
    *   Windows 10 或更高版本。
2.  **Python 3.12 (或更高版本)**：
    *   **macOS**：**強烈建議**從 [Python 官方網站](https://www.python.org/downloads/macos/) 下載並安裝。這會確保你安裝的是與 macOS GUI 工具鏈最相容的「框架建置 (Framework Build)」版本。
    *   **Windows**：從 [Python 官方網站](https://www.python.org/downloads/windows/) 下載並安裝。安裝時請務必勾選「Add Python to PATH」選項。
    *   **確認安裝**：你可以在終端機/命令提示字元中執行 `python3 --version` (macOS/Linux) 或 `py --version` (Windows) 來確認 Python 3 是否已安裝並在 PATH 中。
3.  **Node Version Manager (nvm)** (macOS/Linux) 或 **NVM-Windows** (Windows)：
    *   macOS/Linux：請參考 [nvm 的官方說明](https://github.com/nvm-sh/nvm) 進行安裝。
    *   Windows：請參考 [nvm-windows 的官方說明](https://github.com/coreybutler/nvm-windows) 進行安裝。
4.  **Node.js**：請透過 `nvm` 或 `nvm-windows` 安裝你需要的 Node.js 版本 (例如 `nvm install 22`)。

## 如何建置

本專案提供一個自動化腳本 `build.sh`，可以簡化打包流程。請依照以下步驟來打包產生應用程式：

1.  **Clone 專案**:
    ```bash
    git clone git@github.com:lalame888/gemini-cli-launcher.git
    cd gemini-cli-launcher
    ```

2.  **執行打包腳本**:

    腳本預設會以「單一檔案 (onefile)」模式進行建置。你也可以選擇建置為「資料夾 (folder)」模式。以下是兩種模式的簡單說明：

    *   **單一檔案 (onefile) 模式**：將所有程式碼和依賴項打包成一個獨立的可執行檔 (例如 `Gemini CLI Launcher.exe`)。
        *   **優點**：分發簡單，只有一個檔案。
        *   **缺點**：啟動速度可能稍慢，因為每次執行時都需要在背景解壓縮檔案。
    *   **資料夾 (folder) 模式**：建立一個包含主執行檔和所有依賴項 (如 `.dll`、`.pyc` 檔案) 的資料夾。
        *   **優點**：啟動速度比單一檔案模式快。
        *   **缺點**：需要分發整個資料夾，相對不便。

    *   **macOS/Linux**:
        ```bash
        # 建置為單一檔案 (預設)
        ./build.sh

        # 或者，建置為資料夾模式
        ./build.sh folder
        ```

    *   **Windows (Command Prompt)**:
        ```cmd
        rem 建置為單一檔案 (預設)
        build.bat

        rem 或者，建置為資料夾模式
        build.bat folder
        ```

5.  **完成**!
    建置完成後，你可以在 `dist` 資料夾中找到 `Gemini CLI Launcher` 和 `Reset Settings` 這兩個應用程式。

## 使用方式

-   將 `dist` 資料夾中的應用程式檔案複製到你喜歡的任何位置 (例如 macOS 的「應用程式」資料夾，或 Windows 的任何目錄)。
-   執行 `Gemini CLI Launcher` 來進行設定或啟動。
-   如果需要恢復預設設定，執行 `Reset Settings` 即可。

## 授權

本專案採用 MIT License 授權 - 詳細內容請參閱 [LICENSE](LICENSE) 檔案。