
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="java.util.*,java.sql.Timestamp"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="java.util.Date"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include
	file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp"%>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportComInfo"
	class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager"
	scope="page" />
<HTML>
	<HEAD>
		<%
			String colnum4show = "onecol";//Util.null2String(request.getParameter("colnum4show"));
			String offical = "1";//Util.null2String(request.getParameter("offical"));
			int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
			//当该参数为空时，直接return掉，并重置location
			if(colnum4show.equals("")){
				//收集所有的requrest.笨办法，不好意思

				int __fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
				String __selectedContent = Util.null2String(request.getParameter("selectedContent"));
				int __infoId = Util.getIntValue(request.getParameter("infoId"),0);
				String __needPopupNewPage = Util.null2String(request.getParameter("needPopupNewPage"));
				String __needall=Util.null2String(request.getParameter("needall"));
				String __prjid = Util.null2String(request.getParameter("prjid"));
				String __docid = Util.null2String(request.getParameter("docid"));
				String __crmid = Util.null2String(request.getParameter("crmid"));
				String __hrmid = Util.null2String(request.getParameter("hrmid"));
				String __topage = Util.null2String(request.getParameter("topage"));
				String __isec = Util.null2String(request.getParameter("isec"));
				int __sedtodo = Util.getIntValue(request.getParameter("usedtodo"),-1);
				//System.out.println("__sedtodo"+__sedtodo);
			%>
				<script type="text/javascript">
				var colNum = parent.getcookie("wfnewCol");
					if(colNum==="")colNum = "mulitcol";
					var src = "/workflow/request/RequestTypeShow.jsp?offical=<%=offical%>&colnum4show="+colNum+
					"&fromadvancedmenu=<%=__fromAdvancedMenu%>"+
					"&selectedContent=<%=__selectedContent%>"+
					"&infoId=<%=__infoId%>"+
					"&needPopupNewPage=<%=__needPopupNewPage%>"+
					"&needall=<%=__needall%>"+
					"&prjid=<%=__prjid%>"+
					"&docid=<%=__docid%>"+
					"&crmid=<%=__crmid%>"+
					"&hrmid=<%=__hrmid%>"+
					"&topage=<%=__topage%>"+
					"&isec=<%=__isec%>"+
					"&usedtodo=<%=__sedtodo%>";
					window.location=src;
				</script>
		<% 
			return;
			}%>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		


		<script type="text/javascript">
			jQuery(function(){
				jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	  		 	jQuery("#hoverBtnSpan").hoverBtn(); 	
				jQuery("a.actooLong").each(function(i,item){
					var title = jQuery.trim($(item).html());
					$(item).attr("title",title);
					if(title.length > 14) {
						$(item).html(title.substr(0,14)+"...");
					}
				})	  		 	
			});
			function onBtnSearchClick(){
				var searchText=parent.jQuery("#searchInput").val();

				var searchLength=searchText.length;

				//var searchHtml="<font color='red'>"+searchText+"</font>";

				var innerSearchText=searchText.toLowerCase();
				var innerText="";
				var bindex="";
				var searchStr="";
				var innerHtml="";

				jQuery(".titlecontent label").each(function (){
					var text=jQuery(this).text();
					if(searchLength>0){
						innerText=text.toLowerCase();
						bindex=innerText.indexOf(innerSearchText);
						
						if(bindex!=-1){
							searchStr=text.substr(bindex,searchLength);
							innerHtml="<label class='search_view' style='background-color: #003667'><font color='#ffffff'>"+searchStr+"</font></label>";

							text=text.replace(searchStr,innerHtml);
						}
					}
					jQuery(this).html(text);
					
				});
				jQuery(".fontItem a").each(function (){
					var text=jQuery(this).text();
					if(searchLength>0){
						innerText=text.toLowerCase();
						bindex=innerText.indexOf(innerSearchText);
						
						if(bindex!=-1){
							searchStr=text.substr(bindex,searchLength);
							innerHtml="<label class='search_view' style='background-color: #003667'><font color='#ffffff'>"+searchStr+"</font></label>";

							text=text.replace(searchStr,innerHtml);
						}
					}
					jQuery(this).html(text);	
				});
				jQuery(".commian label").each(function (){
					var text=jQuery(this).text();
					if(searchLength>0){
						innerText=text.toLowerCase();
						bindex=innerText.indexOf(innerSearchText);
						
						if(bindex!=-1){
							searchStr=text.substr(bindex,searchLength);
							innerHtml="<label class='search_view' style='background-color: #003667'><font color='#ffffff'>"+searchStr+"</font></label>";

							text=text.replace(searchStr,innerHtml);
						}
					}
					jQuery(this).html(text);
				});
				//获取页面可见高度
			//	var height_view=document.body.clientHeight;
				//获取页面真实高度
			//	var height_real=document.body.scrollHeight;

			//	console.log("height_view:"+height_view);
			//	console.log("height_real:"+height_real);
				
				//获取匹配标签的最小位置

				//var top_min=height_real;
				var top_min=-1;
				//标签的绝对位置

				var top_real;
				//标签dom对象
				var label;
				//标签parent对象
				var label_Parent;
				jQuery(".search_view").each(function (){
					label=this;
					top_real=label.offsetTop;
					while(label.offsetParent!=null){
						label_Parent = label.offsetParent;
						top_real+=label_Parent.offsetTop ;
						label=label_Parent;
					}
				//	console.log("top_real:"+top_real);
					if(top_min==-1){
						top_min=top_real;
					}
					if(top_min>top_real){
						top_min=top_real;
					}
				})
			//	console.log("top_min:"+top_min);
				
				//滚动条滑动

				if(top_min!=-1){
					window.scrollTo(0,top_min);
				}
			}
		</script>
        <style>
           .listbox2 ul {
             margin: 0 0 0 0;
             padding: 0px;
             list-style: none;
      /**       border-top: 1px solid #ccc;**/
            }

            .listbox2 {
             width:220px;
          /**   border: 1px solid #ccc; **/
			 margin-bottom: 64px;
			 margin-right:32px;
			 height:273px;
			 float:left;
			 /*border:1px solid #efefef;*/
             }

            .listbox2 .titleitem{
			height: 45px;
            line-height: 45px;
            text-align:center;
            font-weight: bold;
			background-image:url(/images/ecology8/rightbg_wev8.png);
			background-repeat:no-repeat;
			background-position:100% 0;
			border-bottom:2px solid #e25453;
			position:relative;
			}
			
			.titlecontent{
				color:#E15352;
				width:198px;
				height:49px;
				border-left:1px solid #efefef;
				border-top:1px solid #efefef;
			}
			
			.e8rightborderoffical{
				position:absolute;
				height:17px;
				border-right:1px solid #efefef;
				width:38px;
				right:0;
				bottom:0;
			}
			
			.mainContent{
				border:1px solid #efefef;
				height:224px;
				background-color:#f9f9f9;
			}
			
			.centerItem{
				border:none!important;
			}
			
			.fontItem{
				padding-left:10px;
			}
         
		    TABLE.ViewForm TD {
              padding: 0 0 0 5;
			  BACKGROUND-COLOR: white;
            }

		    .listbox2 ul li a{
		     color: black;
			 margin-left:8px;
			 margin-right:12px;
		    }

          .listbox2 ul li {
             height: 30px;
             line-height: 30px;
			/* border-bottom:1px dashed #f0f0f0;*/
			 padding-left: 0px;
		/**	 background-image:url(http://localhost:9090/images/ecology8/top_icons/1-1_wev8.png);
			 background-position:0px 50%;
			 background-repeat:no-repeat no-repeat;**/
            }
          

		   TABLE.ViewForm A:link {
			  COLOR: #000;
			  vertical-align: middle;
			  line-height: 24px;
           }
           
           a:hover{
           	color:#E15352!important;
           }
           
           .ViewForm .commonitem{
			 /**  border: 1px solid #ccc;**/
			   margin-bottom: 32px;
			   width: 99.7%;
		 
		   }

			TABLE.ViewForm TD {
				padding: 0px;
				BACKGROUND-COLOR: white;
			}
			
			.ViewForm .commonitem .commonitemtitle{
				height: 26px;
				line-height: 26px;
			/**	background: #F7F7F7;**/
				font-weight: bold;
				border-bottom: 2px solid #E25453;
			/**	padding-left: 10px;**/
			}
			
			.ViewForm .increamentinfo{
			  color:grey;
			  margin-left: 10px;
			}
			#warn{
				width: 260px;
				height: 65px;
				line-height:65px;
				background-color: gray;
				position: absolute;
				display:none;
				text-align:center;
				background: url("/images/ecology8/addWorkGround_wev8.png");
			}
			.commian{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
				border-bottom:2px solid #9e17b6;
			}

			TABLE.ViewForm TR {
           height: 30px  !important;
            }	
				 
		    .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
				}

			.autocomplete-suggestions { border: none;background: #F5F5F5;}
			.autocomplete-suggestion { padding: 2px 5px; color:#5b5b5b;white-space: nowrap; overflow: hidden;height:30px;line-height:30px;cursor: pointer;text-overflow:ellipsis;border-bottom:1px solid #e2e3e4;}
			.autocomplete-selected { border-bottom:1px solid #99cdf8;color:#292828; }

			.autocomplete-suggestions strong { font-weight: normal; color: #292828; }
 
            /*代理菜单样式*/
            .agentitem{

				padding: 2px;
				
			}
            
			.chosen{
			   background:#3399ff;
			   color:white;
			   cursor:pointer;
			}

			.agentitem a:hover{
			color:#ffffff !important;
			}

           .menuitem{

		    margin-bottom:5px;
		   
		   
		   }
		
         
			/*动态计算浮动签字栏距离top的距离*/
		  .flowmenuitem {
			  /* IE5.5+/Win - this is more specific than the IE 5.0 version */
			  right: auto; bottom: auto;
			  top: expression( ( -0.1 - this.offsetHeight + ( document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) ) + 'px' );
			  BACKGROUND-COLOR: #F7F7F7;

			}

			 .wrapper{
			  position: absolute;
				width: 100%;
				height: 41px;
				top: 0;
				left: 0;
				background: #999999;
				z-index: -1;
			 
			 }

		</style>
		<link href="/css/ecology8/request/requestTypeShow_wev8.css" type="text/css" rel="STYLESHEET">
	</head>
	<%!public String getRandom() {
		return "" + (((int) (Math.random() * 1000000) % 3) + 1);
	}%>
	<%




String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
//String seclevel = "";
if(logintype.equals("2")){
	usertype = 1;
	//seclevel = ResourceComInfo.getSeclevel(""+user.getUID());
}
//else if (logintype.equals("1")){
//	seclevel = user.getSeclevel();
//}
//if(seclevel.equals("")){
//	seclevel="0";
//}
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";

/* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String needPopupNewPage = Util.null2String(request.getParameter("needPopupNewPage"));//是否需要弹出新页面  true:需要   false或其它：不需要

if(selectedContent!=null && selectedContent.startsWith("key_")){
	String menuid = selectedContent.substring(4);
	RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
	selectedContent = "";
	while(RecordSet.next()){
		String keyVal = RecordSet.getString(2);
		selectedContent += keyVal +"|";
	}
	if(selectedContent.indexOf("|")!=-1)
		selectedContent = selectedContent.substring(0,selectedContent.length()-1);
}

if(fromAdvancedMenu==1){
	needPopupNewPage="true";
}

boolean navigateTo = false;
int navigateToWfid = 0;
int navigateToIsagent = 0;
int navigateToAgenter = 0;
String commonuse = "";
if(fromAdvancedMenu==1){//目录选择来自高级菜单设置
	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	if(info!=null){
		selectedworkflow = info.getSelectedContent();
		
		List workflowNum = Util.TokenizerString(selectedworkflow,"|");
		int tnum = 0;
		for(Iterator it = workflowNum.iterator();it.hasNext();){
			if(((String)it.next()).startsWith("W")) tnum++;
		}
		if(tnum==1) navigateTo = true;
	}
} else if(usertype==0){
	//ArrayList selectArr=new ArrayList();
	//System.out.println(userid);
	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
	if(RecordSet.next()){
	    selectedworkflow=RecordSet.getString("selectedworkflow");
	    isuserdefault=RecordSet.getString("isuserdefault");
	    commonuse = RecordSet.getString("commonuse");
	
	}
}   

/* edited end */
if(!"".equals(selectedContent))
{
	selectedworkflow = selectedContent;
}
if(!selectedworkflow.equals(""))    selectedworkflow+="|";
String needall=Util.null2String(request.getParameter("needall"));
String sworkflow="";
if(needall.equals("1")) {
	isuserdefault="0";
	fromAdvancedMenu=0;
}
//获取自定义流程的信息
RecordSet.executeSql("select selectedworkflow from workflow_RequestUserDefault where userid="+userid);
if(needall.equals("0")){
	needall="-1";
}
while(RecordSet.next()){
	if(needall.equals("-1")&&!RecordSet.getString("selectedworkflow").equals("")){
		needall="0"; break;
	}else if(needall.equals("1")){
		sworkflow=RecordSet.getString("selectedworkflow");
	}
}

int tdNum=0;
int tdOnum=0;
String[][] color={{"#166ca5","#953735","#01b0f1"},{"#767719","#f99d52","#cf39a4"}};
int colorindex=0;
%>
	<body>
		<script type="text/javascript">	
		 if(parent.$("#searchInput").length && parent.$("#searchInput").length===1){
			parent.$("#searchInput").remove();
		 }
		</script>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<!--<input type="text" id='searchInput' class="searchInput" name="flowTitle" value=""/>
					<span id="advancedSearch" class="advancedSearch">高级搜索</span>-->
		         	<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<script type="text/javascript">
			
             function   bindInputEvent()
			 {
			    
                if(parent.$("#searchInput").length && parent.$("#searchInput").length===1)
				 {
					if(/msie/i.test(navigator.userAgent))    //ie浏览器 
					{
						parent.document.getElementById('searchInput').onpropertychange=onBtnSearchClick;
					} 
					else 
					{//非ie浏览器，比如Firefox 
						parent.document.getElementById('searchInput').addEventListener("input",onBtnSearchClick,false);
					}                    
			   }
               else
                setTimeout(bindInputEvent,1000);
			 }

             bindInputEvent();
		</script>
<!--<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" ></div>-->
		<%//
//if(isuserdefault.equals("1")){
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(16346,user.getLanguage())+",javascript:onuserdefault(0),_self} " ;
//	RCMenuHeight += RCMenuHeightStep;
//} else if(needall.equals("1")){
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:onuserdefault(1),_self} " ;
//	RCMenuHeight += RCMenuHeightStep;
//} else if(fromAdvancedMenu==1){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(16346,user.getLanguage())+",javascript:onuserdefault(0),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:onuserdefault(1),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
//}
if(usertype==0){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/workflow/request/RequestUserDefault.jsp',_top} " ;
	//RCMenuHeight += RCMenuHeightStep;
}
%>

		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="subform" name="subform" method="get"
			action="RequestType.jsp">
			<input type="hidden" id=workflowid name=workflowid>
			<input type="hidden" id=isagent name=isagent>
			<input type="hidden" id=beagenter name=beagenter>
			<input type="hidden" id=offical name=offical value="<%=offical %>">
			<input type="hidden" id=needPopupNewPage name=needPopupNewPage>
			<input type="hidden" id=isec name=isec>

			<%
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));

String isec = Util.null2String(request.getParameter("isec"));
if("1".equals(isec)){
topage = URLEncoder.encode(topage);
}
//获取流程新建权限体系sql条件
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");

ArrayList NewWorkflowTypes = new ArrayList();

String sql="";

 sql = "select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id   and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;

RecordSet.executeSql(sql);

//System.out.println(sql);

while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}


