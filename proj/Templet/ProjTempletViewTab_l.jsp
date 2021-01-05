<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="java.net.URLEncoder" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>


<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_cus" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />

<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<%  
    //判断是否具有项目编码的维护权限
    boolean canMaint = false ;
    if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
        canMaint = true ;
    }
    

    String imagefilename = "/images/sales_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	String needfav ="1";
	String needhelp ="";//取得相应设置的值

    
    /*为了兼容项目自定义字段*/
    /**
    boolean hasFF = true;
    RecordSetFF.executeProc("Base_FreeField_Select","p1");
    if(RecordSetFF.getCounts()<=0)
        hasFF = false;
    else
        RecordSetFF.first(); **/

    String preview =Util.null2String( request.getParameter("preview"));
    //String projTypeId = request.getParameter("txtPrjType");
    //int scopid = Util.getIntValue(projTypeId) ;
    String  prjid ="";
    String  crmid="";
    String  hrmid="";
    String docid="";
    String needinputitems = "";
   /*END*/


  int templetId = Util.getIntValue(request.getParameter("templetId"));
  if (templetId==-1) {
    //out.println("页面出现错误,请与管理员联系!");
    return ;
  }
%>

<%
    String  templetName = "";
    String  templetDesc = "";
    int  proTypeId = -1;
    String  workTypeId = "";
    String  proMember = "";
    String  isMemberSee = "";
    String  proCrm = "";
    String  isCrmSee = "";
    String  parentProId = "";
    String  commentDoc = "";
    String  confirmDoc = "";
    String  adviceDoc = "";
    String  Manager = "";
    String project_accessory ="";
    String status ="";
    String  strSql = "select * from Prj_Template where id="+templetId;      
    RecordSet.executeSql(strSql);
    if (RecordSet.next()){
        templetName = Util.null2String(RecordSet.getString("templetName"));
        templetDesc = Util.null2String(RecordSet.getString("templetDesc"));
        proTypeId = Util.getIntValue(RecordSet.getString("proTypeId"));
        workTypeId = Util.null2String(RecordSet.getString("workTypeId"));
        proMember = Util.null2String(RecordSet.getString("proMember"));
        isMemberSee = Util.null2String(RecordSet.getString("isMemberSee"));
        proCrm = Util.null2String(RecordSet.getString("proCrm"));
        isCrmSee = Util.null2String(RecordSet.getString("isCrmSee"));
        parentProId = Util.null2String(RecordSet.getString("parentProId"));
        commentDoc = Util.null2String(RecordSet.getString("commentDoc"));
        confirmDoc = Util.null2String(RecordSet.getString("confirmDoc"));
        adviceDoc = Util.null2String(RecordSet.getString("adviceDoc"));
        Manager = Util.null2String(RecordSet.getString("Manager"));
        project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件
        status = Util.null2String(RecordSet.getString("status"));//模板状态
    }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
<style>

	.spanSwitch{cursor:pointer;font-weight:bold}
	#tblTask table td{padding:0;}
</style>

