<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="java.io.File" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%!
/********* @2007-08-08 Add by yeriwei! **********************/
private weaver.conn.RecordSet rs1=null;
private HttpServletRequest req=null;

private String[] getReportDates(String inprepfrequence,int lang){
	String currentdate = Util.null2String(req.getParameter("currentdate"));
	String year = Util.null2String(req.getParameter("year"));
	String month = Util.null2String(req.getParameter("month"));
	String day = Util.null2String(req.getParameter("day"));
	String date = Util.null2String(req.getParameter("date"));
	String thedate = currentdate;
	String dspdate = currentdate ;
	switch(Util.getIntValue(inprepfrequence)) {
		case 1:
			thedate = year + "-01-15" ;
			dspdate = year ;
			break ;
		case 2:
			thedate = year + "-"+month+"-15" ;
			dspdate = year + "-"+month ;
			break ;
		case 3:
			thedate = year + "-"+month+"-"+day ;
			dspdate = year + "-"+month ;
			if(day.equals("05")) dspdate += " 上旬" ;
			if(day.equals("15")) dspdate += " 中旬" ;
			if(day.equals("25")) dspdate += " 下旬" ;
			break ;
        case 4:
            thedate = date;
            Calendar today = Calendar.getInstance();
            today.set(Calendar.YEAR,Util.getIntValue(date.substring(0,4)));
            today.set(Calendar.MONTH,Util.getIntValue(date.substring(5,7))-1);
            today.set(Calendar.DAY_OF_MONTH,Util.getIntValue(date.substring(8)));
            dspdate = Util.add0(today.get(Calendar.YEAR), 4) + " 第" + Util.add0(today.get(Calendar.WEEK_OF_YEAR), 2) + "周";
            break;
		case 5:
			thedate = date ;
			dspdate = date ;
			break ;
        case 6:
            thedate = year + "-"+month+"-15" ;
            dspdate = year;
            if(month.equals("01")) dspdate += " 上半年" ;
			if(month.equals("07")) dspdate += " 下半年" ;
            break;
		case 7:
			thedate = year + "-"+month+"-15" ;
            dspdate = year;
            if(month.equals("01")) dspdate += " 一季度" ;
			if(month.equals("04")) dspdate += " 二季度" ;
            if(month.equals("07")) dspdate += " 三季度" ;
            if(month.equals("10")) dspdate += " 四季度" ;
            break;
    }
	return new String[]{thedate,dspdate};
}

/**
 * 返回值：String[0]-0 正常，1 已存在数据，2 数据已导入，处于草稿状态
 *  String[1-2] 是保存getReportDates（）方法的数据返回
 * @return int 
 **/
private String[] checkReportData(String sTableName,int userId,int lang){
	String inpRepFrequence=Util.null2String(req.getParameter("inprepfrequence"));
	String crmid = Util.null2String(req.getParameter("crmid"));
	String date = Util.null2String(req.getParameter("date"));
	String[] reportDates=new String[]{date,date};//表示默认为报表无周期限制，直接为用户选中日期。
	//boolean isFrequence=!inpRepFrequence.equalsIgnoreCase("0");//true表示有报表周期
	reportDates=this.getReportDates(inpRepFrequence,lang);

	String sql=null;
	int ret=0;
	if(!inpRepFrequence.equalsIgnoreCase("0"))
		sql="SELECT inputid,inputstatus FROM "+sTableName+" WHERE inprepdspdate='"+reportDates[1]+"' AND crmid="+crmid+" AND reportuserid="+userId;
	else//报表无周期限定
		sql="SELECT inputid,inputstatus FROM "+sTableName+" WHERE crmid="+crmid+" AND reportuserid="+userId;
		
	rs1.executeSql(sql);
	if(rs1.next()){
		String status=Util.null2String(rs1.getString("inputstatus"));
		ret=status.equalsIgnoreCase("9")?2:1;//status==9,表示已导入数据，但处于草稿状态中。
	}//不存在记录，表示默认报表中不存在数据。
	return new String[]{String.valueOf(ret),reportDates[0],reportDates[1]};
}
/******************************/

/** 获取页面传递过来的所有参数数据 */
	private String getRequestParmHtmlString(){
		StringBuffer str=new StringBuffer();
		Enumeration e0=req.getParameterNames();
		String keyName=null;
		while(e0.hasMoreElements()){
			keyName=e0.nextElement().toString();
			str.append("<input type=\"hidden\" ");
			str.append(" name=\""+keyName+"\"");
			str.append(" value=\""+req.getParameter(keyName)+"\"");
			str.append(">\n");
		}
		return str.toString();
	}
	
	private String checkCustomeTemplate(String inpreptablename,String reportHrmId){
		inpreptablename="User_"+inpreptablename;
		String fname=inpreptablename+reportHrmId+".xls";
		String savePath = GCONST.getRootPath()+"datacenter" + File.separatorChar + "inputexcellfile" + File.separatorChar;
		File f=new File(savePath + fname);
		if(!f.exists()){
			fname=inpreptablename+"0.xls";
			f=new File(savePath+fname);
			if(!f.exists())fname=null;
		}
		return fname;	
	}
	
	
