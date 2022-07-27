---
layout: post
title:  "Java Basic  Part 2"
author: haran
categories: [java,javabasic]
image: post_img/2022/java_basic/1/java.gif
beforetoc: "If else statement , for loop ,while and do while loop ,Switch statement "
toc: true
---

If else statement , for loop ,while and do while loop ,Switch statement


## code blocks if then else statements


![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/1.png)

``` java

public class Hello {

public static void main(String[] args){
    
	if(score < 5000 && score>1000){
		//
	}else if(score <1000){
		//
	}else{
		//
	}
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/2.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/3.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/4.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/5.png)

[[Methods]]

## For Loop

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/6.png)


### Prime Check

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/7.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/8.png)

``` java

public class Hello {

public static void main(String[] args){

public static boolean isPrime(int n){
	if(n==1){return false;}
	
	for(int i=2;i<= n/2;i++){
		if(n%i == 0){return false;}
	}
	return true;
	}
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/9.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/10.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/11.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/12.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/13.png)

[[12 While and Do While Loop]]

## While and Do While Loop

### while

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/14.png)

>- do while gurantted to execute atleast once

### do-While
![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/15.png)

#### Example
![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/16.png)

---
---

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/17.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/18.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/19.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/20.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/21.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/22.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/23.png)

[[8-Parsing Values from String]]

## Switch Statement

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/24.png)

``` java

public class Hello {

public static void main(String[] args){

switch(switchValue){
		case 1:
		//
		break;
		
		case 1:
		//
		break;
		
		case 3:
		//
		break;
		
		default:
		//
		break;


		}

	}
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/2/25.png)

[[11 For Loop]]