<style type="text/css">
.InputStyle{width:40%!important;}
.inputstyle{width:40%!important;}
.Inputstyle{width:40%!important;}
.inputStyle{width:40%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>
</HEAD>
<BODY  style="overflow: hidden;" >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String editPrjUrl="/proj/Templet/ProjTempletEdit.jsp?templetId="+templetId+"&isdialog="+isDialog;
if(!"1".equals(preview)&&!"2".equals(status) ){
	if (canMaint) {      
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit("+templetId+"),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;

	    //RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(),_self} " ;
	    //RCMenuHeight += RCMenuHeightStep ;

	    //RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='ProjTempletAdd.jsp',_self} " ;
	    //RCMenuHeight += RCMenuHeightStep ;
	}
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(320,user.getLanguage())+",javascript:location='ProjTempletList.jsp',_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
<%
if(!"1".equals(preview)&&canMaint&&!"2".equals(status) ){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>" class="e8_btn_top middle" onclick="onEdit(<%=templetId %>)"/>
	<%
}
%>			
		
			<span
				title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
				class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv">
	<span style="width:10px"></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
	</span>
</div>

<div class="zDialog_div_content" style="overflow:auto;">

<FORM id=weaver name=weaver action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="method" value="add">
<input type="hidden" name="accdocids" id="accdocids" value="">
<INPUT class=inputstyle maxLength=3 size=3 name="SecuLevel" value=10 type=hidden />

<!-- 项目信息 -->
<div id="nomalDiv">
<wea:layout>
<%
//项目类型自定义字段
String  sql_cus = "select * from prj_fielddata where id='"+templetId+"' and scope='ProjCustomField' and scopeid='"+proTypeId+"' ";
RecordSet_cus.executeSql(sql_cus);
RecordSet_cus.next();

int fieldcount=0;//用来定位字段
int fieldsize=0;//用来定位字段数量
int groupcount=0;//用来定位组
String needHideField=",passnoworktime,";//用来隐藏字段
/**boolean dataornot=true;
if(dataornot){//资产资料
	needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,";
}**/
TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(proTypeId+"");
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	groupcount++;
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	fieldsize=openfieldMap.size();
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		fieldcount++;
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldid=v.getString("id");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		int type=v.getInt("type");
		String fieldName=v.getString("fieldname");
		//System.out.println("fieldname:"+fieldName);
		if("name".equals(fieldName)){//字段名称和项目卡片里的不一致,手动调整
			fieldName="templetname";
		}else if("prjtype".equals(fieldName)){
			fieldName="protypeid";
		}else if("worktype".equals(fieldName)){
			fieldName="worktypeid";
		}else if("description".equals(fieldName)){
			fieldName="procrm";
		}else if("managerview".equals(fieldName)){
			fieldName="iscrmsee";
		}else if("parentid".equals(fieldName)){
			fieldName="parentproid";
		}else if("members".equals(fieldName)||"hrmids02".equals(fieldName)){
			fieldName="promember";
		}else if("isblock".equals(fieldName)){
			fieldName="ismembersee";
		}else if("envaluedoc".equals(fieldName)){
			fieldName="commentdoc";
		}else if("proposedoc".equals(fieldName)){
			fieldName="advicedoc";
		}else if("protemplateid".equals(fieldName)){//模板字段不需要
			continue;
		}else if("status".equals(fieldName)){//模板字段不需要
			continue;
		}else if("procode".equals(fieldName)){//模板字段不需要
			continue;
		}
		
		String fieldkind=v.getString("fieldkind");
		String fieldValue="";
		if("2".equals(fieldkind)){
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				fieldValue=PrjFieldManager.getBrowserFieldvalue(user,Util.null2String( RecordSet_cus.getString(fieldName)),v.getInt("type"),v.getString("fielddbtype"),true);
			}else{
				fieldValue=PrjFieldManager.getFieldvalue(user, Util.getIntValue( fieldid.replace("prjtype_", "") ), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet_cus.getString(fieldName)) , 2,true);
			}
		}else{
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				fieldValue=PrjFieldManager.getBrowserFieldvalue(user,Util.null2String( RecordSet.getString(fieldName)),v.getInt("type"),v.getString("fielddbtype"),true);
			}else{
				fieldValue=PrjFieldManager.getFieldvalue(user, Util.getIntValue( v.getString("id")), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet.getString(fieldName)) , 0,true);
			}
		}
		
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		
		
		
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
	<%
		if("promember".equals(fieldName)){
			%>
			<span id="prjstatus_span" style="display:block;word-break:break-all;"><%=fieldValue %></span>
			<%
		}else {
			%>
			<%=fieldValue %>
			<%
		}
		%>
		
	</wea:item>


