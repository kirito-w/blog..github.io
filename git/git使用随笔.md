# Git

## 设置用户名和邮箱：

- git config –global user.name “Some One”
- git config –global user.email “someone@gmail.com”

## 在当前分支下创建新的分支：

- git branch <new-branch-name> 在当前提交下创建一个新的分支，但并不会切换到该分支。
- git checkout <new-branch-name> 切换到新创建的分支，并把工作区切换到该分支上。

## 查看当前所在分支：

- 有三种方法：
  - 1、git branch 带有星号(\*)的分支名称，这是当前所在的分支。
  - 2、git branch --show-current
  - 3、git rev-parse --abbrev-ref HEAD 只返回当前所在分支的名称。

## 提交代码前：

- `先确认文件里的commit-readme文件，确认提交前提！`

## 如何拉取 git 远程仓库的某个指定分支：

- git clone -b 分支名 仓库地址

## 撤销上一次提交：

- git reset HEAD~ 撤销上一次提交
- 远程分支的强制推送（force push）：
  - git push -f origin <branch_name>

## 清除之前的提交记录

- 1、清除本地提交记录

  - git log 找到`要保留的头提交记录`哈希值
  - git reset --hard 头提交记录的哈希值 （这将清除所有在头提交记录之前的所有提交记录）

- 2、远程分支的强制推送（force push）：

  - git push -f origin <branch_name>

- git reset --hard 命令：将当前分支的 `HEAD 指针、工作目录和暂存区都重置为指定的提交`，`丢弃`了它们`之后的所有更改`
  - 这意味着此时 git pull 不会拉取丢弃的更改
  - 此时强推也可以更新远程仓库的更改记录

## 写在 freebug 中的提交记录信息：

- 查看本地 git log，复制粘贴

## 格式化提交记录：

- git log --pretty=format:"%h %s" -n 20

================================================================================================

## git 提交代码全流程：

### 新建分支部分:

- 1、git branch：确定自己拉取的代码分支是正确的
- 2、git pull：拉取此分支的最新代码
- 3、git branch release-operator-v1.0-MTK-WiFi6-Route-WR3000-unicom_7981-wqj(新分支名)：新建自己的分支
- 4、git checkout release-operator-v1.0-MTK-WiFi6-Route-WR3000-unicom_7981-wqj(切换到自己的分支)
- 5、git branch：检查是否切换成功

### 编码完成后，提交代码部分：

- 1、git branch：确认分支是否是自己的分支
- 2、git status：确认分支状态
- 3、git pull: 拉取分支最新代码
- 4、git diff：确认改动是否和预期一样
- 5、git add . ：将所有改动文件添加到暂存区
- `./002-pre-commit-check-and-tryfix-space-or-filemode.sh  —— 去除多余空格`
- 5、git add . ：将所有改动文件添加到暂存区
- 6、git commit -m "bugxxxx：（改动信息，最好英文）"：添加提交注释
- 7、`git push origin release-operator-v1.0-MTK-WiFi6-Route-WR3000-unicom_7981-wqj：把本地仓库的改动推送到远程代码对应的分支`
- 8、git pull --rebase origin release-operator-v1.0-MTK-WiFi6-Route-WR3000-unicom_7981：拉取主分支代码
- 9、`git push -f origin release-operator-v1.0-MTK-WiFi6-Route-WR3000-unicom_7981-wqj：确定没有冲突的情况下，推送最新代码到自己的分支(注意，这里的-f是强制推送，一定要确定没有冲突才能使用)`

#### 每次提交后记得 git show 一下，删除多余空格和确认自己的改动，然后可以 git rebase -i HEAD~2，把需要合并的提交（找到对应哈希值）的前缀改成 f，保存后退出即可。`合并后需要强推！！！`

#### git rebase -i HEAD~n —— n 为需要修改的提交数目

#### git rebase -i --root —— HEAD~n 用不了的情况

#### 先提一个空 bug，如果是开发时，不要写任何东西，只拿 bug 号来当提交的注释，测试没问题了再改变 bug 状态。

