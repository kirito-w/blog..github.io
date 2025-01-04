
# GitHub CLI (`gh`) 使用指南

GitHub CLI (`gh`) 是 GitHub 官方提供的命令行工具，简化了与 GitHub 平台的交互操作。以下是 `gh` 常见的使用方法。

## 1. 安装 GitHub CLI

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install gh
```

### macOS (使用 Homebrew)
```bash
brew install gh
```

### Windows (使用 Scoop)
```bash
scoop install gh
```

## 2. 登录 GitHub
要使用 `gh` 工具，需要首先登录 GitHub：
```bash
gh auth login
```
```
root@CHINAMI-P0O0KO8:/home/kirito/freeRTOS# gh auth login
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Paste an authentication token
Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
The minimum required scopes are 'repo', 'read:org', 'workflow'.
? Paste your authentication token: *********************************************************************************************

```


- 根据提示选择登录方式：浏览器登录或使用 GitHub Token。
- 登录成功后，`gh` 会保存认证信息，后续操作无需再次登录。

## 3. 仓库操作

### 克隆仓库
```bash
gh repo clone <owner>/<repository>
```
例子：
```bash
gh repo clone FreeRTOS/FreeRTOS
```

### 创建仓库
```bash
gh repo create <repository-name>
```
选项：
- `--public`：创建公共仓库。
- `--private`：创建私有仓库。

例子：
```bash
gh repo create my-new-repo --public
```

### 查看仓库详情
```bash
gh repo view <owner>/<repository>
```

### 在浏览器中打开仓库
```bash
gh repo view --web
```

## 4. Pull Request (PR) 操作

### 创建 Pull Request
```bash
gh pr create --title "Title" --body "Description of the PR"
```

### 查看 Pull Request 列表
```bash
gh pr list
```

### 检查 Pull Request 详情
```bash
gh pr view <pr-number>
```

### 合并 Pull Request
```bash
gh pr merge <pr-number>
```

## 5. Issue 操作

### 创建 Issue
```bash
gh issue create --title "Issue Title" --body "Issue description"
```

### 查看 Issue 列表
```bash
gh issue list
```

### 查看 Issue 详情
```bash
gh issue view <issue-number>
```

### 关闭 Issue
```bash
gh issue close <issue-number>
```

## 6. GitHub Actions

### 查看最近的工作流运行
```bash
gh run list
```

### 检查工作流运行详情
```bash
gh run view <run-id>
```

### 重新运行工作流
```bash
gh run rerun <run-id>
```

## 7. 其他常用命令

### 检查 GitHub CLI 版本
```bash
gh --version
```

### 查看帮助文档
```bash
gh help
```

### 配置 GitHub CLI
```bash
gh config set editor vim
gh config get editor
```

## 8. 常见问题与解决方法

- **问题 1：`Error: no such option`**
  - 请检查 `gh` 是否正确安装，并确保版本是最新的。

- **问题 2：`Error: Got unexpected extra argument`**
  - 请确认命令格式正确，尤其是在输入仓库名称时，格式为 `<owner>/<repository>`。

- **问题 3：`command not found`**
  - 可能是 `gh` 没有安装或未正确配置环境变量，使用安装命令重新安装或配置 PATH 环境变量。

## 9. 参考资料

- GitHub CLI 官方文档: [https://cli.github.com/manual/](https://cli.github.com/manual/)