<%
if(false&&PrjSettingsComInfo.getPrj_acc() && fieldcount==fieldsize && groupcount==1){//项目卡片附件
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
		<wea:item>
			<%
			String fjnamestr = "";
			if(!"".equals(project_accessory)){
		      String[] fjmultiID = Util.TokenizerString2(project_accessory,",");
	          
			  int linknum=-1;
			  for(int j=0;j<fjmultiID.length;j++){			  									
				String sql = "select id,docsubject,accessorycount from docdetail where id ="+fjmultiID[j]+" order by id asc";
				rs.executeSql(sql);
				linknum++;
				if(rs.next()){
				  String showid = Util.null2String(rs.getString(1)) ;
				  String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
				  int accessoryCount=rs.getInt(3);
				  DocImageManager.resetParameter();
				  DocImageManager.setDocid(Integer.parseInt(showid));
				  DocImageManager.selectDocImageInfo();
				  String docImagefilename = "";
				  if(DocImageManager.next()){
					//DocImageManager会得到doc第一个附件的最新版本
					docImagefilename = DocImageManager.getImagefilename();
				  }
				  fjnamestr += "<a href='/docs/docs/DocDsp.jsp?id="+fjmultiID[j]+"' target='_blank'>"+docImagefilename+"</a>&nbsp;";
			    }			
			  }
			}
	        %>
		
			<%=Util.toScreen(fjnamestr,user.getLanguage())%>
			
		</wea:item>
	
	<%
}

%>


<%
	}
}

%>
</wea:group>
	<%
}
%>
 	
</wea:layout>





</div>
<!-- 任务列表 -->
<div id="agendaDiv" style="display:none;">
  
  <iframe id="taskDataIframe" name="taskDataIframe" src="/proj/Templet/ProjTempletViewData.jsp?templetId=<%=""+templetId %>" class="flowFrame" frameborder="0" scrolling="auto" height="500px" width="100%"></iframe>
  
  <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <div id="divTaskList" style="display:none;"></div>
  
  
  
  
</div>
<div id="temp_seleBeforeTask_DIV" style="display:none"><select name='temp_seleBeforeTask' class='inputStyle'><option value='0'></option></select></div>
</FORM>

</div>

<%
if("1".equals( isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">

				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	
	<%
}
%>
<script language=javascript>

function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		Dialog.alert(errormsg);
		isValid = false;
	}
	return isValid;
}


/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0] + " " +time1;
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}



function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>



</body>
</html>
<script language="javaScript">
 function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down_wev8.jpg";
        imgObj.title="<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>";
        imgObj.objStatus="hidden";
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up_wev8.jpg";
        imgObj.title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";
       imgObj.objStatus="show";      
     }
 }
 function del(){
 if(confirm("<%=SystemEnv.getHtmlLabelName(20903,user.getLanguage())%>"))
   window.location.href="ProjTempletOperate.jsp?method=delete&templetId=<%=templetId%>";
 }

 function ajaxinit(){
	    var ajax=false;
	    try {
	        ajax = new ActiveXObject("Msxml2.XMLHTTP");
	    } catch (e) {
	        try {
	            ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	            ajax = false;
	        }
	    }
	    if (!ajax && typeof XMLHttpRequest!='undefined') {
	    ajax = new XMLHttpRequest();
	    }
	    return ajax;
	}
	function showdata(){
	    var ajax=ajaxinit();
	    ajax.open("POST", "ProjTempletViewData.jsp?templetId=<%=templetId%>", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send(null);
	    //获取执行状态
	    ajax.onreadystatechange = function() {
	        //如果执行状态成功，那么就把返回信息写到指定的层里
	        if (ajax.readyState == 4 && ajax.status == 200) {
	            try{
	                document.getElementById('TaskDataDIV').innerHTML = ajax.responseText;
	            }catch(e){
	            	alert(e.description);
	                return false;
	            }
	        }
	    }
	}
	//showdata();
</script>

<script language="javascript">


function onShowMProj(spanname,inputname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
	if(datas.id){
		$($GetEle(spanname)).html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"' target=_blank>"+datas.name+"</A>");
		$GetEle(inputname).value=datas.id;
	}else {
		$($GetEle(spanname)).empty();
		$GetEle(inputname).value="0"
	}}
}