//所有可创建流程集合
ArrayList NewWorkflows = new ArrayList();

sql = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
RecordSet.executeSql(sql);

//System.out.println(sql);
while(RecordSet.next()){
	NewWorkflows.add(RecordSet.getString("workflowid"));
}



/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
ArrayList AgentWorkflows = new ArrayList();
ArrayList Agenterids = new ArrayList();
//TD13554
Calendar today = Calendar.getInstance();

	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	                     Util.add0(today.get(Calendar.SECOND), 2) ;
if (usertype == 0) {
	//获得当前的日期和时间
	
	String begindate="";
	String begintime="";
	String enddate="";
	String endtime="";
	int agentworkflowtype=0;
	int agentworkflow=0;
	int beagenterid=0;
	sql = "select distinct t1.workflowtype,t.workflowid,t.bagentuid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agentConditionSet t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid="+userid+" order by t1.workflowtype,t.workflowid";
	
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    boolean isvald=false;
	    begindate=Util.null2String(RecordSet.getString("begindate"));
	    begintime=Util.null2String(RecordSet.getString("begintime"));
	    enddate=Util.null2String(RecordSet.getString("enddate"));
	    endtime=Util.null2String(RecordSet.getString("endtime"));
	    agentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
	    agentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
	    beagenterid=Util.getIntValue(RecordSet.getString("bagentuid"),0);
        

	    if(!begindate.equals("")){
	        if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
	            continue;
	    }
	    if(!enddate.equals("")){
	        if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
	            continue;
	    }
		
		boolean haswfcreateperm = shareManager.hasWfCreatePermission(beagenterid, agentworkflow);
		if(haswfcreateperm){
	        if(NewWorkflowTypes.indexOf(agentworkflowtype+"")==-1){
	            NewWorkflowTypes.add(agentworkflowtype+"");
	        }
	        
	        int indx=AgentWorkflows.indexOf(""+agentworkflow);
	        if(indx==-1){
	        	if(!offical.equals("1")||WorkflowComInfo.getIsWorkflowDoc(""+agentworkflow,officalType).equals("1")){
		            AgentWorkflows.add(""+agentworkflow);
		            Agenterids.add(""+beagenterid);
		        }
	        }else{
	            String tempagenter=(String)Agenterids.get(indx);
	            if (tempagenter.indexOf(beagenterid + "") == -1) {
	            	tempagenter += "," + beagenterid;
		            Agenterids.set(indx,tempagenter);	
	            }
	        }
	    }
	}
	//end
}




