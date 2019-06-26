package sample;

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
