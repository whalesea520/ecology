<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page" />
<jsp:useBean id="docrs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="docrs1" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />
<jsp:useBean id="KnowledgeTransMethod" class="weaver.general.KnowledgeTransMethod" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />
<%
String taskid = Util.null2String(request.getParameter("taskrecordid"));
String isfromProjTab = Util.null2String(request.getParameter("isfromProjTab"));
if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/proj/process/PrjTaskTab.jsp?taskid="+taskid);
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<LINK href="/js/ecology8/base/jquery.ui.all_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/ecology8/base/jquery.ui.progressbar_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<style>
.progress-label {
     float: left;
     margin-left: 50%;
     margin-top: 5px;
     font-weight: bold;
     text-shadow: 1px 1px 0 #fff;
}
.ui-progressbar{ 
background : ; 
padding:1px; 
}	
.ui-progressbar-value{ 
background : #A5E994; 
} 
</style>

</HEAD>

<%
char flag = 2;
String ProcPara = "";
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));

//td8154 
   //文档部分
  docrs.executeSql("select * from prj_doc t1,docdetail t2  where taskid="+taskrecordid+" and t1.docid=t2.id");
  while(docrs.next()){
    int docedition=docrs.getInt("docedition");
    int doceditionid=docrs.getInt("doceditionid");
    int ishistory=docrs.getInt("ishistory");
    int docid=docrs.getInt("docid");
    if(doceditionid>-1&&ishistory==1){
        docrs1.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and (docstatus=1 or docstatus=2) order by docedition desc ");
        while(docrs1.next()){      
            int newDocId = docrs1.getInt("id");
            docrs1.executeSql("update prj_doc set docid="+newDocId+" where docid="+docid);
       }
    }    
  }
  //参考文档部分
  docrs.executeSql("select * from Prj_task_referdoc t1,docdetail t2  where taskid="+taskrecordid+" and t1.docid=t2.id");
  while(docrs.next()){
    int docedition=docrs.getInt("docedition");
    int doceditionid=docrs.getInt("doceditionid");
    int ishistory=docrs.getInt("ishistory");
    int docid=docrs.getInt("docid");
    if(doceditionid>-1&&ishistory==1){
        docrs1.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and (docstatus=1 or docstatus=2) order by docedition desc ");
        while(docrs1.next()){      
            int newDocId = docrs1.getInt("id");
            docrs1.executeSql("update Prj_task_referdoc set docid="+newDocId+" where docid="+docid);
       }
    }    
  }


//==============================================================================================	
//TD3732
//added by hubo,2006-03-14
if(taskrecordid.equals("")){
	RecordSet.executeSql("SELECT id FROM Prj_TaskProcess WHERE prjid="+Util.getIntValue(request.getParameter("prjid"))+" AND taskindex="+Util.getIntValue(request.getParameter("taskindex"))+"");
	if(RecordSet.next())	taskrecordid = String.valueOf(RecordSet.getInt("id"));
}
//==============================================================================================
//RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
String sql="select t1.*,t2.subject as parentname from Prj_TaskProcess t1 left outer join Prj_TaskProcess t2 on t1.parentid=t2.id where t1.id="+taskrecordid;
RecordSet.executeSql(sql);
RecordSet.next();
String ProjID = RecordSet.getString("prjid");
String project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件
int prjstatus=Util.getIntValue( ProjectInfoComInfo.getProjectInfostatus(ProjID),0);
//==============================================================================================
//TD4080
//added by hubo,2006-04-12
int relatedRequestId = Util.getIntValue(request.getParameter("requestid"),-1);
if(relatedRequestId!=-1){
	response.sendRedirect("/proj/process/RequestOperation.jsp?method=add&type=2&ProjID="+ProjID+"&taskid="+taskrecordid+"&requestid="+relatedRequestId+"");
}
int relatedDocId = Util.getIntValue(request.getParameter("docid"),-1);
if(relatedDocId!=-1){
	response.sendRedirect("/proj/process/DocOperation.jsp?method=add&type=2&ProjID="+ProjID+"&taskid="+taskrecordid+"&docid="+relatedDocId+"");
}
//==============================================================================================