String  freewfCreater="";
boolean  canFreeWfCreate=false;







List inputReportFormIdList=new ArrayList();
String tempWorkflowId=null;
String tempFormId=null;
String tempIsBill=null;
for(int i=0;i<NewWorkflows.size();i++){
	tempWorkflowId=(String)NewWorkflows.get(i);
	if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+tempWorkflowId,officalType).equals("1"))continue;
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

for(int i=0;i<AgentWorkflows.size();i++){
	tempWorkflowId=(String)AgentWorkflows.get(i);
	if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+tempWorkflowId,officalType).equals("1"))continue;
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

String dataCenterWorkflowTypeId="";
RecordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
if(RecordSet.next()){
	dataCenterWorkflowTypeId=Util.null2String(RecordSet.getString("currentId"));
}

this.rs=RecordSet;
List inputReportList=this.getAllInputReport(String.valueOf(userid));
//if(inputReportList.size()>0){
//	NewWorkflowTypes.add(dataCenterWorkflowTypeId);
//}
if(inputReportList.size()>0&&NewWorkflowTypes.indexOf(dataCenterWorkflowTypeId)==-1){
	NewWorkflowTypes.add(dataCenterWorkflowTypeId);
}
ArrayList NewInputReports = new ArrayList();
Map inputReportMap=null;
String inprepId=null;
String inprepName=null;
for(int i=0;i<inputReportList.size();i++){
	inputReportMap=(Map)inputReportList.get(i);
	inprepId=Util.null2String((String)inputReportMap.get("inprepId"));
	if(!inprepId.equals("")&&inputReportFormIdList.indexOf(InputReportComInfo.getbillid(inprepId))==-1){
		NewInputReports.add(inprepId);
	}
}

int wftypetotal=WorkTypeComInfo.getWorkTypeNum();
int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=0;
//System.out.println("========wftotal:"+wftotal+"===========wftypetotal="+wftypetotal+"======================rownum="+rownum);
//rownum=6;