#### 修改之前的提交注释：git commit --amend ———— 这会修改最近一次的提交注释

================================================================================================

## ssh 密钥问题：

- 如果拉取仓库时，显示没有权限，可能是没有 ssh 密钥的原因。
- 可以按照以下步骤解决：
  - 1、ssh-keygen -t rsa -C “1106709388@qq.com”
  - 2、cd ~/.ssh 目录
  - 3、cat id_rsa.pub 复制文件内容
  - 4、进入 gitlab 界面
  - 5、点击左侧菜单进入 ssh keys
  - 6、添加新 key，将复制的内容填入即可

### 如果加完密钥后仍然不行，可以确认是否是局域网的 gitlab，如果是`自己使用ip地址搭建的gitlab`，将提交地址直接复制的 clone 中的 git@b9**\*\*\***9e9:name/project.git 修改为 ip 地址

```
git remote add origin git@10.10.10.10:name/project.git  (10.10.10.10为你自己gitlab的地址)
```

================================================================================================

## 缺少 ssh 主机密钥：

```
root@DESKTOP-N9TTV9V:~# /etc/init.d/ssh restart
sshd: no hostkeys available -- exiting.
```

- ssh-keygen -A

================================================================================================

## git reset(`慎重使用！！！！`):

- git reset 命令用于回退版本，可以指定退回某一次提交的版本。
- git reset 命令语法格式如下：

```
git reset [--soft | --mixed | --hard] [HEAD]
```

### --mixed 为`默认`，可以不用带该参数，用于`重置暂存区的文件`与上一次的提交(commit)保持一致，`工作区文件内容保持不变`。

- 实例：

```
$ git reset HEAD^            # 回退所有内容到上一个版本
$ git reset HEAD^ hello.php  # 回退 hello.php 文件的版本到上一个版本
$ git  reset  052e           # 回退到指定版本
```

### --soft 参数用于回退到某个版本：

- 实例：

```
$ git reset --soft HEAD~3   # 回退上上上一个版本
```

### --hard 参数`撤销工作区中所有未提交的修改内容`，将`暂存区与工作区都回到上一次版本`，并`删除之前的所有信息提交`：

```
git reset --hard HEAD
```

- 实例：

```
$ git reset --hard HEAD~3  # 回退上上上一个版本
$ git reset –-hard bae128  # 回退到某个版本回退点之前的所有信息。
$ git reset --hard origin/master    # 将本地的状态回退到和远程的一样
```

- `注意：谨慎使用 –-hard 参数，它会删除回退点之前的所有信息!!!!!!`

### HEAD 说明：

```
HEAD 表示当前版本
HEAD^ 上一个版本
HEAD^^ 上上一个版本
HEAD^^^ 上上上一个版本
以此类推...

也可以使用 ～数字表示
HEAD~0 表示当前版本
HEAD~1 上一个版本
HEAD~2 上上一个版本
HEAD~3 上上上一个版本
以此类推...
```

### 简而言之，执行 git reset HEAD 以`取消`之前 `git add 添加`，但不希望包含在下一提交快照中的`缓存`。

================================================================================================

## git stash:

- Git stash 允许你`暂时保存`当前的`工作目录和暂存区的改动`，并`将工作区和暂存区还原到之前的状态`。
- 这样，你可以切换到其他分支，处理其他任务，而`不必担心丢失你的临时改动`。

### 常见用法：

- `git stash save`：这个命令`将你的当前工作目录和暂存区所做的修改保存起来`，并将你的工作区还原到了一个干净的状态。
  - 你可以在命令后`添加`一个`描述`，以便更好地`区分`不同的`stash`记录。例如：git stash save "Temporary changes for feature X"。
