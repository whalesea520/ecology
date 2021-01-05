
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.* , java.io.*, weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>

<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<TITLE></TITLE>
</HEAD>
<BODY onload="doChoose()" onbeforeload="protectDoc()">
<%

String choice = Util.null2String(request.getParameter("MSG")) ; 
String timeinterval = "" + (Util.getIntValue(HrmKqSystemComInfo.getTimeinterval(),60)*60000) ;
String getdatatype = "" + Util.getIntValue(HrmKqSystemComInfo.getDatatype(),1);
String getdatavalue = Util.null2String(HrmKqSystemComInfo.getDatavalue()) ;

// 刘煜处理，分多次接受数据
int countindex = Util.getIntValue(request.getParameter("countindex"),0) ;

ArrayList getdatavalues = new ArrayList() ;

int counttype = 0 ;

if( getdatatype.equals("1") && !getdatatype.equals("") ) {
    counttype = 1 ;
    getdatavalues.add(getdatavalue) ;
}
else {
    getdatavalues = Util.TokenizerString(getdatavalue, "," ) ;
    counttype = getdatavalues.size() ;
}


String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);
String mClientName="CipheData.ocx";
String mClientUrl ="http://"+Util.getRequestHost(request)+temStr+mClientName;

int countvalidatecard = 0 ;
RecordSet.executeSql("select count(*) from HrmValidateCardInfo ") ;
if( RecordSet.next() ) countvalidatecard = Util.getIntValue( RecordSet.getString(1) , 0) ;

%>

<FORM METHOD=POST ACTION="HrmTimecardGetDataOperation.jsp" name=dataform >
<INPUT TYPE="hidden" name="cardData" value="">
<INPUT TYPE="hidden" name="cardError" value="">
<INPUT TYPE="hidden" name="countindex" value="<%=countindex%>">
</FORM>


<SCRIPT LANGUAGE="JavaScript">
<!--
var issuccess = "<%=choice%>" ;

function protectDoc(){
    window.event.returnValue="<%=SystemEnv.getHtmlLabelName(16742,user.getLanguage())%>";    
}

function doChoose() {
    if(issuccess == "ERR") {
        doBackup() ;
    } else { 
        doReceive() ; 
    }
}
function doBackup(){
    // window.setTimeout("Backup()","<%=timeinterval%>") ; //默认十分钟
    Backup() ;  // 立刻做备份工作
}
//doBackup() ; 

function Backup () { 
    dataform.cardError.value = "" ;
    dataform.cardData.value = parent.Frame2.databackup.store.value ; 
    dataform.submit() ;
}

function doReceive () { 
    <%if(countindex >= counttype) {
        countindex = 0 ;
    %>
        window.setTimeout("Receive()","<%=timeinterval%>") ; //默认十分钟
    <%} else { %>
        Receive() ;
    <%} %>
}

function Receive(){

    var result = "" ;
    var countindex = <%=countindex%> ;
    dataform.cardError.value = "" ;

 
    <% 
        if( getdatatype.equals("1")) { //如果采用510的话，上面5条语句用下面的语句
    %>
            CipheData1.ConnectType = 1 
            CipheData1.ConnectString = "9600" 
            CipheData1.Port = <%=getdatavalues.get(countindex)%> 
            CipheData1.ShowMsg = false 
            CipheData1.Connect();	
    <%  }
        else if( getdatatype.equals("2")) {   //如果采用350的话，上面5条语句用下面的语句
    %>
            CipheData1.ConnectType = 3 
            CipheData1.ConnectString = "<%=getdatavalues.get(countindex)%>"  
            CipheData1.Port = 2 
            CipheData1.ShowMsg = false 
            CipheData1.Connect();
    <%  } %>

    number = CipheData1.GetDataCount() ; //获取刷卡资料的数据笔数
    if(number < 0) { 
        errMSG = CipheData1.GetLastErr() ; 
        if(errMSG != 1) {
            dataform.cardError.value = errMSG ; 
        }
    } else { 
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83838,user.getLanguage())%><%=getdatavalues.get(countindex)%><%=SystemEnv.getHtmlLabelName(83836,user.getLanguage())%>"+number+"<%=SystemEnv.getHtmlLabelName(83839,user.getLanguage())%>") ;
        for(i = 0 ; i <= number ; i ++ ) { 
            field = CipheData1.ReadOneRec() ; //从打卡机读取一笔数据，如果读取成功则从510中删除本笔数据
            if(field == "") { 
                errMSG = CipheData1.GetLastErr() ; //获取最近操作的结果代码,如果返回值为1，则没有错误发生；否则有错误发生
                /* if(errMSG != 1) {
                    dataform.cardError.value = errMSG ; 
                    break ;
                } */
            } 
            else if(field.indexOf("OVER")>=0) { //"OVER",510中数据已经采集完毕
                break ; 
            }
            else {
                result = result + field ; 
                result = result + "," ; 
            }
        }
     }

     countindex ++ ;   // 当前数＋1 
     dataform.countindex.value = countindex ; 
     dataform.cardData.value = result ; 
     parent.Frame2.databackup.store.value = result ;  
     dataform.submit() ; 
}
//-->
</SCRIPT>
<P>
<div align=center>

  <table border="0" cellspacing="0" cellpadding="3">
    <tr>
      <td><img src="/images/getcardinfo_wev8.gif" width="402" height="124"> </td>
  </tr>
</table>
</div>

<OBJECT id=CipheData1 classid=clsid:A10009EC-93E0-11D6-9A05-00D0099D6D84 codebase="<%=mClientUrl%>">
	<PARAM NAME="_Version" VALUE="65536">
	<PARAM NAME="_ExtentX" VALUE="1058">
	<PARAM NAME="_ExtentY" VALUE="1058">
	<PARAM NAME="_StockProps" VALUE="0">
	<PARAM NAME="ConnectString" VALUE="9600">
	<PARAM NAME="ConnectType" VALUE="1">
	<PARAM NAME="ShowMsg" VALUE="0">
	<PARAM NAME="Port" VALUE="1">
</OBJECT>
</P>

<% if( countvalidatecard > 0 ) {%>
<table border="0" cellspacing="0" cellpadding="3" align=center>
    <tr>
      <td align=center><font color=red><%=SystemEnv.getHtmlLabelNames("524,15086",user.getLanguage()) %> <%=countvalidatecard%> <%=SystemEnv.getHtmlLabelName(129094, user.getLanguage())%> </font></td>
  </tr>
</table>
<% } %>


</BODY>
</HTML>