while(WorkTypeComInfo.next()){
		String wftypename=WorkTypeComInfo.getWorkTypename();
		String wftypeid = WorkTypeComInfo.getWorkTypeid();



		if(NewWorkflowTypes.indexOf(wftypeid)==-1){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
 			continue;            
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
	 	if(dataCenterWorkflowTypeId.equals(wftypeid)&&true) {
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
        



}
WorkTypeComInfo.setTofirstRow();
%>

			<table height=100% width="100%" border="0" cellspacing="0"
				cellpadding="0"  >
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
					<tr>
						<td height="10" colspan="3"></td>
					</tr>
					<tr>
						<td></td>
						<td valign="top">
							<TABLE class="Shadow"  style="width:100%;"  >
								<tr>
									<td valign="top">
										<table class="ViewForm">

                                          <!-- 2012-09-21 ypc -->
													<%
													
													//System.out.println("pppp="+userid);
                                                    //  System.out.println("pppp="+usertype);
                                                   //     System.out.println("pppp="+commonuse);
													//System.out.println("pppp="+fromAdvancedMenu);
													//System.out.println("pppp="+usertype);
													//System.out.println("pppp="+commonuse);
													int usedtodo = Util.getIntValue(request.getParameter("usedtodo"),-1);
													//System.out.println("usedtodo"+request.getParameter("usedtodo"));
													if(fromAdvancedMenu!=1 && usertype==0&&!commonuse.equals("0") && usedtodo == 1){
														//System.out.println("true");
													%>
													  
													<!-- 常用流程  开始 -->
										<%
								        	String agentWfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
									        if(RecordSet.getDBType().equals("oracle")){
									        	if(offical.equals("1")){
									        		RecordSet.execute("SELECT * FROM (select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t2.isWorkflowDoc=1 and t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype+ " and " + agentWfcrtSqlWhere + ") or wfid in( select distinct t.workflowid from workflow_agentConditionSet t,workflow_base t1 where exists (select * from HrmResource b where t.bagentuid=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid="+userid+" and ((t.beginDate+t.beginTime+':00'<='"+currentdate+currenttime+"' and t.endDate+t.endTime+':00'>='"+currentdate+currenttime+"'))or(t.beginDate+t.beginTime='' and t.endDate+t.endTime = ''))) order by count desc) WHERE ROWNUM <= 12 ORDER BY ROWNUM ASC");
									        	}else{
									        		RecordSet.execute("SELECT * FROM (select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype+ " and " + agentWfcrtSqlWhere + ") or wfid in( select distinct t.workflowid from workflow_agentConditionSet t,workflow_base t1 where exists (select * from HrmResource b where t.bagentuid=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid="+userid+" and ((t.beginDate+t.beginTime+':00'<='"+currentdate+currenttime+"' and t.endDate+t.endTime+':00'>='"+currentdate+currenttime+"'))or(t.beginDate+t.beginTime='' and t.endDate+t.endTime = ''))) order by count desc) WHERE ROWNUM <= 12 ORDER BY ROWNUM ASC");
									        	}
									        }else{
									        	if(offical.equals("1")){
									        		RecordSet.execute("select top 12 * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t2.isWorkflowDoc=1 and t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agentConditionSet t,workflow_base t1 where exists (select * from HrmResource b where t.bagentuid=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid=" + userid +" )) order by count desc");
									        	}else{
									        		RecordSet.execute("select top 12 * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agentConditionSet t,workflow_base t1 where exists (select * from HrmResource b where t.bagentuid=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid=" + userid +" )) order by count desc");
									        	}
									        }
									        //System.out.println("select top 12 * from WorkflowUseCount where userid ='1' and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid='1' )) order by count desc");
								        	if(RecordSet.getCounts()>0){
													


								              %>
										             <td colspan='5'>
													 <div class='commonitem' >
														<!-- <div class='commonitemtitle'>
													    <div class='commian'><label></label> </div>
														</div> -->
														
														<table   style='width:100%;border-collapse: collapse; border: 0px;' class='commonuseitems'>
															<%
															int increment=0;
														    String isImportWf="";
															boolean isWfShow=false;
															
	 	                                                     String curtypeid ="";
					                                       //遍历常用流程
					                                         while(RecordSet.next()){
					                                          
																 isWfShow=false;
					                                        	 String wfid= RecordSet.getString("wfid");
																
																if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+wfid,officalType).equals("1"))continue;
                                                               
					                                         	 if(NewWorkflows.indexOf(wfid) != -1){

                                                                  isWfShow=true;

                                                                  increment++;
																  //流程导入
																  isImportWf=WorkflowComInfo.getIsImportwf(wfid);
																  curtypeid = WorkflowComInfo.getWorkflowtype(wfid);

                                                                 if(increment%3==1)
																 {
																 %>

																  <tr>

																 <%
                                                                  } 
																 %>

															   <td style="width:32%;">
																  
															<!--
																   <span  class='increamentinfo'><img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png"></span>
															-->
															
														    

                                                             <div class='centerItem'  >
                                                            

																<div class='fontItem'>
																  <img name='esymbol' src="/images/ecology8/default_wev8.png" style="vertical-align: middle;">

																  <a class="e8contentover actooLong" style="margin-left:8px;margin-right:10px;" href="javascript:onNewRequest(<%=wfid%>,0,0);">    <%=Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage())%>
																  </a>
																   <!--标识当前用户自身可创建自由流程-->	    
																	<input type='hidden' name='createfreewfbyself'  value='1' >
																</div>
																<div class='imageItem'>

																   <% //流程是否可以导入
																	 if(isImportWf.equals("1")) 
			                                                     { %>
																 <div class='imgspan import'>
                                                                  <img onclick="importWf('<%=wfid %>',this);" class='opimg' style='vertical-align: middle;margin-right:10px;'  src='/images/ecology8/importwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(24270,user.getLanguage())%>" />
																  </div>
                                                                 <%} %>


																   <% //创建代理流程
																	 if(AgentWorkflows.indexOf(wfid)>-1) 
			                                                     { %>
																  <div class='imgspan agent'>
                                                                  <img  onclick="agentWf('<%=wfid %>',this);" class='opimg' style='vertical-align: middle;margin-right:10px;'  src='/images/ecology8/agentwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(84517,user.getLanguage())%>" />
																</div>
															  <%}%>
															</div>
                                                             <%
													         if(AgentWorkflows.indexOf(wfid)>-1){
															 ArrayList    agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
                                                             int isagent=1;	
															 int beagenter;
															 String agentname;

															    %>

																<div  class='agentlistdata' style='display:none'>

															    <%
																for(int k=0;k<agenterlist.size();k++){
																beagenter=Util.getIntValue((String)agenterlist.get(k),0);
																agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
      																	 %>
																<div class='agenter'>
                                                                   <a class="actooLong" style="vertical-align: middle;color:#5b5b5b;"
																		href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
																		<%=Util.toScreen(agentname,user.getLanguage())%> </a>
                                                               </div>
                                                                   <%
																	  }%>

																  </div>
																  <%}
																 %>

                                                                  <!--流程导入-->
																<% //流程是否可以导入
																if(isImportWf.equals("1")) 
																{ %>
																<div class='importwf'>
																	<div class='importSpan'>
																	   <div class='wrapper'></div>
																		<span  class='importTxt'></span>
																	</div>
																</div>
																<%}%>  
                                                                 
																</div>

														    	</td>

                                                                
                                                                 <% if(increment==6){
																	break;
																 }else if(increment%3!=0)
																 {
															         %>
																 <td style='width:25px'></td>  
																   	 <%
                                                                     } 
																   %>

																 <%
																if(increment==6){
																	break;
																 }else if(increment%3==0)
																 {
															         %>
																  </tr>
																   	 <%
                                                                     } 
																   }
																   %>

															  <%
				                                               
						                               	 if (AgentWorkflows.indexOf(wfid)!=-1  && !isWfShow){
				                                         ArrayList agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
				               int isagent=1;
							   increment++;
				                for(int k=0;k<agenterlist.size();k++){
                                 
								 if(increment==6){
									break;
								  }else if(increment%3==1)
			                        {
						             %>
							          <tr>
					                  <%
                                     }

				                   int beagenter=Util.getIntValue((String)agenterlist.get(k),0);
				                   String  agentname="("+ResourceComInfo.getResourcename((String)agenterlist.get(k))+"->"+user.getUsername()+")";

				                    %>
															
															  <td style="width:32%;">
														<!--
																  <span  class='increamentinfo'><img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png"></span>
															-->	
																
                                                             
																 <div class='centerItem'  >
																

																<div class='fontItem'>
																<img name='esymbol' src="/images/ecology8/default_wev8.png" style="vertical-align: middle;"/>

																 
																  <a
																	href="javascript:showPromt();">
																	<%=Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage())%> </a>
																	 <!--标识当前用户不能创建自由流程-->	    
																	<input type='hidden' name='createfreewfbyself'  value='0' >
																	</div>
																	<div class='imageItem'>
																	 <div class='imgspan agent'>
																	<img onclick="agentWf('<%=wfid %>',this);" class='opimg' style='vertical-align: middle;'  src='/images/ecology8/agentwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(84517,user.getLanguage())%>" />
																	</div>
																	</div>
																	  <div  class='agentlistdata' style='display:none'>
																		<%
																		   agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
																		   isagent=1;
																			for(int i=0;i<agenterlist.size();i++){
																			beagenter=Util.getIntValue((String)agenterlist.get(i),0);
																			agentname=ResourceComInfo.getResourcename((String)agenterlist.get(i));
																			%>
																			<div class='agenter'>
																				<a class="actooLong" style="vertical-align: middle;color:#5b5b5b;"
																					href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
																					<%=Util.toScreen(agentname,user.getLanguage())%> </a>
																				</div>
											
																		 <%
																		  }
																		 %>

																	</div>

																</div>
															  </td>

                                                                <%if(increment==6){
																	break;
																 }else if(increment%3!=0)
																  {
															         %>
																 <td style='width:15px'></td>  
																   	 <%
                                                                     } 
																   %>

																 <%
																 if(increment==6){
																	break;
																 }else if(increment%3==0)
																  {
																     %>
																  </tr>
																   	 <%
                                                                    } 

																   %>

															<%
				                }
				            }
				%>
															<%} %>

                                                         <% if(increment%3!=0) { %>
                                                              </tr>

                                                         <% }%>
														  

														</table>
														</div>
	<script language=javascript>
		//jQuery(".commian").append("<font color='#989898' style='font-weight: 400;margin-left:5px;'>(<%=increment%>)</font>")
	</script>
													</td>
													<%
													}
													%>
													<%}	
													if(usedtodo != 1)
													{
													%>
													<!-- 常用流程  结束 -->	
													
											<tr class=field>
												
													<td width="100%" align=left valign=top num=1>
											
													

	<%
	int i=0;
	int needtd=rownum;
	int numRows=0;
	while(WorkTypeComInfo.next()){
		
		String wftypename=WorkTypeComInfo.getWorkTypename();
		
		String wftypeid = WorkTypeComInfo.getWorkTypeid();
		if(offical.equals("1") && !WorkTypeComInfo.hasWorkflowDoc(wftypeid,officalType))continue;

		if(NewWorkflowTypes.indexOf(wftypeid)==-1){
			
 			continue;            
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
			
			continue;
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1){
			
			continue;
		}
	 	if(dataCenterWorkflowTypeId.equals(wftypeid)&&true) {
			
			continue;
		}
	 		numRows++;
			needtd--;

       //  System.out.println("默认流程有=============>"+selectedworkflow);

		%>
													<div class="listbox2">
														<%
 	int isfirst = 1;
	//标识当前记录所处条数

	int countinfo=0;
	if(dataCenterWorkflowTypeId.equals(wftypeid)){
				            
			while(InputReportComInfo.next()){

			 

			 	inprepId = InputReportComInfo.getinprepid();
				inprepName=InputReportComInfo.getinprepname();
			 	if(NewInputReports.indexOf(inprepId)==-1){
			 		    continue;
		        }
			 	//check right
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& isuserdefault.equals("1")) continue;
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& fromAdvancedMenu==1) continue;
			 	i++;
			 	countinfo++;
			 	if(isfirst ==1){
			 		isfirst = 0;
				%>
														<!-- this1 start -->
														<div class='titleitem'>
														<div class="titlecontent main<%=colorindex%>">
															<label><%=Util.toScreen(wftypename,user.getLanguage())%></label>
															<div class="e8rightborderoffical"></div>	
														</div></div>

														<div class='mainItem'>
															<!-- this1 end -->
															<%
				
				
				}
				%>
															 
                                                              <div class='centerItem'  >
																
                                                             	<div class='fontItem'>

                                                                 
																 <!-- <span  class='increamentinfo'><img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png"></span>
																-->
                                                          <img name='esymbol' src="/images/ecology8/default_wev8.png" style="vertical-align: middle;">

																<a
																	href="javascript:onNewWindow('/datacenter/input/InputReportDate.jsp?inprepid=<%=inprepId%>');">
																	<%=inprepName%></a>
															</div>
														<div class='imageItem'>
															<div class='imgspan import'>
																<img   class='opimg'   src='/images/ecology8/importwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(24270,user.getLanguage())%>" />
															</div>
                                                                  <%
																  if(needall.equals("1") && !offical.equals("1"))
																 {
																 %>
																 <div class='imgspan'>
																 <img  class='opimg'   src='/images/ecology8/addwf_wev8.png'>
																 </div>
																 <%
																 }
                                                                 else if(needall.equals("0") && !offical.equals("1"))
                                                                 {%>
																 <div class='imgspan'>
																   <img  class='opimg' src='/images/ecology8/rmwf_wev8.png'>
																   </div>
																 <%
																 }
                                                                 %>
                                                                   
															<div>
			    <%
			}
			InputReportComInfo.setTofirstRow();
  }
	

      // System.out.println("新流程===>"+NewWorkflows);
	//   System.out.println("isuserdefault===>"+AgentWorkflows);

    //流程对应的li是否创建
    boolean  isWfShow; 

	while(WorkflowComInfo.next()){

		String wfname=WorkflowComInfo.getWorkflowname();
        
		String wfid = WorkflowComInfo.getWorkflowid();
		if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+wfid,officalType).equals("1"))continue;
		if(offical.equals("1")){
			if(officalType==1){
				if(!WorkflowComInfo.getOfficalType(""+wfid).equals("1")&&!WorkflowComInfo.getOfficalType(""+wfid).equals("3")){
					continue;
				}
			}else if(officalType==2){
				if(!WorkflowComInfo.getOfficalType(""+wfid).equals("2")){
					continue;
				}
			}
		}
	 	String curtypeid = WorkflowComInfo.getWorkflowtype();

        String  isImportWf=WorkflowComInfo.getIsImportwf();

		isWfShow=false; 

        int isagent=0;
        int beagenter=0;
        String agentname="";
        ArrayList agenterlist=new ArrayList();

        //String isvalid=WorkflowComInfo.getIsValid();

       // System.out.println("curtypeid============="+curtypeid+"wftypeid============="+wftypeid+"wfid============="+wfid);


	 	if(!curtypeid.equals(wftypeid)) continue;


	 	//check right
	 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
        //   System.out.println("name============="+isuserdefault);
	 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& fromAdvancedMenu==1) continue;
       //    System.out.println("name============="+fromAdvancedMenu);
	 	if(isfirst ==1){
	 		isfirst = 0;
	%>
															<!-- this2 start -->
															<div class='titleitem'>
                                                            <div class="titlecontent main<%=colorindex%>">
                                                            	<label><%=Util.toScreen(wftypename,user.getLanguage())%></label>
                                                            	<div class="e8rightborderoffical"></div>
                                                            </div></div>
															<div class="mainContent">
															<div class='mainItem'>
																<!-- this2 end -->
															<%
															}
    //    System.out.println("id=========="+wfid);
		
		if(NewWorkflows.indexOf(wfid)!=-1){
     //  System.out.println("name============="+wfname);
		 countinfo++;
		 isWfShow=true;
	   %>														
																
															

																 <div class='centerItem'  >
																


																<div class='fontItem'>
																  <img name='esymbol' src="/images/ecology8/default_wev8.png" style="vertical-align: middle;">
																	<a   class="actooLong"  
																		href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
																		<%=Util.toScreen(wfname,user.getLanguage())%></a>
															        <!--标识当前用户自身可创建自由流程-->	    
																	<input type='hidden' name='createfreewfbyself'  value='1' >
                                                            	</div>
																<div class='imageItem'>
                                                                 <% //流程是否可以导入
																	 if(isImportWf.equals("1")) 
			                                                     { %>
																 <div class='imgspan import'>
                                                                  <img onclick="importWf('<%=wfid %>',this);" class='opimg'   src='/images/ecology8/importwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(24270,user.getLanguage())%>" />
																  </div>
                                                                 <%} %>


																   <% //创建代理流程
																	 if(AgentWorkflows.indexOf(wfid)>-1) 
			                                                     { %>
																 <div class='imgspan agent'>
                                                                  <img  onclick="agentWf('<%=wfid %>',this);" class='opimg'
																  src='/images/ecology8/agentwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(84517,user.getLanguage())%>" />
                                                                </div>
																  <%}
																 %>
																
																 <%
                                                                   if(needall.equals("1")&&sworkflow.indexOf("W"+wfid)==-1&&!offical.equals("1"))
																 {
																 %>
																 <div class='imgspan'>
																 <img onclick="addWorkflow('<%=wfid %>','<%=curtypeid %>',this,'<%=Util.toScreen(wfname,user.getLanguage())%>');" class='opimg'  src='/images/ecology8/addwf_wev8.png' title='<%=SystemEnv.getHtmlLabelName(193, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%>' />
																 </div>
																 <%
																 }
                                                                 else if(needall.equals("0")&&!offical.equals("1"))
                                                                 {%>
																 <div class='imgspan'>
																   <img onclick="removeWorkflow('<%=wfid %>','<%=curtypeid %>',this);" class='opimg'  src='/images/ecology8/rmwf_wev8.png' title='<%=SystemEnv.getHtmlLabelName(19133, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%>' />
																  </div>
																 <%
																 }
																 %>
																 </div>
															<!--流程代理div-->
																   <% //创建代理流程
																	 if(AgentWorkflows.indexOf(wfid)>-1) 
			                                                     { 
																	
																	 agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
																	 isagent=1;			 
																%>
																<div  class='agentlistdata' style='display:none'>
															    <%
																for(int k=0;k<agenterlist.size();k++){
																beagenter=Util.getIntValue((String)agenterlist.get(k),0);
																agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
      																	 %>
																	<div class='agenter'>
                                                                   <a  class="actooLong" style="vertical-align: middle;color:#5b5b5b;"
																		href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
																		<%=Util.toScreen(agentname,user.getLanguage())%> </a>
																</div>
                                                                   <%
																	  }%>

																  </div>
																<%
																 }
																%>
																<!--流程导入-->
																 <% //流程是否可以导入
																	 if(isImportWf.equals("1")) 
			                                                     { %>
																<div class='importwf'>
																    <div class='wrapper'></div>
																	<div class='importSpan'>
																	<span  class='importTxt'></span>
																	</div>
																</div>
																<%
																 }
																%>
																</div>
																<%
            }
       
	        //流程代理信息
            if(AgentWorkflows.indexOf(wfid)>-1){
	 	
		        //如果未创建，则创建该流程对应得而li节点
                if(!isWfShow)
				{
					countinfo++;
				  %> 
					    

							 <div class='centerItem'  >
							
						  <div class='fontItem'>
						  <img name='esymbol' src="/images/ecology8/default_wev8.png" style="vertical-align: middle;">
							
							<a
								href="javascript:showPromt();">
								<%=Util.toScreen(wfname,user.getLanguage())%> </a>
								 <!--标识当前用户自身不能创建自由流程-->	    
			                     <input type='hidden' name='createfreewfbyself'  value='0' >
							</div>
							<div class='imageItem agent'>
							<img onclick="agentWf('<%=wfid %>',this);" class='opimg'  src='/images/ecology8/agentwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(84517,user.getLanguage())%>" />
                            </div>
                            <div  class='agentlistdata' style='display:none'>
                                <%
                                   agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
                                   isagent=1;
                                    for(int k=0;k<agenterlist.size();k++){
									beagenter=Util.getIntValue((String)agenterlist.get(k),0);
									agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
									%>
										<div class='agenter'>
										<a class="actooLong" style="vertical-align: middle;color:#5b5b5b;"
											href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
											<%=Util.toScreen(agentname,user.getLanguage())%> </a>
											</div>
    
                                 <%
                                  }
                                 %>

							</div>
						</div>

				 <%
				} 
				 
			
                
           
		}
	
        navigateToWfid = Util.getIntValue(wfid);
	 	navigateToIsagent = isagent;
        navigateToAgenter = beagenter;
		}
		WorkflowComInfo.setTofirstRow();
	%>
	</div>
																<!-- this3 start -->

																<!-- this3 end -->

																<!-- dddd -->
													</div>		
													</div>
	<script language=javascript>
		//jQuery(".main<%=colorindex%>").append("<font color='#989898' style='font-weight: 400;margin-left:5px;'>(<%=countinfo%>)</font>")
		<%
			if(countinfo==0){
				numRows--;												
		%>
			jQuery(".main<%=colorindex%>").parent().parent().remove();
		<%
			}
		%>
	</script>
												<%
													colorindex++;
		if(needtd==0){
			needtd=rownum;
	%>
												
											
													<%
													tdNum++;
		}
	}
	%>
												</td>
											</tr>
											<%} %>
										</table>
									</td>
								</tr>
							</TABLE>
						</td>
						<td></td>
					</tr>
					<tr>
						<td height="10" colspan="3"></td>
					</tr>
			</table>
			<input type="hidden" id="needall" name="needall" value="">
			<input type=hidden name="prjid" value="<%=prjid%>">
			<input type=hidden name="docid" value="<%=docid%>">
			<input type=hidden name="crmid" value="<%=crmid%>">
			<input type=hidden name="hrmid" value="<%=hrmid%>">
			<input type=hidden name="topage" value="<%=topage%>">
		</form>
	 
	  <script>
            /** jQuery(".listbox2 li").mouseover(function(){
				if(jQuery(this).find(".opimg").length>0){
	                 jQuery(this).find(".opimg").show(); 
					 jQuery(this).find(".opimg").css("cursor","pointer");
				}
			 });
			jQuery(".listbox2 li").mouseout(function(){
				if(jQuery(this).find(".opimg").length>0){			 
                 		jQuery(this).find(".opimg").hide();
			  		jQuery(this).find(".opimg").css("cursor","default");
				}
			 });**/
			 jQuery(".centerItem").unbind("mouseover");
			 jQuery(".centerItem").mouseover(function (){
				jQuery(this).css("background-color","#eef3f4");
				jQuery(this).find("a").css("color","#E15352");
				jQuery(this).find("img[name='esymbol']").attr("src","/images/ecology8/red_wev8.png");
				//代理流程div
				var agent=jQuery(this).find(".agentlistdata").css("display");
				var imports=jQuery(this).find(".importwf").css("display");
				jQuery(".agentlistdata").css("display","none");
				jQuery(this).find(".agentlistdata").css("display",agent);
				
				jQuery(".importwf").css("display","none");
				jQuery(this).find(".importwf").css("display",imports);

				jQuery(".autocomplete-suggestions").css("display","none");

				jQuery(".imageItem").css("display","none");
				jQuery(".imgdiv").removeClass("imgdiv");
				
				if(agent!="none"&&jQuery(this).find(".agentlistdata").length>0){
					jQuery(this).find(".agent").addClass("imgdiv");
				}else{
					jQuery(this).find(".agent img").attr("src","/images/ecology8/agentwf_wev8.png");
				}
				if(imports!="none"&&jQuery(this).find(".importwf").length>0){
					jQuery(this).find(".import").addClass("imgdiv");
					if(jQuery(this).find(".importwf").find(".labelText").length>0){
					  jQuery(this).find(".importwf").css("height",76);
					}else{
					  jQuery(this).find(".importwf").css("height",(56+jQuery(".autocomplete-suggestions").height()));
					}
					jQuery(".autocomplete-suggestions").css("display","block");
				}else
                    jQuery(this).find(".import img").attr("src","/images/ecology8/importwf_wev8.png");


				jQuery(this).find(".imageItem").css("display","block");
			 })
				
			 jQuery(".centerItem").mouseleave(function (){
				jQuery(this).css("background-color","#f9f9f9");
				jQuery(this).find("a").css("color","#000");
				jQuery(this).find("img[name='esymbol']").attr("src","/images/ecology8/default_wev8.png");
				if(jQuery(this).find(".agentlistdata").length>0){
					//代理流程div
					var agent=jQuery(this).find(".agentlistdata").css("display");
					if(agent=="none"){
						jQuery(this).find(".imageItem").css("display","none");
					}
				}else if(jQuery(this).find(".importwf").length>0){
					//导入流程div
					var imports=jQuery(this).find(".importwf").css("display");
					if(imports=="none"){
						jQuery(this).find(".imageItem").css("display","none");
						jQuery(".autocomplete-suggestions").css("display","none");
					}
				}else{
					jQuery(this).find(".imageItem").css("display","none");
					//更改背景色

					jQuery(".imgdiv").removeClass("imgdiv");
					
				}	
			 })
			 
			 jQuery(".agentlistdata").mouseover(function (){
				jQuery(this).parent().find(".imageItem").css("display","block");
			 })

			 jQuery(".importwf").mouseover(function (){
				jQuery(this).parent().find(".imageItem").css("display","block");
			 })
				
			jQuery(".agentlistdata").find("a").mouseover(function (){
				jQuery(this).parent().css("border-bottom","1px solid #99cdf8");
			});
			jQuery(".agentlistdata").find("a").mouseout(function (){
				jQuery(this).parent().css("border-bottom","1px solid #e2e3e4");
			});		

          
	  </script>
	   <div style='display: none'>
		 <form id=weaver name=frmmain action="RequestHandlerWorkflow.jsp?needall=<%=needall %>" method=post  target="handlerWorkflow">
		 	<input name='worktypeid' value='' />
		 	<input name='workflowid' value='' />
		 	<input name='url' value='' />
		 </form>
		 <iframe name="handlerWorkflow"></iframe>
	 </div>
	 <div id="warn">
	 	<table width="100%" height="100%"><tr><td align="right" width="50px"><img src='/images/ecology8/addWorkflow_wev8.png'></img></td><td align="left"><label style="margin-left: 5px">ecology8.0开发顺利！</label></td></tr></table>
	 </div>
	<%if(!offical.equals("1")){ %>
      <div  class='flowmenuitem'  style='position:fixed;bottom:20px;right:20px;_POSITION: absolute;'>

	     <!-- <div  class='menuitem  freewf'>
		  <input type='hidden' name='overitem' value='/images/ecology8/request/freewfover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/request/freewfout_wev8.png'>
		  <input type='hidden' name='itemname' value='freewf'>
		  <img src='/images/ecology8/request/freewfout_wev8.png' ></div> -->
		  <input type="hidden" id="colnum4show" name="colnum4show" value="mulitcol">
		  <!-- 三栏模式 -->
		  <div  class='menuitem  mulitColumn'>
		  <input type='hidden' name='overitem' value='/images/ecology8/doc/doc1coloutover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/doc/doc1colout_wev8.png'>
		  <input type='hidden' name='itemname' value='mulitcol'>
		  
		  	<img src='/images/ecology8/doc/doc1colout_wev8.png' style="cursor:pointer;z-index:999;"></div>
		  
		  <!-- 一栏模式 -->
		  <div  class='menuitem  oneColumn' style="display:none">
		  <input type='hidden' name='overitem' value='/images/ecology8/doc/docsimpleoutover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/doc/docsimpleout_wev8.png'>
		  <input type='hidden' name='itemname' value='onecol'>
		  <img src='/images/ecology8/doc/docsimpleout_wev8.png' style="cursor:pointer;z-index:999;"></div>
		  
		  <div  class='menuitem'>
		  <input type='hidden' name='overitem' value='/images/ecology8/request/wfletterover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/request/wfletterout_wev8.png'>
		  <input type='hidden' name='itemname' value='letter'>
		  <img src='/images/ecology8/request/wfletterout_wev8.png' style="cursor:pointer;z-index:999;"></div>

		  <div  class='menuitem' style='display:none'>
		  <input type='hidden' name='overitem' value='/images/ecology8/request/voiceover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/request/voiceout_wev8.png'>
		  <input type='hidden' name='itemname' value='voice'>
		  <img src='/images/ecology8/request/voiceout_wev8.png' style="cursor:pointer;z-index:999;"></div>

		  <div  class='menuitem'>
		  <input type='hidden' name='overitem' value='/images/ecology8/request/topover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/request/topout_wev8.png'>
          <input type='hidden' name='itemname' value='totop'>
		  <img src='/images/ecology8/request/topout_wev8.png' style="cursor:pointer;z-index:999;"></div>
	  
	  </div>
	<%} %>
      <script> 

       <%
	     //如果无自由节点权限

	     //if(!canFreeWfCreate)
		 //{
	   %>    
            //jQuery(".flowmenuitem  .freewf").hide();
		<%
		 //}	   
		%>
		<%if(usedtodo == 1){ %>
			jQuery(".flowmenuitem").hide();
		<%} %>

	   
	    jQuery(".menuitem").mouseover(function(){
		   
			  jQuery(this).find("img").attr("src",jQuery(this).find("input[name='overitem']").val());
		});

        jQuery(".menuitem").mouseleave(function(){
		   
			  jQuery(this).find("img").attr("src",jQuery(this).find("input[name='outitem']").val());
		});

		jQuery(".menuitem").click(function(){
		      var itemname=jQuery(this).find("input[name='itemname']").val();
			  if(itemname==='letter')
			  {
                 //保存流程展示方式
                 $.ajax({
					  type: "POST",
					  url: "/workflow/request/RequestTypeShowStyle.jsp",
					  data: { showtype:1,userid:<%=userid%>}
					})
					  .done(function( msg ){
					 
					   if('success'===$.trim(msg))
					    {
					   //先确认设置			 

						var iframe=jQuery(parent.document).find(".e8_box ").find("iframe");
						var links=jQuery(parent.document).find(".tab_menu").find("a");
						$(links[0]).attr("href","/workflow/request/RequestTypeShowWithLetter.jsp?offical=<%=offical%>&needPopupNewPage=true&dfdfid=a&needall=1");
						$(links[1]).attr("href","/workflow/request/RequestTypeShowWithLetter.jsp?offical=<%=offical%>&needPopupNewPage=true&dfdfid=b&needall=0")
					   
						 if('<%=needall %>'==='0')	
						  {
						
						  iframe.attr("src","/workflow/request/RequestTypeShowWithLetter.jsp?offical=<%=offical%>&needPopupNewPage=true&dfdfid=b&needall=0");
					 
						  }else	 
						  
						 {
					
						   iframe.attr("src","/workflow/request/RequestTypeShowWithLetter.jsp?offical=<%=offical%>&needPopupNewPage=true&dfdfid=a&needall=1");

						   }	  
                 
					   
					   }else
						{
					   
					    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84518,user.getLanguage())%>");
					   
					   }
					}); 
              
			  }
			  else if(itemname==='totop')
			  {
			     
				  jQuery(window).scrollTop(0);
			  
			  
			  }else if(itemname==='freewf')
			  {
                    

 
			  }else if(itemname==="onecol")
			  {
			  	jQuery("#colnum4show").val("mulitcol");
			  	jQuery(this).css("display","none");
			  	jQuery("input[name='itemname'][value='mulitcol']").parent("div.menuitem").css("display","block");
			  	parent.setcookie("wfnewCol","mulitcol");
			  	window.location="/workflow/request/RequestTypeShow.jsp?needPopupNewPage=true&dfdfid=b&needall=0&colnum4show=mulitcol";
			  }else if(itemname==="mulitcol")
			  {
			  	jQuery("#colnum4show").val("onecol");
			  	jQuery(this).css("display","none");
			  	jQuery("input[name='itemname'][value='onecol']").parent("div.menuitem").css("display","block");
			  	parent.setcookie("wfnewCol","onecol");
			  	window.location="/workflow/request/RequestTypeShow.jsp?needPopupNewPage=true&dfdfid=b&needall=0&colnum4show=onecol";
			  }

		});
		var colNum = parent.getcookie("wfnewCol");
		if(colNum === "onecol")
		{
			jQuery("input[name='itemname'][value='mulitcol']").parent("div.menuitem").css("display","none");
			jQuery("input[name='itemname'][value='onecol']").parent("div.menuitem").css("display","block");
			jQuery("#colnum4show").val("onecol");
		}	

	  </script>


	</body>
	
