# ICEEC

## 第一题

信号返回到以前记录经过的逻辑门

用拓扑排序删去一部分点（入度为0，或出度为0的点可以删去，直到没有满足条件的点）？

[华为软件精英挑战赛-2020-初赛复赛-题目分析/算法Baseline （求出有向图中所有的环） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/125764650)

起点只可能是入度至少为2的input_node

重点是找到反馈的那条signal,找到以后删去，也可以解决多重环问题

注意并不是入度为2的input_node才可能是环的起点，但是大部分应该都是>2的，也许可以通过这个找到优化？

没有多输出的cell那么cell_output_num = cell_num

```
//可优化方向
1.input_node可以直接到对应gate的output_node
2.多线程？
3.优化等级？
4.删去不可能存在的点？入度、出度为0的点
5.

```



### dfs_v0:

问题：![image-20240827004031877](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240827004031877.png)

无法得到每个gate的gate_level，也就难以获取feedback signal

```c
//recoder:记录out_degree >1 的output_node	弃用
//gate_level:记录每个arc_loop中的arc经过的node的gate的拓扑层级，默认全-1。现在这样写没有用？！
//node_level:面前的node的level，
//在单个arc loop中， 回退过的路径在adj_table会被标记为-1， arc loop重启后会重置
//CLs:一个IntVector_array, 存储Combinational Loops


for 每个primary_input_node	//arc loop
{
    adj_table_reset();
    adj_table_delete_loop_signal();		//删去CL[0,-1]之间的边，也是result的第一个signal edge
	arc.push(每个primary_input_node[i])
	while(1)				//node loop
    {
        gate_level[arc[-1]] = node_level;
		if(is_in[arc[-1]])	//这个点是gate_input_node
        {
            dst_output_node = adj_table[arc[-1]][0];
            if(dst_output_node == -1)	//走过了,或者是primary_ouput_port
            {
                input_node = arc.pop();
                get_level[input_node] = -1;
                for(int i=0; i<adj_table_len[arc[-1]]; i++)
                {
                    if(adj_table[arc[-1]][i] == input_node)
                        adj_table[arc[-1]][i] = -1;			//delete this arc
                }
                
                node_level--;
                

            }
            else
            {
            	arc.push(dst_output_node);//arc加入这个gate的output_node
            }

            
        }
        else //这个点是gate_ouput_node
        {
			dst_input_nodes = get_dst_nodes();	//这个函数得到所有可能得dst点
            if(dst_input_nodes.size == 0)			//没有dst_input_node了
            {
                ouput_node = arc.pop();
                get_level[ouput_node] = -1;
                adj_table[arc[-1]][0] = -1;			//delete this arc
                
                is_break(arc[-1]);//is primary input and no avivable fan out node 
            }
            else							//至少一个dst_nodes
            {
                if(is_in_arc(arc,dst_input_nodes[0]);)	//检查 dst_input_nodes[0]是否已经出现过
                {		////出现过,说明找combinational loop
                    CL = getCL(arc,dst_input_nodes[0]);	//提取Combinational Loop
                    CLs.push(CL);
                }
                else	//没出现过
                {
                	arc.push(dst_input_nodes[0]);			//arc加入这个gate的output_node
                	node_level++；
                }
            }
        }
    };
}

get_result(CLs);//根据CL，得到答案
			

			
        
```

### BFS_v0:

伪代码

代解决：

1. gate_level
2. method of get loop
3. result output
4. get time& memory size
5. detail  analysis of complexity

```c
//解决dfs无法识别feedback signal问题
//可以多线程？
//修改：不要-1
//难点：最后也会有环路的分叉，导致不是
//
define stop_ratio = 0.//已经找到的非
define stop_time = ?//停止时间
define stop_memory = ?//程序内存大于
define stop_layer = //大于多少层停止
    
va arcs;//路径
va arc_parent_index;//dst->src







```

### BFS_v1:

修改：不要cell_level，判断方法改为arc_loop中离起点最远和最近的为feedback signal

无法解决环内环的问题

无法解决并列cell问题

## 第二题



## 第三题

## 第四题

## 第五题

# Iverilog

## rtl编译

```text
iverlog demo.v
```

## rtl仿真

```shell
iverilog -o demo demo.v demo_tb.v 
vvp demo 
gtkwave demo.vcd

```

**iverilog -o demo demo.v demo_tb.v：**
   iverilog 是用于编译和生成仿真可执行文件的命令。
  -o demo 表示生成名为 demo 的可执行文件。
  demo.v 和 demo_tb.v 是输入的 Verilog 源代码文件，其中 demo.v 是被测试的设计文件，demo_tb.v 是测试台文件（testbench）。
**vvp demo：**
  vvp 是用于执行生成的仿真可执行文件的命令。
  demo 是待执行的仿真可执行文件。

