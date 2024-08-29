# 基本指令

![image-20240829133816554](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240829133816554.png)

- `add`：将工作区中的更改添加到本地暂存区。 

- `commit`：将本地暂存区中的更改提交到地仓库，创建一个新的提交。  主要完成的内容就是创建一个新的提交，包括暂存区中的所有更改；每个提交都有一个唯一的哈希值，用于在版本历史中标识该提交。提交时，可以提供一条有意义的提交消息来描述更改的内容。  

- `checkout`：用于在本地仓库中切换分支或恢复历史版本。  主要操作是将Git版本库中的内容拿到工作区。例如回退版本，连续两天提交了版本，第三天的时候，想要将工作区的内容回退到第一天提交的版本，就需要checkout操作回退版本。 或者从一个分支切换到另一个分支，分支的概念看下文；  

- `clone`：克隆远程仓库到本地，创建一个本地仓库的副本。  克隆操作其实就是一个粘贴复制，把远程的仓库完整的拷贝到本地仓库；通常是包含两步： 
  - 创建本地仓库：首先，在本地创建一个新的空白目录或指定已存在的目录作为本地仓库。这一步是为了给克隆的项目提供一个位置，用于存储远程仓库的内容和版本历史。
  - 克隆仓库：使用`git clone`命令，将远程仓库的内容复制到本地仓库中。克隆操作会自动将远程仓库的全部历史记录、分支信息和文件复制到新创建的本地仓库目录中，并为远程仓库设置一个别名（默认为“origin”）。

- `push`：将本地仓库中的更改推送至远程仓库。  将本地的提交推送到远程仓库，更新远程仓库的分支和提交历史。  

- `pull`：从远程仓库拉取最新更改（相当于`fetch` + `merge`）。  其实也是两步；更新是从远程仓库（remote repository）到本地仓库（local repository），但实际的合并操作是将更改从本地仓库合并到工作区（working directory）和本地仓库的当前分支。

# 创建版本库

```bash
$ git init
```

Git 仓库是用于版本控制的一个特殊目录（`.git`目录），它保存了项目的完整历史记录和元数据信息

每当您在项目中添加、修改或删除文件时，Git 都会创建一个新的备份，称为提交（`commit`）。提交是代码修改的快照，并包含了作者、时间戳以及相关的元数据信息。

通过这些提交，Git 可以帮助您追踪项目历史，查看特定版本的代码状态，甚至回滚到之前的某个状态。

```bash
.git/
├── HEAD
├── branches
├── config	#包含了Git 仓库的配置选项，例如用户名、邮箱等。
├── description
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── fsmonitor-watchman.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-merge-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── pre-receive.sample
│   ├── prepare-commit-msg.sample
│   └── update.sample
├── info
│   └── exclude
├── objects
│   ├── info
│   └── pack
└── refs
    ├── heads
    └── tags
```

# 分支

![image-20240829134404593](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240829134404593.png)

默认就是`main/master`分支

在这个新的分支上，可以随意修改代码、添加新的功能、调试和测试，而不会对主分支上的代码产生任何影响

## 基本指令分支

```bash
git branch	#查看分支。当前分支前面会有一个星号 *。
#另外，可以添加 -r 选项来查看远程仓库的分支
git branch name #创建分支 命令加上-b参数表示创建并切换
git switch -c <branch_name> #创建并切换到新分支， Git 2.23 版本之后
git branch -d <branch_name> #如果分支上还有未合并的更改，需要使用 -D 参数来强制删除。
```

 

## 分支合并

注意你在

```bash
git switch -c new_branch
#some change
git add ...
git commit -m "..."
git switch master/main
git merge new_branch
```





# 查看版本库

- `git log`命令可以查看提交历史，包括每个提交的哈希值、作者、提交日期和提交消息等信息。默认以最新的提交开始显示，按照时间倒序排列。
- `git diff`命令可以比较当前工作目录中的文件与最新提交之间的差异。它可以显示插入的内容、删除的内容以及修改的内容等信息。
- `git status`命令可以查看工作目录中文件的状态，包括已修改、已暂存、未跟踪等状态。它会列出所有变更的文件以及它们所处的状态。
- `git show`命令可以查看某个**特定提交的详细信息**，包括提交的更改内容和元数据。需要提供该提交的哈希值或其他引用（如分支名）。 命令版本号没必要写全，前几位就可以了，Git会自动去找。当然也不能只写前一两位，因为Git可能会找到多个版本号，就无法确定是哪一个了。

