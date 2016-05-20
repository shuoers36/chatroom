<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.mysql.jdbc.Driver" %> 
<%! String ss=""; %>
<% 
String driverName="com.mysql.jdbc.Driver"; 
String userName="sds"; 
String userPasswd="123"; 
String dbName="sds1"; 
String tableName="user"; 
String url="jdbc:mysql://localhost:3306/"+dbName+"?user="+userName+"&password="+userPasswd+"&useUnicode=true&characterEncoding=utf-8"; 
Class.forName("com.mysql.jdbc.Driver").newInstance(); 
Connection connection=DriverManager.getConnection(url); 
Statement statement = connection.createStatement(); 
String str=request.getParameter("username");
String pwd=request.getParameter("password");
String register=request.getParameter("register");

if(pwd==null || pwd==""){
String sql="SELECT * FROM "+tableName+" Where name='"+str+"'"; 
ResultSet rs = statement.executeQuery(sql); 
while (rs.next()) 
{
 String username = rs.getString("name"); 
 ss+=username;
} 
response.getWriter().print(ss);
rs.close(); 
}
if(pwd!=null && pwd!="" && register==""){
	String sql="SELECT * FROM "+tableName+" Where name='"+str+"'"+" and password='"+pwd+"'"; 
	System.out.println(sql);
	ResultSet rs = statement.executeQuery(sql); 
	while (rs.next()) 
	{
	 String username = rs.getString("name"); 
	 ss+=username;
	} 
	response.getWriter().print(ss);
	rs.close(); 
}
if(pwd!=null && pwd!="" && register!=""){
	String sql = "insert into user values('" + str + "','" + pwd+"')"; 
	System.out.println(sql);
	statement.execute(sql);
}

ss="";
statement.close(); 
connection.close(); 
%> 