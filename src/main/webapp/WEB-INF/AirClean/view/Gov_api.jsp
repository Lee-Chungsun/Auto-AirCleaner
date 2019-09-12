<%@page import ="java.sql.*" %>
<%@page import="org.json.*"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%

String dbUrl = "디비주소"
Connection dbConn = DriverManager.getConnection(dbUrl,"DBid","DBpass");
Statement stmt = dbConn.createStatement();
PreparedStatement pstmt = null
/*빨간색 부분은 해당 API에 맞게 수정해야 합니다.*/
/*보낼 URL를 StringBuilder에 입력, 가이드에 나오는 URL를 입력 */ 
StringBuilder urlBuilder = new 
StringBuilder("http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"); /*URL*/

/*내가 신청한 인증키 입력*/ 
urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=59a9h3y5LYJCzu%2BLtAA79gkQ9rn"); /*Service Key*/

/*가이드에 있는 여러 가지 조건 설정(가이드라인 예제 URL 그대로 하시면 문제 없이 잘돌아갑니다. */ 
urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("999", "UTF-8")); /*검색건수*/
urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
urlBuilder.append("&" + URLEncoder.encode("itemCode","UTF-8") + "=" + URLEncoder.encode("PM10", "UTF-8")); /*측정타입*/
urlBuilder.append("&" + URLEncoder.encode("dataGubun","UTF-8") + "=" + URLEncoder.encode("HOUR", "UTF-8")); /*축정기준*/
urlBuilder.append("&" + URLEncoder.encode("searchCondition","UTF-8") + "=" + URLEncoder.encode("WEEK", "UTF-8")); 
urlBuilder.append("&" + URLEncoder.encode("ver","UTF-8") + "=" + URLEncoder.encode("1.3", "UTF-8")); /*버전*/
/*JSON으로 처리하기위해 JSON으로 응답 메시지를 받는다고 설정*/ 
urlBuilder.append("&" + URLEncoder.encode("_returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*타입*/

/*그대로 붙여 넣기 하면 됩니다. 해당 URL를 Http통신 Get방식으로 보냅니다. 받을 타입은 Json으로 Header에 명시해 주고 응답코드(성공 실패 여부)을 구분하여 받은 메시지를 읽어와 BufferReader에 집어넣습니다. 받아온 JSON 형태의 문자를 jsonObject, Array에 집어 넣어줍니다.*/ 
URL url = new URL(urlBuilder.toString());
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
conn.setRequestProperty("Content-type", "application/json");
System.out.println("Response code: " + conn.getResponseCode());
BufferedReader rd
if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
} else {
    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
}
String sb = ""
String line=""
while ((line = rd.readLine()) != null) {
    sb +=line
}
rd.close();
conn.disconnect();

JSONObject json = new JSONObject(sb);
/*보내주는 json이름에 맞추어서 해당 부분을 입력해야 합니다. list의 확률이 크지만 정확히 확인하기 위해서는  System.out.print(sb)를 확인해보는 것을 추천합니다. */ 
JSONArray jArr = json.getJSONArray("list");



/*해당 데이터를 데이터베이스에 집어넣는 부분, 각자의 DB와 데이터에 따라 다르게 코딩되어야 합니다. 밑에는 예시 정도로 생각하시면 됩니다.. */ 
String getJsonData[];
getJsonData = new String[18];


String strSQL = "INSERT INTO OutSideDustTbl(dataTime,busan,chungbuk,chungnam,daegu,daejeon,gangwon,gwangju,gyeongbuk,gyeonggi,gyeongnam,incheon,jeju,jeonbuk,jeonnam,sejong,seoul,ulsan)"
json = jArr.getJSONObject(0);
String strSQL1 = "SELECT * FROM OutSideDustTbl ORDER BY dataTime DESC"
ResultSet rs = stmt.executeQuery(strSQL1);
rs.next();
if(!json.getString("dataTime").equals(rs.getString("dataTime"))){
strSQL = strSQL + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
pstmt = dbConn.prepareStatement(strSQL);
pstmt.setString(1, json.getString("dataTime"));
pstmt.setString(2, json.getString("busan"));
pstmt.setString(3, json.getString("chungbuk"));
pstmt.setString(4, json.getString("chungnam"));
pstmt.setString(5, json.getString("daegu"));
pstmt.setString(6, json.getString("daejeon"));
pstmt.setString(7, json.getString("gangwon"));
pstmt.setString(8, json.getString("gwangju"));
pstmt.setString(9, json.getString("gyeongbuk"));
pstmt.setString(10, json.getString("gyeonggi"));
pstmt.setString(11, json.getString("gyeongnam"));
pstmt.setString(12, json.getString("incheon"));
pstmt.setString(13, json.getString("jeju"));
pstmt.setString(14, json.getString("jeonbuk"));
pstmt.setString(15, json.getString("jeonnam"));
pstmt.setString(16, json.getString("sejong"));
pstmt.setString(17, json.getString("seoul"));
pstmt.setString(18, json.getString("ulsan"));
pstmt.executeUpdate();

    for(int a=0;a<18;a++){
    out.println("미세먼지"+json.getString("dataTime"));%>
    <BR>
    <%
    }
}
dbConn.close();
stmt.close();
%>

<%=jArr.getJSONObject(0)%>
</body>
</html>