int taskStatus = RecordSet.getInt("status");


/*项目状态*/
 RecordSet rs = new RecordSet();
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划
String status_prj="" ;
String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
rs.executeSql(sql_prjstatus);
if(rs.next())
 status_prj=rs.getString("status");
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结


String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";


//4E8 项目任务权限等级(默认共享的值设置:成员可见0.5,项目经理2.5,项目经理上级2.1,项目管理员2.2;项目手动共享值设置:查看1,编辑2;任务负责人:2.8;项目任务手动共享值设置:查看0.8,编辑2.3;)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjTskPermissionType(taskrecordid, user) ,0.0);
if(ptype>=2.0){
	canedit=true;
	canview=true;
}else if(ptype>=0.5){
	canview=true;
}
boolean isResponser=false;
if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
  isResponser=true;
}
if(canedit || isResponser){
	canview=true;
}
if(!canview && !CoworkDAO.haveRightToViewTask(Integer.toString(user.getUID()),taskrecordid)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

%>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>




<%
//项目完成和冻结时不允许编辑,项目任务待审批时不允许修改和删除
boolean canEditAndDel=(canedit || isResponser)&&!status_prj.equals("3")&&!status_prj.equals("4")&&!status_prj.equals("6")&&(taskStatus == 0 || taskStatus == 2)&&taskStatus!=2;
String editPrjUrl="/proj/process/EditTask.jsp?taskrecordid="+taskrecordid+"&ProjID="+ProjID;

if(canEditAndDel){%>
<FORM id=delplan name=delplan action="/proj/process/TaskOperation.jsp" method=post>
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
<input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
<input type="hidden" name="method" value="del">
</form>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit("+taskrecordid+")"+",_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDeletePlan();,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canEditAndDel){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%> " class="e8_btn_top" onclick="onEdit(<%=taskrecordid %>)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%> " class="e8_btn_top" onclick="doDeletePlan(<%=taskrecordid %>)"/>
			<%
		}
		%>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout>
<%
TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap();
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
%>	
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>
<%
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldName=v.getString("fieldname");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		int type=v.getInt("type");
		String fieldValue="";
		if(("actualbegindate".equalsIgnoreCase(fieldName)
				||"actualenddate".equalsIgnoreCase(fieldName)
				||"finish".equalsIgnoreCase(fieldName)
				||"realmandays".equalsIgnoreCase(fieldName))&&(prjstatus==0||prjstatus==6||prjstatus==7) ){
			continue;
		}
		if("fixedcost".equalsIgnoreCase(fieldName) && "2".equals( user.getLogintype())){
			continue;
		}
		if("accessory".equalsIgnoreCase(fieldName)&& !PrjSettingsComInfo.getTsk_acc()){
			continue;
		}
		if("parentid".equalsIgnoreCase(fieldName)&&Util.getIntValue(RecordSet.getString("parentid")  ,0)<=0){
			continue;
		}
		if("islandmark".equalsIgnoreCase(fieldName)&&Util.getIntValue(RecordSet.getString("parentid")  ,0)>0){
			continue;
		}

		if(fieldlabel==1322){
			fieldlabel = 742;
		}else if(fieldlabel==741){
			fieldlabel = 743;
		}else if(fieldlabel==33351){
			fieldlabel = 24162;
		}else if(fieldlabel==24697){
			fieldlabel = 24163;
		}
		
%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
<%
		if("parentid".equalsIgnoreCase( fieldName)){
			if(RecordSet.getInt("parentid")>0){
				fieldValue="<a href=\"javascript:openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="+RecordSet.getString("parentid")+"')\" >"+Util.null2String( RecordSet.getString("parentname"))+"</a>";
			}
		}else if("finish".equalsIgnoreCase( fieldName)&&prjstatus!=0&&prjstatus!=6&&prjstatus!=7){
            String tskenddate= RecordSet.getString("enddate");
            if ("".equals(tskenddate)) {
                tskenddate="1970-01-01";
            }
			fieldValue="<div style=\"width:30%!important;\">"+KnowledgeTransMethod.getPercent(""+Util.getIntValue(RecordSet.getString("finish"),0), ProjectTransUtil.getPrjTaskProgressbar(""+Util.getIntValue(RecordSet.getString("finish"),0),tskenddate ) ) +"</div>";
		}else if("islandmark".equalsIgnoreCase( fieldName)&&"1".equals( RecordSet.getString("level_n"))){
			fieldValue= CptFieldManager.getFieldvalue(user, v.getInt("id"), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet.getString(v.getString("fieldname"))) , 0,true);
		}else if("prefinish".equalsIgnoreCase( fieldName)){
			int prefinish=Util.getIntValue(RecordSet.getString("prefinish"),0);
			if(prefinish>0){
				String sql_1="select id,subject from Prj_TaskProcess where prjid="+Util.getIntValue(ProjID)+" AND taskIndex="+prefinish+"";
				RecordSet3.executeSql(sql_1);
		 		if(RecordSet3.next()){
			 		fieldValue ="<a href=\"javascript:openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="+RecordSet3.getInt("id")+"')\" >"+ RecordSet3.getString("subject")+ "</a>";
		 		}
			}
			
			
		}else if("accessory".equalsIgnoreCase(fieldName)){
			String[] fjmultiID = Util.TokenizerString2(project_accessory,",");
	          String fjnamestr = "";
			  int linknum=-1;
			  for(int j=0;j<fjmultiID.length;j++){			  									
				sql = "select id,docsubject,accessorycount from docdetail where id ="+fjmultiID[j]+" order by id asc";
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
				  fjnamestr += "<a href=\"javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+fjmultiID[j]+"')\" >"+docImagefilename+"</a>&nbsp;";
			    }			
			  }
			  fieldValue=Util.toScreen(fjnamestr,user.getLanguage());
		}else if("begindate".equalsIgnoreCase( fieldName)){
			fieldValue = RecordSet.getString("begindate")+" "+RecordSet.getString("begintime");
		}else if("enddate".equalsIgnoreCase( fieldName)){
			fieldValue = RecordSet.getString("enddate")+" "+RecordSet.getString("endtime");
		}else if("actualbegindate".equalsIgnoreCase( fieldName)){
			fieldValue = RecordSet.getString("actualbegindate")+" "+RecordSet.getString("actualbegintime");
		}else if("actualenddate".equalsIgnoreCase( fieldName)){
			fieldValue = RecordSet.getString("actualenddate")+" "+RecordSet.getString("actualendtime");
		}else{
			fieldValue= CptFieldManager.getFieldvalue(user, v.getInt("id"), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet.getString(v.getString("fieldname"))) , 0,true);
		
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				fieldValue=CptFieldManager.getBrowserFieldvalue(user,Util.null2String( RecordSet.getString(fieldName)),v.getInt("type"),v.getString("fielddbtype"),true);
			}else{
				fieldValue=CptFieldManager.getFieldvalue(user, Util.getIntValue( v.getString("id")), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet.getString(fieldName)) , 0,true);
			}
		}

		
%>			
		<wea:item><%=fieldValue %></wea:item>
<%
	}
}	
%>
</wea:group>
<%
	
}


%>


</wea:layout>




<script type="text/javascript">
function onEdit(id){
	if(id){
		window.location.href="<%=editPrjUrl %>";
	}
}
function doDeletePlan(){
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("83925",user.getLanguage())%>",function(){
    	document.delplan.submit();
    });
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

</script>

</BODY>
</HTML>

