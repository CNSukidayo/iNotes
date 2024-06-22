# 目录  
1.计算机基础






## 1.计算机基础  
**目录:**  
1.1 汇编语言基础  
1.2 C语言基础  




### 1.1 汇编语言基础
*提示:这一章可以参考计算机组成原理*  

1.常见操作语句  
Intel 8086(16位)CPU有以下基础指令  
* INC:加1
* DEC:减1
* MUL:相乘
* DIV:除
* ADD:相加
* MOV:将数据从源位置传送至目标位置,源操作数不变,不影响标志位
* XCHG:内容交换,不影响标志位
* PUSH:压入堆栈
* POP:弹出堆栈
* JMP:无条件跳转至某条指令的内存地址
* LEA:有效地址传送指令,内存将存储器操作数的有效偏移地址传送至指定的寄存器中
* LDS/LES:地址指针传送指令,将内存中指定的地址传送至寄存器中

2.内联汇编  
<font color="#FF00FF">内联汇编是指在C语言代码中插入汇编指令</font>,在Linux中编写汇编程序时较为常见,内联汇编产生的原因在于,有时编写C语言程序时,某些操作不需要C语言编译器产生汇编代码,这时就必须自行在C语言方法中编写汇编代码.  
Linux中使用的汇编程序语法和GCC(Linux的GUN C编译器)使用的语法一致,都是AT&T汇编语法,在汇编语言的世界中,存在两个不同种类的汇编语法,即Intel和AT&T  

2.1 寄存器命名  
在AT&T汇编语法中,寄存器名称前使用%前缀,如果使用eax寄存器,那么应该用作%eax;在intel汇编语法中,寄存器名称前不需要加上%前缀,直接编写寄存器名字eax即可;对于<font color="#00FF00">立即数</font>的命名也不需要加上\$符,而AT&T需要对立即数加上\$符号  

2.7 基本内联汇编  
基本内联汇编格式比较直观,可以写成如下形式  
```c
asm("movl %ecx, %eax");     // 把ecx内容移动到eax
_asm_("movb %bh, (%eax)");  // 把bh中一个字节的内容移动到eax指向的内存中 
```
这里使用了两个不同的关键字,即asm和_asm_;这两个关键字都可以使用,但是当遇到asm关键字与程序中其他变量有冲突时,就必须使用_asm_关键字,如果内联汇编有多条指令,则每行都需要加双引号,并且该行要以`\n\t`结尾.这是因为GCC会将每行指令作为一个字符串传给汇编器,使用换行和TAB,可以将正确且格式良好的代码传递给汇编器  
```c
_asm_("movl %eax, %ebx"
  "movl %56, %esi"
  "movl %ecx,$label(%edx, ebx, $4)"
  "movb %ah, (%ebx)");
```

2.8 扩展内联汇编  
在扩展形式中,还可以指定操作数,且可以选择输入输出寄存器,并指明要修改的寄存器列表,扩展内联汇编格式如下  
```c
asm(assembler template
        :output operands
        :input operands
        :list of clobbered registers);
```
其中assembler template是汇编指令部分,output operands为输出操作数,input operands为输入操作数,list of clobbered registers为clobbered寄存器列表,包含特殊的指示作用,不同部分之间用冒号":"分隔  


### 1.2 C语言基础  
1.C语言基本介绍  
<font color="#00FF00">汇编语言的本质是对机器语言的抽象,C语言的本质是对汇编语言的抽象</font>,所以C语言可以通过编译器被编译为汇编语言,汇编语言再通过汇编器被编译为机器语言  

2.结构体  
结构体是C语言编程中一种用户自定义的可用的数据类型,它允许存储不同类型的数据项  

2.1 定义结构体
```c
struct tag{         // tag是结构体标签
  member-list       // member-list是标准的变量定义,如int i;char username[50]
  member-list
  member-list
}variable-list;
// variable-list是结构变量,定义在结构的末尾,最后一个分号之前.可以指定一个或多个结构变量

// 举例
struct Person{
  char username[50];
  int age;
}user;
// 注意:tag、member-list、variable-list 3部分至少要出现三个
```

2.2 结构体变量的初始化  
```c
#include<stdio.h>
struct Person{
  int age;
  char username[50];
};
int main(){
  struct Person person={18,"小明"};
  printf("username:%sage:%d",person.username,person.age);
}

// 运行结果usemname：小明age:18
```