**gtkwave demo.vcd**：
  gtkwave 是一款常用的波形查看器，用于打开和分析仿真生成的波形文件。
  demo.vcd 是仿真期间生成的波形文件，它包含了不同信号在每个时间点上的值变化。

### 注意

![image-20240806192119894](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240806192119894.png)

### 其他

- -D: 定义宏
- -P: 覆盖root module中的一个参数的值
- -E: 只预处理(进行宏替换), 不编译
- -g1995, -g2001, -g2005 ...: 选择支持的verilog语言版本.
- -I includedir: 指定(添加)verilog中include指令的搜索路径
- -s topmodule : 指定要建立的顶层模块. 默认是没有被实例化的哪些module

## VPI(Verilog Prodecure Interface)

一个主要面向C语言的接口. 可以让行为级别的Verilog代码调用C函数, 让C函数调用标准Verilog系统函数.

```
//adder_example
iverilog adder_rtl.v adder_tb.v -o adder.vvp
iverilog-vpi adder.c
vvp -M . -m adder adder.vvp
```

- iverilog-vpi: 自带的帮助生成库的脚本
- -M path: 将path加入定位VPI模块的路径, .: 当前路径
- -m module: 告诉vvp在执行simulation之前加载指定的module.

### 数据类型

#### vpiHandle

The VPI interface deÞnes the C data type of vpiHandle. All objects are manipulated via a vpiHandle variable  

#### t_vpi_value

![image-20240812163301998](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812163301998.png)

![image-20240812163744268](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812163744268.png)

![image-20240812162747773](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812162747773.png)

### 常用定义

vpiDefName

vpiNet



### cmd

- vpi_handle
- vpi_handle_by_name  ![image-20240812165030228](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812165030228.png)



- vpi_get_value(obj, value_p)
-  vpi_iterate(, handle);



## install

### windows

