package sample;

import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.transformation.FilteredList;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.scene.Scene;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;


public class EnadeUFSMExplorer extends Application {

    private static final String defaultURL1 =  "https://docs.google.com/spreadsheets/d/e/2PACX-1vTO0" +
            "6Jdr3J1kPYoTPRkdUaq8XuslvSD5--FPMht-ilVBT1gExJXDPTiX0P3FsrxV5VKUZJrIUtH1wvN/pub?gid=0&single=true&output=csv";
    private static final String defaultURL2 = "https://docs.google.com/spreadsheets/d/e/2PACX-1vTO06Jdr3J1kPYoTPRkdUaq8Xu" +
            "slvSD5--FPMht-ilVBT1gExJXDPTiX0P3FsrxV5VKUZJrIUtH1wvN/pub?gid=1285855524&single=true&output=csv";

    public class DataEntry {
        private String ano;
        private String prova;
        private String tipoQuestao;
        private String idQuestao;
        private String objeto;
        private String gabarito;
        private String acertosCurso;
        private String acertosRegiao;
        private String acertosBrasil;
        private String dif;
        private String imageUrl;

        public DataEntry(String ano, String prova, String tipoQuestao, String idQuestao, String objeto,String gabarito, String acertosCurso,
                  String acertosRegiao, String acertosBrasil, String dif, String imageUrl){

            this.ano =  ano;
            this.prova = prova;
            this.tipoQuestao = tipoQuestao;
            this.idQuestao = idQuestao;
            this.objeto = objeto;
            this.gabarito =  gabarito;
            this.acertosCurso = acertosCurso;
            this.acertosRegiao = acertosRegiao;
            this.acertosBrasil =  acertosBrasil;
            this.dif = dif;
            this.imageUrl = imageUrl;
        }


         public String getAcertosCurso() {
             return acertosCurso;
         }

         public void setAcertosCurso(String acertosCurso) {
             this.acertosCurso = acertosCurso;
         }

         public String getAno() {
             return ano;
         }

         public void setAno(String ano) {
             this.ano = ano;
         }

         public String getProva() {
             return prova;
         }

         public void setProva(String prova) {
             this.prova = prova;
         }

         public String getTipoQuestao() {
             return tipoQuestao;
         }

         public void setTipoQuestao(String tipoQuestao) {
             this.tipoQuestao = tipoQuestao;
         }

         public String getIdQuestao() {
             return idQuestao;
         }

         public void setIdQuestao(String idQuestao) {
             this.idQuestao = idQuestao;
         }

         public String getObjeto() {
             return objeto;
         }

         public void setObjeto(String objeto) {
             this.objeto = objeto;
         }

         public String getAcertosRegiao() {
             return acertosRegiao;
         }

        public void setAcertosRegiao(String acertosRegiao) {
            this.acertosRegiao = acertosRegiao;
        }

         public String getAcertosBrasil() {
             return acertosBrasil;
         }

         public void setAcertosBrasil(String acertosBrasil) {
             this.acertosBrasil = acertosBrasil;
         }

         public String getDif() {
             return dif;
         }

         public void setDif(String dif) {
             this.dif = dif;
         }

        public String getGabarito() {
            return gabarito;
        }

        public void setGabarito(String gabarito) {
            this.gabarito = gabarito;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }
    }

    public List<String> parseLine(String line) {

        List<String> result = new ArrayList<>();
        char separador = ',';
        char aspas = '"';

        if (line == null && line.isEmpty()) {
            return result;
        }


        StringBuffer stringBuffer = new StringBuffer();
        boolean entreAspas = false;
        boolean pegarChars = false;

        char[] chars = line.toCharArray();

        for (char ch : chars) {

            if (entreAspas) {
                pegarChars = true;
                if (ch == aspas) {
                    entreAspas = false;
                } else {

                    stringBuffer.append(ch);

                }
            } else {
                if (ch == aspas) {
                    entreAspas = true;

                    if (pegarChars) {
                        stringBuffer.append('"');
                    }

                } else if (ch == separador) {

                    result.add(stringBuffer.toString());

                    stringBuffer = new StringBuffer();
                    pegarChars = false;

                } else if (ch == '\r') {
                    continue;
                } else if (ch == '\n') {
                    break;
                } else {
                    stringBuffer.append(ch);
                }
            }

        }

        result.add(stringBuffer.toString());

        return result;
    }