</html>


<script language=javascript>

<%
    if(navigateTo){
	    if("true".equals(needPopupNewPage)){
%>
	        var redirectUrl =  "AddRequest.jsp?workflowid="+<%=navigateToWfid%>+"&isagent="+<%=navigateToIsagent%>+"&beagenter=<%=navigateToAgenter%>";
	        var width = screen.availWidth-10 ;
	        var height = screen.availHeight-50 ;
	        var szFeatures = "top=0," ;
	        szFeatures +="left=0," ;
	        szFeatures +="width="+width+"," ;
	        szFeatures +="height="+height+"," ;
	        szFeatures +="directories=no," ;
	        szFeatures +="status=yes,toolbar=no,location=no," ;
	        szFeatures +="menubar=no," ;
	        szFeatures +="scrollbars=yes," ;
	        szFeatures +="resizable=yes" ; //channelmode
	        window.open(redirectUrl,"",szFeatures) ;
<%
	    }else{
%>
	        document.getElementById("workflowid").value="<%=navigateToWfid%>";
	        document.getElementById("isagent").value="<%=navigateToIsagent%>";
	        document.getElementById("beagenter").value="<%=navigateToAgenter%>";
	        document.subform.action = "AddRequest.jsp";
	        document.subform.submit();
<%
	    }
    }
