import java.net.*;
import java.io.IOException;

public class DemoPost {

  public static void main(String[] args) throws IOException {

    String urlstr = "https://script.google.com/a/inf.ufsm.br/macros/s/AKfycbwKrcRHm08L9bIxBIATDI65zWj7tb244VOq4kcPog/exec?";
    URL url = new URL(urlstr);
    HttpURLConnection con = (HttpURLConnection) url.openConnection();
    System.out.println("" + con.getClass());
    con.setRequestMethod("POST");
    con.setDoOutput(true);

    String data = "luckynumber=(100!)^100&nccid=hbbrum&msg=O que o pagodeiro foi fazer na igreja?\nCantar pa god :)";
    con.getOutputStream().write(data.getBytes("UTF-8"));

    System.out.println("Response code: " + con.getResponseCode());
  }

}
