import tkinter as tk
from tkinter import messagebox, filedialog
import json
import os
import subprocess
import sys
import tempfile # 新增這一行

# --- 常數設定 ---
import sys

# 將設定檔放在使用者 home 目錄下的 .config 資料夾，是比較標準的做法
if sys.platform == 'win32':
    CONFIG_DIR = os.path.join(os.getenv('APPDATA'), "gemini_cli_launcher")
else:
    CONFIG_DIR = os.path.expanduser("~/.config/gemini_cli_launcher")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")

# SHELL_SCRIPT_PATH 已移除，改用臨時檔案

# --- 設定管理 ---

def get_default_config():
    """回傳一個預設的設定字典"""
    # 判斷是否為 PyInstaller 打包的應用程式
    if getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'):
        # PyInstaller 打包的應用程式
        # 從 sys.executable (例如 .../AppName.app/Contents/MacOS/AppName) 向上追溯到 .app 所在的目錄
        app_path = os.path.dirname(os.path.dirname(os.path.dirname(sys.executable)))
        # 再向上追溯一層，得到 dist 目錄
        default_gemini_dir = os.path.dirname(app_path)
    else:
        # 未打包的 Python 腳本
        default_gemini_dir = os.path.dirname(os.path.abspath(__file__))

    return {
        "use_nvm": True,
        "node_version": "22",
        "gemini_directory": default_gemini_dir,
        "skip_gui": False
    }

def load_config():
    """載入設定檔，如果檔案或目錄不存在則回傳預設值"""
    if not os.path.exists(CONFIG_FILE):
        return get_default_config()
    try:
        with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError):
        return get_default_config()

def save_config(config):
    """儲存設定到 JSON 檔案"""
    try:
        os.makedirs(CONFIG_DIR, exist_ok=True)
        with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=4)
    except IOError as e:
        messagebox.showerror("儲存錯誤", f"無法儲存設定檔: {e}")

# --- 核心執行邏輯 ---

def generate_and_run_script(config):
    """根據設定動態生成並執行 Shell/Batch 腳本"""
    gemini_dir = config.get("gemini_directory", "")
    if not os.path.isdir(gemini_dir):
        messagebox.showerror("路徑錯誤", f"指定的目錄不存在: {gemini_dir}")
        return

    if sys.platform == 'win32':
        # Windows 邏輯
        batch_lines = []
        batch_lines.append(f"cd /d \"{gemini_dir}\"" ) # /d 參數用於切換不同磁碟機

        if config.get("use_nvm", False):
            node_version = config["node_version"]
            batch_lines.append(f"call nvm use {node_version}") # nvm-windows 使用 call nvm
            batch_lines.append(f"if %errorlevel% neq 0 (echo 無法切換到 Node.js v{node_version}，請確認已安裝該版本並設定 NVM-Windows) && pause && exit /b %errorlevel%")
        
        batch_lines.append("echo --- Starting Gemini CLI ---")
        batch_lines.append("gemini")
        batch_lines.append("echo --- Gemini CLI exited. Press any key to close this terminal. ---")
        batch_lines.append("pause") # 等待使用者按任意鍵

        # 將批次指令寫入一個臨時 .bat 檔案
        batch_script_path = os.path.join(os.getenv('TEMP'), "run_gemini_logic.bat")
        try:
            with open(batch_script_path, 'w', encoding='utf-8') as f:
                f.write("\n".join(batch_lines))
            
            # 使用 start 命令在新的 CMD 視窗中執行批次檔
            subprocess.Popen(f"start cmd.exe /k \"{batch_script_path}\"", shell=True)
            
        except IOError as e:
            messagebox.showerror("腳本錯誤", f"無法寫入或執行 Batch 腳本: {e}")
        except Exception as e:
            messagebox.showerror("未知錯誤", f"發生預期外的錯誤: {e}")

    else:
        # macOS/Linux 邏輯
        script_lines = ["#!/bin/bash"]
        
        if config.get("use_nvm", False):
            script_lines.extend([
                'echo "--- Setting up NVM environment ---"',
                'export NVM_DIR="$HOME/.nvm"',
                '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || echo "NVM script not found, skipping..."',
                f'echo "--- Switching to Node v{config["node_version"]} ---"',
                f'nvm use {config["node_version"]}'
            ])

        script_lines.extend([
            f'echo "--- Changing to project directory: {gemini_dir} ---"',
            f'cd "{gemini_dir}"',
            'echo "--- Starting Gemini CLI ---"',
            'gemini',
            'echo "--- Gemini CLI exited. Press Enter to close this terminal. ---"',
            'read' # 等待使用者按 Enter
        ])
        script_lines.append('rm "$0"' ) # 腳本執行完畢後自我刪除
        
        script_content = "\n".join(script_lines)

        # 使用臨時檔案來寫入和執行腳本
        with tempfile.NamedTemporaryFile(mode='w', delete=False, encoding='utf-8', suffix='.sh') as temp_script:
            temp_script.write(script_content)
            temp_script_path = temp_script.name
        
        try:
            os.chmod(temp_script_path, 0o755) # 賦予執行權限

            applescript_command = f'tell application "Terminal" to do script "{os.path.abspath(temp_script_path)}"'
            subprocess.run(["osascript", "-e", applescript_command], check=True)
            
        except IOError as e:
            messagebox.showerror("腳本錯誤", f"無法寫入或執行 Shell 腳本: {e}")
        except subprocess.CalledProcessError as e:
            messagebox.showerror("執行錯誤", f"無法啟動終端機: {e}")
        except Exception as e:
            messagebox.showerror("未知錯誤", f"發生預期外的錯誤: {e}")


# --- GUI 介面 ---

