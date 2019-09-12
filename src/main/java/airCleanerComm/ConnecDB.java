// 공통모듈

package kr.or.hanium.aircleaner.connecDB;

import android.os.AsyncTask;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.NameValuePair;
import cz.msebera.android.httpclient.client.HttpClient;
import cz.msebera.android.httpclient.client.entity.UrlEncodedFormEntity;
import cz.msebera.android.httpclient.client.methods.HttpPost;
import cz.msebera.android.httpclient.impl.client.DefaultHttpClient;
import cz.msebera.android.httpclient.message.BasicNameValuePair;
import cz.msebera.android.httpclient.protocol.HTTP;

/*** Created by son on 2016-08-08.*/
public class ConnecDB extends AsyncTask<Void,String,JSONArray> {
  String data;
  String page = "";
  String postURL;
  HttpResponse response;
  ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();

  //데이터를 받는 메소드 key/value 형태로 데이터를 받아와 ArrayList에 집어넣어 준다.
  public void setSendData(String... param){
    String msgId,msgValue;
    
    for(int i =0;i<param.length;i++){
      msgId=param[i];
      i++;
      
      msgValue=param[i];
      params.add(new BasicNameValuePair(msgId,msgValue));
     }
   }
   
   public void setPostURL(String postURL1){
    postURL=postURL1;
   }

  //스레드 역할을 하는 부분으로 실질적인 웹통신을 통한 DB에 접근하는 부분이다.
  @Overrideprotected 
  JSONArray doInBackground(Void... param) {
  // TODO Auto-generated method stub
  JSONArray jArr =null;
  
  try{
    //Http통신을 위한 client 객체 생성
    HttpClient client = new DefaultHttpClient();
    //웹통신 방법을 post방식으로 보낸다고 설정 데이터를 보낼 URL를 전달값으로 집어 넣어준다.
    HttpPost post = new HttpPost(postURL);
    //전달 하려는 값을 집어넣어 준다. 전달값을 UTF_8로 인코딩해서 보낸다
    post.setEntity(new UrlEncodedFormEntity(params, HTTP.UTF_8));
    /*데이터와 전달하려는 주소를 가지고 있는 post를 clitent에 집어넣어 실행시킨다. 
    웹은 요청(request)과 동시에 응답(response)을 해주기에 요청에 대한 데이터를 즉각적으로 받아온다.*/
    response = client.execute(post);
    //받은 데이터를 String형태로 만들기 위한 작업
    BufferedReader bufreader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "utf-8"));
    String line = null;page = "";
    // 버퍼의웹문서소스를줄단위로읽어(line), page에저장함
    while ((line = bufreader.readLine()) != null) {
      page += line;
    }
    // 읽어들인내용을json 객체에담아그중dataSend로정의된내용을
    // 불어온다. 그럼json 중원하는내용을하나의json 배열에담게된다.
    // 읽어온 String은 JSON형태로 되어 있기에 JSONObject에 받아온 String을 넣어준다.
    JSONObject json = new JSONObject(page);
    //JSON에서 List(웹서버에서 지정해준 이름)라고 정의된 값을 가져온다.
    jArr = json.getJSONArray("List");
   } catch (Exception e) {
    e.printStackTrace();
   }
   //받은 JSONArray를 UI접근을 하는 메소드 onPostExecute로 리턴시켜준다
   return jArr;
  }
  
  @Overridepublic void onPostExecute(JSONArray userJson) {
    super.onPostExecute(userJson);
  }
}
