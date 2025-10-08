import tkinter as tk
import shutil
import os
from tkinter import messagebox

# 主要設定目錄，與主程式 start_gemini.py 中定義的路徑一致
CONFIG_DIR = os.path.expanduser("~/.config/gemini_cli_launcher")

def reset_config():
    """重置設定的主函式"""
    # 隱藏主視窗，因為我們只需要彈出對話框
    root = tk.Tk()
    root.withdraw()

    # 檢查設定目錄是否存在
    if not os.path.exists(CONFIG_DIR):
        messagebox.showinfo("提示", "設定已經是預設值，無需重置。")
        return

    # 彈出確認對話框
    is_confirmed = messagebox.askyesno(
        "確認重置",
        f"這將會刪除以下設定目錄及其所有內容，恢復到初始狀態：\n\n{CONFIG_DIR}\n\n確定要繼續嗎？"
    )

    if not is_confirmed:
        messagebox.showinfo("已取消", "操作已取消，您的設定保持不變。")
        return

    # 執行刪除
    try:
        shutil.rmtree(CONFIG_DIR)
        messagebox.showinfo("成功", "設定已成功重置為預設值！")
    except OSError as e:
        messagebox.showerror("錯誤", f"刪除設定時發生錯誤：\n{e}")

if __name__ == "__main__":
    reset_config()
