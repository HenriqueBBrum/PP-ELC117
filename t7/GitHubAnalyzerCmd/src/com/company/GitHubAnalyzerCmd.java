package com.company;

import java.io.*;
import java.net.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Scanner;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

public class GitHubAnalyzerCmd {

    private static List<DataEntry> data =  new ArrayList<DataEntry>();

    public static class DataEntry {

        private String url;
        private String numCommit;
        private String tamMedioMesg;
        private String firstDate;
        private String lastDate;

        DataEntry(String url, String numCommit, String tamMedioMesg, String firstDate, String lastDate) {
            this.url = url;
            this.numCommit = numCommit;
            this.tamMedioMesg = tamMedioMesg;
            this.firstDate = firstDate;
            this.lastDate = lastDate;
        }

        public String getNumCommit() {
            return numCommit;
        }

        public void setNumCommit(String numCommit) {
            this.numCommit = numCommit;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public String getTamMedioMesg() {
            return tamMedioMesg;
        }

        public void setTamMedioMesg(String tamMedioMesg) {
            this.tamMedioMesg = tamMedioMesg;
        }

        public String getFirstDate() {
            return firstDate;
        }

        public void setFirstDate(String firstDate) {
            this.firstDate = firstDate;
        }

        public String getLastDate() {
            return lastDate;
        }

        public void setLastDate(String lastDate) {
            this.lastDate = lastDate;
        }
    }

    public static List<String> fileToList(String fileName) {
        List<String> urls = new ArrayList<String>();
        File file = new File(fileName);
        if(!file.exists()){
            System.out.println("Arquivo não existe");
            return null;
        }
        BufferedReader reader = null;

        try {
            reader = new BufferedReader(new FileReader(file));
            String text = null;

            while ((text = reader.readLine()) != null) {
                urls.add(text);
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
        return urls;
    }

    private static DataEntry readCommits(String urlstr){
        int page = 1;
        int mesgSize = 0;
        int size = 0;
        String firstDate = null;
        String lastDate = null;
        boolean temCommit = true;
        String auxStr = urlstr;
        do{
            URL url = null;
            try {
                url = new URL(auxStr);
            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
            HttpURLConnection con = null;
            try {
                con = (HttpURLConnection) url.openConnection();
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                con.setRequestMethod("GET");
            } catch (ProtocolException e) {
                e.printStackTrace();
            }
            con.setRequestProperty("User-Agent", "Mozilla/5.0");
            try {
                System.out.println("Response code" + con.getResponseCode());
            } catch (IOException e) {
                e.printStackTrace();
            }

            BufferedReader in = null;
            try {
                in = new BufferedReader(
                        new InputStreamReader(con.getInputStream()));
            } catch (IOException e) {
                e.printStackTrace();
            }


            // Response header (includes pagination links)

            // Parse a nested JSON response using Gson
            JsonParser parser = new JsonParser();
            JsonArray results = null;
            try {
                results = parser.parse(in.readLine()).getAsJsonArray();
            } catch (IOException e) {
                e.printStackTrace();
            }


            size+=  results.size();
            if(results.size()<30){
                temCommit = false;
            }

            for (JsonElement e : results) {
                if(mesgSize==0){
                    firstDate = e.getAsJsonObject().get("commit").getAsJsonObject().get("author").getAsJsonObject().get("date").getAsString();
                }
                lastDate = e.getAsJsonObject().get("commit").getAsJsonObject().get("author").getAsJsonObject().get("date").getAsString();
                mesgSize+= e.getAsJsonObject().get("commit").getAsJsonObject().get("message").getAsString().length();
            }
            mesgSize/=size;


            auxStr = urlstr+"?page"+Integer.toString(page);
            page++;
            try {
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }while(temCommit);

        DataEntry dataEntry =  new DataEntry(urlstr,Integer.toString(size), Integer.toString(mesgSize), firstDate, lastDate );

        return  dataEntry;
    }

    private static boolean validUrl(String url){
        if(url.contains("https://api.github.com/repo")){
            return true;
        }

        return  false;
    }

    private static String mostCommits(){
        int maior = Integer.parseInt(data.get(0).getNumCommit());
        String url = data.get(0).getUrl();
        for(DataEntry i: data){
            if(Integer.parseInt(i.getNumCommit())>maior){
                maior  = Integer.parseInt(i.getNumCommit());
                url = i.getUrl();
            }
        }

        return url;
    }

    private static String fewerCommits(){
        int menor = Integer.parseInt(data.get(0).getNumCommit());
        String url = data.get(0).getUrl();
        for(DataEntry i: data){
            if(Integer.parseInt(i.getNumCommit())<menor){
                menor  = Integer.parseInt(i.getNumCommit());
                url = i.getUrl();
            }
        }

        return url;
    }

    private static String recentCommit() throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date recentDate = sdf.parse(data.get(0).getFirstDate().split("T")[0]);
        String url = data.get(0).getUrl();
        for(DataEntry i : data){
            Date auxDate = sdf.parse(i.getFirstDate().split("T")[0]);
            if(auxDate.after(recentDate)){
                recentDate = auxDate;
                url = i.getUrl();
            }

        }

        return url;
    }

    private static String oldestCommit() throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date oldestDate = sdf.parse(data.get(0).getFirstDate().split("T")[0]);
        String url = data.get(0).getUrl();
        for(DataEntry i : data){
            Date auxDate = sdf.parse(i.getFirstDate().split("T")[0]);
            if(auxDate.before(oldestDate)){
                oldestDate = auxDate;
                url = i.getUrl();
            }

        }

        return url;
    }


    public static void main(String[] args){
        Scanner sc =  new Scanner(System.in);
        System.out.println("Digite o nome do seu arquivo");
        String fileName = sc.nextLine();
        List<String> list  =  fileToList(fileName);
        if(list==null || list.isEmpty()){
            return ;
        }
        for (String s : list) {
            data.add(new DataEntry(s, "-", "-","-","-"));
        }
        List<DataEntry> dataAux = new ArrayList<DataEntry>(data);
        data.clear();
        try {
            URL url = new URL("https://www.wikipedia.org/");
            URLConnection connection = url.openConnection();
            connection.connect();
            for(DataEntry i: dataAux){
                if(validUrl(i.getUrl())){
                    data.add(readCommits(i.getUrl()));
                }

            }
            for(DataEntry i: data){
                System.out.println("URl: "+i.getUrl()+ " Num commits: "+i.getNumCommit()+" Tam medio mesg: "+i.getTamMedioMesg());
            }
            try {
                System.out.println("\nMaior numero de commits: "+mostCommits()+"\nMenor número commits: "+fewerCommits()+
                        "\nCommit mais recente: "+recentCommit()+"\nCommit mais antigo: "+oldestCommit());
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        catch (Exception e) {
            System.out.println("Sem internet");
        }


    }
}