- `git stash list`：此命令可用于查看当前存在的 stash 记录列表。
- `git stash apply`: 这个命令用于将`最近的stash记录`应用到当前分支中(也可以指定某个 stash 应用)。使用它后，stash 记录将被应用，但不会删除。
- `git stash pop`: 这个命令与 git stash apply 类似，但它`将应用stash记录(需要注意)`的同时将其从列表中删除(同样可以指定某个 stash)。
- `git stash clear`：`删除所有`的 stash 记录，包括其中的修改内容。
- `git stash branch`：可以使用该命令来`创建一个新的分支`，并`在该分支上应用stash记录`。

================================================================================================================

## 常见问题：

- 当执行 `git reset HEAD` 命令时，`暂存区的目录树会被重写`，被 `master 分支指`向的`目录树`所替换，但是`工作区不受影响`。
- 当执行 `git checkout .` 或者 git checkout -- <file> 命令时，会`用暂存区全部或指定的文件替换工作区的文件`。这个操作`很危险`，`会清除工作区中未添加到暂存区中的改动`。
- git diff 比较的是`暂存区和工作区的差异`。
- git commit —— `提交暂存区`到`本地仓库`。

- `git checkout 指定文件` —— 将指定文件还原为分支原始状态

- git log --pretty=format:"%h %s" —— 格式化提交记录（哈希值前七位）
- git log --pretty=format:"%H %s" —— 格式化提交记录（完整哈希值）

=================================================================================================================

## 获取指定分支最新代码：

- git fetch --all ： 从远程仓库获取所有分支的最新代码
- git reset --hard origin/<branch-name> : 将指定分支重置为远程仓库中的最新代码。

=================================================================================================================

## 把前一次提交变成补丁(尽量少用)：

- git format-patch -1 ———— 把最新一次提交变为补丁
- git am 0001-bug51480-ubus-OTA-AC-AP.patch ———— 还原提交

=================================================================================================================

## 合并其他分支的提交：

- git cherry-pick 提交哈希值
- git status —— 查看冲突并解决
- git cherry-pick --continue ——继续进行合并

=================================================================================================================

## 查看、替换当前仓库追踪的 url：

- git remote -v
- 替换当前仓库追踪的 url：git remote set-url origin <new_remote_url>

## git 不会追踪空文件夹！

## 冲突指的是提交记录不同步导致的，单纯的在目前的提交记录的基础上，无论怎么改，都不会有冲突的！！！

## git 删除未跟踪(Untracked files)的文件：

- git clean -f ：将删除 Git 仓库中的`所有未跟踪文件`，包括未添加到版本控制的文件和忽略文件列表之外的文件。
- git clean -f -d ：将删除未跟踪`文件和文件夹`，但保留 Git 忽略列表中列出的文件。

## 如何修改指定提交的注释(或者编辑本地分支！)：

- 1、首先，`git rebase -i HEAD~x`，x 对应最近的 x 次提交
- 2、在编辑器中，找到需要修改注释的提交的行，将其` pick 标记改为 edit，改为d是删除此提交`, 保存并关闭
- 3、git commit --amend，修改想要改为的注释，修改完成后保存并关闭
- 4、git rebase --continue，继续 rebase

## 撤销某次提交：

- git revert commit_hash

## 查看某个文件的改动记录：

- git log -p 文件

## 生成、应用 patch

diff -Naur a b >11.patch 生成补丁
patch -bp1 <11.patch 还原文件

## 网络原因导致 git 拉取出错：

- https://blog.csdn.net/u011943534/article/details/132147508

```
error: RPC failed; curl 18 transfer closed with outstanding read data remaining
error: 5695 bytes of body are still expected
fetch-pack: unexpected disconnect while reading sideband packet
fatal: early EOF
fatal: fetch-pack: invalid index-pack output
failed.

git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
git config http.postBuffer 524288000
```

# git 官网：https://git-scm.com/docs/git-archive

# git 常用及进阶命令总结:https://github.com/huaqianlee/blog-file/blob/master/_posts/Git/git%E5%B8%B8%E7%94%A8%E5%8F%8A%E8%BF%9B%E9%98%B6%E5%91%BD%E4%BB%A4%E6%80%BB%E7%BB%93.md

