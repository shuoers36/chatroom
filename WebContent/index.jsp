

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>chatroom</title>
  <meta charset="UTF-8">
  <style type="text/css">
  html,body,ul,li,input,form,div{
  margin:0;
  padding:0;
  }
  html{
  background:linear-gradient(to right, #50a3a2 0%, #53e3a6 100%);
  min-width:900px; 
  }
  
  body{
  background:linear-gradient(to right, #50a3a2 0%, #53e3a6 100%);
  opacity: 0.8;
  font-family:"microsoft yahei", "Arial Rounded MT Bold", "Helvetica Rounded", Arial, sans-serif;
  font-weight:500;
  }
  h2{
  padding-left:200px;}
  #sidebar{
  float:right;
  position:relative;
  padding:20px;
  }
  #online,#status{
  display:inline-block;
  padding:50px 0 0 120px;
  }
  #online{
  padding-left:30px;}
  #onlineinfos{
  width:128px;
  position:absolute;
  left:-10px;
  top:70px;
  }
  #onlineinfos li{
  list-style:none;
  box-shadow: 0 3px 3px rgba(0,0,0,.3);
  padding-top:5px;
  }
  #onlineinfos li a{
  text-decoration:none;
  color:#000;
  font-weight:600;
  display:block;
  background-color:rgba(230,230,230,.3);
  border-radius:5px;
  text-align:center;
  }
  #text{
  width:400px;
  height:5em;
  margin:10px 0;
  border-radius:10px;
  }
  #msgarea{
  height:500px;
  width:650px;
  padding:10px;
  float:left;
  background-color:#fff;
  overflow:scroll;
  }
  
  #sendtext{
  width:470px;
  margin:20px 0;
  padding-left:120px;
  border-radius:15px}
  
  #msgarea p{
  border-radius:10px;
  width:250px;
  position:relative;
  padding:12px;
  font-size:.9em;
  }
  p.fromMe{
  margin-left:280px;
  background-color:rgba(200,200,30,.4);
  }
 
  p.fromMe:after{
  content:'';
  width:0;
  height:0;
  position:absolute;
  left:100%;
  bottom:0%;
  border:8px solid transparent;
  border-left:20px solid rgba(200,200,30,.4);
  transform: rotate(12deg); 
  }
  p.fromMe:before{
  content:'';
  display:block;
  width:48px;
  height:48px;
  position:absolute;
  bottom:0px;
  right:-65px;
  background-image:url(head.jpg);}
  
  p.toMe{
  margin-left:70px;
  background-color:rgba(50,200,30,.4);
  }
  
  p.toMe:before{
  content:'';
  width:0;
  height:0;
  position:absolute;
  left:-24px;
  bottom:0%;
  border:8px solid transparent;
  border-left:20px solid rgba(40,180,140,.4);
  transform: rotate(160deg); 
  }
  p.toMe:after{
  content:'';
  display:block;
  width:48px;
  height:48px;
  position:absolute;
  bottom:0px;
  left:-65px;
  background-image:url(head.jpg);
  }
  #msg{
  border:10px solid #fff;
  border-radius:15px;
  overflow:hidden;
  margin:20px;
  margin-right:5px;
  width:670px;
  }
  
  

#onlineinfos{

}
  </style>
</head>
<body>
  <div id="sidebar">
  <div id="status">用户名：</div>
  
	<div id="online"></div>
  	<ul id="onlineinfos"></ul>
  
  <div id="sendtext">发送消息给:
  <select id="users">
    <option>all</option>
  </select><br>
  <input type="text" id="text"></input><br>
  <button id="sendbtn">发送</button> <button id="clearbtn">清屏</button>
  </div>
</div>
<h2>Web Socket Chatroom</h2>
<div id="msg"><div id="msgarea"></div></div>
<script>
  <% String nameId = new String(request.getParameter("username").getBytes("ISO-8859-1"),"utf-8"); %>;
  nameId="<%=nameId%>";
  var URL="ws://localhost:8080/chatroom/websocket/";
  URL+=nameId;
  var websocket;
  var text=document.getElementById("text");
  var user=document.getElementById("users");
  var msgarea=document.getElementById("msgarea");
  var mystatus=document.getElementById("status");
  var online=document.getElementById("online");
  var onlineinfos=document.getElementById("onlineinfos");
  
  window.onload=function(){
	  connect();
  };
  
  function connect(){
    try{
      websocket=new WebSocket(URL);
      websocket.onopen=function(event){
        onOpen(event);
      }
      websocket.onmessage=function(event){
        onMessage(event);
      }
      websocket.onerror=function(event){
        onError(event);
      } 
    } catch(e){
      alert("your browser not support websocket");
    }
  }
  document.getElementById("sendbtn").onclick=sendMessage;
  text.onkeypress=function se(event){
	  if(event.keyCode==13){
		  sendMessage();
	  }
  }
  document.getElementById("clearbtn").onclick=function(e){
	  msgarea.innerHTML="";
  }
	
	function sendMessage(){
    var msg=text.value;
    if(user.value!=='all'){
      msg+="|"+user.value;
    }
    websocket.send(msg);
    if(users.value!=='all'){
    msgarea.innerHTML+=("<p class=\"fromMe\">"+" 我   "+" 对   "+users.value+" 说 :"+text.value);}
    else{
    	msgarea.innerHTML+=("<p class=\"fromMe\">"+"  我   "+" 说 :"+text.value);
    }
  }

  function onOpen(){
    mystatus.appendChild(document.createTextNode(nameId));
  }

  function onMessage(event){
    if(typeof event.data=='string'){
      if(event.data.indexOf("init:")==0){
        var str=event.data;
        var json=str.substring(5);
        var initObj=eval("("+json+")");
        if(initObj.clients.length > 0){
        	online.innerHTML=("当前在线人数： "+initObj.clients.length);
        	user.innerHTML="<option value=\"all\">all</option>";
        	 var onlineinfo="";
  
          for(var i=0;i<initObj.clients.length;i++){     
        	  
        	  onlineinfo+="<li><a href=\"#\">"+initObj.clients[i]+"</a></li>";
        	  if(initObj.clients[i]!==nameId){
        	  user.options.add(new Option(initObj.clients[i],initObj.clients[i])); 
        	  }
        	 } 
          
          	onlineinfos.innerHTML=onlineinfo;
          }
        } 
    
      else{
          msgarea.innerHTML+=("<p class=\"toMe\">"+event.data+"</p>");
        }
      }
  }

function onError(event){
  alert('ERROR:'+event.data);
}




</script>
</body>
</html>