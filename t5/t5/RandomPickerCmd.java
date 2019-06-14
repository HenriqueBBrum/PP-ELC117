//package com.company;

import java.io.*;
import java.util.*;

class RandomPickerCmd {

    private  List<String> names;

    public List<String> getNames(){
        return names;
    }

    public void setNames(List<String> names){
        this.names = names;
    }


    public void printNames(){
        int count = 0;
        for(String nome: names){
            System.out.print(nome + " ");
            if(count%10==0 && count!=0)
                System.out.println("\n");
            count++;
        }
    }



    protected boolean continuar(){
        Scanner in = new Scanner(System.in);
        System.out.println("\n\nSair digite: 1");
        System.out.println("Continuar digite: 2");
        int ans = in.nextInt();
        if(ans == 1)
            return false;
        else if(ans == 2)
            return true;
        else{
            System.out.println("\n\nEra pra ter escolhido 1 ou 2");
            return false;
        }
    }



    public void loop() throws IOException {
        Scanner in = new Scanner(System.in);
        Common common = new Common();
        Random generator = new Random(new Date().getTime());

        do{
            System.out.println("Shuffling: ");
            common.shuffle(names);

            int remover = generator.nextInt(names.size()-1);
            String removido = names.get(remover);
            System.out.println("\nNome removido : "+ removido);
            names.remove(remover);
            printNames();

        } while(continuar()==true);
    }



    public static void main(String[] args) throws IOException {
        RandomPickerCmd RandPickerCmd= new RandomPickerCmd();
        String file = String.join("", args);
        System.out.println("\nNome do arquivo : "+ file);
        System.out.println("\nLista de nomes iniciais:\n");
        Common common = new Common();
        RandPickerCmd.setNames(common.fileToList(file));
        RandPickerCmd.printNames();
        RandPickerCmd.loop();

    }
}
