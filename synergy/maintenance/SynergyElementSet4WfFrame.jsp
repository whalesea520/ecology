
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageElementCominfo"></jsp:useBean>
<%@ page import="java.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="spc" class="weaver.synergy.SynergyParamsComInfo" scope="page" />
<jsp:useBean id="sgwff" class="weaver.synergy.SynergyGetWFField" scope="page" />
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page" />
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String tabid = Util.null2String(request.getParameter("tabid"));
	String esharelevel = Util.null2String(request.getParameter("esharelevel"));
	//baseBean.writeLog("esharelevel"+esharelevel);
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String wfids = Util.null2String(request.getParameter("wfids"));
	//baseBean.writeLog("wfids==="+wfids);
	String hpid = "";
	if(null==request.getParameter("hpid")){
		hpid = hpc.getHpid(ebaseid);
	}else{
		hpid = Util.null2String(request.getParameter("hpid"));
	}
	String wfid = Util.null2String(request.getParameter("wfid"));
	String subcompanyid = Util.null2String(request.getParameter("subCompanyId"));
	String stype = Util.null2String(request.getParameter("stype"));
	String spagetype = Util.null2String(request.getParameter("spagetype"));
	String saddpage = Util.null2String(request.getParameter("saddpage"));
	//是否为处理页面
	String ispagedeal = Util.null2String(request.getParameter("ispagedeal"));
	//页面类型 流程或文档
	String pagetype = Util.null2String(request.getParameter("pagetype"));

	String id ="";
	String workflowname="";
	Map<String, String> map = new HashMap<String, String>();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript"><!--
function showSynParamSetting(eid,ebaseid,wfid){
	var ePerpageValue=5;
 	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=800;//定义长度
	dlg.Height=460;
	dlg.URL="/synergy/maintenance/SynergyElementSet4WfParam.jsp?ispagedeal=<%=ispagedeal%>&pagetype=<%=pagetype%>&eid="+eid+"&ebaseid="+ebaseid+"&wfid="+wfid+"&from=wfex&subCompanyId=<%=subcompanyid%>&tabid=<%=tabid%>&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=saddpage%>";
	dlg.Title="元素参数设置";
	dlg.callbackfun=function(datas){
		if(datas){
			var postObj={};
			postObj.SynergyParamXML=datas;
			$.post('/synergy/browser/operationCommon.jsp?eid='+eid+'&ebaseid='+ebaseid+'&wfid='+wfid+'&ePerpageValue='+ePerpageValue+'&esharelevel=<%=esharelevel%>&tabid=<%=tabid%>&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=saddpage%>', postObj,function(data){
						  if($.trim(data)=="") 	{
							  //$("#setting_"+eid).hide();
							  //$("#setting_"+eid).remove(); 
							  if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
							  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'submit',eid:eid},function(data){
							  	 	if($.trim(data)==""){
							  	 		//$("#item_"+eid).attr('needRefresh','true')
							  	 		//$("#item_"+eid).trigger("reload");
							  	 	}
							  	 });
							  }else{
							  	 //$("#item_"+eid).attr('needRefresh','true')
							  	 //$("#item_"+eid).trigger("reload");
							  }
			    		  }
					}
			);
		}
		dlg.close();
	}
	dlg.show();
}

function onClose(){
	var dialog =  parent.parent.getDialog(parent);
	dialog.callbackfun();
}
</script>
</HEAD>
<BODY>
<div style="height:100%;width:100%;overflow-y:auto;">
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;margin-bottom: 50px" width="100%">
<TR class=DataHeader>
      <TH width=35%><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></TH>        
      <TH width=30%><%=SystemEnv.getHtmlLabelName(17632, user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
		<%
		if(!wfids.equals("")){
			rs.executeSql("SELECT id,workflowname,version from workflow_base where id in ("+wfids+") order by workflowname, id");
			baseBean.writeLog("sql=="+"SELECT id,workflowname,version from workflow_base where id in ("+wfids+") order by workflowname, id");
			while(rs.next()){
				id = Util.null2String(rs.getString("id"));
				workflowname = Util.null2String(rs.getString("workflowname")) + "(V" + (!"".equals(Util.null2String(rs.getString("version"))) ? Util.null2String(rs.getString("version")) : 1) + ")";
				map.put(id,workflowname);
			
		%>
			<tr style="height: 30px ;line-height: 30px; "><td style="padding-left: 15px"><%=workflowname%></td>
			<td style="padding-left: 15px"><a href="#" onclick="showSynParamSetting('<%=eid%>','<%=ebaseid%>','<%=id%>')">参数设置</a></td></tr>
		<%
			}
		}
		%>
</TABLE>
</div>
        <div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align:center;buttom:0px">
		     <input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"  class="zd_btn_cancle" onclick="onClose();"/>
		</div>
</BODY>
</HTML>
