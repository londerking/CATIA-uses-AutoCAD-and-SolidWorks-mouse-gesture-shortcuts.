# CATIA 快捷助手（CATIA QuickKeys）v1.0.8

**CATIA QuickKeys — AutoCAD- and SolidWorks-style mouse gestures and shortcuts for CATIA V5.**  
A lightweight, standalone Windows tool for CATIA V5; no injection, no network, no CATIA settings changes.

本工具由deepseek harness编写

### English summary

CATIA QuickKeys brings SolidWorks-style right-drag gestures, AutoCAD-style space behavior, and a visual shortcut editor to CATIA V5. It is a single .NET Framework 4.8 executable and does not inject into CATIA.

一个给 **CATIA V5** 用的 Windows 小工具：把 SolidWorks 的右键笔势、AutoCAD 的空格习惯，以及一个可视化的快捷键配置界面带到 CATIA。

> 已在 **Windows 11 + CATIA V5-6R2022（B32，中文界面）** 上开发和自测。  
> 单文件 EXE，约 **127 KB**，免安装、不联网、不注入 CATIA。

---

## 1. 功能一览

| 功能 | 说明 |
|---|---|
| 右键笔势 | 在 CATIA 三维视图按住右键拖动，松开执行命令；原地右键仍是 CATIA 原生菜单 |
| 空格键 | 命令/对话框中 = 取消（ESC）；空闲 = 重复上一个工具命令；输入框 = 正常空格 |
| 快捷键 | 任意组合键 → 任意 CATIA 工具栏命令；保存即生效，不用进 CATIA 的“自定义” |
| 多套配置 | 零件设计 / 草图 / 装配按当前可见工具栏自动切换，也可手动切换 |
| 动作系统 | 命令、发送按键、命令序列、外部脚本、重复、切换状态 |
| 高可自定义 | 4/8/12/16 向、阈值、指示器、修饰键分套、JSON、热重载、导入导出 |
| 小巧 | 单 EXE、托盘运行、配置是纯文本 JSON |

---

## 2. 重要：命令是怎么执行的

CATIA V5-6R2022 在本机有一个限制：**外部 COM 调用 CATIA.StartCommand 会返回 E_FAIL**（自动化对象里 Documents.Count = 0，看不到当前文档）。

所以 v1.0 默认采用另一条可靠路径：

> **找到 CATIA 当前界面上可见的工具栏按钮，向它发送 BM_CLICK。**

这意味着：

- 命令名就是**按钮上的文字**，例如 凸台、凹槽、草图编辑器、圆角。
- 只有**当前工作台可见**的按钮才能点。跨工作台请切换工作台，或使用对应的 Profile。
- 命令库里的“**扫描当前按钮**”会列出 CATIA 当前可见按钮，直接选，不用猜名字。
- StartCommand 作为“实验”动作保留；如果你的 CATIA 版本能调用成功，可以在动作编辑器里选它。

---

## 3. 60 秒上手

1. 启动 CATIA，打开一个零件，确认“凸台 / 凹槽 / 圆角”等工具栏可见。
2. 双击 **CATIAQuickKeys.exe**。托盘出现图标，设置窗口打开。
3. 打开“笔势”页，默认是：
   - ↑ 凸台
   - ↓ 凹槽
   - ← 草图
   - → 圆角
4. 双击某一行可以改动作；改完立即生效。
5. 打开“快捷键”页 → “添加” → 按下组合键 → 选动作 → 选命令/扫描按钮。
6. 托盘菜单可以暂停、切换自动配置、退出；开机自启在“设置”里勾选。

---

## 4. 默认行为

### 4.1 右键笔势

