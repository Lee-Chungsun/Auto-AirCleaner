// 전송된 데이터를 받아 서버 디비에 저장시켜주는 jsp

<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8" import = "org.json.simple.*"%>
<%@ page import ="java.sql.*" %>

<%
String id = request.getParameter("id");
String pass = request.getParameter("pass");

JSONObject jsonMain = new JSONObject();
JSONArray jArray = new JSONArray();
JSONObject jObject = new JSONObject();


String url = "자기 디비 url"
Connection conn = DriverManager.getConnection(url,"DBid설정","DBpassword");
Statement stmt = conn.createStatement();
PreparedStatement pstmt = null, pstmt2 = null


String strSQL = "SELECT * FROM AirUserTbl where userId='" + id + "'"
ResultSet rs = stmt.executeQuery(strSQL);
if(!rs.next()){
    jObject.put("msg1", "noId")
}else{
String logid = rs.getString("userId");
String logpass = rs.getString("pass");


if (pass.equals(logpass)){
jObject.put("msg1", "success")
}else{
jObject.put("msg1", "noPw")
}
}
  stmt.close();
  conn.close();

//stmt와conn객체를닫습니다.
  jArray.add(0,jObject)

//담은데이터를배열로만듭니다.
  jsonMain.put("List",jArray)

//안드로이드로데이터를날립니다.
  out.println(jsonMain.toString());
  


%>