class ConfigApp:
    def __init__(self, master, config):
        self.master = master
        self.master.title("Gemini CLI 啟動設定")
        self.config = config

        # --- Variables ---
        self.use_nvm = tk.BooleanVar(value=config.get("use_nvm", True))
        self.node_version = tk.StringVar(value=config.get("node_version", "22"))
        self.gemini_directory = tk.StringVar(value=config.get("gemini_directory", ""))
        self.skip_gui = tk.BooleanVar(value=config.get("skip_gui", False))

        # --- Widgets ---
        # NVM Frame
        nvm_frame = tk.LabelFrame(master, text="NVM 設定", padx=10, pady=10)
        nvm_frame.pack(padx=10, pady=5, fill="x")
        
        self.nvm_check = tk.Checkbutton(nvm_frame, text="使用 NVM", variable=self.use_nvm, command=self.toggle_nvm_entry)
        self.nvm_check.pack(anchor="w")

        tk.Label(nvm_frame, text="Node 版本:").pack(anchor="w")
        self.nvm_entry = tk.Entry(nvm_frame, textvariable=self.node_version)
        self.nvm_entry.pack(fill="x")

        # Directory Frame
        dir_frame = tk.LabelFrame(master, text="目錄設定", padx=10, pady=10)
        dir_frame.pack(padx=10, pady=5, fill="x")

        tk.Label(dir_frame, text="Gemini CLI 目錄:").pack(anchor="w")
        dir_entry_frame = tk.Frame(dir_frame)
        dir_entry_frame.pack(fill="x")
        self.dir_entry = tk.Entry(dir_entry_frame, textvariable=self.gemini_directory)
        self.dir_entry.pack(side="left", fill="x", expand=True)
        tk.Button(dir_entry_frame, text="瀏覽...", command=self.browse_directory).pack(side="right")

        # Options Frame
        tk.Checkbutton(master, text="下次不再詢問，直接執行", variable=self.skip_gui).pack(padx=10, pady=5, anchor="w")

        # Buttons Frame
        button_frame = tk.Frame(master)
        button_frame.pack(padx=10, pady=10, fill="x")
        tk.Button(button_frame, text="儲存並執行", command=self.save_and_run).pack(side="right")
        tk.Button(button_frame, text="取消", command=master.quit).pack(side="right", padx=5)

        # --- Initial State ---
        self.toggle_nvm_entry()
        master.eval('tk::PlaceWindow . center')


    def toggle_nvm_entry(self):
        """根據 NVM 勾選狀態，啟用或禁用 Node 版本輸入框"""
        if self.use_nvm.get():
            self.nvm_entry.config(state="normal")
        else:
            self.nvm_entry.config(state="disabled")

    def browse_directory(self):
        """開啟對話框讓使用者選擇目錄"""
        directory = filedialog.askdirectory(initialdir=self.gemini_directory.get())
        if directory:
            self.gemini_directory.set(directory)

    def _validate_nvm(self):
        """驗證 NVM 及 Node 版本是否存在"""
        node_version_to_check = self.node_version.get()
        if not node_version_to_check:
            messagebox.showerror("缺少版本", "請輸入要使用的 Node.js 版本。")
            return False

        # 1. 檢查 NVM 是否安裝
        nvm_check_cmd = 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && command -v nvm'
        result = subprocess.run(['/bin/bash', '-l', '-c', nvm_check_cmd], capture_output=True, text=True)
        if result.returncode != 0 or not result.stdout.strip():
            install_cmd = "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
            messagebox.showerror("NVM 未安裝", f"找不到 NVM。請先安裝 NVM。\n\n建議安裝指令:\n{install_cmd}")
            return False

        # 2. 檢查 Node 版本是否已安裝
        node_version_check_cmd = f'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm ls {node_version_to_check}'
        result = subprocess.run(['/bin/bash', '-l', '-c', node_version_check_cmd], capture_output=True, text=True)
        # 如果 nvm ls 的回傳不是 0，代表該版本不存在
        if result.returncode != 0:
            install_cmd = f"nvm install {node_version_to_check}"
            messagebox.showerror("Node 版本未安裝", f"NVM 中找不到 Node.js 版本: {node_version_to_check}。\n\n建議安裝指令:\n{install_cmd}")
            return False
            
        return True

    def save_and_run(self):
        """儲存設定並執行"""
        # 從 GUI 讀取最新的值到 config 字典
        self.config["use_nvm"] = self.use_nvm.get()
        self.config["node_version"] = self.node_version.get()
        self.config["gemini_directory"] = self.gemini_directory.get()
        self.config["skip_gui"] = self.skip_gui.get()

        if not self.config["gemini_directory"]:
            messagebox.showwarning("缺少設定", "請指定 Gemini CLI 的目錄！")
            return

        # 如果啟用 NVM，執行驗證
        if self.config["use_nvm"]:
            if not self._validate_nvm():
                return # 驗證失敗，中斷執行

        save_config(self.config)
        self.master.quit() # 關閉 GUI 視窗
        
        # 在關閉 GUI 後執行腳本
        generate_and_run_script(self.config)


# --- 主程式入口 ---

def main():
    """主函式"""
    config = load_config()
    
    # 檢查是否要跳過 GUI
    if config.get("skip_gui", False) and "--show-config" not in sys.argv:
        generate_and_run_script(config)
    else:
        # 啟動 Tkinter GUI
        root = tk.Tk()
        app = ConfigApp(root, config)
        root.mainloop()

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        import traceback
        error_log_path = '/tmp/gemini_launcher_error.log'
        with open(error_log_path, 'w') as f:
            f.write(f"An unexpected error occurred:\n{e}\n")
            f.write(traceback.format_exc())