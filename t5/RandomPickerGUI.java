package sample;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TextArea;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import java.io.*;
import java.util.*;

import static javafx.geometry.Pos.CENTER;



public class RandomPickerGUI extends Application {
    private  int num_pgn_images =  6;


    public static void main(String[] args) {
        Application.launch(args);
    }


    @Override
    public void start(final Stage primaryStage) {

        BorderPane bp = new BorderPane();
        Scene scene = new Scene(bp, 600, 400);

        final TextArea textArea = new TextArea();

        final Button shuffle = new Button("Shuffle");

        final Button next = new Button("Next");
        next.setDisable(true);


        final Label nomeRemovido =  new Label("");
        nomeRemovido.setAlignment(Pos.CENTER);
        nomeRemovido.setMaxWidth(200);
        nomeRemovido.setMinWidth(60);

        final Label label =  new Label("    NOME REMOVIDO: \n\n");
        label.setAlignment(Pos.CENTER);
        MenuBar menuB = new MenuBar();
        Menu file = new Menu("File");
        MenuItem open = new MenuItem("Open");
        MenuItem exit = new MenuItem("Exit");
        file.getItems().addAll(open, exit);

        final  Label info =  new Label("Aluno: Henrique Becker Brum\nPrograma: RandomPickerGUI");
        info.setVisible(false);
        Menu help = new Menu("Help");
        MenuItem about = new MenuItem("About");
        help.getItems().add(about);

        menuB.getMenus().addAll(file, help);//adding menu to menubar
        ToolBar toolBar = new ToolBar();
        toolBar.getItems().addAll(menuB, info);

        HBox bottomHbox = new HBox();
        bottomHbox.getChildren().addAll(shuffle, next);
        bottomHbox.setAlignment(Pos.CENTER);

        VBox leftVbox  =  new VBox();
        leftVbox.getChildren().addAll(label, nomeRemovido);
        leftVbox.setAlignment(Pos.CENTER);


        menuB.setBackground(new Background(new BackgroundFill(Color.WHITE,
                CornerRadii.EMPTY, Insets.EMPTY)));
        toolBar.setBackground(new Background(new BackgroundFill(Color.LIGHTBLUE,
                CornerRadii.EMPTY, Insets.EMPTY)));
        shuffle.setBackground(new Background(new BackgroundFill(Color.rgb( 142,74,114),
                CornerRadii.EMPTY, Insets.EMPTY)));
        next.setBackground(new Background(new BackgroundFill(Color.LIGHTGREEN,
                CornerRadii.EMPTY, Insets.EMPTY)));


        menuB.setBorder(new Border(new BorderStroke(Color.BLACK,
                BorderStrokeStyle.SOLID, CornerRadii.EMPTY, BorderWidths.DEFAULT)));
        toolBar.setBorder(new Border(new BorderStroke(Color.WHITE,
                BorderStrokeStyle.DASHED, CornerRadii.EMPTY, BorderWidths.DEFAULT)));

        bp.setCenter(textArea);
        bp.setRight(leftVbox);
        bp.setBottom(bottomHbox);
        bp.setTop(toolBar);



        handleEvents(primaryStage,exit,open,about,info,nomeRemovido,shuffle,next,textArea);

        handleImages(scene,file,help,exit,open,about,shuffle,next);


        primaryStage.setTitle("RandomRicker");
        primaryStage.setScene(scene);
        primaryStage.show();

    }

    public void handleImages(Scene scene, Menu file, Menu help, MenuItem exit, MenuItem open, MenuItem about, Button shuffle, Button next){
        String imagesDir = "C:/Users/hbrum/Desktop/Universidade/3° Semestre/Paradigmas de Programação/Trabalho5/GUI/src/sample/Images/";
        File auxFile = new File(imagesDir+"file.jpg");
        if(auxFile.exists()) {
            Image fileIcon = new Image(getClass().getResourceAsStream("Images/file.jpg"));
            ImageView fileView = new ImageView(fileIcon);
            fileView.setFitWidth(scene.getWidth() / 10);
            fileView.setFitHeight(scene.getWidth() / 8);
            file.setGraphic(fileView);
        }


        List<ImageView> iconView = new ArrayList<ImageView>(num_pgn_images);
        List<String> fileNames = new ArrayList<String>(Arrays.asList("about", "exit", "help","open","shuffle","next"));
        boolean usePic = true;
        for(int i = 0;i <num_pgn_images;i++){
            File tempFile =  new File(imagesDir+fileNames.get(i)+".png");

            if(tempFile.exists()) {
                Image icon = new Image(getClass().getResourceAsStream("Images/" + fileNames.get(i) + ".png"));
                iconView.add(new ImageView(icon));
                iconView.get(i).setFitWidth(scene.getWidth() / 10);
                iconView.get(i).setFitHeight(scene.getWidth() / 8);
            }else{
                usePic = false;
                break;
            }
        }

        if(usePic==true) {
            about.setGraphic(iconView.get(0));
            exit.setGraphic(iconView.get(1));
            help.setGraphic(iconView.get(2));
            open.setGraphic(iconView.get(3));
            shuffle.setGraphic(iconView.get(4));
            next.setGraphic(iconView.get(5));
        }
    }

