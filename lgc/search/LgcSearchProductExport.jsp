
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<%
   
    String psqlexport=(String)session.getAttribute("psqlexport");
    RecordSet.executeSql(psqlexport);

    ExcelSheet es = new ExcelSheet();

    ExcelRow erTitle = es.newExcelRow();
    ExcelRow erEmpty = es.newExcelRow();
	ExcelRow er = es.newExcelRow();
	  
    erTitle.addStringValue("");
    erTitle.addStringValue(SystemEnv.getHtmlLabelName(15108,user.getLanguage()));
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
	  
    er.addStringValue(SystemEnv.getHtmlLabelName(15129,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(705,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(726,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(178,user.getLanguage()));
   
    while(RecordSet.next()){
   
      er = es.newExcelRow();
      er.addStringValue(RecordSet.getString("assetname"));
      er.addStringValue(Util.toScreen(AssetUnitComInfo.getAssetUnitname(RecordSet.getString("assetunitid")),user.getLanguage()));
      er.addStringValue(Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSet.getString("currencyid")),user.getLanguage())+" "+Util.getPointValue(Util.toScreen(RecordSet.getString("salesprice"),user.getLanguage())));
      er.addStringValue(Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(RecordSet.getString("assortmentid")),user.getLanguage()));
    
     
    }

    ExcelFile.init() ;
    ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15108,user.getLanguage())) ;
    ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15108,user.getLanguage()), es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>