- 只在 **CATIA 前台**、鼠标位于 **三维视图** 时接管右键。
- 按住右键移动超过阈值（默认 24 px）才判定为笔势；不拖动则合成一次普通右键，保留 CATIA 菜单。
- 默认只响应纯右键；带 Ctrl/Shift/Alt 的右键直接放行；**左键或中键已经按下时也不触发**，保证 CATIA 的平移/缩放/旋转优先。
- 方向数支持 4 / 8 / 12 / 16；12/16 向的绑定键为 d0、d1…（0 在正上方，顺时针）。
- 指示器可设为轮盘 / 列表 / 文字 / 关闭，可调大小、透明度、主题。

### 4.2 空格

按优先级：

1. 输入框/文本编辑、中文输入法组合中 → 放行，正常输入空格。
2. CATIA 对话框打开 → 空格 = ESC（可在“空格”页改成 Enter）。
3. 命令进行中 → 空格 = ESC（取消）。
4. 空闲 → 空格 = 重复上一个“由本工具触发”的命令；没有记录时发送 ESC。
5. 非 CATIA 前台 → 不拦截。

> “重复上一个命令”只对工具触发的命令可靠。你在 CATIA 工具栏上直接点的命令，工具不知道。

### 4.3 快捷键

- 任意组合键，例如 Ctrl+Shift+1、Alt+F8、F9。
- 字母/数字键默认要求至少一个修饰键，避免打字误触。
- Space / Esc / Enter / Tab / Alt+Tab / Win+L 等保留键不允许映射。
- 与 CATIA 常用键冲突时标黄提示，但不禁止。
- 托盘“暂停”可临时停用全部拦截。

### 4.4 多套配置（Profile）

- 默认有：默认（零件设计）、零件设计、草图、装配。
- 匹配规则：任一“可见工具栏 / 可见按钮 / 窗口类 / 工作台 / 标题正则”命中即匹配，优先级高者优先。
- “默认”是兜底。
- 在“配置”页选中某个配置只编辑参数；点“切换到此配置”才会手动生效；点“自动匹配”恢复自动。
- 选择左侧配置后，快捷键/笔势/空格页编辑的仍是**当前生效的配置**，不是列表里选中的那个。

---

## 5. 配置文件

- 默认位置：EXE 同目录 config.json。
- 如果目录不可写：%APPDATA%\CATIAQuickKeys\config.json。
- UTF-8 JSON，可直接编辑；保存后约 300 ms 热重载。
- 写错时保留上一份配置，托盘气泡提示，不会崩溃。
- 每次保存会生成 config.json.bak。
- “设置”页可打开配置文件夹、重新加载、导入/导出配置、恢复默认。

主要结构：

~~~json
{
  "SchemaVersion": 1,
  "General": { "Enabled": true, "Scope": "catia", "UiMode": "simple" },
  "Overlay": { "Mode": "wheel", "Size": 170, "Opacity": 0.88, "Theme": "dark" },
  "Profiles": [
    {
      "Id": "part",
      "Name": "零件设计",
      "Priority": 10,
      "Match": { "VisibleToolbars": ["PrtSketchBasedFeature"] },
      "Gestures": {
        "Directions": 4,
        "Threshold": 24,
        "Bindings": {
          "up":    { "Type": "command", "Command": "凸台", "Label": "凸台" },
          "down":  { "Type": "command", "Command": "凹槽", "Label": "凹槽" },
          "left":  { "Type": "command", "Command": "草图编辑器", "Label": "草图" },
          "right": { "Type": "command", "Command": "圆角", "Label": "圆角" }
        }
      },
      "Hotkeys": [],
      "Space": { "Idle": { "Type": "repeat" }, "Dialog": { "Type": "keys", "Keys": "{ESC}" } }
    }
  ],
  "Commands": []
}
~~~

> 配置里的字段名是 PascalCase；JSON 解析不区分大小写，手写小写也可以。

---

## 6. 动作类型