    public void handleEvents(Stage primaryStage, MenuItem exit, MenuItem open, MenuItem about, Label info
                             ,Label nomeRemovido, Button shuffle, Button next, TextArea textArea){
        exit.setOnAction(new EventHandler<ActionEvent>(){
            @Override
            public void handle(ActionEvent event) {
                primaryStage.close();
            }
        });

        about.setOnAction(new EventHandler<ActionEvent>(){
            @Override
            public void handle(ActionEvent event) {
                info.setVisible(!info.isVisible());
            }
        });

        shuffle.setOnAction(new EventHandler<ActionEvent>(){
            @Override
            public void handle(ActionEvent event) {
                Common common = new Common();
                String text = textArea.getText();
                System.out.println("String\n"+text);
                List<String> names = new ArrayList<String>(Arrays.asList(text.split("\n")));
                System.out.println("List\n"+text);
                if(!text.isEmpty()) {
                    next.setDisable(false);
                    common.shuffle(names);
                    textArea.setText(String.join("\n", names));
                }else{
                    next.setDisable(true);
                }

            }
        });

        shuffle.setOnMouseEntered(new EventHandler<MouseEvent>(){

            @Override
            public void handle(MouseEvent mouseEvent) {
                shuffle.setBackground(new Background(new BackgroundFill(Color.PLUM,
                        CornerRadii.EMPTY, Insets.EMPTY)));
            }

        });

        shuffle.setOnMouseExited(new EventHandler<MouseEvent>(){

            @Override
            public void handle(MouseEvent mouseEvent) {
                shuffle.setBackground(new Background(new BackgroundFill(Color.rgb(142,74,114),
                        CornerRadii.EMPTY, Insets.EMPTY)));
            }

        });

        next.setOnAction(new EventHandler<ActionEvent>(){
            @Override
            public void handle(ActionEvent event) {
                Common common = new Common();
                Random generator = new Random(new Date().getTime());
                String text = textArea.getText();
                List<String> names = new ArrayList<String>(Arrays.asList(text.split("\n")));
                if(text.isEmpty()){
                    next.setDisable(true);
                }else{
                    int remover = generator.nextInt(names.size());
                    String removido =  names.get(remover);
                    nomeRemovido.setText(removido);
                    names.remove(remover);
                    textArea.setText(String.join("\n", names));

                }

            }
        });

        next.setOnMouseEntered(new EventHandler<MouseEvent>(){

            @Override
            public void handle(MouseEvent mouseEvent) {
                next.setBackground(new Background(new BackgroundFill(Color.DARKGREEN,
                        CornerRadii.EMPTY, Insets.EMPTY)));
            }

        });

        next.setOnMouseExited(new EventHandler<MouseEvent>(){

            @Override
            public void handle(MouseEvent mouseEvent) {
                next.setBackground(new Background(new BackgroundFill(Color.LIGHTGREEN,
                        CornerRadii.EMPTY, Insets.EMPTY)));
            }

        });

        open.setOnAction(new EventHandler<ActionEvent>(){
            @Override
            public void handle(ActionEvent event) {
                FileChooser fileChooser = new FileChooser();
                fileChooser.setTitle("Open File");
                fileChooser.setInitialDirectory(new File("."));
                File file = fileChooser.showOpenDialog(primaryStage);

                if (file != null) {
                    Common common = new Common();
                    List<String> fileContent =  common.fileToList(file.getAbsolutePath());
                    textArea.appendText(String.join("\n",fileContent));
                }
            }
        });

    }
}