    private String getCurso(File f){
        String curso ="";
        try (Scanner sc = new Scanner(new FileReader(f))) {
            if(sc.hasNextLine()){
                String fields = sc.nextLine();
            }

            if(sc.hasNextLine()){
                String aux[] = sc.nextLine().split(",");
                curso =  aux[0];
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return curso;
    }

    private void readFromCsvFile(File f, List<DataEntry> data, Label label){
         String line = "";
         try (Scanner sc = new Scanner(new FileReader(f))) {
             //Exclui a primeira linha
            if(sc.hasNextLine()) {
                String fields = sc.nextLine();
            }
            String curso = getCurso(f);
            label.setText("  Curso: "+curso+"  ");

            boolean achou = false;

            //Junta as linhas sabendo que cada linha valida deve começar com a sigla do curso
            while ((sc.hasNextLine())) {
                //if -> Linha tem sigla do curso
                //else -> junta linha inválida com a linha anterior
                if(sc.findWithinHorizon(curso, 3)!=null){
                    //if -> primeira linha ou já formou uma linha válida
                    //else if -> achou outra linha que comecem com CC
                    if(!achou && line.isEmpty()){
                        line =sc.nextLine();
                    }else if(!achou && !line.isEmpty()){
                        achou = true;
                    }
                }else{
                    line+=sc.nextLine();
                }

                //Quando achou uma nova linha com a sigla do curso
                if(achou){
                    achou=false;
                    line = curso+ line;
                    List<String> linha;
                    linha = parseLine(line);
                    //System.out.println(line);
                    line="";
                    data.add(new DataEntry(linha.get(1), linha.get(2), linha.get(3), linha.get(4), linha.get(5)
                            ,linha.get(7), linha.get(8), linha.get(9), linha.get(10), linha.get(11), linha.get(17)));
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
     }

    public void dowloadFileFromURL(String strUrl) throws IOException {
        if(strUrl==null || strUrl.isEmpty()){
            return;
        }
         if(!strUrl.equals(defaultURL1) && !strUrl.equals(defaultURL2)) {
             System.out.println(strUrl.equals(defaultURL2));
             Alert alerta = new Alert(Alert.AlertType.WARNING);
             alerta.setContentText("Invalid URL");
             alerta.showAndWait();
             return;
         }
         try {
             URL url = new URL(strUrl);
             URLConnection connection = url.openConnection();
             connection.connect();
             ReadableByteChannel readC = Channels.newChannel(url.openStream());
             FileOutputStream fileOS = new FileOutputStream("src/sample/enade.csv", false);
             FileChannel writeC =  fileOS.getChannel();
             writeC.transferFrom(readC,0,Long.MAX_VALUE);

             //System.out.println("Connection Successful");
         }
         catch (Exception e) {
             Alert alerta = new Alert(Alert.AlertType.ERROR);
             alerta.setContentText("No Internet connection");
             alerta.showAndWait();
         }

     }

    private BarChart<String,Number> createBarChart(DataEntry dt){
        if(dt.getAcertosBrasil()==null || dt.getAcertosBrasil().isEmpty() || dt.getAcertosBrasil().equals("-")){
            dt.setAcertosBrasil("0");
        }
        if(dt.getAcertosCurso()==null || dt.getAcertosCurso().isEmpty() || dt.getAcertosCurso().equals("-")){
            dt.setAcertosCurso("0");
        }
        if(dt.getAcertosRegiao()==null || dt.getAcertosRegiao().isEmpty() || dt.getAcertosRegiao().equals("-")){
            dt.setAcertosRegiao("0");
        }
        System.out.println(dt.getAcertosCurso());
        System.out.println(dt.getAcertosBrasil());
        System.out.println(dt.getAcertosRegiao());
        CategoryAxis xAxis = new CategoryAxis();
        xAxis.setCategories(FXCollections.<String>observableArrayList(
                Arrays.asList("Acertos Curso", "Acertos Região", "Acertos Brasil")));
        xAxis.setLabel("Categoria");
        NumberAxis yAxis =  new NumberAxis();
        yAxis.setLabel("Acertos");

        BarChart<String, Number> barChart =  new BarChart<>(xAxis,yAxis);
        barChart.setTitle("Comparação entre acertos");
        XYChart.Series<String, Number> serie =  new XYChart.Series<>();
        serie.setName("Acertos");
        serie.getData().add(new XYChart.Data<>("Acertos Curso",Float.parseFloat(dt.getAcertosCurso().replaceAll(",","."))));
        serie.getData().add(new XYChart.Data<>("Acertos Região",Float.parseFloat(dt.getAcertosRegiao().replaceAll(",","."))));
        serie.getData().add(new XYChart.Data<>("Acertos Brasil",Float.parseFloat(dt.getAcertosBrasil().replaceAll(",","."))));
        barChart.getData().add(serie);

        return barChart;
    }

    private void clickOnTable(TableView tv, Stage primaryStage){
        if(tv.getSelectionModel().getSelectedItem()!=null){
            DataEntry dt = (DataEntry) tv.getSelectionModel().getSelectedItem();
            BarChart<String, Number> barChart =  createBarChart(dt);
            Button graphBtn =  new Button("Graph");
            Button imageBtn =  new Button("Image");
            boolean validImage =  true;
            Image image = null;
            if(dt.getImageUrl().isEmpty()) {
                validImage = false;
                imageBtn.setDisable(true);
            }else{
                image = new Image(dt.getImageUrl());
                if(image.isError()){
                    Alert alerta = new Alert(Alert.AlertType.ERROR);
                    alerta.setContentText("Couldn't download image");
                    alerta.showAndWait();
                    validImage =  false;
                    imageBtn.setDisable(true);
                }
            }

            ImageView imageView = null;
            if(validImage)
                    imageView = new ImageView(image);

            barChart.setManaged(false);
            barChart.setVisible(false);



            List<Text> texts = new ArrayList<>();
            texts.add(new Text("Ano : "+dt.getAno()));
            texts.add(new Text("Prova : "+dt.getProva()));
            texts.add(new Text("Tipo de Questao : "+dt.getTipoQuestao()));
            texts.add(new Text("Id da Questao : "+dt.getIdQuestao()));
            texts.add(new Text("Objeto : "+dt.getObjeto()));
            texts.add(new Text("Gabarito : "+dt.getGabarito()));
            texts.add(new Text("Acertos do Curso : "+dt.getAcertosCurso()));
            texts.add(new Text("Acertos da Regiao : "+dt.getAcertosRegiao()));
            texts.add(new Text("Acertos do Brasil : "+dt.getAcertosBrasil()));
            texts.add(new Text("Dif. (Curso-Brasil): "+dt.getDif()));

            ListView<Text> lv =  new ListView<>();
            lv.setItems(FXCollections.observableArrayList(texts));
            lv.setOrientation(Orientation.VERTICAL);
            lv.setBackground(new Background(new BackgroundFill(Color.LIGHTGREEN,
                    CornerRadii.EMPTY, Insets.EMPTY)));

            ScrollPane scrollPane = new ScrollPane();
            scrollPane.setVbarPolicy(ScrollPane.ScrollBarPolicy.AS_NEEDED);
            scrollPane.setHbarPolicy(ScrollPane.ScrollBarPolicy.AS_NEEDED);
            scrollPane.setManaged(false);
            scrollPane.setVisible(false);
            if(validImage) {
                scrollPane.setContent(imageView);
            }

            VBox vBox = new VBox(3);
            HBox hBox = new HBox(5);
            hBox.getChildren().addAll(graphBtn,imageBtn);
            vBox.setPadding(new Insets(10, 10, 10, 10));
            vBox.getChildren().addAll(lv,barChart,scrollPane, hBox);

            ImageView finalImageView = imageView;
            boolean finalValidImage = validImage;
            graphBtn.setOnAction(event -> {
                barChart.setVisible(!barChart.isVisible());
                barChart.setManaged(!barChart.isManaged());
                if(finalValidImage)
                    finalImageView.setManaged(false);
                lv.setManaged(!lv.isManaged());
                lv.setVisible(!lv.isVisible());
                if(graphBtn.getText().equals("Data"))
                    graphBtn.setText("Graph");
                else if(graphBtn.getText().equals("Graph"))
                    graphBtn.setText("Data");
                if(finalValidImage)
                    imageBtn.setDisable(!imageBtn.isDisabled());
            });

            ScrollPane finalScrollPane = scrollPane;
            imageBtn.setOnAction(event -> {
                if(finalValidImage) {
                    finalScrollPane.setVisible(!finalScrollPane.isVisible());
                    finalScrollPane.setManaged(!finalScrollPane.isManaged());
                }
                barChart.setManaged(false);
                lv.setManaged(!lv.isManaged());
                lv.setVisible(!lv.isVisible());
                if(imageBtn.getText().equals("Data"))
                    imageBtn.setText("Image");
                else if(imageBtn.getText().equals("Image"))
                    imageBtn.setText("Data");
                graphBtn.setDisable(!graphBtn.isDisabled());

            });

            Scene secondScene = new Scene(vBox, 600,650);

            // New window (Stage)
            Stage newWindow = new Stage();
            if(validImage) {
                imageView.fitWidthProperty().bind(newWindow.widthProperty());
                imageView.preserveRatioProperty();
            }
            newWindow.setTitle("Visualização Questão");
            newWindow.setScene(secondScene);

            newWindow.initModality(Modality.WINDOW_MODAL);

            newWindow.initOwner(primaryStage);

            newWindow.setX(primaryStage.getX() + 200);
            newWindow.setY(primaryStage.getY() + 100);

            newWindow.show();
        }
    }

    private final List<DataEntry> data = new ArrayList<>();

    @Override
    public void start(final Stage primaryStage) throws Exception{
        Alert alerta;
        final String csvFile =  "src/sample/enade.csv";
        final String[] url = {defaultURL1};
        Label cursoLabel =  new Label();
        cursoLabel.setTextAlignment(TextAlignment.CENTER);
        cursoLabel.setBorder(new Border(new BorderStroke(Color.BLACK,
                BorderStrokeStyle.DASHED, CornerRadii.EMPTY, BorderWidths.DEFAULT)));

        ///Abre arquivo e caso não exista baica da url default
        File f =  new File(csvFile);
        if(f.exists()) {
            readFromCsvFile(f,data,cursoLabel);
        }else{
            alerta = new Alert(Alert.AlertType.ERROR);
            alerta.setContentText("enade.csv doesn't exist");
            alerta.showAndWait();
            try {
                dowloadFileFromURL(url[0]);
                f =  new File(csvFile);
                if(f.exists())
                    readFromCsvFile(f,data,cursoLabel);
                else{
                    alerta = new Alert(Alert.AlertType.ERROR);
                    alerta.setContentText("Erro ao baixar o arquivo online");
                    alerta.showAndWait();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        VBox vbox = new VBox(5);

        MenuBar mb = new MenuBar();
        Menu file =  new Menu("File");
        MenuItem reload =  new MenuItem("Reload");
        final MenuItem source = new MenuItem("Source");
        MenuItem exit = new MenuItem("Exit");
        file.getItems().addAll(reload,source,exit);


        Menu help =  new Menu("Help");
        MenuItem about =  new MenuItem("About");
        help.getItems().add(about);
        mb.getMenus().addAll(file,help);

        final Label aboutLabel =  new Label();
        aboutLabel.setText("\tEnadeUFSMExplorer\n\tHenrique Becker Brum");
        aboutLabel.setVisible(false);
        aboutLabel.setManaged(false);


        final TextField sourceText =  new TextField();
        sourceText.setVisible(false);
        sourceText.setManaged(false);

        final TableView tv = new TableView();
        TableColumn colAno = new TableColumn("Ano");
        TableColumn colProva = new TableColumn("Prova");
        TableColumn colTipoQuestao = new TableColumn("TipoQuestao");
        TableColumn colIdQuestao = new TableColumn("IdQuestao");
        TableColumn colObjeto = new TableColumn("Objeto");
        TableColumn colAcertosCurso = new TableColumn("AcertosCurso");
        TableColumn colAcertosRegiao = new TableColumn("AcertosRegiao");
        TableColumn colAcertosBrasil = new TableColumn("AcertosBrasil");
        TableColumn colDif = new TableColumn("Dif. (Curso-Brasil)");

        colAno.setCellValueFactory(new PropertyValueFactory<>("ano"));
        colProva.setCellValueFactory(new PropertyValueFactory<>("prova"));
        colTipoQuestao.setCellValueFactory(new PropertyValueFactory<>("tipoQuestao"));
        colIdQuestao.setCellValueFactory(new PropertyValueFactory<>("idQuestao"));
        colObjeto.setCellValueFactory(new PropertyValueFactory<>("objeto"));
        colAcertosCurso.setCellValueFactory(new PropertyValueFactory<>("acertosCurso"));
        colAcertosRegiao.setCellValueFactory(new PropertyValueFactory<>("acertosRegiao"));
        colAcertosBrasil.setCellValueFactory(new PropertyValueFactory<>("acertosBrasil"));
        colDif.setCellValueFactory(new PropertyValueFactory<>("dif"));



        tv.setItems(FXCollections.observableList(data));
        tv.getColumns().addAll(colAno,colProva,colTipoQuestao,colIdQuestao,colObjeto,colAcertosCurso,
                colAcertosRegiao,colAcertosBrasil,colDif);

        //Escolha de items
        FilteredList<DataEntry> filteredList =  new FilteredList(FXCollections.observableList(data), p -> true);
        ChoiceBox<String> choiceBox =  new ChoiceBox<>();
        choiceBox.getItems().addAll("Ano", "Prova", "TipoQuestao", "IdQuestao");
        choiceBox.setValue("Ano");
        TextField searchBar =  new TextField();
        searchBar.setPromptText("Search");

        HBox hbox1 =  new HBox(5);
        hbox1.getChildren().addAll(mb, aboutLabel, cursoLabel);
        HBox hbox2 =  new HBox(5);
        hbox2.getChildren().addAll(choiceBox,searchBar);
        vbox.getChildren().addAll(hbox1, sourceText, tv, hbox2);
        vbox.setMaxHeight(Double.MAX_VALUE);
        vbox.setPadding(new Insets(10, 10, 0, 10));

        searchBar.setOnKeyReleased(keyEvent -> {
            if(choiceBox.getValue().equals("Ano")){
                filteredList.setPredicate(p->p.getAno().toLowerCase().contains(searchBar.getText().toLowerCase().trim()));
            }else if(choiceBox.getValue().equals("Prova")){
                filteredList.setPredicate(p->p.getProva().toLowerCase().contains(searchBar.getText().toLowerCase().trim()));
            }else if(choiceBox.getValue().equals("TipoQuestao")){
                filteredList.setPredicate(p->p.getTipoQuestao().toLowerCase().contains(searchBar.getText().toLowerCase().trim()));
            }else  if(choiceBox.getValue().equals("IdQuestao")){
                filteredList.setPredicate(p->p.getIdQuestao().toLowerCase().contains(searchBar.getText().toLowerCase().trim()));
            }
            tv.setItems(filteredList);
        });

        exit.setOnAction(event -> primaryStage.close());

        tv.setOnMouseClicked(mouseEvent -> {
            if(mouseEvent.getClickCount()>=1){
                clickOnTable(tv, primaryStage);
            }
        });

        about.setOnAction(event -> {
            aboutLabel.setVisible(!aboutLabel.isVisible());
            aboutLabel.setManaged(!aboutLabel.isManaged());
        });


        source.setOnAction(event -> {
            sourceText.setVisible(!sourceText.isVisible());
            sourceText.setManaged(!sourceText.isManaged());
        });

        ///Quando clicado pega o texto do sourceTexto e baixa a url do sourceText
        reload.setOnAction(actionEvent -> {
            try {
                url[0] = sourceText.getText();
                dowloadFileFromURL(url[0]);
                File fl =  new File(csvFile);
                if(fl.exists()) {
                    readFromCsvFile(fl, data, cursoLabel);
                    tv.getItems().clear();

                    colAno.setCellValueFactory(new PropertyValueFactory<>("ano"));
                    colProva.setCellValueFactory(new PropertyValueFactory<>("prova"));
                    colTipoQuestao.setCellValueFactory(new PropertyValueFactory<>("tipoQuestao"));
                    colIdQuestao.setCellValueFactory(new PropertyValueFactory<>("idQuestao"));
                    colObjeto.setCellValueFactory(new PropertyValueFactory<>("objeto"));
                    colAcertosCurso.setCellValueFactory(new PropertyValueFactory<>("acertosCurso"));
                    colAcertosRegiao.setCellValueFactory(new PropertyValueFactory<>("acertosRegiao"));
                    colAcertosBrasil.setCellValueFactory(new PropertyValueFactory<>("acertosBrasil"));
                    colDif.setCellValueFactory(new PropertyValueFactory<>("dif"));

                    tv.setItems(FXCollections.observableList(data));
                    //
                    //;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        primaryStage.setTitle("EnadeUFSMExplorer");
        primaryStage.setScene(new Scene(vbox,650, 600));
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}
