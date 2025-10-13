# Gemini CLI Launcher
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows-blue.svg)

<p>這是一個圖形化啟動器 (GUI Launcher)，用來簡化啟動 `gemini` 命令列工具的流程，支援 macOS 和 Windows 作業系統。</p>
<img width="328" height="358" alt="截圖 2025-10-13 下午3 59 24" src="https://github.com/user-attachments/assets/285c60a9-3c18-4425-9509-c1c4df34ace6" />

## 這個工具解決了什麼問題？

如果您厭倦了每次啟動 `gemini` 指令前，都需要手動打開終端機、透過 `nvm use <version>` 切換 Node.js 版本，然後再 `cd` 到專案目錄的繁瑣流程，那麼這個工具就是為您設計的。

本專案提供一個圖形介面，讓您一次性設定好所需環境，之後便可一鍵啟動，大幅簡化您的日常工作流程。

## 前提條件 (Prerequisites)

在開始之前，請確認您的系統已具備以下環境。本工具是為已有 `nvm` 和 `gemini-cli` 使用經驗的使用者設計的輔助工具。

1.  **確認 Gemini CLI 已安裝**
    *   您必須已透過 `npm` 全域安裝了 `@google/gemini-cli`。
    *   請在終端機執行 `gemini -v`，如果成功顯示版本號，代表已正確安裝。
        ```bash
        gemini -v
        ```
    *   <details>
        <summary>點此展開/收合 Gemini CLI 安裝指南</summary>
        
        > **Gemini CLI** 是一個命令列介面工具，本啟動器旨在簡化其在特定 Node.js 環境下的啟動流程。
        > 
        > **如何安裝 Gemini CLI**：
        > 
        > 請使用以下指令全域安裝 Gemini CLI：
        > 
        > ```bash
        > npm install -g @google/gemini-cli
        > ```
        </details>

