package sample;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.FileChooser;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.io.*;
import java.net.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class GitHubAnalyzerGUI extends Application {

    public class CommitThread extends  Thread{
        public void run(){
            data.clear();
            for(DataEntry i: tv.getItems()){
                if(validUrl(i.getUrl())){
                    data.add(readCommits(i.getUrl()));
                }
            }
            tv.setItems(FXCollections.observableArrayList(data));

        }
    }

    public class DataEntry {

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

    public List<String> fileToList(String fileName) {
        List<String> urls = new ArrayList<String>();
        File file = new File(fileName);
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

    private DataEntry readCommits(String urlstr){
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
               Alert alerta = new Alert(Alert.AlertType.WARNING);
               alerta.setContentText("Malformed Url");
               alerta.showAndWait();
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
                System.out.println("Response code: " + con.getResponseCode());
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

    private boolean validUrl(String url){
        if(url.contains("https://api.github.com/repo")){
            return true;
        }

        return  false;
    }

    private String mostCommits(){
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

    private String fewerCommits(){
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

    private String recentCommit() throws ParseException {
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

    private String oldestCommit() throws ParseException {
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

    private void informacoesGerais(Stage primaryStage){
        VBox secondaryLayout = new VBox();
        ListView lv = new ListView();
        try {
            lv.setItems(FXCollections.observableArrayList("Maior numero de commits: "+mostCommits(),"Menor número commits: "+fewerCommits(),
                    "Commit mais recente: "+recentCommit(),"Commit mais antigo: "+oldestCommit()));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        secondaryLayout.getChildren().add(lv);
        Scene secondScene = new Scene(secondaryLayout, 400, 400);

        // New window (Stage)
        Stage newWindow = new Stage();
        newWindow.setTitle("Gerais");
        newWindow.setScene(secondScene);
        newWindow.initModality(Modality.WINDOW_MODAL);


        // Set position of second window, related to primary window.
        newWindow.setX(primaryStage.getX() + 200);
        newWindow.setY(primaryStage.getY() + 100);

        newWindow.show();
    }

    private final List<DataEntry> data = new ArrayList<>();
    private final TableView<DataEntry> tv = new TableView();

    @Override
    public void start(final Stage primaryStage) throws IOException {
        VBox layout = new VBox(5);

        HBox hbox1 = new HBox(5);
        MenuBar menuB = new MenuBar();
        Menu file = new Menu("File");
        MenuItem open = new MenuItem("Open");
        MenuItem exit = new MenuItem("Exit");
        file.getItems().addAll(open, exit);

        Menu help = new Menu("Help");
        MenuItem about = new MenuItem("About");
        help.getItems().add(about);

        Menu tools = new Menu("Tools");
        MenuItem commitAnalyzer = new MenuItem("Commit Analyzer");
        tools.getItems().add(commitAnalyzer);


        final Label info = new Label("Aluno: Henrique Becker Brum\nPrograma: RandomPickerGUI");
        info.setVisible(false);

        Button gerais = new Button("Gerais");
        gerais.setDisable(true);

        TableColumn colUrl = new TableColumn("URL");
        TableColumn colNumCommit = new TableColumn("Qnt. Commits");
        TableColumn colTamMesg = new TableColumn("Tam. Médio Mensagem");

        colUrl.setMinWidth(250);
        colUrl.setCellValueFactory(new PropertyValueFactory<>("url"));
        colNumCommit.setCellValueFactory(new PropertyValueFactory<>("numCommit"));
        colTamMesg.setCellValueFactory(new PropertyValueFactory<>("tamMedioMesg"));


        tv.getColumns().addAll(colUrl, colNumCommit, colTamMesg);

        HBox hbox2 = new HBox(5);
        hbox2.getChildren().addAll(gerais);


        exit.setOnAction(event -> primaryStage.close());

        about.setOnAction(event -> {
            info.setVisible(!info.isVisible());
        });

        open.setOnAction(event -> {
            FileChooser fileChooser = new FileChooser();
            fileChooser.setTitle("Open File");
            fileChooser.setInitialDirectory(new File("."));
            File file1 = fileChooser.showOpenDialog(primaryStage);

            if (file1 != null) {
                List<String> fileContent = fileToList(file1.getAbsolutePath());
                for (String s : fileContent) {
                    data.add(new DataEntry(s, "-", "-","-","-"));
                }
                tv.getItems().addAll(FXCollections.observableArrayList(data));
            }else{
                Alert alerta = new Alert(Alert.AlertType.WARNING);
                alerta.setContentText("File doesn't exist");
                alerta.showAndWait();
            }
        });

        commitAnalyzer.setOnAction(event -> {
            try {
                URL url = new URL("https://www.wikipedia.org/");
                URLConnection connection = url.openConnection();
                connection.connect();
                if(!data.isEmpty()) {
                    CommitThread commitThread = new CommitThread();
                    commitThread.start();
                    gerais.setDisable(false);
                }
            }
            catch (Exception e) {
                Alert alerta = new Alert(Alert.AlertType.WARNING);
                alerta.setContentText("Internet not connected");
                alerta.showAndWait();
            }
        });

        gerais.setOnAction(event ->{
            informacoesGerais(primaryStage);
        });

        menuB.getMenus().addAll(file, tools, help);
        hbox1.getChildren().addAll(menuB, info);
        layout.getChildren().addAll(hbox1, tv, hbox2);
        primaryStage.setTitle("Hello World");
        primaryStage.setScene(new Scene(layout, 500, 550));
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}
