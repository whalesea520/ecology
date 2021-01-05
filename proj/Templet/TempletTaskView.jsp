<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.SQLUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
</HEAD>

<%
int taskTempletId = Integer.parseInt(Util.null2String(request.getParameter("id")));
String loginType = ""+user.getLogintype();
/*权限－begin*/
boolean canMaint = false ;
if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
  canMaint = true ;
}
/*权限－end*/
%>
<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

%>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav = "1";
String needhelp = "";
String sql = "";

String templetId = "";
String taskName = "";
String taskManager = "";
String taskBeginDate = "";
String taskEndDate = "";
String taskWorkDay = "";
String taskBudget = "";
String taskBefTaskID = "";
String taskDesc = "";
String project_accessory = "";//相关附件
String templateStatus = "";//模板状态
String sqlSelectTaskByID = "SELECT t1.*,t2.status as tstatus FROM Prj_TemplateTask t1 left outer join Prj_Template t2 on t2.id=t1.templetId WHERE t1.id="+taskTempletId;
RecordSet.executeSql(sqlSelectTaskByID);

if(RecordSet.next()){
	templetId = RecordSet.getString("templetId");
	taskName = RecordSet.getString("taskName");
	taskManager = RecordSet.getString("taskManager");
	taskBeginDate = RecordSet.getString("beginDate");
	taskEndDate = RecordSet.getString("endDate");
	taskWorkDay = RecordSet.getString("workDay");
	taskBudget = RecordSet.getString("budget");
	taskBefTaskID = RecordSet.getString("befTaskId");
	taskDesc = RecordSet.getString("taskDesc");
	project_accessory = Util.null2String(RecordSet.getString("accessory"));
	templateStatus=Util.null2String(RecordSet.getString("tstatus"));
}


%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String editPrjUrl="/proj/Templet/TempletTaskEdit.jsp?templetid="+templetId+"&id="+taskTempletId;
    if (canMaint&&!"2".equals(templateStatus) ) {      
        RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='ProjTempletView.jsp?templetId="+templetId+"',_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canMaint&&!"2".equals(templateStatus)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%> " class="e8_btn_top" onclick="onEdit()"/>
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
		int fieldhtmltype=v.getInt("fieldhtmltype");
		int type=v.getInt("type");
		String fieldName=v.getString("fieldname");
		String fieldValue="";
		if("actualbegindate".equalsIgnoreCase(fieldName)||"actualenddate".equalsIgnoreCase(fieldName)
				||"realmandays".equalsIgnoreCase(fieldName)||"finish".equalsIgnoreCase(fieldName)
				||"islandmark".equalsIgnoreCase(fieldName)||"prjid".equalsIgnoreCase(fieldName)){
			continue;
		}
		if("fixedcost".equalsIgnoreCase(fieldName) && "2".equals( user.getLogintype())){
			continue;
		}
		if("accessory".equalsIgnoreCase(fieldName)&& (true||!PrjSettingsComInfo.getTsk_acc())){
			continue;
		}
		if("parentid".equalsIgnoreCase( fieldName)&&RecordSet.getInt("parenttaskid")<=0){
			continue;
		}
		
%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
<%
		if("subject".equalsIgnoreCase( fieldName)){
			fieldValue=taskName;
		}else if("fixedcost".equalsIgnoreCase( fieldName)){
			fieldValue=taskBudget;
		}else if("hrmid".equalsIgnoreCase( fieldName)){
			fieldValue=CptFieldManager.getFieldvalue(user, v.getInt("id"), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( taskManager) , 0,true);
		}else if("content".equalsIgnoreCase( fieldName)){
			fieldValue=Util.toScreen(taskDesc, user.getLanguage()) ;
		}else if("parentid".equalsIgnoreCase( fieldName)){
			int parenttaskid=RecordSet.getInt("parenttaskid");
			if(parenttaskid>0){
				String sql_1="select id,taskname from Prj_TaskProcess where templetid="+Util.getIntValue(templetId)+" AND id="+parenttaskid+"";
				RecordSet3.executeSql(sql_1);
		 		if(RecordSet3.next()){
					fieldValue="<a href=\"javascript:openFullWindowForXtable('/proj/Templet/TempletTaskView.jsp?id="+parenttaskid+"')\" >"+Util.null2String( RecordSet3.getString("taskname"))+"</a>";
		 		}
			}
		}else if("prefinish".equalsIgnoreCase( fieldName)){
			int prefinish=Util.getIntValue(taskBefTaskID,0);
			if(prefinish>0){
				String sql_1="SELECT id,taskName FROM Prj_TemplateTask WHERE templetTaskId='"+taskBefTaskID+"' and templetId='"+templetId+"' ";
				RecordSet3.executeSql(sql_1);
				if(RecordSet3.next()){
					fieldValue +="<a href=\"javascript:openFullWindowForXtable('/proj/Templet/TempletTaskView.jsp?id="+RecordSet3.getString("id") +"') \">"+ RecordSet3.getString("taskName")+ "</a>";
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



<script language=javascript>
function onEdit(){
	window.location.href="<%=editPrjUrl %>";
}


function displaydiv_1()
{
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
        WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
    }
    else{
        WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></a>";
        WorkFlowDiv.style.display = "";
    }
}

function doDeletePlan(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.delplan.submit();
    }
}
</script>
</BODY>
</HTML>