# 版本回退

## git reset

`git reset`主要用于**修改提交历史**，并具有对索引和工作目录的不同影响。

```bash
git reset id
#id 以后的log会消失
#本地文件不会变
```

### 其他

1. ```bash
   git reset --soft
   ```

   - 这个命令会将当前分支的 HEAD 指针指向指定的提交，同时**保留之前的修改内容和暂存区的文件**。
   - 它不会改变工作目录的文件状态，也不会删除已提交的历史记录。
   - 通过这个命令，你可以撤销之前的提交，将其作为未提交的修改保留下来，方便进行新的提交。

2. ```bash
   git reset --mixed
   ```

   - 这个命令的行为与默认的 `git reset` 命令相同。
   - 这个命令会将当前分支的 HEAD 指针指向指定的提交，同时将之前的修改内容放入工作目录，并**取消暂存区的文件**。
   - 它会保留之前的修改作为未暂存的修改，需要重新添加和提交文件。

3. ```bash
   git reset --hard
   ```

   - 这个命令会彻底丢弃当前分支的 HEAD 指向的提交以及之后的所有提交。
   - 它会将当前分支的 HEAD 指针指向指定的提交，并将之前的**修改内容从工作目录、暂存区和 Git 历史记录中全部移除**。
   - 执行这个命令后，之前的修改将无法恢复。
   - 注意：在使用这个命令时，请谨慎操作，以免意外丢失重要的修改。

## git checkout

`git checkout`主要用于切换分支、还原文件和查看历史版本，**不会修改提交历史**。

```bash
git checkout <commit_id>
```

切换回去之后，就开始没有关联任何分支了，相当于是把那个版本拿出来**独立在分支之外**了； 

也就是说，`checkout`会切换到旧版本，切换回去之后可以查看旧版本的状态，但是他并不能改变提交历史，也就是不管你怎么操作，都不会改变当前分支的提交记录和版本； 

如果要保留`checkout`之后的修改，可以**创建一个新的分支**；

```bash
#加入现在git log显示有3个版本，要回到第二个版本上进行修改，不要第三个版本
git log #查看版本2 id
git checkout version_2_id #此时会进入一个游离分支，本地文件也会变为回退版本的对应文件#如果git checkout main/master会回到原来main/master分支
#some change
git add ...	#注意add后不要commite
git stash save "Your stash message" #保存修改到临时区
git checkout main/master
git stash list #查看暂存区内容
git stash apply name# name 根据查看内容填, 一般是stash@{0}...#将暂存区的内容应用到当前分支
git commit -m "..."
git stash drop <stash_id> #删除暂存， git stash apply换成git stash pop；git会在应用暂存的时候同时删除那个暂存；
```



# Tag

`git tag tagname`为最新的提交打标签

`git tag tagname id` 为以往版本打标签

`git show <tagname>`查看标签信息

`git tag -d tagname`即可完成标签的删除；

# Patch

```bash
场景1：拿到一个项目的.patch文件，要把这个补丁打上
git apply xxx.patch
```

```bash
场景二：只对本地特定文件的修改生成.patch。
git diff file_name > xxx.patch
```



