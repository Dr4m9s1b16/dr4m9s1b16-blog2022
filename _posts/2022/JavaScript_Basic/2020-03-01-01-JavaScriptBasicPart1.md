---
layout: post
title:  "JavaScript Basic  Part 1"
author: haran
categories: [javascript,jsbasic]
image: post_img/2022/javascript_basic/js.png
beforetoc: " Java Script intro ,JavaScript parsers and engines ,Let and const , Objects in JavaScript , Primitives vs Objects ,Objects and Functions"
toc: true
---

## Basic

``` js
console.log('Haran')
```

-  Link javascript

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/2.jpg)

``` js
var first ='John' ;

var age = 28 ;

var isFull = True;

```


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/3.jpg)

- javascript is dynamic programming language variable types are automatically assigned to variables

## Variable mutation and type cohersion
### variable mutation
``` js
\\ oneline comment

\*
multiline comment
*\ 

``` js
var first , second ;

first = 'htl' ;
second = 'youh' ;

first = 't';
second = 'e';

```

```

### type cohersion

``` js
var first , second ;

first = 'htl' ;
second = 'youh' ;

```

### How javascript execute

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/4.jpg)

### Execution contexts

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/5.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/6.jpg)



![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/7.jpg)

- **Variable Object :** it contains functions arguments ,variable declarations 
- **Scope Chain :** Current variable objects and its parents

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/9.jpg)

### Hoisting exmaple

#### Example 1

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/11.jpg)

#### Example 2

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/12.jpg)

- This is not function declaration this is function expression
- HOISTING only works with function declaration.

 ![[Pasted image 20210407123939.png]]


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/13.jpg)

- Variables that dont have value yet they have dataType undefined.

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/14.jpg)

## Let and Const

>- Const value not changeable 

>- Let used to change the value of the variable


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/15.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/17.jpg)

>- got error because variables are not function scoped but block scoped.
>
>- If it is has a for block or while block it will create another variable.
>- vlock scoped means all the variables in the curly braces.
>- only access by the definitions with their own block.Out side of the block doesnot scoped.

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/21.jpg)

## Objects in JavaScript

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/24.jpg)

>In others called ==Class== in javascript constructors/Instances

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/26.jpg)

### Inheritance

>One object is based on another object

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/27.jpg)

>Each and every javascript obkect has a prototype property which makes inheritance possible

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/29.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/30.jpg)

>Constructors/Instances Start with Capital Letter

---
---

>- new variable used to point not global object but new Person Object/empty Object.
>- First create empty Object and then call the function

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/31.jpg)

## ProtoType Through Inheritance

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/33.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/34.jpg)


## ProtoType chains in the console

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/42.jpg)


## ==Object.Create Method==

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/44.jpg)

>- Difference between Object.Create and Function constructor pattern
>
>- Object.create pattern create inheritance directly we passed into the first argument.
>- function constructor newly created object inherits from the constructors prototype property
>- Object.create used to create really complex object structures in easier way than  function constructors 
>- because it involves to directly specify which object should be a prototype

## Primitives vs Objects

>- strings, booleans, undefined, and null
are primitives and that everything else are objects.

> - big difference between primitives and objects
> is that variables containing primitives
> actually hold that data inside of the variable itself.
>- On objects it's very different. Variables associated with objects do not actually contain the object, but instead they contain a reference to the place in memory where the object sits, so where the object is stored.
>- So again a variable declared as an object,does not have a real copy of the object, it just points to that object.

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/45.jpg)

>- when we say obj1=obj2 no new object is created here new reference whwich points to the new object . it is the same object 

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/46.jpg)

>- Primitive data types doesnot effect because it create new primitve datatype ,but objects can vary according to our change
>
>- reference to the object can change 
>- if we change the in the function primitive cant change.

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/47.jpg)

## Objects and Functions

>- IIFE -  Immediately called function evalutions .

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/49.jpg)

>- Through this we cam ensure data privacy from outer execution context
>- This is just for data privacy.

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/1/50.jpg)
