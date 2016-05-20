<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>chatroom</title>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/reset.css">
  <link rel="stylesheet" href="css/main.css">
</head>
<body>
	<header><img src="images/logo.png"> 
	WebSocket Chatroom
  <div id="online"></div>
  <div id="status">User：</div> 	
	</header>
  <div id="sidebar"><h2>Online Users</h2>
  	<ul id="onlineinfos"></ul>
  
  <div id="sendtext">Send To:<span id="span1"><span id="span2">
  <select id="users">
    <option>all</option>
  </select></span></span><br>
  <input type="text" id="text"></input><br>
  <button id="sendbtn">Send</button> <button id="clearbtn">Clear</button><br>
  </div>
  <h3>Some Communication Skills:</h3>
  <ul id="skill">
  <li>Being a good listener is one of the best ways to be a good communicator.</li>
  <li>Try to convey your message in as few words as possible. </li>
  <li>It is important to be confident in all of your interactions with others.</li>
  <li>A good communicator should enter any conversation with a flexible, open mind.</li> 
  <li>Being able to appropriately give and receive feedback is an important communication skill.</li>
  </ul>
</div>
<div id="msg"><div id="msgarea"></div></div>
<script>
  <% String nameId = new String(request.getParameter("username").getBytes("ISO-8859-1"),"utf-8"); %>;
  nameId="<%=nameId%>";
  var URL="ws://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}${pageContext.request.contextPath}/websocket/";
  console.log(URL);
  URL+=nameId;
  document.title="Chatroom User: "+nameId;
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
        	 online.innerHTML=("Online： "+initObj.clients.length);
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