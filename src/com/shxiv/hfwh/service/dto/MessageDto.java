package com.shxiv.hfwh.service.dto;

/**
 * Created by zsd on 2019/1/18.
 */
public class MessageDto {

    private String ipName;

    private String pdfId;//PDFID

    private String fmId;//封面ID

    private String tcId;//图册ID

    private String tcName;//图册姓名

    private String tcBm;//图册编码

    private String tcIp;

    private String mfmId;

    private String ai;

    private String psd;

    private String jpg;

    private String png;

    private String isSc;

    private String eps;

    public String getTcBm() {
        return tcBm;
    }

    public void setTcBm(String tcBm) {
        this.tcBm = tcBm;
    }

    public String getEps() {
        return eps;
    }

    public void setEps(String eps) {
        this.eps = eps;
    }

    public String getIsSc() {
        return isSc;
    }

    public void setIsSc(String isSc) {
        this.isSc = isSc;
    }

    public String getMfmId() {
        return mfmId;
    }

    public void setMfmId(String mfmId) {
        this.mfmId = mfmId;
    }

    public String getAi() {
        return ai;
    }

    public void setAi(String ai) {
        this.ai = ai;
    }

    public String getPsd() {
        return psd;
    }

    public void setPsd(String psd) {
        this.psd = psd;
    }

    public String getJpg() {
        return jpg;
    }

    public void setJpg(String jpg) {
        this.jpg = jpg;
    }

    public String getPng() {
        return png;
    }

    public void setPng(String png) {
        this.png = png;
    }

    public String getTcIp() {
        return tcIp;
    }

    public void setTcIp(String tcIp) {
        this.tcIp = tcIp;
    }

    public String getTcId() {
        return tcId;
    }

    public void setTcId(String tcId) {
        this.tcId = tcId;
    }

    public String getTcName() {
        return tcName;
    }

    public void setTcName(String tcName) {
        this.tcName = tcName;
    }

    public String getPdfId() {
        return pdfId;
    }

    public void setPdfId(String pdfId) {
        this.pdfId = pdfId;
    }

    public String getFmId() {
        return fmId;
    }

    public void setFmId(String fmId) {
        this.fmId = fmId;
    }

    public String getIpName() {
        return ipName;
    }

    public void setIpName(String ipName) {
        this.ipName = ipName;
    }
}
