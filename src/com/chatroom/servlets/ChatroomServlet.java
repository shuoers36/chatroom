package com.chatroom.servlets;
import java.io.IOException;
import java.util.HashMap;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.OnError;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/websocket/{client-id}")
public class ChatroomServlet{
  private static final HashMap<String,Session> clients=new HashMap<String,Session>();

@OnOpen
public void OnOpen(Session session,@PathParam("client-id") String clientId){
  clients.put(clientId,session);
 refresh();
}

public void refresh(){
   Set<String> ids=clients.keySet();
  try{
    StringBuilder strs=new StringBuilder("");
    strs.append("[");
    for(String id:ids){
      strs.append("\"");
      strs.append(id);
      strs.append("\"");
      strs.append(",");
    }
    if(strs.indexOf(",")>-1){
      strs.deleteCharAt(strs.lastIndexOf(","));
    }
    strs .append("]");
    for(Session s:clients.values()){
      s.getBasicRemote().sendText("init:{clients:"+strs.toString()+"}");
    }
  } catch(IOException e){
    e.printStackTrace();
  }
}

@OnClose
public void OnClose(Session session,@PathParam("client-id") String clientId){
  System.out.println("the clentId of"+clientId+"退出");
  clients.remove(clientId);
  refresh();
}


@OnMessage
public void onMessage(Session session,String message,@PathParam("client-id") String clientId){
  String sendTo=getSendToClientId(message);
  if(sendTo==null){
    for(Session client:clients.values()){
      if(client!=session){
    	try{
        client.getBasicRemote().sendText(clientId+":"+message);      
      } catch(IOException e){
        e.printStackTrace();
      }
    }
    }
  } else{
    Session sessionTo=clients.get(sendTo);
    try{
      sessionTo.getBasicRemote().sendText(clientId+"对你说:"+getMsgBody(message));
    } catch(IOException e){
      e.printStackTrace();
    }
  }
}



@OnError
public void onError(Throwable t) {
  System.out.println("发生错误");
  t.printStackTrace();  
}

public String getSendToClientId(String msg){
  String[] strs=msg.split("\\|");
  if(strs.length>1){
    return strs[1];
  }
  return null;
}

public String getMsgBody(String msg){
  String[] strs=msg.split("\\|");
  if(strs.length>1){
    return strs[0];
  }
  return msg;
}


}