%>




function onNewWindows(redirectUrl){
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
  }

function openwins(suggestion,wfid)
{
  

  //var content = "正在导入流程数据，请稍候...";
 // showPrompt(content);
   var  params="src=import&imprequestid="+suggestion.data+"&workflowid="+wfid+"&formid="+suggestion.formid+"&isbill="+suggestion.isbill+"&nodeid="+suggestion.nodeid+"&nodetype="+suggestion.nodetype+"&requestname="+escape(suggestion.value);
  onNewWindows("/workflow/request/RequestImportOption.jsp?newmodeid=0&ismode=0&"+params);
 
 
}

/*
提示用户该流程为代理流程，用户本身不具备创建该流程的权限
*/
function showPromt()
{

    showAlert("<%=SystemEnv.getHtmlLabelName(84519,user.getLanguage())%>");

}




/**
流程代理
**/
function  c(wfid,item)
{
	item.src="/images/ecology8/agentclick_wev8.png";

	var pitem=jQuery(item).parent();
	var offset=pitem.position();
//	console.dir(offset);
	pitem.addClass("imgdiv");
	
	var pagent=pitem.parent().parent();
	var agent=pagent.find(".agentlistdata");
	agent.css("display","block");
	agent.css("left",(pagent.width()-pitem.parent().width())+offset.left+pitem.width()-agent.width());
	agent.css("top",(pitem.height()+offset.top+4));

	pagent.find(".importwf").css("display","none");
	
	var scrollTop=Math.max(document.documentElement.scrollTop,document.body.scrollTop);
	var window_height=jQuery(window).height();
	var top_min=pagent.offset().top;
	var importwf_height=pagent.find(".agentlistdata").height();
	if((top_min+importwf_height)>(scrollTop+window_height)){
		window.scrollTo(0,(top_min+importwf_height));
	}

/**	  var offset=jQuery(item).offset();

      var menu=jQuery('<div style="z-index:100;position:absolute;border:1px solid  #86a2bd;background:white"></div>');

      menu.css("left",offset.left);
      menu.css("top",offset.top);

      var links=jQuery(item).parent().find(".agentlistdata  a");

      var item;
      for(var i=0;i<links.length;i++)
	  { 
         item=jQuery('<div class="agentitem" ><span class="middlehelper"></span><img style="vertical-align: middle;" src="/images/ecology8/avatar_wev8.png" /></div>');
		 item.append($(links[i]).clone());
	     menu.append(item);
	  }
      
     
      jQuery(document.body).append(menu);


     menu.find(".agentitem").mouseover(function(){
	     menu.find(".agentitem").removeClass("chosen");
         menu.find(".agentitem a").css("color","#5b5b5b");
		 $(this).addClass("chosen");
         $(this).find("a").css("color","white");

	 });


   **/


    function  showOrHideForAgent(e)
   {
  
         var containera = jQuery(item).parent().parent().parent();

		var containerb = pitem.parent();

		if ((!containera.is(e.target) // if the target of the click isn't the container...
			&& containera.has(e.target).length === 0)  &&  (!containerb.is(e.target) && containerb.has(e.target).length === 0)) // ... nor a descendant of the container
		{
			jQuery(".imageItem").css("display","none");
			jQuery(".imgdiv").removeClass("imgdiv");
			jQuery(".agentlistdata").css("display","none");
			jQuery(item).attr("src","/images/ecology8/agentwf_wev8.png");
			$(document).unbind("mousedown",showOrHideForAgent);
		}
	 
   }
    
     $(document).bind("mousedown",showOrHideForAgent);


}


