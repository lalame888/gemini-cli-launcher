# Gemini CLI Launcher
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)

**[macOS 專用]** 這是一個為 macOS 使用者設計的圖形化啟動器 (GUI Launcher)，用來簡化啟動 `gemini` 命令列工具的流程。

## 問題背景

直接使用 `gemini` CLI 工具時，可能需要先在終端機中手動設定特定的 Node.js 版本 (透過 `nvm`)，並切換到正確的專案目錄。這個過程比較繁瑣。

本專案透過一個圖形介面，讓使用者可以一次性設定好所需環境，並提供「直接啟動」與「重置設定」的選項，大幅簡化了日常使用流程。

## 功能

本專案會產生兩個獨立的 macOS 應用程式：

1.  **`Gemini CLI Launcher.app`**:
    *   提供圖形化介面，讓使用者設定 `nvm` 版本和 `gemini` 專案目錄。
    *   可儲存設定，並提供「下次不再詢問」的選項，實現快速啟動。
    *   自動產生並執行 Shell 腳本，在新終端機視窗中完成環境設定並啟動 `gemini`。

2.  **`Reset Settings.app`**:
    *   提供一個簡單、直覺的方式來刪除已儲存的設定。
    *   使用者點擊後，會彈出確認視窗，同意後即可將所有設定恢復到預設狀態。

## 系統與建置需求 (macOS Only)

在開始之前，請確保你的系統已安裝以下軟體：

1.  **作業系統**: macOS 13 (Ventura) 或更高版本。
2.  **Python 3.12 (或更高版本)**：
    *   **強烈建議**從 [Python 官方網站](https://www.python.org/downloads/macos/) 下載並安裝。這會確保你安裝的是與 macOS GUI 工具鏈最相容的「框架建置 (Framework Build)」版本。
3.  **Node Version Manager (nvm)**：請參考 [nvm 的官方說明](https://github.com/nvm-sh/nvm) 進行安裝。
4.  **Node.js**：請透過 `nvm` 安裝你需要的 Node.js 版本 (例如 `nvm install 22`)。

## 如何建置

請依照以下步驟來打包產生兩個 `.app` 應用程式：

1.  **Clone 專案**:
    ```bash
    git clone git@github.com:lalame888/gemini-cli-launcher.git
    cd gemini-cli-launcher
    ```

2.  **建立並啟用 Python 虛擬環境**:
    *   請務必使用你從官方網站安裝的 Python 版本。
    ```bash
    # 將 python3.12 換成你安裝的實際版本
    /usr/local/bin/python3.12 -m venv venv
    source venv/bin/activate
    ```
    啟用成功後，你的終端機提示符前會出現 `(venv)`。

3.  **安裝依賴套件**:
    ```bash
    pip install pyinstaller
    ```

4.  **執行打包指令**:

    `PyInstaller` 提供兩種主要的打包模式：「單檔案 (One-file)」和「單資料夾 (One-folder)」。

    *   **單檔案模式 (`--onefile` 或 `-F`)**：
        *   **優點**：`dist` 資料夾中只會產生一個 `.app` 檔案，發佈最簡潔。
        *   **缺點**：每次啟動時需要先解壓縮到暫存目錄，**啟動速度會較慢**。
        *   **指令**：
            *   **打包主程式**:
                ```bash
                pyinstaller --onefile --windowed --name "Gemini CLI Launcher" \
                --add-data "run_gemini_logic.sh:." \
                --add-data "app.icns:." \
                --icon "app.icns" \
                start_gemini.py
                ```

            *   **打包重置程式**:
                ```bash
                pyinstaller --onefile --windowed --name "Reset Settings" \
                --icon "app.icns" \
                reset_settings.py
                ```

    *   **單資料夾模式 (`--onedir` 或 `-D`)**：
        *   **優點**：應用程式啟動速度快，因為所有資源都已在資料夾中，無需解壓縮。
        *   **缺點**：`dist` 資料夾中會產生一個 `.app` 檔案和一個同名的資料夾。分發時需要將 `.app` 和該資料夾一起提供。
        *   **指令**：
            *   **打包主程式**:
                ```bash
                pyinstaller --onedir --windowed --name "Gemini CLI Launcher" \
                --add-data "run_gemini_logic.sh:." \
                --add-data "app.icns:." \
                --icon "app.icns" \
                start_gemini.py
                ```

            *   **打包重置程式**:
                ```bash
                pyinstaller --onedir --windowed --name "Reset Settings" \
                --icon "app.icns" \
                reset_settings.py
                ```

    **建議**：如果對啟動速度有要求，建議使用「單資料夾模式」。如果追求發佈的簡潔性，則使用「單檔案模式」。

5.  **完成**!
    建置完成後，你可以在 `dist` 資料夾中找到 `Gemini CLI Launcher.app` 和 `Reset Settings.app` 這兩個應用程式。
    *   如果使用「單檔案模式」，`dist` 資料夾中只會有 `.app` 檔案。
    *   如果使用「單資料夾模式」，`dist` 資料夾中會同時有 `.app` 檔案和同名的資料夾，分發時請務必將兩者一起提供。

## 使用方式

-   將 `dist` 資料夾中的兩個 `.app` 檔案複製到你喜歡的任何位置 (例如「應用程式」資料夾)。
-   執行 `Gemini CLI Launcher.app` 來進行設定或啟動。
-   如果需要恢復預設設定，執行 `Reset Settings.app` 即可。

## 授權

本專案採用 MIT License 授權 - 詳細內容請參閱 [LICENSE](LICENSE) 檔案。