| Type | 作用 | 关键字段 |
|---|---|---|
| command | 点击 CATIA 当前可见工具栏按钮 | Command（按钮文字）、Label |
| keys | 发送按键 | Keys，如 {ESC}、Ctrl+S、Ctrl+Shift+P |
| repeat | 重复上一个工具命令 | 无 |
| toggle | 暂停/指示器/切换配置 | Target、Value |
| sequence | 按顺序执行多个动作 | Steps、DelayMs |
| external | 运行外部程序/脚本 | Path、Args、Wait、TimeoutMs |
| startcmd | 实验性 CATIA.StartCommand | Command |
| none | 什么都不做 | 无 |
| passthrough | 放行（仅空格规则用） | 无 |

sequence 的 Steps 就是动作数组，例如：

~~~json
[
  { "Type": "command", "Command": "草图编辑器" },
  { "Type": "keys", "Keys": "{ESC}" }
]
~~~

外部脚本支持占位符：{profile}、{document}、{workbench}。  
**外部脚本默认不启用**；只运行你信任的文件。工具不联网。

---

## 7. 命令库

- 内置 66 个常用命令，覆盖零件设计、草图、装配、工程图、通用视图。
- “命令库”页可搜索、添加、编辑、删除、测试。
- “扫描当前按钮”会扫描 CATIA 当前可见按钮，选中后自动填按钮文字。
- “测试”会真的点击一次按钮；会先弹确认。
- 按钮文字匹配会去掉末尾的 ...、… 和 &，并优先精确匹配。
- 在轮盘 / 快捷键 / 空格的动作编辑器里点“选择命令”时，默认**只列出当前配置可映射的命令**（当前界面可见按钮 + 已配置的快捷键/轮盘命令），不再把 66 个命令全部列出来；取消勾选“仅显示当前配置可映射的命令”才显示全部命令库。
- “矩形”这类藏在“预定义的轮廓”flyout 里的命令当前不可见，默认过滤列表里可能没有；如果它已经绑在轮盘/快捷键上会显示，否则取消勾选到完整命令库里选。执行时会自动用隐藏按钮的鼠标消息，不会弹出工具栏。

---

## 8. 已知限制

1. 支持可见按钮（含浮动“轮廓 / 约束 / 操作”工具栏）和隐藏在 flyout 里的按钮（如草图的“矩形 / 斜置矩形 / 居中矩形”）；纯菜单项或完全没有按钮的命令仍不行，请用 keys 动作或原生快捷键。
2. StartCommand 在本机外部调用失败；如你的环境可用，可在专家模式选择该动作。
3. 空格“重复上一个命令”只记录工具触发的命令。
4. 右键笔势只在三维视图生效；工具栏、结构树、对话框上的右键不拦截。
5. 全局键鼠钩子可能被个别杀毒软件误报；本工具不联网、不注入、不修改 CATIA 文件。
6. CATIA 与工具权限不一致（一个管理员、一个普通用户）时，合成 ESC/右键可能被 UIPI 拦截。
7. 多实例 CATIA 只连接当前前台实例；第一版按单会话设计。
8. 12/16 向的编辑界面只显示编号 d0…；建议只用 4/8 向，除非确实需要。
9. 指示器主题只有深色/浅色两套，轮盘字体跟随系统 DPI。
10. 草图默认用 4 向（直线 / 圆 / 约束 / 圆角），因为“圆弧 / 矩形 / 修剪 / 镜像”等在普通草图界面没有独立可见按钮；需要 8 向时，先在笔势页确认每个按钮都能被“扫描当前按钮”找到。

---

## 9. 自测状态

已通过自动化自测（CATIAQuickKeys.exe --selftest，结果写入 selftest.txt）：