function  generateLoading(item)
{

   var flowdiv=$("<div class='loadingarea' style='width:100px;height:100px;position:absolute;'><img  src='/images/ecology8/loading_wev8.gif'></div>");

   flowdiv.css("left",95);
   flowdiv.css("top",50);

   item.append(flowdiv);

}


/*
导入流程
*/
function importWf(wfid,item)
{


      

         
        
        jQuery(item).attr("src","/images/ecology8/importclick_wev8.png");

        var pitem=jQuery(item).parent();
		var offset=pitem.position();
		pitem.addClass("imgdiv");
		
		var pagent=pitem.parent().parent();
		var flowimport=pagent.find(".importwf");
		flowimport.css("display","block");
		flowimport.css("left",(pagent.width()-pitem.parent().width())+offset.left+pitem.width()-flowimport.width());
		flowimport.css("top",(pitem.height()+offset.top+4));
		
		pagent.find(".agentlistdata").css("display","none");
		
		jQuery(".autocomplete-suggestions").remove();


		flowimport.find(".importTxt").html("");
		flowimport.find(".importTxt").append("<input type='text' value=''>");
		flowimport.find("input").css("width","200px");
		flowimport.find("input").css("margin-top","5px");
		flowimport.find("input").css("margin-left","5px");
		flowimport.find("input").css("border","none");


		flowimport.css("height",120);

        generateLoading(flowimport);


 $.ajax({
  type: "POST",
  url: "/workflow/request/RequestImportJson.jsp",
  data: { workflowid: wfid, location: "Boston" }
})
  .done(function( msg ) {
	 $(".loadingarea").remove();
     var data=$.trim(msg);
     var contentarray=eval('('+data+')');
     if(contentarray.length===0)
	 {
		//flowimport.css("display","none");
		//pagent.find(".imageItem").css("display","none");
		//showAlert("当前没有流程可以导入!");
	//   alert("当前没有流程可以导入!!!");
		flowimport.css("height","76");
		flowimport.find(".labelText").remove();
		flowimport.append("<div class='labelText' style='margin-top:10px;height:30px;line-height:30px;text-align: center;'><%=SystemEnv.getHtmlLabelName(124786,user.getLanguage())%></label>");
		
		  function  showOrHide(e)
			{
		  
		  
			var containera = jQuery(item).parent().parent().parent();

				if ((!containera.is(e.target) // if the target of the click isn't the container...
					&& containera.has(e.target).length === 0))
				{
					jQuery(".imageItem").css("display","none");
					jQuery(".imgdiv").removeClass("imgdiv");
					jQuery(item).attr("src","/images/ecology8/importwf_wev8.png");
					flowimport.css("display","none");
					$(document).unbind("mousedown",showOrHide);
				}
			 
		   }
			 $(document).bind("mousedown",showOrHide);	
	 }else
	 {
	//	console.dir(contentarray);
		
       if(!flowimport.is(":visible"))
		  return;

	    flowimport.find("input").autocomplete({
			lookup: contentarray,
			onSelect: function (suggestion) {
			
			  //	alert('You selected: ' + suggestion.value + ', ' + suggestion.data);
				
			  //	 console.dir(suggestion);
				  flowimport.find(".importTxt").html("");
				  $(".autocomplete-suggestions").remove();
				  //隐藏浮动窗口
				  flowimport.hide();
                  //更改背景色

				  jQuery(".imgdiv").removeClass("imgdiv");
				  jQuery(item).attr("src","/images/ecology8/importwf_wev8.png");
				  openwins(suggestion,wfid);
			},
			//插件扩展
	  //      iconUrl:"/images/ecology8/avatar_wev8.png",
			 defaultShow:5
		});

  //  pitem.css("background","#999999");

    //控制提示框展示的高度




        
    var offset=jQuery(".autocomplete-suggestions").offset();
	var top=offset.top;
	var left=offset.left;
   
    
    jQuery(".autocomplete-suggestions").css("top",top+6);
    jQuery(".autocomplete-suggestions").css("left",left-6);
    jQuery(".autocomplete-suggestions").css("width","206px");

    
     


	flowimport.css("height",(56+jQuery(".autocomplete-suggestions").height()));

/**
	jQuery(".autocomplete-suggestions").css("border","none");
	jQuery(".autocomplete-suggestions").css("background-color","#f5f5f5");
	jQuery(".autocomplete-suggestions").css("width","188px");
	jQuery(".autocomplete-suggestion").css("border","1px solid #e2e3e4");	
**/
    


	flowimport.find("input").keyup(function (){
		if(jQuery(".autocomplete-suggestions").css("display")=="none"){
			jQuery(this).parent().parent().parent().css("height",56);
		}else{
			jQuery(this).parent().parent().parent().css("height",(56+jQuery(".autocomplete-suggestions").height()));
		}
		 
	
    jQuery(".autocomplete-suggestions").css("width","206px");
	});

	flowimport.find("input").focus(function(){
	
        
    var offset=jQuery(".autocomplete-suggestions").offset();
	var top=offset.top;
	var left=offset.left;
   
    jQuery(".autocomplete-suggestions").css("top",top+6);
    jQuery(".autocomplete-suggestions").css("left",left-6);
    jQuery(".autocomplete-suggestions").css("width","206px");
	
	});
	
	var scrollTop=Math.max(document.documentElement.scrollTop,document.body.scrollTop);
	var window_height=jQuery(window).height()
	var top_min=pagent.offset().top;
	var importwf_height=pagent.find(".importwf").height();
	if((top_min+importwf_height)>(scrollTop+window_height)){
		window.scrollTo(0,(top_min+importwf_height));
	}

  function  showOrHide(e)
  {
  
  
    var containera = jQuery(item).parent().parent().parent();

	var containerb= $(".autocomplete-suggestions");

		if ((!containera.is(e.target) // if the target of the click isn't the container...
			&& containera.has(e.target).length === 0)  &&  (!containerb.is(e.target) && containerb.has(e.target).length === 0)) // ... nor a descendant of the container
		{
			jQuery(".imageItem").css("display","none");
			jQuery(".imgdiv").removeClass("imgdiv");
			jQuery(item).attr("src","/images/ecology8/importwf_wev8.png");
			flowimport.css("display","none");
            containerb.remove();
			$(document).unbind("mousedown",showOrHide);
		}
	 
   }
     $(document).bind("mousedown",showOrHide);

	 }
  });




 
/*

  var li=jQuery(item).parent();
  var offset=li.offset();
  var flowimport=jQuery("<div class='flowimport' style='position:absolute;'><input></div>");
  flowimport.css("left",offset.left);
  flowimport.css("top",offset.top);
  flowimport.css("width",li.outerWidth()+'px');
  
  flowimport.find("input").css("width",li.outerWidth()+'px');
  jQuery(document.body).append(flowimport);


   var countries = [
       { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
		   { value: 'Andorra', data: 'AD' },
       // ...
       { value: 'Zimbabwe', data: 'ZZ' },
	   { value: 'Zimbabwe', data: 'ZZ' },
	   { value: '中国', data: '中国' }
    ];

   
   flowimport.find("input").autocomplete({
        lookup: countries,
        onSelect: function (suggestion) {
            alert('You selected: ' + suggestion.value + ', ' + suggestion.data);
        },
        //插件扩展
        iconUrl:"/images/ecology8/avatar_wev8.png"
    });

  function  showOrHide(e)
  {
  
  
    var containera = flowimport;
	var containerb= $(".autocomplete-suggestions");

    if ((!containera.is(e.target) // if the target of the click isn't the container...
        && containera.has(e.target).length === 0)  &&  (!containerb.is(e.target) && containerb.has(e.target).length === 0)) // ... nor a descendant of the container
    {
        containera.remove();
        containerb.remove();
	    $(document).unbind("mousedown",showOrHide);
    }
 
  
  }




   $(document).bind("mousedown",showOrHide);

   
 */



}
function showAlert(title){
	jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
	jQuery("#warn").css("top",215+document.body.scrollTop);
	jQuery("#warn").find("label").html(title);
	jQuery("#warn").css("display","block");
	setTimeout(function (){
		jQuery("#warn").css("display","none");
	},1500);
}
//添加自定义