2.  **NVM 已安裝 (可選)**
    *   如果您的系統中需要管理多個 Node.js 版本，建議安裝 [nvm](https://github.com/nvm-sh/nvm) (macOS/Linux) 或 [nvm-windows](https://github.com/coreybutler/nvm-windows)。
    *   請在終端機執行 `nvm -v`，如果成功顯示版本號，代表已正確安裝。
        ```bash
        nvm -v
        ```

    *   <details>
        <summary>點此展開/收合 NVM 安裝指南</summary>

        > **NVM (Node Version Manager)** 是一個用於管理多個 Node.js 版本的工具。它允許你在不同的專案之間輕鬆切換 Node.js 版本，確保開發環境的隔離與穩定。
        >
        >*   **macOS/Linux**：請參考 [NVM 官方 GitHub 頁面](https://github.com/nvm-sh/nvm) 上的指示進行安裝。通常會是類似以下的指令：
        >    ```bash
        >    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        >    ```
        >    或者使用 `wget`：
        >    ```bash
        >    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        >    ```
        >    *(請注意：`v0.39.7` 是撰寫本文時的穩定版本，你可以訪問 [NVM 官方 GitHub 頁面](https://github.com/nvm-sh/nvm) 查看最新版本。)*
        >
        >    安裝後，請務必依照 NVM 的指示設定你的 shell 環境 (例如將 `source ~/.nvm/nvm.sh` 加入到 `.zshrc` 或 `.bash_profile`)。
        >
        >*   **Windows**：請參考 [NVM-Windows 官方 GitHub 頁面](https://github.com/coreybutler/nvm-windows) 上的指示進行安裝。
        >
        >    安裝後，請確保 `nvm` 指令在你的命令提示字元或 PowerShell 中可用。
        >
        >**驗證安裝**：
        >
        >要確認 NVM/NVM-Windows 是否已正確安裝，請執行以下指令：
        >
        >```bash
        >nvm --version
        >```
        >如果顯示版本號，則表示安裝成功。如果看到「command not found」，請確保你已正確設定並載入 shell/環境變數。
        </details>

## 功能

本專案會產生兩個獨立的應用程式：

1.  **`Gemini CLI Launcher.app` (macOS) / `Gemini CLI Launcher.exe` (Windows)**: 
    *   提供圖形化介面，讓使用者設定 `nvm` (macOS) 或 `nvm-windows` (Windows) 版本和 `gemini` 專案目錄。
    *   可儲存設定，並提供「下次不再詢問」的選項，實現快速啟動。
    *   自動產生並執行 Shell/Batch 腳本，在新終端機視窗中完成環境設定並啟動 `gemini`。

2.  **`Reset Settings.app` (macOS) / `Reset Settings.exe` (Windows)**: 
    *   提供一個簡單、直覺的方式來刪除已儲存的設定。
    *   使用者點擊後，會彈出確認視窗，同意後即可將所有設定恢復到預設狀態。

## 安裝方式

我們提供預先建置好的安裝檔，建議所有使用者透過此方式安裝。

1.  **下載最新版本**
    *   請前往本專案的 **[Releases 頁面](https://github.com/lalame888/gemini-cli-launcher/releases)**。

2.  **進行安裝**

    *   **Windows**:
        1.  在最新的版本中，下載 `Gemini-CLI-Launcher-Setup-vX.X.X.exe` 檔案。
        2.  執行下載的 `.exe` 檔案，並依照安裝程式的指示完成安裝。
        3.  安裝完成後，您可以從「開始」功能表或桌面捷徑啟動 `Gemini CLI Launcher`。

    *   **macOS**:
        1.  在最新的版本中，下載 `Gemini-CLI-Launcher.dmg` 檔案。
        2.  雙擊打開下載的 `.dmg` 檔案。
        3.  在彈出的視窗中，將 `Gemini CLI Launcher` 圖示拖曳到「應用程式」(Applications) 資料夾的捷徑上。
        4.  安裝完成！您現在可以從「應用程式」資料夾中啟動它。
        5.  注意：初次開啟時，需要針對應用程式點選右鍵 > 打開，這時候會跳出一個安全性的確認，點選「打開」，往後才能正常開啟。
           <img width="482" height="123" alt="截圖 2025-10-13 下午3 54 20" src="https://github.com/user-attachments/assets/5c341ba2-27cf-448b-a178-8cea11cf3bb2" />
           <hr></hr>
           <img width="275" height="382" alt="截圖 2025-10-13 下午3 56 36" src="https://github.com/user-attachments/assets/9f2d3202-9ae6-4b6f-a009-8d24ac5f0945" />

3.  **首次設定**
    *   第一次執行 `Gemini CLI Launcher` 時，請在圖形介面中設定您要使用的 Node.js 版本和 `gemini` 專案所在的目錄。
    *   如果您希望未來跳過此設定畫面直接執行，可以勾選「下次不再詢問，直接執行」。

4.  **重設設定**
    *   如果您需要修改或清除設定，可以執行與主程式一同安裝的 `Reset Settings` 應用程式。

---

## 開發者：如何從原始碼建置

若要從原始碼建置本專案，您的開發環境需要滿足以下需求。

### 系統與建置需求

1.  **作業系統**:
    *   macOS 13 (Ventura) 或更高版本。
    *   Windows 10 或更高版本。
2.  **Python 3.12+**:
    *   從 [Python 官方網站](https://www.python.org/) 下載並安裝。
    *   **Windows**: 安裝時請務必勾選「Add Python to PATH」。
    *   **macOS**: 建議安裝官網的「Framework Build」版本。
3.  **NVM / NVM-Windows**:
    *   macOS/Linux：請參考 [nvm 的官方說明](https://github.com/nvm-sh/nvm)。
    *   Windows：請參考 [nvm-windows 的官方說明](https://github.com/coreybutler/nvm-windows)。
4.  **(Windows Installer)** **Inno Setup**:
    *   若要在 Windows 上打包成 `.exe` 安裝檔，您必須安裝 [Inno Setup](https://jrsoftware.org/isinfo.php)。
    *   安裝時請務必勾選「將 Inno Setup 安裝目錄加到環境變數 PATH」。
5.  **(macOS Installer)** **create-dmg**:
    *   若要在 macOS 上打包成 `.dmg` 安裝檔，您必須先安裝 `create-dmg` (`brew install create-dmg`)。

### 建置流程

1.  **Clone 專案**:
    ```bash
    git clone git@github.com:lalame888/gemini-cli-launcher.git
    cd gemini-cli-launcher
    ```

2.  **執行建置腳本**:
    腳本會自動建立虛擬環境、安裝依賴並打包應用程式。

    *   **Windows (使用 Command Prompt 或 PowerShell)**:
        ```cmd
        # 建置單一的 .exe 執行檔 (預設)
        .\build.bat

        # 建置資料夾形式的執行檔
        .\build.bat folder

        # 建置資料夾形式的執行檔，並打包成 .exe 安裝檔
        .\build.bat installer
        ```

    *   **macOS/Linux**:
        ```bash
        # 建置 .app 應用程式 (預設)
        ./build.sh

        # 建置資料夾形式的應用程式
        ./build.sh folder

        # 建置 .dmg 安裝檔
        ./build.sh dmg
        ```

## 授權

本專案採用 MIT License 授權 - 詳細內容請參閱 [LICENSE](LICENSE) 檔案。