- 默认配置 4 个 Profile / 66 个命令；JSON 序列化/反序列化/大小写字段。
- 快捷键解析、方向角度、4 向索引。
- CATIA 进程/窗口识别；不同工作台 17–27 个可见工具栏、56–99 个可见按钮（含浮动工具栏）。
- 零件设计默认 4 个笔势按钮（凸台/凹槽/草图编辑器/圆角）都能找到；草图默认 4 向（直线/圆/约束/圆角）也都能找到。
- 动作引擎实际点击“全部适应”成功。
- 钩子安装/托盘启动无异常。
- 修复 1.0.2：右键拖动时不再吞掉鼠标移动消息，光标可以正常移动选择方向。
- 修复 1.0.3：轮盘固定在右键起点，不再跟着光标移动；光标在轮盘上选择方向。
- 修复 1.0.4：空格“重复上一个命令”不再因为对话框关闭而丢失最后命令；最后命令会保留到下一次工具触发。
- 修复 1.0.5：按 ESC 取消命令后立即结束“命令进行中”状态，下一次空格可直接重复；最后命令仍保留。
- 新增 1.0.6：命令选择器按当前配置过滤；草图中实测只显示 22 个可映射命令（含 4 个轮盘命令）。
- 修复 1.0.7：支持隐藏在浮动 flyout 里的按钮；轮盘中的“矩形”已实测可启动矩形命令，ESC 取消后撤销标签恢复。
- 修复 1.0.8：中键/左键先按下时不触发右键笔势，避免打断 CATIA 的平移/缩放；右键拖到一半再按中键也会取消笔势。

**还需要你在真实交互里验证：**

- 右键笔势的实际手感（阈值/方向/右键菜单是否正常）。
- 空格在 CATIA 命令、对话框、输入框里的表现。
- 你自定义的快捷键是否与 CATIA 现有键冲突。

---

## 10. 从源码构建

需要：Windows 10/11 + .NET Framework 4.8（系统自带）+ CATIA V5（运行本工具时）。

~~~powershell
cd CATIA-QuickKeys
.\build.ps1
~~~

build.ps1 调用系统自带：

C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe

产物：CATIAQuickKeys.exe（x64，约 127 KB）。

源码在 src\，无第三方 DLL；只引用系统程序集：
System.dll、System.Core.dll、System.Web.Extensions.dll、System.Windows.Forms.dll、System.Drawing.dll。

---

## 11. 命令行参数

| 参数 | 作用 |
|---|---|
| --selftest | 运行自测，写 selftest.txt，不显示界面 |
| --no-hooks | 启动界面但不安装键鼠钩子（调试/截图用） |
| --tray | 启动后只驻留托盘，不打开设置 |
| --tab N | 启动时选中第 N 个页签（0–6，调试用） |
| --config <path> | 指定配置文件 |

---

## 12. 文件说明

| 文件 | 说明 |
|---|---|
| CATIAQuickKeys.exe | 主程序 |
| config.json | 当前配置（首次运行自动生成） |
| config.json.bak | 上一次保存的备份 |
| CATIAQuickKeys.log | 运行日志 |
| src\*.cs | C# 源码 |
| build.ps1 | 编译脚本 |
| app.manifest | DPI/权限清单 |
| app.ico | 图标 |
| selftest.txt | 自测结果（运行 --selftest 后生成） |

---

## 13. 卸载

1. 托盘右键 → 退出。
2. 删除 CATIAQuickKeys.exe、config.json、config.json.bak、CATIAQuickKeys.log。
3. 如果勾过开机自启：设置里取消，或删除注册表
   HKCU\Software\Microsoft\Windows\CurrentVersion\Run\CATIAQuickKeys。

---

## 14. 安全说明

- 不联网、不上传任何数据。
- 不注入 CATIA 进程，不修改 CATIA 安装目录。
- 不写 CATIA 的 CATSettings / 原生快捷键。
- 全局键鼠钩子只用于本工具的热键、空格和右键笔势。
- 外部脚本动作默认关闭；开启即表示你信任该脚本。

---

## 15. License / 许可证

MIT License — 见 [LICENSE](LICENSE)。

CATIA 是 Dassault Systèmes 的商标。本项目是独立第三方工具，与 Dassault Systèmes 无关联，也未获得其背书。仓库中不包含 CATIA 安装文件、许可证文件或任何 Dassault 二进制文件。

欢迎 Issue / PR。

---

*版本 1.0.8 · 2026-10-28 · 适用于 CATIA V5-6R2022（中文界面）*
本工具由deepseek harness编写