private int langFlag=7;
private String getLabel(int labelId){//获取语言标签
	return SystemEnv.getHtmlLabelName(labelId,this.langFlag);
}
%>
<html><head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver.js"></script>
</head>
<%
this.langFlag=user.getLanguage();
String inprepid = Util.null2String(request.getParameter("inprepid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String reportHrmId=Util.null2String(request.getParameter("reportHrmId"));
String fromcheck = Util.null2String(request.getParameter("fromcheck"));
String inprepfrequence=Util.null2String(request.getParameter("inprepfrequence"));

rs.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
rs.next() ;

String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
/********* @2007-08-08 Add by yeriwei! **********************/
String multiLine = Util.null2String(rs.getString("isInputMultiLine")) ;
boolean isMultiLine=multiLine.equalsIgnoreCase("1");
this.rs1=rs;
this.req=request;
String[] chkResult=this.checkReportData(inpreptablename,user.getUID(),user.getLanguage());
int chkRet=Integer.parseInt(chkResult[0]);

String strMsg="";//需要在客户端脚本中提示的信息
int msgFlag=0;//0 不显示，1，显示消息确认框且转向，2 显示消息确认框并设置Hidden，3 显示对话框并直接转向，数据已存在
if(chkRet==1){//已导入数据提示
	strMsg=chkResult[2]+" "+this.getLabel(20775);//报表数据已存在;
	msgFlag=3;
}if(chkRet==2){//数据处于草稿状态
	if(isMultiLine){//是否可允许多行数据。
		strMsg=chkResult[2]+" "+this.getLabel(20776);//报表数据在处于草稿状态，继续导入吗(Y/N)";
		msgFlag=1;
	}else{
		strMsg=this.getLabel(20777);//"当前报表为单行数据，已有数据处于草稿状态,是否导入覆盖(Y/N)";
		msgFlag=2;
	}
}

String reportDates=chkResult[1]+"|"+chkResult[2];//存储计算出来的reportDate|dspDate
/********************************************************/

String modulefilename = "" ;
if(fromcheck.equals("1") || fromcheck.equals("2")) modulefilename = inpreptablename + "2" ;
else modulefilename = inpreptablename + "1" ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(15184,user.getLanguage()),user.getLanguage(),"0") + ":" + inprepname;
String needfav ="1";
String needhelp ="";
%>
<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:dosubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form id=frmMain name=frmMain action="InputReportMutiUploadOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="inprepfrequence" value="<%=inprepfrequence%>">
<input type="hidden" name="isOverWriter" id="isOverWriter" value="false"><!--默认为不存在，导入新数据，否则为删除原先的-->
<input type="hidden" name="reportDates" value="<%=reportDates%>">
<input type="hidden" name="reprotHrmId" value="<%=reportHrmId%>">
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="inprepname" value="<%=inprepname%>">
<input type="hidden" name="fromcheck" value="<%=fromcheck%>">
<input type="hidden" name="crmid" value="<%=crmid%>">
<input type="hidden" name="redirectFormString" id="redirectFormString" value="">
<input type="hidden" name="returnUrl" id="returnUrl" value="">
<!-- 用来传递执行成功后转向所的字符串 -->


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<table class=Shadow>
		<tr>
		<td valign="top">

  <table class="viewform" width="100%">
    <tr > 
      <td colspan="2"><nobr><b><%=inprepname%></b></td>
      </tr>
   <tr><td class=Line1 colSpan=2></td></tr> 
   <tr> 
      <td><%=this.getLabel(18493)+this.getLabel(63)%><!--文件类型--></td>
      <td width="88%" class=Field>
	  <label for="txtFile"><input type="radio" name="filetype" id="txtFile" value="1"><%=this.getLabel(19110)%><!--文本类型-->(*.txt)</label>&nbsp;&nbsp;&nbsp;
	  <label for="sysExcelFile"><input name="filetype" type="radio" id="sysExcelFile" value="2" checked>
	  <%=this.getLabel(468)%>Excel<%=this.getLabel(64)%>(*.xls)<!--系统Excel模板 --></label>&nbsp;&nbsp;&nbsp;
<%
String userExcelTemplate=this.checkCustomeTemplate(inpreptablename,reportHrmId);
if(userExcelTemplate!=null){
%><label for="customExcelFile"><input type="radio" name="filetype" id="customExcelFile" value="3"><%=this.getLabel(73)%>Excel<%=this.getLabel(64)%><!--自定义模板-->(*.xls)</label>
<%}%></td>
    </tr> <tr><td class=Line colSpan=2></td></tr>
    <tr> 
      <td><%=this.getLabel(18493)%><!--文件--></td>
      <td class=Field><input type="file" id="file1" name="file1" class=inputstyle size=60 onChange="dochange(this)">
        <span id="filespan" name="filespan"><img src='/images/BacoError.gif' align='absMiddle'></span ></td>
    </tr>
	<tr><td class="Line" colSpan="3"></td></tr>
</tbody> 
  </table>
<br>
  <table class="viewform" width="100%">
    <tr > 
      <td colspan=2><nobr><b><%=this.getLabel(20774)%><!--报表模板及填报注意事项--></b></td>
    </tr>
   <tr><td class=Line1 colSpan=2></td></tr> 
   <tr> 
      <td width="12%"><%=this.getLabel(258)+this.getLabel(64)%><!--下载模板--></td>
      <td width="88%" class=Field><a href='/datacenter/inputexcellfile/<%=inpreptablename+reportHrmId%>.txt' target="_blank"><%=this.getLabel(19110)+this.getLabel(64)%><!--文本类型模板--></a>&nbsp;
	  <a href='/datacenter/inputexcellfile/<%=inpreptablename+reportHrmId%>.xls' target="_blank"><%=this.getLabel(468)%>Excel<%=this.getLabel(64)%><!--系统Excel文件模板--></a>&nbsp;
	  <%//TD7493
		if(userExcelTemplate!=null){%>
			<a href="/datacenter/inputexcellfile/<%=userExcelTemplate%>" target="_blank"><%=this.getLabel(73)+this.getLabel(64)%></a>
		<%}%>
	  </td>
    </tr> 
    <tr><td class=Line colSpan=2></td></tr>
    <tr> 
      <td width="12%"><%=this.getLabel(15736)%><!--注意事项--></td>
      <td width="88%" class=Field>
        <ol>
		<li><%=SystemEnv.getHtmlLabelName(23253,user.getLanguage()) %></li>
		<li><%=SystemEnv.getHtmlLabelName(23254,user.getLanguage()) %></li>
        <li><%=SystemEnv.getHtmlLabelName(23255,user.getLanguage()) %></li>
        </ol></td>
    </tr> 
    <tr><td class=Line1 colSpan=2></td></tr> 
    </tbody> 
  </table>
  
		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>
<!-- 用来页面转向传递数据用的表单 -->
<form name="redirectForm" id="redirectForm" action="" method="post">
<%=this.getRequestParmHtmlString()%>
</form>
<script language=javascript>
String.prototype.endsWith=function(suffix){
	return this.substring(this.length-suffix.length).toLowerCase()==suffix.toLowerCase();
}

function onReturn(){
	window.history.back(-1);
}

function dochange(obj){
    if(obj.value==""){
        document.getElementById("filespan").innerHTML="<img src='/images/BacoError.gif' align='absMiddle'>";
    }else{
        document.getElementById("filespan").innerHTML="";
    }
}

function dosubmit() {
    if(check_form(document.frmMain,'file1')) {
		var fname=document.getElementById("file1").value;
		var filetype=2;
		if(document.getElementById("txtFile").checked) filetype=1;
		if((filetype==1 && !fname.endsWith(".txt")) || (filetype==2 && !fname.endsWith(".xls"))){
			alert("<%=SystemEnv.getHtmlLabelName(23256,user.getLanguage()) %>");
			return;
		}
		var frm=document.getElementById("redirectForm");
		document.getElementById("redirectFormString").value=frm.innerHTML;
		document.getElementById("returnUrl").value=sUrl;
        document.frmMain.submit() ;
    }
}

var isMutilLine=<%=isMultiLine?"true":"false"%>;
var sUrl=isMutilLine?"InputReportMtiData.jsp":"InputReportData.jsp";
function confirmMsg(){
	//0 不显示，1，显示消息确认框且转向，2 显示消息确认框并设置Hidden，3 显示对话框并直接转向，数据已存在
	var str="<%=strMsg%>";
	var msgFlag=<%=msgFlag%>;
	var frm=document.getElementById("redirectForm");
	frm.action=sUrl;
	switch(msgFlag){
		case 1:
			if(!confirm(str))
				frm.submit();
		break;
		case 2:
			if(confirm(str))
				document.getElementById("isOverWriter").value="true";
			else 
				frm.submit();
		break;
		case 3:
			alert(str);
			frm.submit();
		break;
		default:
		
	}//End switch.
}

confirmMsg();
</script>
</body></html>
