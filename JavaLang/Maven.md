# 目录  




## 1.pom.xml  
**目录:**  
1.1 scope作用域  



### 1.1 scope作用域  
1.分类  
在Maven中作用域一共分为5种  
* provided
* compile:依赖的jar/模块只参与编译;为的是能够编译通过,不会参与到最后真正的运行,如果打包当前模块是不会打包compile作用域的jar 
* runtime
* test
* system
* import:只做声明不真正导入