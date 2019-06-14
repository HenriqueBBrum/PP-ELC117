package sample;

import java.util.*;
import java.net.*;
import java.io.*;


public class Common {

    private String formatNamesList(List<String> names){
        String data = "list=";
        int i;
        for(i = 0; i<names.size()-1;i++){
            data+=names.get(i)+"%0D%0A";
        }
        data+=names.get(i)+"&format=plain&rnd=new";

        return data;
    }

    public List<String> fileToList(String fileName){
        List<String> names = new ArrayList<String>();
        File file = new File(fileName);
        BufferedReader reader = null;

        try {
            reader = new BufferedReader(new FileReader(file));
            String text = null;

            while ((text = reader.readLine()) != null) {
                names.add(text);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
            }
        }
        return names;
    }

    public void shuffle(List<String> names){

        if(!onlineShuffle(names)){
            offlineShuffle(names);
        }else {
            if(names.size()%2==0)
                offlineShuffle(names);
            else if(names.size()%2==0)
                onlineShuffle(names);
        }

    }

    public boolean onlineShuffle(List<String> names){

        try {
            String urlstr = "https://www.random.org/lists/?mode=advanced";
            URL url = new URL(urlstr);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("User-Agent", "Mozilla/5.0");
            con.setDoOutput(true);
            try {
                con.connect();
                System.out.println("Connection Successful");
            }
            catch (Exception e) {
                System.out.println("Internet Not Connected");
                return false;
            }

            String data = formatNamesList(names);

            // Envia dados pela conexão aberta
            con.getOutputStream().write(data.getBytes("UTF-8"));
            System.out.println("Response code: " + con.getResponseCode());

            if(con.getResponseCode()!=200)
                return false;



            // Cria objeto que fará leitura da resposta pela conexão aberta
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()));

            // Lê resposta, linha por linha
            String responseLine;
            names.clear();
            while ((responseLine = in.readLine()) != null) {
                names.add(responseLine);
            }

            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }


    public void offlineShuffle(List<String> names){
        Collections.shuffle(names,new Random(new Date().getTime()));
    }
}
