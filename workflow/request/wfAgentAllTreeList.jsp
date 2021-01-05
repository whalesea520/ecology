
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.request.WFAgentTreeUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
 <%@ include file="/systeminfo/init_wev8.jsp" %>

<% 
String isrefreshTree  = Util.null2String(request.getParameter("isrefreshTree"));   
WFAgentTreeUtil  manager=new WFAgentTreeUtil();
String  agentFlag=request.getParameter("agentFlag");
String  treeData=manager.getAgentTreeList(user.getUID()+"",agentFlag);
//刷新树功能
if(isrefreshTree.equals("y"))
{
	//System.out.println("treeDate:"+treeData);
	out.clear();
	out.print(treeData);
	return;
}
String titlename = ""+SystemEnv.getHtmlLabelName(21979,user.getLanguage());

%>

<html>
     <head>
    </head>
     <body>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
<tr><td class="leftTypeSearch">
	<div class="topMenuTitle" style="border-bottom:none;">
		<span class="leftType">
		<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
		<span>
			<div style="width:auto;height:auto;position:relative;">
				<span id="optionSpan"><%=titlename%></span>
			</div>
		</span>
		<span id="totalDoc"></span>
		</span>
		<span class="leftSearchSpan">
			<input type="text" class="leftSearchInput" style="width:110px;"/>
		</span>
	</div>
</td>
</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:100%;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>

 <script type="text/javascript">
    var treeData=<%=treeData%>;

	var	numberTypes={
		flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(84379,user.getLanguage())%>"},
		flowResponse:{hoverColor:"#FFC600",color:"#FFC600",title:" <%=SystemEnv.getHtmlLabelName(84506,user.getLanguage())%>"},
	             flowAll:{hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84382,user.getLanguage())%>"}

  	};
	$(".ulDiv").leftNumMenu(treeData,{
		numberTypes:numberTypes,
		showZero:false,
		menuStyles:["menu_lv1",""],
		clickFunction:function(attr,level,numberType){
			   var frame=$("#contentframe",parent.document);
	           var method=attr.method;
			   var objid=attr.objid;
			   var agentFlag=attr.agentFlag;
			   frame.attr("src","/workflow/request/wfAgentAll.jsp?menutype="+method+"&menuid="+objid+"&agentFlag="+agentFlag+"&agented=1");
		}
	});
	
	function refreshTree(ag)
	{
		var req;
    	if (window.XMLHttpRequest) {
        	req = new XMLHttpRequest(); 
    	}
    	else if (window.ActiveXObject){ 
        	req = new ActiveXObject("Microsoft.XMLHTTP"); 
        }
        if(req){
            req.open("post","/workflow/request/wfAgentAllTreeList.jsp?agentFlag="+ag+"&isrefreshTree=y",true);
            req.onreadystatechange = function() {
            	if (req.readyState == 4 && req.status == 200) {
            		
            		$(".ulDiv").html("");
            		treeData = jQuery.parseJSON(req.responseText);
					$(".ulDiv").leftNumMenu(treeData,{
					numberTypes:numberTypes,
					showZero:false,
					menuStyles:["menu_lv1",""],
					clickFunction:function(attr,level,numberType){
						   var frame=$("#contentframe",parent.document);
				           var method=attr.method;
						   var objid=attr.objid;
						   var agentFlag=attr.agentFlag;
						   frame.attr("src","/workflow/request/wfAgentAll.jsp?menutype="+method+"&menuid="+objid+"&agentFlag="+agentFlag+"&agented=1");
						}
					});
            	}
            }; 
            req.send(null);
        }
	}
</script>

	   
	 </body>
</html>