[Git 补丁 —— diff 和 patch 使用详解_diff --git 内核打补丁-CSDN博客](https://blog.csdn.net/wanglei_11/article/details/130768993)

# remote

## download

```
git clone ...
```
- git clone 命令会克隆远程仓库的所有分支。但是，克隆下来的分支在本地仓库中会以远程分支的形式存在，并不会自动创建与每个远程分支对应的本地分支。

-  你可以使用 git branch -r 命令查看克隆下来的所有远程分支，使用 git branch -a 命令查看所有本地分支和远程分支。
- 要将远程分支创建为本地分支，可以使用以下命令： git checkout -b <本地分支名> <远程仓库名/远程分支名>


```bash
git pull origin main/master
```

1. 首先，它会自动调用 `git fetch` 命令，从指定的远程仓库中获取最新的提交，但不会应用到本地分支。
2. 然后，它会自动调用 `git merge` 命令，将获取的提交与当前分支进行合并

- 如果本地没有未提交的修改，`git pull` 会自动合并远程分支的更新到**当前分支**，并创建一个新的合并提交。
- 如果本地有未提交的修改，`git pull` 默认会尝试自动合并。如果合并过程中发生冲突，你需要手动解决冲突后再提交。
- 如果你想要强制执行 `git pull`，可以使用 `git pull --force` 命令。

### 拉取远程分支

```bash
git clone https://github.com/steveicarus/iverilog.git iverilog_v11
cd iverilog_v11
#拉取远程分支
git checkout -r #查看远程分支
git checkout --track -b v11-branch origin/v11-branch #切换到远程分支“origin/v11-branch”v11到本地， 本地命名为v11-branch
git pull	#拉取
```



## upload

```bash
cd your project_file
git init	#这个命令可以把当前目录变成git可以管理的仓库。
git add file
#git status	#检查当前git状态
git commit -m "Update *** Files by ***"
#复制仓库ssh连接
git remote add origin git@github.com:user/xxx.git #添加一个远程仓库，命名为origin
#git remote set-url origin git@github.com:Pxx-X/ICEEC2024-5.git#添加文件到远程库
git push origin master#或者main #使用push指令进行上传,The authenticity of host 'github.com (xxx)'can't be established., 输入yes
#第一次要加origin master， 后面之间git push 就行

```

### 相关报错：

```bash
** Please tell me who you are.
Run
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'XXX@YYY.(none)')
#这时候的解决办法是，在进行`git add ./`操作的路径中，实际上已经生成了一个隐藏的.git文件夹。在该路径下输入指令`cd ./.git`便进入.git文件夹，使用gedit或vim打开文件config，在文件末尾加入内容：
[user]
 email = your email
 name = your name
```

```bash
fatal: remote origin already exists
#说明远程仓库已经存在。这时候需要先删除origin仓库，然后再重新添加该远程仓库
git remote rm origin
git remote add origin git@github.com:upcAutoLang/Framework-for-NACIT2017.git
```

```bash
有时候对新建的仓库进行push操作，会出现上传失败的情况。 

通常出现这种情况的原因，是新建的仓库往往会有一个文件Readme.md文件，而本地仓库中没有这个文件，也就是说本地仓库与服务器端仓库没有实现同步。所以将这个Readme.md文件clone到本地，然后再commit提交，应该就没有问题了。
```

```bash
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'git@github.com:Pxx-X/ICEEC24-5.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.

#强行上传
git push -u origin +master
```

# 

# 设置SSH Key

由于本地的Git仓库与GitHub网站仓库之间的传输是通过SSH加密的，所以这时候需要设置SSH keys。

## 创建SSH Key

```bash
ssh-keygen -t rsa -C "youremail@example.com"
#其中，”youremail@example.com”是你的邮件地址，-C的字母为大写。
#后面可以一直回车。中间会让你输入密码，但整个SSH Key对笔者来说保密意义不大，所以不需要设置。SSH Key创建成功后，在笔者的主目录下就会生成/home/grq/.ssh文件夹，里面也会生成文件id_rsa与id_rsa.pub，它们是SSH Key的秘钥对。其中id_rsa是私钥，不能泄露，id_rsa.pub是公钥，可以告诉其他人。 
```

![image-20240822205619902](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240822205619902.png)

## 在GitHub端设置SSH Key

登录GitHub，点击右上角头像，Settings -> Personal settings -> SSH and GPG keys。在SSH Keys标签右方点击New SSH Key。 

 弹出两个文本框。其中的Title，可以随意命名。笔者此处随便命名为grq-Ubuntu。 

 另一个Key文本框，需要输入刚刚生成的`id_rsa.pub`文件中的内容。粘贴后点击`Add SSH Key`，即可生成SSH Key



# 参考

[Git使用教程（看完会了也懂了）-腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/2312328)