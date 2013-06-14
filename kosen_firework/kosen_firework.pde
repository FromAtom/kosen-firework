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

import ddf.minim.*;
import controlP5.*;
import java.util.*;

import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.net.URI;
import java.net.URISyntaxException;

String hoge = "http://www.processing.org/reference/images/loadImage_2";
PImage webImg = loadImage(hoge,"png");

int windowX = 1024;
int windowY = 760;

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
PImage topImage;

//花火用インスタンス
Fireworks fws;
Minim minim;
AudioPlayer lounchSound;
AudioPlayer bombSound;

//map処理用
HashMap<String,String> heldSiteMap = new HashMap<String,String>();
ArrayList<String[]> heldInfoList = new ArrayList<String[]>();
HashMap<String,float[]> lounchPointMap = new HashMap<String,float[]>();

MapRenderClass mapRender;

void setup(){
    size(windowX,windowY);
    smooth();
    frameRate(100);
    colorMode(HSB, 255);

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
        ACCESS_TOKEN        = accessToken.getToken();
        ACCESS_TOKEN_SECRET = accessToken.getTokenSecret();
        tfPIN.hide();
        startUserStream();
    }

    //花火周りのセットアップ
    minim = new Minim(this);
    fws = new Fireworks(minim);
    //for(int i = 0; i < 20; i++){
    fws.addNewFireworkTest(width/2.0, height/1.1);
    //}

    //マップ周りのセットアップ
    initHeldInfoList();
    initHeldSiteMap();
    initlounchPointMap();

    mapRender = new MapRenderClass();
    topImage = loadImage("topImage.png");
}

void draw(){
    background(0);
    textAlign(CENTER);

    if(startFlag){
    if(frameCount % 120 == 0)
        mapRender.nextHeldSite();

    if(frameCount % 30 == 0){
        int currentNum = mapRender.getCurrentHeldNumber();
        String[] currentHeldInfo = heldInfoList.get(currentNum);
        float[] lounchPoint = lounchPointMap.get(currentHeldInfo[3]);

        fws.addNewFireworkTest(lounchPoint[0], lounchPoint[1]);
    }

    fill(255);
    mapRender.update();
    fws.drawAndReflesh();
    }
    else{
      image(topImage,0,0);
    }
}

void keyPressed() {
  if (key == ' ') {
    frameCount = 0;
    startFlag = true;
  }
}

