/*DB접속을 하는 클래스 생성 ConnecDB클래스는 공통 클래스로 AsyncTask를 상속받아 구현하고 있다.*/
public class ConnecLogin extends ConnecDB {
  private final String postURL="웹서버 URL주소 입력";
  JSONObject json;
  String getJsonData;
  String s =null;
  public ConnecLogin(){
    super.setPostURL(postURL);
  }
  protected void parsing(String page) {
    getJsonData=page;
  }
  //doInBackground에서 전달한 JSONArray를 String으로 바꿔주는 메소드public void getData(JSONArray userJson){
  try {
    JSONObject json = null;
    json = userJson.getJSONObject(0);
    s=json.getString("msg1");
  } catch (JSONException e) {
    e.printStackTrace();
  }
  }/*서브 스레드는 UI에 접근을 못하게 막아 놓았기에 스레드를 통해 작업한 데이터는 핸들러를 통해 UI에 접근 해야 한다. 해당 부분은 AsyncTask의 핸들러 부분으로 doInBackground(AsyncTask의 스레드 역할)의 리턴값을 받아야 UI에 접근을 한다. 해당 소스는 로그인 성공 페이지 이동 실패시 오류메세지를 토스트메세지로 띄우게 설정하였다, */@Overridepublic void onPostExecute(JSONArray jsonArray) {
  //ID를 저장할 파일의 이름을 설정한다.String sfName = "myFile";


  //위에 선언한 메소드를 통해 데이터(JSONArray)를 String으로 변화시킨다.getData(jsonArray);

  //받아온 데이터를 화면에 토스트 형태로 띄워준다.Toast.makeText(getApplicationContext(), s, Toast.LENGTH_SHORT).show();
  switch (s){
    case "success":
      Toast.makeText(getApplicationContext(), "로그인성공", Toast.LENGTH_SHORT).show();
      //id를 모든 Activity에서 사용하기 위해 SharedPreferences에 저장하는 작업SharedPreferences sf = getSharedPreferences(sfName, 0);
      SharedPreferences.Editor editor = sf.edit();
      //저장하려면editor가필요String str = editID.getText().toString();
      editor.putString("name", str);
       // 입력editor.putString("xx", "xx");
       // 입력editor.commit();
       // 파일에최종반영함

      //페이지를 이동하는 부분Intent intent = new Intent(getApplicationContext(), AirCleanerMain.class);
      startActivity(intent);
    finish();
      break;
    case "noId":
      Toast.makeText(getApplicationContext(),"아이디가없습니다.",Toast.LENGTH_SHORT).show();
      break;
    case "noPw":
      Toast.makeText(getApplicationContext(),"패스워드가틀렸습니다.",Toast.LENGTH_SHORT).show();
      break;
    default:
      Toast.makeText(getApplicationContext(),"서버연결실패",Toast.LENGTH_SHORT).show();
      break;
  }super.onPostExecute(jsonArray);
  }
}//class End}
