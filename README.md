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
3.  **Node Version Manager (nvm)** (macOS/Linux) 或 **NVM-Windows** (Windows)：
    *   macOS/Linux：請參考 [nvm 的官方說明](https://github.com/nvm-sh/nvm) 進行安裝。
    *   Windows：請參考 [nvm-windows 的官方說明](https://github.com/coreybutler/nvm-windows) 進行安裝。
4.  **Node.js**：請透過 `nvm` 或 `nvm-windows` 安裝你需要的 Node.js 版本 (例如 `nvm install 22`)。

## 如何建置

請依照以下步驟來打包產生應用程式：

1.  **Clone 專案**:
    ```bash
    git clone git@github.com:lalame888/gemini-cli-launcher.git
    cd gemini-cli-launcher
    ```

2.  **建立並啟用 Python 虛擬環境**:
    *   請務必使用你從官方網站安裝的 Python 版本。
    *   **macOS**:
        ```bash
        # 將 python3.12 換成你安裝的實際版本
        /usr/local/bin/python3.12 -m venv venv
        source venv/bin/activate
        ```
    *   **Windows (Command Prompt)**:
        ```cmd
        py -3.12 -m venv venv
        venv\Scripts\activate.bat
        ```
    *   **Windows (PowerShell)**:
        ```powershell
        py -3.12 -m venv venv
        .\venv\Scripts\Activate.ps1
        ```
    啟用成功後，你的終端機提示符前會出現 `(venv)`。

3.  **安裝依賴套件**:
    ```bash
    pip install pyinstaller
    ```

4.  **執行打包指令**:

    `PyInstaller` 提供兩種主要的打包模式：「單檔案 (One-file)」和「單資料夾 (One-folder)」。

    *   **單檔案模式 (`--onefile` 或 `-F`)**：
        *   **優點**：`dist` 資料夾中只會產生一個 `.app` (macOS) 或 `.exe` (Windows) 檔案，發佈最簡潔。
        *   **缺點**：每次啟動時需要先解壓縮到暫存目錄，**啟動速度會較慢**。
        *   **指令**：
            *   **macOS 主程式**:
                ```bash
                pyinstaller --onefile --windowed --name "Gemini CLI Launcher" \
                --add-data "run_gemini_logic.sh:." \
                --add-data "app.icns:." \
                --icon "app.icns" \
                start_gemini.py
                ```

            *   **macOS 重置程式**:
                ```bash
                pyinstaller --onefile --windowed --name "Reset Settings" \
                --add-data "app.icns:." \
                --icon "app.icns" \
                reset_settings.py
                ```

            *   **Windows 主程式**:
                ```cmd
                pyinstaller --onefile --windowed --name "Gemini CLI Launcher" ^
                --add-data "app.ico;." ^
                --icon "app.ico" ^
                start_gemini.py
                ```

            *   **Windows 重置程式**:
                ```cmd
                pyinstaller --onefile --windowed --name "Reset Settings" ^
                --add-data "app.ico;." ^
                --icon "app.ico" ^
                reset_settings.py
                ```

    *   **單資料夾模式 (`--onedir` 或 `-D`)**：
        *   **優點**：應用程式啟動速度快，因為所有資源都已在資料夾中，無需解壓縮。
        *   **缺點**：`dist` 資料夾中會產生一個 `.app` (macOS) 或資料夾 (Windows) 和一個同名的資料夾。分發時需要將 `.app` 或 `.exe` 和該資料夾一起提供。
        *   **指令**：
            *   **macOS 主程式**:
                ```bash
                pyinstaller --onedir --windowed --name "Gemini CLI Launcher" \
                --add-data "run_gemini_logic.sh:." \
                --add-data "app.icns:." \
                --icon "app.icns" \
                start_gemini.py
                ```

            *   **macOS 重置程式**:
                ```bash
                pyinstaller --onedir --windowed --name "Reset Settings" \
                --add-data "app.icns:." \
                --icon "app.icns" \
                reset_settings.py
                ```

            *   **Windows 主程式**:
                ```cmd
                pyinstaller --onedir --windowed --name "Gemini CLI Launcher" ^
                --add-data "app.ico;." ^
                --icon "app.ico" ^
                start_gemini.py
                ```

            *   **Windows 重置程式**:
                ```cmd
                pyinstaller --onedir --windowed --name "Reset Settings" ^
                --add-data "app.ico;." ^
                --icon "app.ico" ^
                reset_settings.py
                ```

    **建議**：如果對啟動速度有要求，建議使用「單資料夾模式」。如果追求發佈的簡潔性，則使用「單檔案模式」。

5.  **完成**!
    建置完成後，你可以在 `dist` 資料夾中找到 `Gemini CLI Launcher.app` (macOS) / `Gemini CLI Launcher.exe` (Windows) 和 `Reset Settings.app` (macOS) / `Reset Settings.exe` (Windows) 這兩個應用程式。
    *   如果使用「單檔案模式」，`dist` 資料夾中只會有 `.app` 或 `.exe` 檔案。
    *   如果使用「單資料夾模式」，`dist` 資料夾中會同時有 `.app` 或 `.exe` 檔案和同名的資料夾，分發時請務必將兩者一起提供。

## 使用方式

-   將 `dist` 資料夾中的應用程式檔案複製到你喜歡的任何位置 (例如 macOS 的「應用程式」資料夾，或 Windows 的任何目錄)。
-   執行 `Gemini CLI Launcher` 來進行設定或啟動。
-   如果需要恢復預設設定，執行 `Reset Settings` 即可。

## 授權

本專案採用 MIT License 授權 - 詳細內容請參閱 [LICENSE](LICENSE) 檔案。