## rebase 自己分支到主分支的技巧：

- `先在自己的分支rebase主分支，解决完冲突`
- 然后再切换到主分支，rebase 自己的分支

## HEAD detached from f0d15be29 报错问题：

- https://www.cloudbees.com/blog/git-detached-head
- git checkout my_branc
- git reset --hard HEAD~x(撤销本地分支的 f0d15be29 提交)

## 如何使用 git rebase -i 修改某一次提交的部分内容

- 1、git rebase -i HEAD~x 找到需要修改的提交 提交前改为 e
- 2、保存后退出
- 3、修改想要修改的文件，修改完成后 git add 此文件
- 4、git commit --amend 提交本次改动
- 5、git rebase --continue 继续 rebase 过程（遇到冲突需要解决）
- 6、将本地分支强推到远程分支

## HEAD detached at my-branch 问题解决：

- https://juejin.cn/post/7130927945362866213

## 如何将本地的全部代码，重新推到仓库的新建分支上？

- 1、git checkout -b new_branch_name
- 2、git add .
- 3、git commit -m "Commit message"
- 4、git remote remove name
- 5、git remote add origin remote_repository_url
- 6、git push -u origin new_branch_name

## 如何删除远程仓库的分支？

- git push origin --delete branch_name

## 如何重命名分支？

- git branch -m old_name new_name

## 解决： [remote rejected] master -> master (shallow update not allowed)问题

- 原因：浅克隆导致无法推到远程分支
- 解决：
  - https://gist.github.com/gobinathm/96e27a588bb447154604963e09c38ddc

```
git fetch --unshallow https://github.com/this_is_the_source_url_from_where_you_did_clone_it.git
git remote remove origin
git init
git remote add origin https://github.com/your_new_repository_url_here.git
git push origin master
```

## 解决 cherr-pick 遇到冲突的问题：

- 原因：这种时候一般是要 cherry-pick 的分支里，某些文件与当前分支的文件差异过大导致的
- 解决方法：可以切换到要 cherry-pick 的分支下，git log -p xxxx 追溯此文件，找到与当前分支一致的提交节点，然后从此节点开始，将之后的所有提交按顺序 cherry-pick 即可

## git pull 由于远程追踪未设置导致失败：

- 解决：git branch --set-upstream origin your-branch
- git push 还是建议写全为 git push origin your-branch，防止推错分支

## 遇到冲突时如何快速查看差异：

- 1、git status
- 2、git diff –merge

## git log 的一些用法

- git log -p ————— 查看详细改动
- git log --stat ———— 查看有哪些文件改动
- git log --author=wqj ———— 查看指定作者的提交
- git log filename ———— 查看改动过此文件的提交
- git log -p filename ———— 查看改动过此文件的提交详细内容

## 查看某次提交改动过的文件：

- git show --name-only <commit-id>

## 查看指定人的提交：

- git log --author="John Doe"

## git blame file —— 查看某个文件是在何时被何人改动的

## 在 rebase 合并冲突时，使用当前分支的更改`作为解决冲突的偏好`：

- git pull --rebase -s recursive -Xtheirs origin target_branch

## git fetch --tags —— 获取最新 tag 列表

## 清除所有之前的 git 跟踪、提交记录：

- rm -rf .git
- git init

## 将最近一次本地提交的改动撤回到暂存区：

- git reset --soft HEAD^

## vscode 查看提交树：

- 源代码管理：View git graph

## 通过 git 生成、应用 patch：

- 生成 patch：git show xxx > 001-xxx-xx.patch
- 应用 patch: git apply 001-xxx-xx.patch

## .gitignore（常见于.so 文件无法跟踪）

- .gitignore 里是本地 git 忽略的文件类型，如果想不忽略，则需要将对应文件类型删除

## error: Invalid path 报错，clone 失败，文件夹空白问题解决

- git config core.protectNTFS false
  - 大致意思是关闭文件保护之类的，然后切换为刚刚的分支，如
- git checkout main
  - 然后文件夹就正常咯