[iverilog安装及快速上手（Windows）-CSDN博客](https://blog.csdn.net/CHEN_cwx/article/details/139844957)

### ubuntu

[iverilog开发工具配置 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/667241496)

[iverilog工具的使用 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/643961181)

## gtkwave

直接查看生成的.vcd文件

```
gtkwave waveform.vcd
```

## reference

[1.steveicarus/iverilog: Icarus Verilog (github.com)](https://github.com/steveicarus/iverilog?tab=readme-ov-file)

[2.iverilog+GTKwave使用总结-CSDN博客](https://blog.csdn.net/m0_57102661/article/details/134911273)

[**3.一文学会使用全球第四大数字芯片仿真器iverilog - 知乎 (zhihu.com)**](https://zhuanlan.zhihu.com/p/148795858)很好！

[4.Using VPI — Icarus Verilog documentation (steveicarus.github.io)](https://steveicarus.github.io/iverilog/usage/vpi.html)有一个实例，同时解释了vpi.c文件的结构

[5.iverilog/vpi at master · steveicarus/iverilog (github.com)](https://github.com/steveicarus/iverilog/tree/master/vpi)

# 组合逻辑环路

起始于某个组合逻辑单元经过一串组合逻辑又回到起始组合逻辑单元

a combinational loop occurs when the left-hand side of an arithmetic expression also appears on the right-hand side in HDL code. A combinational loop also occurs when you feed back the output of a register to an asynchronous pin of the same register through combinational logic.



**组合逻辑环路**（Combinational Loops）：指组合逻辑的输出信号**不经过任何时序逻辑电路**（FF等），而直接**反馈到输入节点**，从而构成的电路环路。  

![image-20240812160734624](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812160734624.png)

此外，如果**直接将寄存器的输出端通过组合逻辑反馈到该寄存器的异步端口**（异步复位或异步置位），也会形成组合逻辑环路。

![image-20240812160832064](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812160832064.png)

## 震荡的组合逻辑环  

震荡发生的条件是**负反馈**  

![image-20240813202952521](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240813202952521.png)

## 常见的Combinational loop（人为设计的）

- 伪随机数生成器，由奇数个反相器组成的回环；
- DFT Bypass 逻辑，在DFT 模式有组合逻辑环；
- 振荡器

## 危害

Combinational loops are among the most common causes of instability and unreliability in digital designs. Combinational loops generally violate synchronous design principles by establishing a direct feedback loop that contains no registers.

Combinational loop 如果不是用于特别用途，通常是不应该出现在代码中的，所有不预期的Combination loop 都要当做bug 处理

- 组合逻辑环路**违反了同步设计原则**，容易振荡，从而导致整个设计不稳定和不可靠。

- 组合逻辑环路的行为功能**取决于该环路上的延迟**（逻辑延迟和布线延迟），一旦延迟发生变化，整个设计的行为功能将变得无法预测。
- 组合逻辑环路的振荡将导致EDA软件做**无穷无尽的计算**。为了完成这种计算，EDA软件将会**切割环路**。不同的EDA软件的切割方式不尽相同，这可能会与设计者的设计目的相违背，从而导致逻辑功能错误。
- 组合逻辑环路**无法进行静态时序分析（STA）**，可能会出现时序违例，或者导致STA过程时间过长。









## 参考



# C/C++

## 数据类型

### bool

```c
#include <stdbool.h>

//或者自己定义
typedef int bool;
#define true 1
#define false 0
```

### 字符串

在 C 语言中，字符串实际上是使用 **null** 字符 ‘\0’ 终止的一维字符数组

### 常用的“%”

![image-20240812151153861](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812151153861.png)

## 系统函数

- sscanf![image-20240812151103062](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812151103062.png)
- sprintf![image-20240812151700300](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812151700300.png)![image-20240812151709056](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240812151709056.png)
- scanf：键盘输入

## 内存管理

### malloc

动态分配指定大小的内存块。它从堆中分配内存，并返回指向该内存块的**指针**

分配的内存内容未初始化

如果你需要更多的空间，你需要手动调用`realloc`来调整这块内存的大小，或者分配一块新的、更大的内存块。

**使用限制**：这20字节的内存并不会像“用一点给一点”那样逐渐分配，而是**一次性分配**。如果在使用过程中**超过了这20字节的边界**（例如试图访问第21字节），则可能会引发未定义行为，通常会导致**程序崩溃或内存损坏**。

**内存对齐：**尽管你可能请求了例如`malloc(20)`，实际分配的内存可能会大于20字节，以确保内存对齐，但对你而言，能安全使用的仍然是请求的20字节空间。

```c
int *p = (int*)malloc(sizeof(int) * 10); // 分配能存储10个int类型元素的内存
 
    if (p == NULL) {
        printf("内存分配失败\n");
        return 1;
    }
 
    // 使用分配的内存
    for (int i = 0; i < 10; i++) {
        p[i] = i;
        printf("%d ", p[i]);
    }
 
    // 释放内存
    free(p);


```

### free

用于释放由`malloc`、`calloc`或`realloc`分配的内存，使这部分内存重新可用。（手动释放内存）

**不要对同一块内存多次调用 `free`**。这会导致未定义行为，比如程序崩溃。

**不要对未分配的内存调用 `free`**。确保你只释放通过 `malloc`, `calloc`, 或 `realloc` 分配的内存。

```c
int *p = (int*)malloc(sizeof(int) * 10);
if (p != NULL) {
    // 使用内存
    free(p); // 释放内存
}
```

```c
如果结构体中包含指向动态分配内存的指针，在销毁结构体前需要释放这些内存：
struct Node {
    int data;
    struct Node *next;
};
 
void freeNode(struct Node *node) {
    if (node != NULL) {
        freeNode(node->next); // 递归释放链表中的每个节点
        free(node);
    }
}
```

> **正确使用 `free` 函数是良好编程实践的一部分，它可以避免内存泄漏，并确保程序的稳定性和性能。**

#### 动态内存后一定要释放吗

```


```

```

```

就算没有free()，**main()结束后也是会自动释放malloc()的内存的**，这里监控者是操作系统，设计严谨的操作系统会登记每一块给每一个应用程序分配的内存，这使得它能够在应用程序本身失控的情况下仍然做到有效地回收内存。你可以试一下在TaskManager里强行结束你的程序，这样显然是没有执行程序自身的free()操作的，但内存并没有发生泄漏

free()的用处在于实时回收内存。如果你的程序很简单，那么你不写free()也没关系，在你的程序结束之前你不会用掉很多内存，不会降低系统性能；而你的程序结束之后，操作系统会替你完成这个工作
但你开始开发**大型程序**之后就会发现，不写free()的后果是很严重的。很可能你在程序中要重复10k次分配10M的内存，如果每次使用完内存后都用free()释放，你的程序只需要占用10M内存就能运行；但如果你不用free()，那么你的程序结束之前就会吃掉100G的内存。这其中当然包括绝大部分的虚拟内存，而由于虚拟内存的操作是要读写磁盘，因此极大地影响系统的性能。你的系统很可能因此而崩溃

任何时候都为每一个malloc()写一个对应的free()是一个良好的**编程习惯**。这不但体现在处理大程序时的必要性上，更体现在程序的优良的风格和健壮性上。毕竟只有你自己的程序知道你为哪些操作分配了哪些内存以及什么时候不再需要这些内存。因此，这些内存当然最好由你自己的程序来回收

### calloc

`calloc`（contiguous allocation）用于分配内存并初始化所有位为**零**。与`malloc`不同，它接受两个参数：**分配的元素个数**和**每个元素的大小**



```c
#include <stdio.h>
#include <stdlib.h>
 
int main() {
    int *p = (int*)calloc(10, sizeof(int)); // 分配能存储10个int类型元素的内存，并初始化为0
 
    if (p == NULL) {
        printf("内存分配失败\n");
        return 1;
    }
 
    // 使用分配的内存
    for (int i = 0; i < 10; i++) {
        printf("%d ", p[i]);
    }
 
    // 释放内存
    free(p);
 
    return 0;
}
```

### realloc

`realloc`（reallocation）在 C 语言中用于改变已分配内存块的大小。这个函数允许您动态地增加或减少内存空间的大小，这对于需要根据运行时条件调整数据结构大小的应用程序非常有用。它可以扩展或缩小内存块，如果新内存>旧内存，未初始化的新内存内容是**不确定的**。

- 如果`realloc`失败，原来的内存块仍然有效，应该**避免内存泄漏**。
- 如果新大小为0，`realloc`等同于调用`free`
- `realloc`的返回值应检查是否为`NULL`，因为重新分配可能失败

缩容注意事项:

1. 数据保留:

如果新的大小大于或等于原始大小，那么原始数据会被保留。
如果新的大小小于原始大小，那么原始数据中超出新大小范围的部分将被丢弃。
因此，在缩小内存之前，最好先备份重要数据，以防丢失。

2. 检查返回值:

总是要检查 realloc() 的返回值是否为 NULL，这表示内存分配失败。
如果返回值非 NULL，则需要将指针更新为新的地址。

3. 类型转换:

类型转换通常需要应用到 realloc() 的返回值上，以保持类型安全。

4. 性能考虑:

频繁缩容可能导致内存碎片化和性能降低。
如果知道内存大小变化频繁，考虑使用其他数据结构或者技术，如自定义内存池。

```c
#include <stdio.h>
#include <stdlib.h>
 
int main() {
    int *p = (int*)malloc(sizeof(int) * 5); // 初始分配5个int类型元素的内存
 
    if (p == NULL) {
        printf("内存分配失败\n");
        return 1;
    }
 
    // 扩展内存到10个int类型元素
    p = (int*)realloc(p, sizeof(int) * 10);
 
    if (p == NULL) {
        printf("内存重新分配失败\n");
        return 1;
    }
 
    // 使用扩展的内存
    for (int i = 0; i < 10; i++) {
        p[i] = i;
        printf("%d ", p[i]);
    }
 
    // 释放内存
    free(p);
 
    return 0;
}
```

### 深拷贝



## 多维动态数组

```C
//写了个IntVector类
```



## 多线程

[一文搞定之C语言多线程_c语言线程-CSDN博客](https://blog.csdn.net/qq_45790916/article/details/132438564)

## 编译优化

[编译器的优化选项和简单解析_编译器优化等级-CSDN博客](https://blog.csdn.net/u012276729/article/details/136813963)

[Gcc优化选项-CSDN博客](https://blog.csdn.net/zhang626zhen/article/details/52988242)

## 环境配置

### gcc

```bash
apt-get install gcc
apt-get install build-essential #自动安装上g++,libc6-dev,linux-libc-dev,libstdc++6-4.1-dev等一些必须的软件和头文件的库

```

```bash
#常用编译流程
##对于单个.c文件
gcc -o exe_name main.c#或者直接gcc main.c, 这样会生成可执行文件“a.out”

##对于多个.c文件
gcc -c main.c func.c xxx.c #-c: 编译文件，但是不进行链接操作,生成.o文件
gcc -o exe_name main.o func.o xxx.o #链接，生成可执行文件


```

```bash
#其他gcc命令
##预处理 -E
gcc -E hello.c -o hello.i	#对hello.c文件预处理得到hello.i文件
##编译 -S
gcc -S hello.i -o hello.s	#对预处理的hello.i文件 编译到 hello.s文件 
##汇编 -C 
gcc -C hello.s -o hello.o	#实现汇编代码翻译成机器指令代码
##链接 -o
gcc hello.o -o hello 		#实现整个程序的多个.o文件的链接
```

### codelite

[Hello World - CodeLite Documentation](https://docs.codelite.org/hello_world/)

### vscode-wsl 环境配置

#### Debug相关配置文件

工作区相关的所有`VScode`的配置文件都放在`${workspaceFolder}/.vscode`文件夹下

##### launch.json

这个文件里面记录的是与debug直接相关的配置，包括debug任务名称、debug程序（c语言对应`gdb`）、相关参数等等。对于python这种不需要编译的解释性语言，仅用这个文件就够了。但是c语言是编译型语言，在调用`gdb`debug之前还需要调用`gcc`进行编译，对应到`launch.json`里面就要配置一个参数`"preLaunchTask"`，里面调用接下来要说的`tasks.json`文件里的配置进行编译。

##### tasks.json

这个文件就是一些常用任务的配置，写成配置文件后就可以一键运行，而不用每次都敲繁琐的命令行了。在debug的相关配置中常用来填写编译（`build`）任务的相关配置，里面可以指定使用的编译器、使用的语言版本、编译参数等等。

```
//tasks.json, debug多个文件，默认生成后改“args"这里就好
{
    "tasks": [
        {
            "type": "cppbuild",
            "label": "C/C++: gcc build active file",
            "command": "/usr/bin/gcc",
            "args": [
                "*.c",
                "*.h",
                "-g",
                "-o",
                "${fileDirname}/${fileBasenameNoExtension}"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "Task generated by Debugger."
        }
    ],
    "version": "2.0.0"
}
```



#### 参考

[Get Started with C++ and Windows Subsystem for Linux in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-wsl)

[Linux环境下使用vscode进行c/c++语言debug | Geek Space (comfluter.life)](https://geek.comfluter.life/posts/22.04.30-config-cppdebug-in-vscode/)

[VSCode编译、调试C/C++代码以及编译运行多个.c文件的配置方法_vscode 引用.c-CSDN博客](https://blog.csdn.net/weixin_43854928/article/details/124423714#:~:text=打开VSCode的扩展中心，安装Code Runner插件。 打开插件的配置界面,找到Code-runner%3A Executor Map选项，点击json编辑： 将c和cpp两项中的%24fileName替换为*.c和*.cpp，保存。)

[vs code 配置C/C++多文件编译调试（linux&windows）_vscodec++多文件编译-CSDN博客](https://blog.csdn.net/hzf978742221/article/details/116101789)

## 参考

[【6】C++编译器是如何工作的_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1oD4y1h7S3?p=6&vd_source=4d1b708351a5fc77a4a09ddd288c25c2)

[基于Linux系统搭建c开发环境_linux搭建c语言开发环境-CSDN博客](https://blog.csdn.net/weixin_45594288/article/details/129414371?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-4-129414371-blog-127115486.235^v43^control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-4-129414371-blog-127115486.235^v43^control&utm_relevant_index=9)

[【C语言】动态内存管理（malloc，free，calloc，realloc详解 ）-CSDN博客](https://blog.csdn.net/Huangcancan666/article/details/141025475)

# 图论算法

关键词：有向图的环路检测和取环

## 有向图的环路检测和取环

### Johnson’s 算法



### 深度优先搜索(DFS)

#### 原理

点亮迷宫中所有的灯，我们会一条道走到头，如果走不动了，再往回退寻找其他没有走过的

#### 复杂度

时间复杂度为 `O(V+E)` ，

空间复杂度为 `O(V)` (实际上我们需要额外的空间保存环结构，所以最坏情况下占用空间应该是 cv1+cv2+…+cvv＝2^v）

存在什么隐患：图的层级太深会爆栈

- 用邻接矩阵来表示图，遍历图中每一个顶点都要从头扫描该顶点所在行，时间复杂度为O(*V*2).稠密图适于在邻接矩阵上进行深度遍历；
- 用邻接表来表示图，虽然有 2*e* 个表结点，但只需扫描 *e* 个结点即可完成遍历，加上访问 *n*个头结点的时间，时间复杂度为O(*V*+*E*).稀疏图适于在邻接表上进行深度遍历

#### 邻接矩阵法来实现DFS

```c
//https://blog.csdn.net/Blusher1/article/details/140440146
#include <stdio.h>
#include <std.h>
 
#define MAX_VERTICES 100
 
// 定义邻接矩阵和访问标记数组
int graph[MAX_VERTICES][MAX_VERTICES];
bool visited[MAX_VERTICES];
int num_vertices;
 
// 深度优先搜索函数
void dfs(int vertex) {
    // 标记当前节点为已访问
    visited[vertex] = true;
    // 输出当前节点
    printf("%d ", vertex);
 
    // 遍历当前节点的所有邻接节点
    for (int i = 0; i < num_vertices; i++) {
        // 如果邻接节点存在且未被访问，则递归调用dfs函数
        if (graph[vertex][i] == 1 && !visited[i]) {
            dfs(i);
        }
    }
}
 
int main() {
    // 输入顶点数和边数
    printf("请输入顶点数和边数：");
    scanf("%d", &num_vertices);
 
    // 输入邻接矩阵
    printf("请输入邻接矩阵：");
    for (int i = 0; i < num_vertices; i++) {
        for (int j = 0; j < num_vertices; j++) {
            scanf("%d", &graph[i][j]);
        }
    }
 
    // 输出深度优先遍历结果
    printf("深度优先遍历结果：");
    // 初始化访问标记数组
    for (int i = 0; i < num_vertices; i++) {
        visited[i] = false;
    }
 
    // 遍历所有节点，如果节点未被访问，则调用dfs函数
    for (int i = 0; i < num_vertices; i++) {
        if (!visited[i]) {
            dfs(i);
        }
    }
 
    return 0;
}
```

#### 邻接表法实现DFS

```c
//https://blog.csdn.net/Blusher1/article/details/140440146
#include <stdio.h>
#include <stdlib.h>
 
#define MAX_VERTICES 100
 
typedef struct Node {
    int vertex;
    struct Node* next;
} Node;
 
typedef struct Graph {
    int numVertices;
    Node* adjLists[MAX_VERTICES];
} Graph;
 
// 添加边函数
void addEdge(Graph* graph, int src, int dest) {
    // 创建新节点
    Node* newNode = (Node*)malloc(sizeof(Node));
    newNode->vertex = dest;
    newNode->next = graph->adjLists[src];
    graph->adjLists[src] = newNode;
}
 
// 深度优先搜索函数
void DFS(Graph* graph, int vertex, int visited[]) {
    // 标记当前节点为已访问
    visited[vertex] = 1;
    // 输出当前节点
    printf("%d ", vertex);
 
    // 遍历当前节点的所有邻接节点
    Node* temp = graph->adjLists[vertex];
    while (temp) {
        int connectedVertex = temp->vertex;
        // 如果邻接节点未被访问，则递归调用DFS函数
        if (!visited[connectedVertex]) {
            DFS(graph, connectedVertex, visited);
        }
        temp = temp->next;
    }
}
 
// 深度优先遍历函数
void DFSTraversal(Graph* graph) {
    // 初始化访问标记数组
    int visited[MAX_VERTICES] = {0};
    for (int i = 0; i < graph->numVertices; i++) {
        // 如果节点未被访问，则调用DFS函数
        if (!visited[i]) {
            DFS(graph, i, visited);
        }
    }
}
 
int main() {
    // 创建图
    Graph* graph = (Graph*)malloc(sizeof(Graph));
    graph->numVertices = 5;
 
    // 初始化邻接表
    for (int i = 0; i < graph->numVertices; i++) {
        graph->adjLists[i] = NULL;
    }
 
    // 添加边
    addEdge(graph, 0, 1);
    addEdge(graph, 0, 2);
    addEdge(graph, 1, 3);
    addEdge(graph, 1, 4);
 
    // 输出深度优先遍历结果
    printf("Depth First Traversal: ");
    DFSTraversal(graph);
 
    return 0;
}
```

> output: Depth First Traversal: 0 2 1 4 3 

### 广度优先搜索(BFS)

#### 原理

广度优先搜索没有一条道走到黑，而是每个道都走，一层一层实现遍历。

#### 邻接矩阵法实现BFS

```c
#include <stdio.h>
#include <stdlib.h>
 
#define MAX_SIZE 100
 
// 定义队列结构体
typedef struct {
    int data[MAX_SIZE]; // 队列数据
    int front, rear; // 队头和队尾指针
} Queue;
 
// 初始化队列
void initQueue(Queue *q) {
    q->front = q->rear = 0;
}
 
// 判断队列是否已满
int isFull(Queue *q) {
    return (q->rear + 1) % MAX_SIZE == q->front;
}
 
// 判断队列是否为空
int isEmpty(Queue *q) {
    return q->front == q->rear;
}
 
// 入队
void enqueue(Queue *q, int x) {
    if (isFull(q)) {
        printf("Queue is full!\n");
        exit(1);
    }
    q->data[q->rear] = x;
    q->rear = (q->rear + 1) % MAX_SIZE;
}
 
// 出队
int dequeue(Queue *q) {
    if (isEmpty(q)) {
        printf("Queue is empty!\n");
        exit(1);
    }
    int x = q->data[q->front];
    q->front = (q->front + 1) % MAX_SIZE;
    return x;
}
 
// 广度优先搜索
void BFS(int graph[][MAX_SIZE], int visited[], int start, int n) {
    Queue q;
    initQueue(&q);
    enqueue(&q, start);
    visited[start] = 1;
    printf("%d ", start);
 
    while (!isEmpty(&q)) {
        int current = dequeue(&q);
        for (int i = 0; i < n; i++) {
            if (graph[current][i] && !visited[i]) {
                enqueue(&q, i);
                visited[i] = 1;
                printf("%d ", i);
            }
        }
    }
}
 
int main() {
    int n, e;
    printf("Enter the number of vertices and edges: ");
    scanf("%d %d", &n, &e);
 
    int graph[MAX_SIZE][MAX_SIZE] = {0};
    int visited[MAX_SIZE] = {0};
 
    printf("Enter the edges (u v):\n");
    for (int i = 0; i < e; i++) {
        int u, v;
        scanf("%d %d", &u, &v);
        graph[u][v] = 1;
        graph[v][u] = 1; 
    }
 
    printf("BFS traversal starting from vertex 0:\n");
    BFS(graph, visited, 0, n);
 
    return 0;
}
```

#### 邻接表法实现BFS

```c
#include <stdio.h>
#include <stdlib.h>
 
// 定义邻接表结构体
typedef struct Node {
    int vertex;
    struct Node* next;
} Node;
 
// 定义图结构体
typedef struct Graph {
    int numVertices;
    Node** adjLists;
} Graph;
 
// 创建新的节点
Node* createNode(int v) {
    Node* newNode = malloc(sizeof(Node));
    newNode->vertex = v;
    newNode->next = NULL;
    return newNode;
}
 
// 添加边到邻接表
void addEdge(Graph* graph, int src, int dest) {
    Node* newNode = createNode(dest);
    newNode->next = graph->adjLists[src];
    graph->adjLists[src] = newNode;
 
    // 如果是无向图，需要添加反向边
    newNode = createNode(src);
    newNode->next = graph->adjLists[dest];
    graph->adjLists[dest] = newNode;
}
 
// 初始化图
Graph* createGraph(int vertices) {
    Graph* graph = malloc(sizeof(Graph));
    graph->numVertices = vertices;
    graph->adjLists = malloc(vertices * sizeof(Node*));
    for (int i = 0; i < vertices; i++) {
        graph->adjLists[i] = NULL;
    }
    return graph;
}
 
// BFS遍历图
void BFS(Graph* graph, int startVertex) {
    int visited[graph->numVertices];
    for (int i = 0; i < graph->numVertices; i++) {
        visited[i] = 0;
    }
 
    // 创建一个队列并初始化起始顶点
    Node* queue = createNode(startVertex);
    visited[startVertex] = 1;
 
    // 当队列不为空时继续遍历
    while (queue != NULL) {
        // 打印当前顶点
        printf("%d ", queue->vertex);
 
        // 获取当前顶点的邻接顶点列表
        Node* temp = graph->adjLists[queue->vertex];
 
        // 遍历邻接顶点列表
        while (temp != NULL) {
            int adjVertex = temp->vertex;
            if (!visited[adjVertex]) {
                // 将未访问过的邻接顶点加入队列并标记为已访问
                Node* newNode = createNode(adjVertex);
                newNode->next = queue->next;
                queue->next = newNode;
                visited[adjVertex] = 1;
            }
            temp = temp->next;
        }
 
        // 弹出队列的第一个元素
        Node* dequeuedNode = queue;
        queue = queue->next;
        free(dequeuedNode);
    }
}
 
int main() {
    int vertices = 6;
    Graph* graph = createGraph(vertices);
    addEdge(graph, 0, 1);
    addEdge(graph, 0, 2);
    addEdge(graph, 1, 3);
    addEdge(graph, 1, 4);
    addEdge(graph, 2, 4);
    addEdge(graph, 3, 5);
    addEdge(graph, 4, 5);
 
    printf("BFS traversal starting from vertex 0: ");
    BFS(graph, 0);
 
    return 0;
}
```

## 图的存储结构

### 邻接矩阵

![image-20240814144159661](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240814144159661.png)

### 邻接表

![image-20240815150742001](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240815150742001.png)

### 链式向前星

[链式前向星-CSDN博客](https://blog.csdn.net/MuShan_bit/article/details/123882339)

[图论003链式前向星_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Rr4y1871K/?vd_source=4d1b708351a5fc77a4a09ddd288c25c2)

![image-20240818005627462](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240818005627462.png)

![image-20240818005906575](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240818005906575.png)

```c
struct Edge{    //表示边
    int w;
	int to;
    int next;
}edge[xxx];
  
int head[xxx];    //表示来源的边序号


```

- Edge表示边，这个结构体数组将逐步记录边信息，其中包含有三个元素

  - w为权重即边之间的权值，下图中为默认的1，不演示

  - to表示为第i条边指向哪一个结点

  - edge[i].next表示第i条边的下一条边的序号

- Cnt表示边的数量，在输入时利用他逐个+1

- Head表示第x个结点所需要访问的边

#### 遍历一个src的所有边：

![image-20240818010128521](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240818010128521.png)

### 十字链表

### 邻接多重表

## 参考

- [图论算法 —— 图论概述-CSDN博客](https://blog.csdn.net/u011815404/article/details/80313879)
- [理论基础 —— 图 —— 图的存储结构_十字链表和链式前向星-CSDN博客](https://blog.csdn.net/u011815404/article/details/91634080)
- 遍历的方法：拓扑排序[有向图环路检测_有向图环检测-CSDN博客](https://blog.csdn.net/qq_34732050/article/details/127693082)
- DFS,也就是拓扑排序，遍历？[Detect Cycle in Directed Graph Algorithm (youtube.com)](https://www.youtube.com/watch?v=rKQaZuoUR4M)
- DFS和BFS,但是无向图[图——图的遍历（DFS与BFS算法详解）-CSDN博客](https://blog.csdn.net/Blusher1/article/details/140440146)

# todo

1. 学习图论算法
2. 上几届比赛
3. 能否找到开源的一些关于寻找组合逻辑环的算法
4. 赛题中的一些定义：什么时候逻辑环不会震荡、插入寄存器如何影响逻辑环
5. vpi提取出图的结构，还有逻辑门的特性？



# 问题

1. 转为图的具体过程？如何处理inout端口（对单个输入端口的多个输入wire命名是一样的），多输出的命名，wire的命名（gate内部）
2. vpi output 补充
3.  





# Git

## 设置SSH Key

由于本地的Git仓库与GitHub网站仓库之间的传输是通过SSH加密的，所以这时候需要设置SSH keys。

### 创建SSH Key

```bash
ssh-keygen -t rsa -C "youremail@example.com"
#其中，”youremail@example.com”是你的邮件地址，-C的字母为大写。
#后面可以一直回车。中间会让你输入密码，但整个SSH Key对笔者来说保密意义不大，所以不需要设置。SSH Key创建成功后，在笔者的主目录下就会生成/home/grq/.ssh文件夹，里面也会生成文件id_rsa与id_rsa.pub，它们是SSH Key的秘钥对。其中id_rsa是私钥，不能泄露，id_rsa.pub是公钥，可以告诉其他人。 
```

![image-20240822205619902](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240822205619902.png)

### 在GitHub端设置SSH Key

登录GitHub，点击右上角头像，Settings -> Personal settings -> SSH and GPG keys。在SSH Keys标签右方点击New SSH Key。 

 弹出两个文本框。其中的Title，可以随意命名。笔者此处随便命名为grq-Ubuntu。 

 另一个Key文本框，需要输入刚刚生成的`id_rsa.pub`文件中的内容。粘贴后点击`Add SSH Key`，即可生成SSH Key



## 版本管理

每次提交都会是一个版本

主分支是main/master

有一个HEAD指针指向当前分支（只有一个分支的情况下会指向master，而master是指向最新提交）

每个版本都会有自己的版本信息，如特有的版本号、版本名等



## 相关指令

git分为四部分：一部分是自己的本机文件，一部分是缓存区，一个是本地仓库，一个是服务器仓库。当用户在本机修改了文件后，就应该使用`git add xx`指令将修改保存到缓存区，然后再用`git commit yy`指令将推送从缓存区修改到本地仓库中，最后使用`git push`将本地仓库中的修改推送到服务器仓库中。 

### upload

```bash
cd your project_file
git init	#这个命令可以把当前目录变成git可以管理的仓库。
git add file
#git status	#检查当前git状态
git commit -m "Update *** Files by ***"
#复制仓库ssh连接
git remote add origin git@github.com:user/xxx.git #添加一个远程仓库，命名为origin
git remote set-url origin git@github.com:Pxx-X/ICEEC2024-5.git#添加文件到远程库
git push origin master#或者main #使用push指令进行上传,The authenticity of host 'github.com (xxx)'can't be established., 输入yes
#第一次要加origin master， 后面之间git push 就行

```



#### 相关报错：

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



### download

```
git clone ...
```



### 版本回退

```bash
git log #查看版本历史
#commit 3da84125a0c7dc670096fffea730e5ec40f2f198 (HEAD -> master, origin/master, origin/HEAD)
#Author: PxmmmmGH <17875200128@163.com>
#Date:   Fri Aug 23 01:05:55 2024 +0800
#    upload by px
其中"3da84125a0c7dc670096fffea730e5ec40f2f198"就是版本号

#也可以在github上查看

git branch -a 
```

```bash
git reset --hard 目标版本号#git reset的作用是修改HEAD的位置
#适用场景： 如果想恢复到之前某个提交的版本，且那个版本之后提交的版本我们都不要了，就可以用这种方法。
git push -f	#提交更改
```

```bash
git revert -n 版本号
#适用场景： 如果我们想撤销之前的某一版本，但是又想保留该目标版本后面的版本，记录下这整个版本变动流程
git commit -m 版本名
git push
```



### 建立分支

[如何使用 Git 进行多人协作开发（全流程图解）_git多人协作开发流程-CSDN博客](https://blog.csdn.net/whc18858/article/details/133209975)没看懂，有点晕

```bash

```





## 其他

### 关于master与main

源代码存储库的主要版本

> 从 2020 年 10 月 1 日开始，GitHub 上的所有新库都将用中性词「main」命名，取代原来的「master」，因为后者是一个容易让人联想到奴隶制的术语。

## 参考

[最简单的Github管理多人同时开发项目的教程 无需掌握任何命令就能完成版本控制 图形化操作 自动合并代码 太方便了_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1o7411U7j6/?spm_id_from=333.337.search-card.all.click&vd_source=4d1b708351a5fc77a4a09ddd288c25c2)

[Ubuntu环境如何上传项目到GitHub网站？-腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1010093)**主要是按照这个做的**

[Git使用教程（看完会了也懂了）-腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/2312328)**非常好的教程**





# 宣讲

![image-20240828190524502](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240828190524502.png)

**注意锁存器**

![image-20240828190631173](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240828190631173.png)

右图震荡



**没有时序逻辑！**

**公共支路**，最少

**环套环！**

C++?

![image-20240828191354590](C:\Users\Pxmmmm.DESKTOP-G18CTQU\AppData\Roaming\Typora\typora-user-images\image-20240828191354590.png)

**至多2输入！**

简化

不用考虑环旁路port的互相影响，是独立的，创新分

第五题是检测整个case出现震荡
