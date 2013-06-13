import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;

import controlP5.*;
import java.util.List;
import java.util.Date;
import java.util.Calendar;
import java.util.Properties;

import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.net.URI;
import java.net.URISyntaxException;

String hoge = "http://www.processing.org/reference/images/loadImage_2";
PImage webImg = loadImage(hoge,"png");

int windowX = 800;
int windowY = 600;

ControlP5 controlP5;
Textfield tfPIN;

RequestToken  requestToken;
AccessToken   accessToken;
Twitter       twitter;
TwitterStream twitterStream;

String CONSUMER_KEY        = null;
String CONSUMER_SECRET     = null;
String ACCESS_TOKEN        = null;
String ACCESS_TOKEN_SECRET = null;

String filename = null;
String name     = "user";

boolean startFlag = false;

void setup(){
    size(windowX,windowY);
    smooth();
    frameRate(30);

    //GUI系のセットアップ
    controlP5 = new ControlP5(this);
    tfPIN     = controlP5.addTextfield("PIN", windowX/2-105, windowY/2+40, 200, 20);
    tfPIN.setFocus(true);

    //Twitter周りのセットアップ
    loadKeys();
    TwitterFactory factory = new TwitterFactory();
    twitter = factory.getInstance();
    twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);

    try {
        requestToken = twitter.getOAuthRequestToken();
        accessToken  = null;
    }
    catch (TwitterException e) {
        e.printStackTrace();
    }

    if((accessToken = loadAccessToken(name)) == null){
        //ブラウザにURLを投げつけて開かせる
        try {
            throwURL(requestToken.getAuthorizationURL());
        } catch (URISyntaxException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    else{
        startFlag           = true;
        ACCESS_TOKEN        = accessToken.getToken();
        ACCESS_TOKEN_SECRET = accessToken.getTokenSecret();
        tfPIN.hide();
        startUserStream();
    }
}

void draw(){
    background(0);
    textAlign(CENTER);
    text("Kosen Firework", windowX/2, windowY/2);
    
    image(webImg, 10, 10);
}

//コンシューマキーとコンシューマシークレットを読み込み
void loadKeys() {
    String lines[]  = loadStrings("twitter4j.properties");
    CONSUMER_KEY    = lines[0];
    CONSUMER_SECRET = lines[1];
}

//アクセストークンを呼び出す
AccessToken loadAccessToken(String name) {
    File f = createAccessTokenFileName(name);

    ObjectInputStream is = null;

    try {
        is                         = new ObjectInputStream(new FileInputStream(f));
        AccessToken accessTokenBuf = (AccessToken) is.readObject();
        return accessTokenBuf;
    }
    catch (IOException e) {
        return null;            //ファイルが読めない（存在しない）場合はnullを返す
    }
    catch (Exception e) {
        e.printStackTrace();
        return null;
    }
    finally {
        if (is != null) {
            try {
                is.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

// アクセストークンを保存するファイル名を生成する
// nameで振り分ければ複数アカウント対応可
static File createAccessTokenFileName(String name) {
    String s = "~/userdata/accessToken.dat";
    return new File(s);
}

//アクセストークンをファイルに保存する
void storeAccessToken(AccessToken accessToken) {
    File f = createAccessTokenFileName(name);
    File d = f.getParentFile();

    if (!d.exists()) {
        d.mkdirs();
    }

    ObjectOutputStream os = null;

    try {
        os = new ObjectOutputStream(new FileOutputStream(f));
        os.writeObject(accessToken);
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if (os != null) {
            try { os.close(); } catch (IOException e) { e.printStackTrace(); }
        }
    }
}

//アクセストークンファイルをリセットする
void resetAccessToken(){
    BufferedReader br   = new BufferedReader(new InputStreamReader(System.in));
    System.out.print("Do you want to delete your AccessToken? [Y/N] ->");
    String         text = null;
    try {
        text            = br.readLine();
    }
    catch (IOException e) {
        e.printStackTrace();
    }
    if((text.equals("Y"))||(text.equals("y"))){
        File resetfile = createAccessTokenFileName(filename);
        resetfile.delete();
        System.out.print("Your Access Token was deleted.");
    }
}

//ブラウザにURLを投げつけるメソッド
private static void throwURL(String url) throws URISyntaxException, IOException {
    Desktop desktop = Desktop.getDesktop();
    desktop.browse(new URI(url));
}

//PIN入力取得
public void PIN(String pin) {
    if(pin.trim().length() < 1)
        return;

    try{
        if(pin.trim().length() > 0){
            accessToken         = twitter.getOAuthAccessToken(requestToken, pin);
            ACCESS_TOKEN        = accessToken.getToken();
            ACCESS_TOKEN_SECRET = accessToken.getTokenSecret();

            storeAccessToken(accessToken);

            startFlag   = true;
            tfPIN.hide();
            startUserStream();
        }else{
            accessToken = null;
        }
    } catch (TwitterException te) {
        if(401 == te.getStatusCode()){
            System.out.println("Unable to get the access token.");
        }else{
            te.printStackTrace();
        }

        //ブラウザにURLを投げつけて開かせる
        try {
            throwURL(requestToken.getAuthorizationURL());
        } catch (URISyntaxException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}

// イベントを受け取るリスナーオブジェクト
class MyStreamAdapter extends UserStreamAdapter {
    Date     date;
    Calendar tweetedAt = Calendar.getInstance();
    Calendar favorited;
    Calendar retweeted;

    // ステータス更新のハンドラ
    @Override
        public void onStatus(Status status) {
        super .onStatus(status);

        // ステータスを受け取って何かをする
        date = status.getCreatedAt();

        //System.out.println("URL : " + status.getUser().getBiggerProfileImageURL());
        String url = status.getUser().getBiggerProfileImageURL();
        webImg = loadImage(url);
        System.out.println(tweetedAt.get(Calendar.HOUR_OF_DAY) + " | " +status.getUser().getName() + " : " + status.getText());
    }
}

// User Stream APIを開始する
private void startUserStream() {
    // Configureationを生成するためのビルダーオブジェクトを生成
    ConfigurationBuilder builder = new ConfigurationBuilder();

    // コンシューマーキーとアクセスキーを設定
    builder.setOAuthConsumerKey( CONSUMER_KEY );
    builder.setOAuthConsumerSecret( CONSUMER_SECRET );
    builder.setOAuthAccessToken( ACCESS_TOKEN );
    builder.setOAuthAccessTokenSecret( ACCESS_TOKEN_SECRET );

    // 現行のTwitter4JではAPIのデフォルト呼び先がbetastream.twitter.comになっているので修正
    //builder.setUserStreamBaseURL( "https://userstream.twitter.com/2/" );

    // Configurationを生成
    Configuration conf = builder.build();

    // TwitterStreamを生成
    TwitterStreamFactory Streamfactory = new TwitterStreamFactory(conf);
    twitterStream                      = Streamfactory.getInstance();

    // イベントを受け取るリスナーオブジェクトを設定
    twitterStream.addListener(new MyStreamAdapter());
    
    //フィルターを追加
    FilterQuery filterQuery = new FilterQuery();
    // 検索する文字列を設定します。 複数設定することも出来て、配列で渡します
    filterQuery.track(new String[] {"#kosenconf"});
    // フィルターをつけてStreamを開始
    twitterStream.filter(filterQuery);

    // User Streamの取得をスタート
    //twitterStream.user();
    println("stream start!!!");
}
