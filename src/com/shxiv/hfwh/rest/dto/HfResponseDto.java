package com.shxiv.hfwh.rest.dto;

import java.util.List;

/**
 * Created by zsd on 2018/12/23.
 */
public class HfResponseDto {

    private String ID;

    private String DOCNO;

    private String OA_DOCNO;

    private String BILLDATE;

    private String STORE;

    private String TOT_QTYIN;

    private String TOT_AMTIN;

    private String MATERIAL;

    private String QTYIN;

    private String AMTIN;

    private String STATUSTIME;

    private String OPERATION_DATE;

    private String TOT_QTYOUT;

    private String TOT_AMTOUT;

    private String QTYOUT;

    private String AMTOUT;

    private String PRODUCTALIAS;

    private String PRODUCT;

    private String BEGIN_FAKENO;

    private String END_FAKENO;

    private String BEGIN_NUM;

    private String END_NUM;

    private String EXPRESSNO;

    private String PREFIX;

    public String getPREFIX() {
        return PREFIX;
    }

    public void setPREFIX(String PREFIX) {
        this.PREFIX = PREFIX;
    }

    public String getEXPRESSNO() {
        return EXPRESSNO;
    }

    public void setEXPRESSNO(String EXPRESSNO) {
        this.EXPRESSNO = EXPRESSNO;
    }

    public String getBEGIN_NUM() {
        return BEGIN_NUM;
    }

    public void setBEGIN_NUM(String BEGIN_NUM) {
        this.BEGIN_NUM = BEGIN_NUM;
    }

    public String getEND_NUM() {
        return END_NUM;
    }

    public void setEND_NUM(String END_NUM) {
        this.END_NUM = END_NUM;
    }

    public String getBEGIN_FAKENO() {
        return BEGIN_FAKENO;
    }

    public void setBEGIN_FAKENO(String BEGIN_FAKENO) {
        this.BEGIN_FAKENO = BEGIN_FAKENO;
    }

    public String getEND_FAKENO() {
        return END_FAKENO;
    }

    public void setEND_FAKENO(String END_FAKENO) {
        this.END_FAKENO = END_FAKENO;
    }

    public String getPRODUCT() {
        return PRODUCT;
    }

    public void setPRODUCT(String PRODUCT) {
        this.PRODUCT = PRODUCT;
    }

    public String getPRODUCTALIAS() {
        return PRODUCTALIAS;
    }

    public void setPRODUCTALIAS(String PRODUCTALIAS) {
        this.PRODUCTALIAS = PRODUCTALIAS;
    }

    public String getTOT_QTYOUT() {
        return TOT_QTYOUT;
    }

    public void setTOT_QTYOUT(String TOT_QTYOUT) {
        this.TOT_QTYOUT = TOT_QTYOUT;
    }

    public String getTOT_AMTOUT() {
        return TOT_AMTOUT;
    }

    public void setTOT_AMTOUT(String TOT_AMTOUT) {
        this.TOT_AMTOUT = TOT_AMTOUT;
    }

    public String getQTYOUT() {
        return QTYOUT;
    }

    public void setQTYOUT(String QTYOUT) {
        this.QTYOUT = QTYOUT;
    }

    public String getAMTOUT() {
        return AMTOUT;
    }

    public void setAMTOUT(String AMTOUT) {
        this.AMTOUT = AMTOUT;
    }

    private List<HfResponseDto> data;

    private String status;

    public List<HfResponseDto> getData() {
        return data;
    }

    public void setData(List<HfResponseDto> data) {
        this.data = data;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getDOCNO() {
        return DOCNO;
    }

    public void setDOCNO(String DOCNO) {
        this.DOCNO = DOCNO;
    }

    public String getOA_DOCNO() {
        return OA_DOCNO;
    }

    public void setOA_DOCNO(String OA_DOCNO) {
        this.OA_DOCNO = OA_DOCNO;
    }

    public String getBILLDATE() {
        return BILLDATE;
    }

    public void setBILLDATE(String BILLDATE) {
        this.BILLDATE = BILLDATE;
    }

    public String getSTORE() {
        return STORE;
    }

    public void setSTORE(String STORE) {
        this.STORE = STORE;
    }

    public String getTOT_QTYIN() {
        return TOT_QTYIN;
    }

    public void setTOT_QTYIN(String TOT_QTYIN) {
        this.TOT_QTYIN = TOT_QTYIN;
    }

    public String getTOT_AMTIN() {
        return TOT_AMTIN;
    }

    public void setTOT_AMTIN(String TOT_AMTIN) {
        this.TOT_AMTIN = TOT_AMTIN;
    }

    public String getMATERIAL() {
        return MATERIAL;
    }

    public void setMATERIAL(String MATERIAL) {
        this.MATERIAL = MATERIAL;
    }

    public String getQTYIN() {
        return QTYIN;
    }

    public void setQTYIN(String QTYIN) {
        this.QTYIN = QTYIN;
    }

    public String getAMTIN() {
        return AMTIN;
    }

    public void setAMTIN(String AMTIN) {
        this.AMTIN = AMTIN;
    }

    public String getSTATUSTIME() {
        return STATUSTIME;
    }

    public void setSTATUSTIME(String STATUSTIME) {
        this.STATUSTIME = STATUSTIME;
    }

    public String getOPERATION_DATE() {
        return OPERATION_DATE;
    }

    public void setOPERATION_DATE(String OPERATION_DATE) {
        this.OPERATION_DATE = OPERATION_DATE;
    }
}
