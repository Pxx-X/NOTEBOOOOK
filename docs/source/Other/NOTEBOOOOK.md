# Read the Docs

Read the Docs 是一个基于 Sphinx 的免费文档托管项目

# Sphinx

Sphinx 是一个基于 Python 的文档生成项目

Sphinx 使用 reST(reStructuredText) 作为标记语言, 通常采用 .rst 作为文件后缀

## 安装最新版本的 Sphinx 及依赖

```
pip3 install -U Sphinx
#other relate installer
pip3 install sphinx-autobuild
pip3 install sphinx_rtd_theme
pip3 install recommonmark	#sphinx markdown支持工具
pip3 install sphinx_markdown_tables
pip install sphinxcontrib.mermaid #mermaid渲染插件
pip install myst-parser	#markdown语法支持插件


#安装完成后，系统会增加一些 sphinx- 开头的命令。
#sphinx-apidoc    sphinx-autobuild    sphinx-autogen    sphinx-build    sphinx-quickstart
```







# sphinx_rtd_theme 网站搭建

## 1.install

[安装最新版本的 Sphinx 及依赖](#安装最新版本的 Sphinx 及依赖)

## 2.创建项目

```
sphinx-quickstart
y
project_name
v0
zh_CN
```

### 输出文件

Makefile：可以看作是一个包含指令的文件，在使用 make 命令时，可以使用这些指令来构建文档输出。
build：生成的文件的输出目录。
make.bat：Windows 用命令行。
_static：静态文件目录，比如图片等。
_templates：模板目录。
conf.py：存放 Sphinx 的配置，包括在 sphinx-quickstart 时选中的那些值，可以自行定义其他的值。
index.rst：文档项目起始文件。

```
make html#就会在 build/html 目录生成 html 相关文件

```
## 3.sphinx-autobuild 工具启动 HTTP 服务

```

sphinx-autobuild source build/html
默认启动 8000 端口，在浏览器输入 http://127.0.0.1:8000 

#注意：搭一个简单服务器的时候，选择在终端直接Ctrl+z而不是使用Ctrl+c
#Ctrl+c 直接停止当前执行的命令．
#Ctrl+z 挂起当前执行的命令


```

```
ERROR:    [Errno 98] error while attempting to bind on address ('127.0.0.1', 8000): address already in use

#解决方法 windows
$netstat -ano | findstr :8000
#返回
#TCP    127.0.0.1:12126        127.0.0.1:8000         FIN_WAIT_2      20580
$taskkill /F /PID 20580
```



## 3.修改样式

[Sphinx Themes Gallery (sphinx-themes.org)](https://sphinx-themes.org/)

conf.py 文件，找到 html_theme 字段，修改为“sphinx_rtd_theme”主题。



## 4.edit with .md

.rst文件就是网站内容

1. 在project_name/source/. 中新建文件用来存放你的所有markdown
2. 在index.rst 中修改maxdepth, 数量为文件内文件层数
3. 再在下方添加文件夹名称/index
4. 每一层都需要有index.rst文件

```
.. toctree::
   :maxdepth: 3
   :caption: Contents:

   mydoc/index
```

# 5.github托管

1. 上传到github仓库(build文件夹可以不上传)
2. [Project Dashboard | Read the Docs](https://readthedocs.org/dashboard/)上传

## 参考

[Read the Docs 从懵逼到入门-CSDN博客](https://luhuadong.blog.csdn.net/article/details/109006380?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1.pc_relevant_antiscan&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1.pc_relevant_antiscan&utm_relevant_index=1)

[Sphinx+gitee+ReadtheDocs搭建在线阅读文档系统_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1S5411T7Qg/?spm_id_from=333.337.search-card.all.click&vd_source=4d1b708351a5fc77a4a09ddd288c25c2)

[Github + Sphinx+Read the docs 实战入门指南（一） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/618869114)

[【小沐学Python】Python实现在线电子书制作（MkDocs + readthedocs + github + Markdown）_爱看书的小沐-CSDN博客](https://blog.csdn.net/hhy321/article/details/131144439)

[readthedocs/tutorial-template: Template for the Read the Docs tutorial (github.com)](https://github.com/readthedocs/tutorial-template/)**例程**