function addWorkflow(wfid,typeid,img,text){
	//alert(wfid);
//	var url=document.location.href; 
	jQuery("#weaver").find("input[name='worktypeid']").val("T"+typeid);
	jQuery("#weaver").find("input[name='workflowid']").val("W"+wfid);
//	jQuery("#weaver").find("input[name='url']").val(url);
	weaver.submit();
	jQuery(img).parent().remove();
	//居中显示
	//showAlert("已成功添加到自定义流程中！");
	 showAlert("<%=SystemEnv.getHtmlLabelName(84520,user.getLanguage())%>");
}
//删除自定义

function removeWorkflow(wfid,typeid,img){
	//alert(wfid);

	var li=jQuery(img).parent().parent().parent();

	var ul=li.parent();

	var size=ul.find(".centerItem").length;
	 
	jQuery("#weaver").find("input[name='worktypeid']").val("T"+typeid);
	jQuery("#weaver").find("input[name='workflowid']").val("W"+wfid);
		
	var b=true;

	if(jQuery(".commonitem").length==0&&jQuery(".listbox2").length==1&&size==1){
		var url=document.location.href;
		jQuery("#weaver").find("input[name='url']").val(url);
		weaver.target="_self";
		b=false;
	}

//	console.log(weaver.target);

	weaver.submit();
	
	if(b){
		//移除掉该条信息

		
		var div=ul.parent();

	//	console.dir(div);

		if(size==1){
			div.remove();
		}else{
			li.remove();
		}
		//showAlert("已成功从自定义流程中移除！");
          showAlert("<%=SystemEnv.getHtmlLabelName(84521,user.getLanguage())%>");
		//div.find(".titlecontent").find("font").text("("+(size-1)+")");
	}
}
function onuserdefault(flag){
	if(flag==0){
		$G("needall").value = 1;
	}else{
		$G("needall").value = 0;
	}
	$G("needPopupNewPage").value="<%=needPopupNewPage%>";
	$G("isec").value="1";
	$G("topage").value="<%=topage%>";
	$G("subform").action = "/workflow/request/RequestType.jsp";
	$G("subform").submit();
}

function onNewRequest(wfid,agent,beagenter){
	jQuery.post('AddWorkflowUseCount.jsp',{wfid:wfid});
<%
	if("true".equals(needPopupNewPage)){
%>
	    var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&beagenter="+beagenter;
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
	    var szFeatures = "top=0," ;
 	    szFeatures +="left=0," ;
	    szFeatures +="width="+width+"," ;
	    szFeatures +="height="+height+"," ;
	    szFeatures +="directories=no," ;
	    szFeatures +="status=yes,toolbar=no,location=no," ;
	    szFeatures +="menubar=no," ;
	    szFeatures +="scrollbars=yes," ;
	    szFeatures +="resizable=yes" ; //channelmode
	    window.open(redirectUrl,"",szFeatures) ;
<%
	}else{
%>
	    document.getElementById("workflowid").value=wfid;
	    document.getElementById("isagent").value=agent;
	    document.getElementById("beagenter").value=beagenter;
	    document.subform.action="AddRequest.jsp";
	    document.subform.submit();
<%
	}
%>
}

function onNewWindow(redirectUrl){
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
	    var szFeatures = "top=0," ;
 	    szFeatures +="left=0," ;
	    szFeatures +="width="+width+"," ;
	    szFeatures +="height="+height+"," ;
	    szFeatures +="directories=no," ;
	    szFeatures +="status=yes,toolbar=no,location=no," ;
	    szFeatures +="menubar=no," ;
	    szFeatures +="scrollbars=yes," ;
	    szFeatures +="resizable=yes" ; //channelmode
	    window.open(redirectUrl,"",szFeatures) ;
}
</script>