void initHeldInfoList(){
    heldInfoList.add(new String[]{"第一回 高専カンファレンス","#001tokyo","2008/6/14","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 北海道","#002hokkaido","2008/9/13","hokkaido"});
    heldInfoList.add(new String[]{"高専カンファレンス2008 Winter in 東京","#003tokyo","2008/12/6","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 福井","#004fukui","2009/2/28","fukui"});
    heldInfoList.add(new String[]{"東京 第3回 LT","#006tokyo","2009/4/4","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 九州","#005kyushu","2009/5/16","fukuoka"});
    heldInfoList.add(new String[]{"高専カンファレンス in 東北","#008tohoku","2009/8/29","hukushima"});
    heldInfoList.add(new String[]{"高専カンファレンス 2009秋 in 東京","#009tokyo","2009/11/7","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 長野","#011nagano","2009/12/19","nagano"});
    heldInfoList.add(new String[]{"高専カンファレンス in 八戸","#012hachinohe","2010/1/30","aomori"});
    heldInfoList.add(new String[]{"高専カンファレンス in サレジオ","#013salesio","2010/4/24","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 北海道2","#010hokkaido","2010/5/29","hokkaido"});
    heldInfoList.add(new String[]{"高専カンファレンス in 奈良","#015nara","2010/7/17","nara"});
    heldInfoList.add(new String[]{"高専カンファレンス in 石川","#017ishikawa","2010/8/7","ishikawa"});
    heldInfoList.add(new String[]{"高専女子カンファレンスin東京","#018joshi-tokyo","2010/9/25","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 九州～大分","#016oita","2010/9/25","oita"});
    heldInfoList.add(new String[]{"高専カンファレンス 2010秋 in 東京","#014tokyo","2010/10/2","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 京都","#019kyoto","2010/11/13","kyoto"});
    heldInfoList.add(new String[]{"高専カンファレンス in 沼津","#021numazu","2010/12/18","shizuoka"});
    heldInfoList.add(new String[]{"高専カンファレンス in 神戸","#022kobe","2011/1/8","hyogo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 四国","#023shikoku","2011/1/22","ehime"});
    heldInfoList.add(new String[]{"高専カンファレンス in 北東北","#024north-tohoku","2011/1/22","iwate"});
    heldInfoList.add(new String[]{"高専カンファレンス in 鉱泉","#025spa","2011/1/22","shizuoka"});
    heldInfoList.add(new String[]{"高専カンファレンス in サレジオ2","#020salesio","2011/2/12","tokyo"});
    heldInfoList.add(new String[]{"Hokuriku.rb x 高専カンファレンス","#027hokurikurb","2011/3/20","ishikawa"});
    heldInfoList.add(new String[]{"高専カンファレンス in 三重","#028mie","2011/3/26","mie"});
    heldInfoList.add(new String[]{"高専カンファレンス for careers","#033careers","2011/6/12","fukuoka"});
    heldInfoList.add(new String[]{"高専女子カンファレンス2","#030joshi-tokyo","2011/6/25","tokyo"});
    heldInfoList.add(new String[]{"Kosenconf.jp Hackathon","#","2011/7/9","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 長野2","#034nagano","2011/7/16","nagano"});
    heldInfoList.add(new String[]{"高専カンファレンス in 大阪","#026osaka","2011/8/27","osaka"});
    heldInfoList.add(new String[]{"高専カンファレンス in 松江","#037matsue","2011/9/24","shimane"});
    heldInfoList.add(new String[]{"高専カンファレンス in 小山","#039oyama","2011/9/25","tochigi"});
    heldInfoList.add(new String[]{"つくば理学カンファレンス","#031sciences","2011/10/8","ibaraki"});
    heldInfoList.add(new String[]{"高専カンファレンス in 仙台","#036sendai","2011/10/22","miyagi"});
    heldInfoList.add(new String[]{"高専カンファレンス in 茨城 ","#032ibaraki","2011/10/29","ibaraki"});
    heldInfoList.add(new String[]{"高専カンファレンス in 長岡 ","#035nagaoka","2011/11/5","niigata"});
    heldInfoList.add(new String[]{"高専女子カンファレンス3 in 石川","#040joshi-ishikawa","2011/11/12","ishikawa"});
    heldInfoList.add(new String[]{"高専ロボコニストカンファ","#041rbcn","2011/11/19","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 舞鶴","#044maizuru","2011/12/23","kyoto"});
    heldInfoList.add(new String[]{"新春・高専カンファレンス2012 in 東京","#038tokyo","2012/01/14,15","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 岐阜","#043gifu","2012/2/4","gifu"});
    heldInfoList.add(new String[]{"t-Cup Party","#047tokyo","2012/3/10","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 東京","#045tokyo","2012/4/14","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 奈良2","#054nara","2012/5/12","nara"});
    heldInfoList.add(new String[]{"高専カンファレンス in 東京 with Microsoft","#061tokyo","2012/6/16","tokyo"});
    heldInfoList.add(new String[]{"NSEG勉強会 feat. 高専カンファレンス","#053nseg","2012/6/23","nagano"});
    heldInfoList.add(new String[]{"高専カンファレンス in 岐阜 1.5","#058gifu","2012/7/21","gifu"});
    heldInfoList.add(new String[]{"高専カンファレンス in ものづくり名古屋","#046FCNagoya","2012/7/28","aichi"});
    heldInfoList.add(new String[]{"高専カンファレンス in 旭川","#048asahikawa","2012/8/11","hokkaido"});
    heldInfoList.add(new String[]{"高専カンファレンス in 大高専パーティー","#063kosenparty","2012/8/14","fukui"});
    heldInfoList.add(new String[]{"高専カンファレンス in 関西","#042kansai","2012/8/26","kyoto"});
    heldInfoList.add(new String[]{"高専カンファレンス in 松江2","#052matsue","2012/9/16","shimane"});
    heldInfoList.add(new String[]{"高専カンファレンス in 宇宙","#056space","2012/10/20","ibaraki"});
    heldInfoList.add(new String[]{"高専カンファレンス in 富山","#059toyama","2012/11/17","toyama"});
    heldInfoList.add(new String[]{"高専カンファレンス in 釧路","#062kushiro","2012/11/17","hokkaido"});
    heldInfoList.add(new String[]{"ロボコニストカンファレンス・リトライ","#064rbcn","2012/11/24","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 三重2","#060mie2","2012/12/22","mie"});
    heldInfoList.add(new String[]{"高専カンファレンス in 神戸2","#065kobe2","2013/1/12","hyogo"});
    heldInfoList.add(new String[]{"高専カンファレンス in 沼津2","#066numazu2","2013/1/19","shizuoka"});
    heldInfoList.add(new String[]{"高専カンファレンス in 名古屋","#050nagoya","2013/3/9","aichi"});
    heldInfoList.add(new String[]{"高専カンファレンス in 津山","#070tsuyama","2013/3/16","okayama"});
    heldInfoList.add(new String[]{"Rails寺子屋 x kosenconf","#068terakoya","2013/3/23","tokyo"});
    heldInfoList.add(new String[]{"高専カンファレンス5周年記念パーティ","#071kc5party","2013/6/15","tokyo"});
}