function onShowHrm(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (datas){
		if(datas.id){
			$($GetEle(spanname)).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"' target=_blank>"+datas.name+"</A>");
			$GetEle(inputename).value=datas.id;
		}else{ 
			if(needinput == "1"){
				$($GetEle(spanname)).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$($GetEle(spanname)).html("");
			}
		
			$GetEle(inputename).value=""
		}
	}
}
function onShowProjectID(objval){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
		if(datas.id){
			$("#projectidspan").html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"' target=_blank>"+datas.name+"</A>");
			weaver.projectid.value=datas.id;
		}else{ 
			if(objval=="2"){
				$("#projectidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$("#projectidspan").html("");
			}
			weaver.projectid.value="0";
		}
	}
}


function onShowMeetingHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
	    if(datas){
	        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
		         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
					return;
			 }else if(datas.id){
				resourceids = datas.id;
				resourcename =datas.name;
				sHtml = "";
				resourceids=resourceids.substr(1);
				resourceids =resourceids.split(",");
				$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
				resourcename =resourcename.substr(1);
				resourcename =resourcename.split(",");
				for(var i=0;i<resourceids.length;i++){
					if(resourceids[i]&&resourcename[i]){
						sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
					}
				}
				$("#"+spanname).html(sHtml);
	        }else{
				$GetEle(inputename).value="";
				$($GetEle(spanname)).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	        }
	    }
}
function onShowMHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
    if(datas){
        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
	         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
				return;
		 }else if(datas.id){
			resourceids = datas.id;
			resourcename =datas.name;
			sHtml = "";
			resourceids =resourceids.split(",");
			$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
			resourcename =resourcename.split(",");
			for(var i=0;i<resourceids.length;i++){
				if(resourceids[i]&&resourcename[i]){
					sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
				}
			}
			$("#"+spanname).html(sHtml);
        }else{
			$GetEle(inputename).value="";
			$($GetEle(spanname)).html("");
        }
    }
 }

function onShowMCrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id!=""){
					resourceids = datas.id.substr(1);
					resourcename =datas.name.substr(1);
					sHtml = "";
					$GetEle(inputename).value= resourceids;
					//$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
					resourceids =resourceids.split(",");
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+resourceids[i]+" target=_blank>"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}


function onShowMHrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id){
					resourceids = datas.id;
					resourcename =datas.name;
					sHtml = "";
					resourceids =resourceids.split(",");
					$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}


function onEdit(id){
	if(id){
		var currenttab=jQuery("#currentTab",parent.document).val();
		//alert("currenttab:"+currenttab);
		window.parent.location.href="<%=editPrjUrl %>"+"&currentTab="+currenttab;
	}
}

function openHrefWithChinese(url){
    url = dealChineseOfFieldParams(url);
    window.open(url);
}

//encodeURIComponent
function dealChineseOfFieldParams(url){
	if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
		return url;
	}
	var params = "";
	var path = url.substring(0,url.indexOf("?")+1);
	var filedparams = url.substring(url.indexOf("?")+1);
	var fieldparam = filedparams.split("&");
	 for(var i=0;i<fieldparam.length;i++) {
		var tmpindex = fieldparam[i].indexOf("=");
		if(tmpindex != -1) {
			var key = fieldparam[i].substring(0, tmpindex);
			var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
			params+="&"+key+"="+value
		}
	} 
	return path+params.substring(1);
}

function btn_cancle(){
		window.parent.closeDialog();
	}
jQuery(document).ready(function(){
	resizeDialog(document);
});

$(function(){
	try{
		parent.setTabObjName('<%=templetName %>');
	}catch(e){}
});
</script>
<script type="text/javascript">
jQuery(function(){
	hideEle('hideField');
});
</script>