2.3 访问结构体成员  
要想访问结构体中的成员,可以使用成员访问运算符"."  
```c
#include <stdio.h>
#include <string.h>
struct User {
  char username[50];
  int gender;
  char telephone[20];
};

int main(){
  struct User user1;
  struct User user2;

  // 初始化user1变量
  strcpy(user1.username,"A");     // strcpy(args0,args1) 拷贝字符串args1到args1中去
  strcpy(user1.telephone,"138xxxx8899");
  user1.gender = 1;
  // 初始化user2变量
  strcpy(user2.username,"B");
  strcpy(user2.telephone,"138xxxx8889");
  user2.gender = 0;
  // 输出user1信息
  print("user1 username:%s",user1.username);
  print("user1 gender:%d",user1.gender);
  print("user1 telephone:%s",user1.telephone);
  // 输出user2信息
  print("user2 username:%s",user2.username);
  print("user2 gender:%d",user2.gender);
  print("user2 telephone:%s",user2.telephone);
}

// 运行结果
/*
user1 username:A
user1 gender:1
user1 telephone:138xxxx8899

user2 username:B
user2 gender:0
user2 telephone:138xxxx8889
*/
```

2.4 结构体作为函数参数  
C语言中的结构体可以作为函数的传入参数,其传参方式与变量类似  
```c
#include <stdio.h>
#include <string.h>

struct User {
  char username[50];
  int gender;
  char telephone[20];
};
void printUser(struct User user);   // 函数声明
int main() {
  // 初始化user1变量
  strcpy(user1.username,"A");     // strcpy(args0,args1) 拷贝字符串args1到args1中去
  strcpy(user1.telephone,"138xxxx8899");
  user1.gender = 1;
  // 初始化user2变量
  strcpy(user2.username,"B");
  strcpy(user2.telephone,"138xxxx8889");
  user2.gender = 0;

  printUser(user1);
  printUser(user2);

  return 0;
}

void printUser(User user){
  // 输出user信息
  print("user username:%s",user.username);
  print("user gender:%d",user.gender);
  print("user telephone:%s",user.telephone);
}
// 运行结果同2.3
```

2.5 指向结构体的指针  
在C语言中,有时我们需要传递结构体的指针值而不是复制一份副本作为值传递,我们想在函数中对原来的结构体成员变量进行修改,这时就需要传递指向结构体的指针,使用方法如下  
```c
// 定义指向结构体的指针,与指向其他类型变量的指针相似,如下所示
struct User *struct_pointer;
// 上述定义的指针变量中存储结构变量的地址,查找结构变量的地址
// 需要把 & 运算符放在结构名称的前面,如下所述
struct_pointer = &user1;

// 使用结构指针访问结构的成员,需要使用 -> 运算符,如下所示
struct_pointer.username;
struct_pointer.gender;

#include <stdio.h>
#include <string.h>

struct User {
  char username[50];
  int gender;
  char telephone[20];
};
void printUser(struct User user);   // 函数声明
int main() {
  // 初始化user1变量
  strcpy(user1.username,"A");     // strcpy(args0,args1) 拷贝字符串args1到args1中去
  strcpy(user1.telephone,"138xxxx8899");
  user1.gender = 1;
  // 初始化user2变量
  strcpy(user2.username,"B");
  strcpy(user2.telephone,"138xxxx8889");
  user2.gender = 0;

  printUser(&user1);
  printUser(&user2);

  return 0;
}

void printUser(struct User *user){
  // 输出user信息
  print("user username:%s",user->username);
  print("user gender:%d",user->gender);
  print("user telephone:%s",user->telephone);
}

// 输出结果同2.3
```

2.6 从汇编语言角度理解结构体  
<font color="#00FF00">结构体本质是一片连续的空间,存储了不同类型的数据</font>;接下来,我们从汇编语言角度解析结构体的实现原理,首先来看下列C语言代码  

```c
#include <stdio.h>
struct User {
  int age;
  char *name;
  long money;
};
int main(){
  struct User user = {17,"lisa",10000};
  // 创建结构体指针
  struct User *p = &user;
  // user结构体的地址
  printf("user 变量的地址:%p",&user);
  // 使用指针访问age
  printf("user ");
}

```





