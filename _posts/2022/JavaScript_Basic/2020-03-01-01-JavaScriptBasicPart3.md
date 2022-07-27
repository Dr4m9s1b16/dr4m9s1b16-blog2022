---
layout: post
title:  "JavaScript Basic  Part 3"
author: haran
categories: [javascript,jsbasic]
image: post_img/2022/javascript_basic/js.png
beforetoc: "Dom and Dom manipulation , Events and Events Handling , This keyword , Html and css , ES5 and ES6 , Project dice game"
toc: true
---

## DOM and DOM Manipulation

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/2.jpg)

## Events and Events handling

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/3.jpg)

>After execution stack finish event functions are invoked



![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/7.jpg)

>call back function ,the function which is not called by us but called by another function.

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/9.jpg)

```js
document.querySelector('.btn-roll').addEventListener
('click',function(){

//generate Random Number
var dice = Math.floor(Math.random()*6)+1;

//Display the result
var diceDom =document.querySelector('.dice');
diceDom.style.display = 'block';
diceDom.src ='dice-'+dice+'.png';

//Update the round score if the rolled was 
//NOT a 1 


});


```

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/10.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/11.jpg)

```js

document.getElementById('score-0').textContent ='0';
document.getElementById('score-1').textContent ='0';
document.getElementById
('current-0').textContent ='0';
document.getElementById
('current-1').textContent ='0';
```



![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/12.jpg)

>or

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/13.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/15.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/16.jpg)

---
---
---

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/18.jpg)

---
---
---


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/19.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/24.jpg)

---
---
![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/27.jpg)

## This Keyword

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/32.jpg)

>regular function call happen default object is window object.
>this declared inside a function but it is a regular function 


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/33.jpg)

## Html and CSS

>ID should be unique class can be written over and over agin

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/36.jpg)

>Universal Selector applied to all of them


![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/37.jpg)

## ES5,ES6

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/39.jpg)

## Project Dice Game

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/javascript_basic/3/42.jpg)

``` js
var scores ,roundScore,activeScore,dice;

scores =[0,0];
roundScore = 0;
activePlayer = 1;

dice = Math.floor(Math.random()*6)+1;
//Math.random()*6 - random values from 0-5

document.querySelector('#current'+activePlayer).
textContent = dice;

var x= document.querySelector('#score-0')
.textContent;
// 0 th player score

document.querySelector('.dice').style.
display ='none';

//display dice none

```