void initlounchPointMap(){
    lounchPointMap.put("aichi",new float[]{467,581});
    lounchPointMap.put("aomori",new float[]{754,411});
    lounchPointMap.put("ehime",new float[]{210,576});
    lounchPointMap.put("fukui",new float[]{438,535});
    lounchPointMap.put("fukuoka",new float[]{102,555});
    lounchPointMap.put("gifu",new float[]{475,552});
    lounchPointMap.put("hokkaido",new float[]{854,338});
    lounchPointMap.put("hukushima",new float[]{664,530});
    lounchPointMap.put("hyogo",new float[]{342,551});
    lounchPointMap.put("ibaraki",new float[]{644,570});
    lounchPointMap.put("ishikawa",new float[]{463,526});
    lounchPointMap.put("iwate",new float[]{751,463});
    lounchPointMap.put("kyoto",new float[]{384,554});
    lounchPointMap.put("mie",new float[]{415,594});
    lounchPointMap.put("nagano",new float[]{535,540});
    lounchPointMap.put("nara",new float[]{389,588});
    lounchPointMap.put("niigata",new float[]{595,510});
    lounchPointMap.put("oita",new float[]{130,580});
    lounchPointMap.put("osaka",new float[]{377,576});
    lounchPointMap.put("shimane",new float[]{253,524});
    lounchPointMap.put("shizuoka",new float[]{503,596});
    lounchPointMap.put("tochigi",new float[]{622,550});
    lounchPointMap.put("tokyo",new float[]{586,583});
    lounchPointMap.put("tottori",new float[]{322,531});
    lounchPointMap.put("toyama",new float[]{499,521});
    lounchPointMap.put("miyagi",new float[]{706,492});
    lounchPointMap.put("okayama",new float[]{292,546});
}

void initHeldSiteMap(){
    heldSiteMap.put("aichi", "aichi.png");
    heldSiteMap.put("aomori", "aomori.png");
    heldSiteMap.put("ehime", "ehime.png");
    heldSiteMap.put("fukui", "fukui.png");
    heldSiteMap.put("fukuoka", "fukuoka.png");
    heldSiteMap.put("gifu", "gifu.png");
    heldSiteMap.put("hokkaido", "hokkaido.png");
    heldSiteMap.put("hukushima", "hukushima.png");
    heldSiteMap.put("hyogo", "hyogo.png");
    heldSiteMap.put("ibaraki", "ibaraki.png");
    heldSiteMap.put("ishikawa", "ishikawa.png");
    heldSiteMap.put("iwate", "iwate.png");
    heldSiteMap.put("kyoto", "kyoto.png");
    heldSiteMap.put("mie", "mie.png");
    heldSiteMap.put("nagano", "nagano.png");
    heldSiteMap.put("nara", "nara.png");
    heldSiteMap.put("niigata", "niigata.png");
    heldSiteMap.put("oita", "oita.png");
    heldSiteMap.put("okayama", "okayama.png");
    heldSiteMap.put("miyagi", "miyagi.png");
    heldSiteMap.put("osaka", "osaka.png");
    heldSiteMap.put("shimane", "shimane.png");
    heldSiteMap.put("shizuoka", "shizuoka.png");
    heldSiteMap.put("tochigi", "tochigi.png");
    heldSiteMap.put("tokyo", "tokyo.png");
    heldSiteMap.put("tottori", "tottori.png");
    heldSiteMap.put("toyama", "toyama.png");
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
        //System.out.println(tweetedAt.get(Calendar.HOUR_OF_DAY) + " | " +status.getUser().getName() + " : " + status.getText());

        int currentNum = mapRender.getCurrentHeldNumber();
        String[] currentHeldInfo = heldInfoList.get(currentNum);
        float[] lounchPoint = lounchPointMap.get(currentHeldInfo[3]);

        fws.addNewFirework(lounchPoint[0], lounchPoint[1],webImg);
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
