
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="java.util.*"%>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper"%>
<%@ page import="java.util.*,java.sql.Timestamp"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="java.util.Date"%>
<%@ page import="weaver.file.FileUpload" %>
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
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="jobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkFlowInit" class="weaver.soa.workflow.WorkFlowInit" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportComInfo"
	class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager"
	scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/css/request_wev8.css" type="text/css" rel="STYLESHEET">
		<script  src='/js/ecology8/jquery_wev8.js'></script>
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
		
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		<script  src='/js/ecology8/weaverautocomplete/jquery.autocomplete_wev8.js'></script>

		<script type="text/javascript">
			jQuery(function(){
				var colNum = parent.getcookie("wfnewCol");
				if(colNum === "onecol"){
					jQuery("input[name='itemname'][value='mulitcol']").parent("div.menuitem").css("display","none");
					jQuery("input[name='itemname'][value='onecol']").parent("div.menuitem").css("display","block");
					jQuery("#colnum4show").val("onecol");
					jQuery(".itemdetail").css("width","100%");
				}
				jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	  		 	jQuery("#hoverBtnSpan").hoverBtn(); 
				
			});
			function onBtnSearchClick(){
				var searchText=parent.jQuery("#searchInput").val();

				var searchLength=searchText.length;
			
				var innerSearchText=searchText.toLowerCase();
				var innerText="";
				var bindex="";
				var searchStr="";
				var innerHtml="";

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
					//窗口高度
					var windheight=$(window).height();	  
					 
					//滚动条高度

					var scrollheight=$(document).height()-windheight;
					if((top_min-100)<scrollheight){
						top_min=top_min-100;
					}else{
						top_min=scrollheight;
					}
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
             width:99%;
          /**   border: 1px solid #ccc; **/
			 margin-bottom: 32px;
			 margin-right:0px;
             }

            .listbox2 .titleitem{
			height: 26px;
            line-height: 26px;
         /**   background: #F7F7F7;**/
            font-weight: bold;
		/**	padding-left: 10px;**/
			border-bottom: 2px solid #e4e4e4;
			}
         
            .listbox2 .opimg{
			vertical-align: middle;
			margin-right:10px;
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
			 border-bottom:1px dashed #f0f0f0;
			 padding-left: 0px;
		/**	 background-image:url(http://localhost:9090/images/ecology8/top_icons/1-1_wev8.png);
			 background-position:0px 50%;
			 background-repeat:no-repeat no-repeat;**/
            }
          

		   TABLE.ViewForm A:link {
			  COLOR: grey;
			  TEXT-DECORATION: none;
			  vertical-align: middle;
			  line-height: 24px;
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
				border-bottom: 2px solid #e4e4e4;
			/**	padding-left: 10px;**/
			}
			
			.ViewForm .increamentinfo{
			  color:grey;
			  margin-left: 10px;
			}
			#warn{
				width: 260px;
				height: 65px;
				background-color: gray;
				position: absolute;
				display:none;
				background: url("/images/ecology8/addWorkGround_wev8.png");
			}
			.titlecontent{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
			}
			.commian{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
				border-bottom:2px solid #9e17b6;
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

             .letters
			 {
			   
			   position:fixed;
			   left:0;
			   background:white;
			   padding-top:10px;
			   z-index:999;
			   width:100%;
			   top: expression( (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) + 'px' );
			   
			 }

			 .lettersplacehold{
			   height:50px;
               width:100%;
			 }
             
			 .letters ul{
			 
			    list-style: none;
				padding: 0;
				margin-left: 10px;
				font-size: 14px;
				margin-top: 2px;

			 }

			 .letters .letteritem{
			   
				float: left;
				height: 30px;
				line-height: 30px;
				margin-left: -1px;
				border: 1px dashed #dddddd;
				width: 30px;
				text-align: center;
				cursor:pointer;
				color: #667dad;
				position: relative;
			 }

			 .letterhasdata{
			 	 position:absolute;
				 top:0px;
				 right:0px;
				 display:none;
			 }
			 
			 .letters a{
			 
				 color: #e5e5e5;
				 width: 100%;
				 display: inline-block;
				 height: 100%;
				 cursor:text;
				 
			 }

             .letters a:hover{
			  
             margin-top:-3px;
			 
			 

			 }
             
			 .selectedletter a:hover
			 {
			  color:white !important;
			 
			 }
			
             .acolor{
			 
			 color:white !important;
			 
			 }



			 .lettercontainer{
			 
			 margin-bottom:40px;
			 clear: left;
			 
			 }

			 .signalletter{
			 
			 height: 45px;
			line-height: 45px;
			font-size: 18px;
			margin-left: 8px;
		    font-weight: 200;;
			border-bottom: 2px solid #e2e2e2;
			 
			 }
             .letterline{
			   height:2px;
               width:70px;
			   margin-top: -2px;
			 }
			 .itemdetail{
			  height:32px;
			  line-height:32px;
			  width: 30%;
			  margin-right: 3%;
              float: left;
			
			 }
              /*帮助元素里面的节点垂直居中展示*/
			   .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
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


            
			.selectedletter{
			
			  background:#2a8ede !important;
              color:white !important;
			
			
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
             
			.lettercontainer a{
				COLOR: #123885 !important;
			}
			.lettercontainer a:hover{
				COLOR: red !important;
			}
		</style>
	<link href="/css/ecology8/request/requestTypeShow_wev8.css" type="text/css" rel="STYLESHEET">
	</head>
	<%!public String getRandom() {
		return "" + (((int) (Math.random() * 1000000) % 3) + 1);
	}%>
	<%

String  freewfid="0";
String offical = Util.null2String(request.getParameter("offical"));
//获取自由流程id(系统中只有一个流程绑定该具体单据)
String  freeWfSql="select  id  from workflow_base a  where  a.formid=285";
RecordSet.executeSql(freeWfSql);
if(RecordSet.next())
{
  freewfid=RecordSet.getString("id");
}



String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();
String belongtoshow = "";				
RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userid);
if(RecordSet.next()){
	belongtoshow = RecordSet.getString("belongtoshow");
}
String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){
userIDAll = userid+","+Belongtoids;
}
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
	if(info!=null && infoId!=0){
		selectedworkflow = info.getSelectedContent();
	}else if(!"".equals(selectedContent)){
		selectedworkflow = selectedContent;
	}
	if(!"".equals(selectedworkflow)){
		List workflowNum = Util.TokenizerString(selectedworkflow,"|");
		int tnum = 0;
		for(Iterator it = workflowNum.iterator();it.hasNext();){
			if(((String)it.next()).startsWith("W")) tnum++;
		}
		if(tnum==1) navigateTo = true;
	}
} else if(usertype==0){
	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
	if(RecordSet.next()){
	    selectedworkflow=RecordSet.getString("selectedworkflow");
	    isuserdefault=RecordSet.getString("isuserdefault");
	    commonuse = RecordSet.getString("commonuse");
	}
}   

/* edited end */
if(!"".equals(selectedContent)){
	selectedworkflow = selectedContent;
}
if(!selectedworkflow.equals(""))    selectedworkflow+="|";

String needall=Util.null2String(request.getParameter("needall"));
if(needall.equals("1")) {		//全部流程
	isuserdefault="0";
	//fromAdvancedMenu=0;
}
if(needall.equals("0")) {		//收藏夹流程

	//isuserdefault="1";		//收藏夹默认为空加上此行

	if("".equals(selectedworkflow)){
		needall="-1";
	}
}
int tdNum=0;
int tdOnum=0;
String[][] color={{"#166ca5","#953735","#01b0f1"},{"#767719","#f99d52","#cf39a4"}};
int colorindex=0;
%>
	<body >
		<script type="text/javascript">	
			 if(parent.jQuery("#searchInput").length && parent.jQuery("#searchInput").length===1){
				parent.jQuery("#searchInput").remove();
			 }
		</script>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="text" id='searchInput' class="searchInput" name="flowTitle" value=""/>
					<!--<span id="advancedSearch" class="advancedSearch">高级搜索</span>-->
		         	<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<script type="text/javascript">
		     
		
             function   bindInputEvent()
			 {
			    
                if(parent.jQuery("#searchInput").length && parent.jQuery("#searchInput").length===1)
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
			<input type="hidden" id=offical name=offical value="<%=offical %>">
			<input type="hidden" id=beagenter name=beagenter>
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
//List wfcreateruleuserinfo = new ArrayList();
//存放可以创建对应流程的人
//数据结构：key ： 流程id，value:可以创建这条流程的所有人员，类型为list
Map<String, List<String>> wfcreateinfo = new HashMap<String, List<String>>();
ArrayList NewWorkflowTypes = new ArrayList();
ArrayList NewWorkflows = new ArrayList();
List<String> userlist = null;
String wfcrtSqlWhereMain = "";
User BelongtoUser = new User();
int Belongtoid=0;
String[] arr = null;
String sql = "";
//获取流程新建权限体系sql条件
if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){
arr = Belongtoids.split(",");
for(int i=0;i<arr.length;i++){
Belongtoid = Util.getIntValue(arr[i]);
BelongtoUser = WorkFlowInit.getUser(Belongtoid);
BelongtoUser.getUserSubCompany1();
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(BelongtoUser, "t1");
 sql="select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id   and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;
RecordSet.executeSql(sql);

while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}

//所有可创建流程集合
sql = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
RecordSet.executeSql(sql);

while(RecordSet.next()){
    String _workflowid = RecordSet.getString("workflowid");
	NewWorkflows.add(_workflowid);
	//获取可以创建这条流程的人员集合

	 userlist = wfcreateinfo.get(_workflowid);
	//第一次为空

	if (userlist == null) {
	    userlist = new ArrayList<String>();
	    wfcreateinfo.put(_workflowid, userlist);
	}
	
	//把当前那个户添加进去
	userlist.add(BelongtoUser.getUID() + "");
}
}
}

wfcrtSqlWhereMain = shareManager.getWfShareSqlWhere(user, "t1");
String sqlmain="select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id   and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhereMain;
RecordSet.executeSql(sqlmain);

while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}


//所有可创建流程集合
sqlmain = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhereMain;
RecordSet.executeSql(sqlmain);

while(RecordSet.next()){
    String _workflowid = RecordSet.getString("workflowid");
	NewWorkflows.add(_workflowid);
	//获取可以创建这条流程的人员集合

	 userlist = wfcreateinfo.get(_workflowid);

	//第一次为空

	if (userlist == null) {
	    userlist = new ArrayList<String>();
	    wfcreateinfo.put(_workflowid, userlist);
	}
	
	//把当前那个户添加进去
	userlist.add(user.getUID() + "");
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
	sql = "select distinct t1.workflowtype,t.workflowid,t.bagentuid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agentConditionSet t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid in ("+userIDAll+") order by t1.workflowtype,t.workflowid";
	
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
        //忽略自由流程
        if(freewfid.equals("0") || freewfid.equals(agentworkflow))
			  continue;

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
	        	if(!offical.equals("1")||WorkflowComInfo.getIsWorkflowDoc(""+agentworkflow).equals("1")){
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

//如果用户自身有创建自由流程的权限
if(NewWorkflows.contains(freewfid))
 {
	 canFreeWfCreate=true;
     //如果包含自由流程
     freewfCreater=userid+",";
     int  increment=-1;
     for(int i=0;i<AgentWorkflows.size();i++)
	 {
	     if((AgentWorkflows.get(i)+"").equals(freewfid))
		 {
		    
			   freewfCreater=freewfCreater+Agenterids.get(i);
			   increment=i;
    	       break;
    	 
		 }else
          continue;
	 }
	 //移除自由流程
	 NewWorkflows.remove(freewfid);
   if(increment!=-1)
	{

		AgentWorkflows.remove(increment);
	    Agenterids.remove(increment);
	}
 }
//用户自身不能创建自由流程
else
if(AgentWorkflows.contains(freewfid))
 {
     canFreeWfCreate=true;
	 int  increment=-1;
     for(int i=0;i<AgentWorkflows.size();i++)
	 {
	     if((AgentWorkflows.get(i)+"").equals(freewfid))
		 {
		     freewfCreater=freewfCreater+Agenterids.get(i);
			 increment=i;
    	     break;
		 }else
          continue;
	 }
    if(increment!=-1)
	{

		AgentWorkflows.remove(increment);
	    Agenterids.remove(increment);
	}
 }

List inputReportFormIdList=new ArrayList();
String tempWorkflowId=null;
String tempFormId=null;
String tempIsBill=null;
for(int i=0;i<NewWorkflows.size();i++){
	tempWorkflowId=(String)NewWorkflows.get(i);
	if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+tempWorkflowId).equals("1"))continue;
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

for(int i=0;i<AgentWorkflows.size();i++){
	tempWorkflowId=(String)AgentWorkflows.get(i);
	if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+tempWorkflowId).equals("1"))continue;
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
 
 <div>

 <div class='lettersplacehold'></div>
  <div class='letters' style='top:0;_POSITION: absolute;'>
	  <ul>
         <li class='letteritem'><a class='#A'>A</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#B'>B</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#C'>C</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#D'>D</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#E'>E</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#F'>F</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#G'>G</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#H'>H</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#I'>I</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#J'>J</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#K'>K</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#L'>L</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#M'>M</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#N'>N</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#O'>O</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#P'>P</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#Q'>Q</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#R'>R</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#S'>S</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#T'>T</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#U'>U</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#V'>V</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#W'>W</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#X'>X</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#Y'>Y</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#Z'>Z</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem' style='width:60px'><a class='#其他'><%=SystemEnv.getHtmlLabelName(375, user.getLanguage())%></a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
	  </ul>  

  </div>
 
<script>
jQuery(".letteritem a").click(function(){
     if(jQuery(this).hasClass("linkletteritem")){
	      jQuery(".letteritem a").parent().removeClass("selectedletter");
	      jQuery(".letteritem a").removeClass("acolor");
	      $(this).parent().addClass("selectedletter");
		  $(this).addClass("acolor");
	       
	      var  letterinfo=$(this).html();
		  var  letterdetail=$("#"+letterinfo).parent();
		  var  topheight=letterdetail.offset().top;
		  //窗口高度
		  var windheight=$(window).height();	  
		  //滚动条高度

		  var scrollheight=$(document).height()-windheight;
		  if(topheight<scrollheight){
	          $(document).scrollTop(topheight-50);
		  }else{
		  	  $(document).scrollTop(scrollheight);
		  }
	 }
});
</script>
   <div class='wfcontentarea'>
			<table  width="100%" border="0" cellspacing="0"
				cellpadding="0">
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
							<TABLE class="Shadow"  style="width:100%;">
								<tr>
									<td valign="top">
<%
       //包含特殊字符的流程

	   final TreeMap<String,String>  specialtmap=new TreeMap<String,String>();  

       //按字母排序流程

	   final Map<String,Map<String,String>>  letterdatas=new TreeMap<String,Map<String,String>>();
	 
	   String specialstr="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*()--+|{}【】‘；：”“’。，、？]"; 
     
 if(true)
 {
%>
<!-- 常用流程  结束 -->	
													
<tr class=field>

	<%
	int i=0;
	int needtd=rownum;
	int numRows=0;

	while(WorkTypeComInfo.next()){
		
		String wftypename=WorkTypeComInfo.getWorkTypename();
		String wftypeid = WorkTypeComInfo.getWorkTypeid();
		
		if(offical.equals("1") && !WorkTypeComInfo.hasWorkflowDoc(wftypeid))continue;

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
				
				}
				
			}
			InputReportComInfo.setTofirstRow();
  }

    //流程对应的li是否创建
    boolean  isWfShow; 

   
	while(WorkflowComInfo.next()){

		String wfname=WorkflowComInfo.getWorkflowname();
        
		String wfid = WorkflowComInfo.getWorkflowid();
		if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+wfid).equals("1"))continue;

	 	String curtypeid = WorkflowComInfo.getWorkflowtype();

        String  isImportWf=WorkflowComInfo.getIsImportwf();

     

		isWfShow=false; 

        int isagent=0;

        int beagenter=0;

        String agentname="";

        ArrayList agenterlist=new ArrayList();

	 	if(!curtypeid.equals(wftypeid)) continue;

     

	 	//check right
	 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
	 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& fromAdvancedMenu==1) continue;
	 	

		if(NewWorkflows.indexOf(wfid)!=-1){
			//QC247202 Begin
			String[] currentData = wfname.split("`~`");
			String currentLan = user.getLanguage() + " ";
			if(specialstr.indexOf(wfname.charAt(0)) >= 0 ) {
				//如果workflowname是多语言格式的
				if(currentData.length > 3) {
					for(String currentStr : currentData) {
						if(currentStr.length() > 2) {
							if (currentStr.substring(0, 2).equals(currentLan)) {
								wfname = currentStr.substring(2);
							}
						}
					}
					char multiLanChinese = wfname.charAt(0);
					String multiLanLetter = PinyinHelper.toHanyuPinyinStringArray(multiLanChinese) == null   ?   multiLanChinese + ""   :   PinyinHelper.toHanyuPinyinStringArray(multiLanChinese)[0];
					multiLanLetter = (multiLanLetter.charAt(0) + "").toUpperCase();
					Map<String,String> multiLanMap;
					if(!letterdatas.containsKey(multiLanLetter)) {
						multiLanMap = new LinkedHashMap<String,String>();
						letterdatas.put(multiLanLetter,multiLanMap);
					}else {
						multiLanMap = letterdatas.get(multiLanLetter);
					}
					multiLanMap.put(wfid,wfname);
				}
				//非多语言包
				else {
					specialtmap.put(wfid,wfname);
				}
			//QC247202 End
			}
		else
		{
	

		   char chinese = wfname.charAt(0);

		   String letter=PinyinHelper.toHanyuPinyinStringArray(chinese)==null?chinese+"":PinyinHelper.toHanyuPinyinStringArray(chinese)[0];
           letter=(letter.charAt(0)+"").toUpperCase();
           Map<String,String>  letteritems;	 

		  
		   if(!letterdatas.containsKey(letter))
			{
		      letteritems=new  LinkedHashMap<String,String>();
              letterdatas.put(letter,letteritems);
			 }
            else
			{
			  letteritems=letterdatas.get(letter);
			}
			  letteritems.put(wfid,wfname);
		}
	   
        }
		


	 	if(isfirst ==1){
	 		isfirst = 0;
	
															}
	
       
	        //流程代理信息
            if(AgentWorkflows.indexOf(wfid)>-1){
	 	
		        //如果未创建，则创建该流程对应得而li节点
                if(!isWfShow)
				{
					countinfo++;
				
                    agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
                    isagent=1;
					for(int k=0;k<agenterlist.size();k++){
					beagenter=Util.getIntValue((String)agenterlist.get(k),0);
					agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
								
                                  }
        
				} 
				 
			
                
           
		}
	
        navigateToWfid = Util.getIntValue(wfid);
	 	navigateToIsagent = isagent;
        navigateToAgenter = beagenter;
		}
		WorkflowComInfo.setTofirstRow();
	%>


													<%
													colorindex++;
		if(needtd==0){
			needtd=rownum;

													tdNum++;
		}
	}
	%>


<%
	
	
       String[] colorful=new String[]{"#9e17b6","#166ca5","#953735","#01b0f1","#cf39a4"};
     
	   int  itemcolorindex=0;

       
      if(!specialtmap.isEmpty())
       letterdatas.put(""+SystemEnv.getHtmlLabelName(375,user.getLanguage()),specialtmap);


	    for ( Map.Entry<String, Map<String,String>> e : letterdatas.entrySet() )
		{
             
          %>
             
			  
          <div class='lettercontainer'>
		     <div  class='<%=e.getKey()%>  signalletter'  style='color:<%=colorful[itemcolorindex%5]%>'>
			 <a id='<%=e.getKey()%>' style='color:<%=colorful[itemcolorindex%5]%>'><%=e.getKey()%></a></div>	
           
		     <script>
				    if($("a[class='#<%=e.getKey()%>']").length>0)
			          {
				          var letteritem=$("a[class='#<%=e.getKey()%>']");
				         // $("a[href='#<%=e.getKey()%>']").parent().find(".letterhasdata").show();
                          letteritem.css("color","#667dad");
						  letteritem.css("cursor","pointer");
                          letteritem.addClass("linkletteritem");
			          }

		     </script>



			 <div class='letterline' style='background:<%=colorful[itemcolorindex%5]%>'></div> 


		   <%
			Map<String,String> item=e.getValue();
		    int isagent=0;
			int beagenter=0;
			String agentname="";
		    ArrayList agenterlist=new ArrayList();
			for(Map.Entry<String,String>  entry:item.entrySet())
			   {
				String wfid=entry.getKey();
				String isImportWf=WorkflowComInfo.getIsImportwf(wfid);
				String curtypeid=WorkflowComInfo.getWorkflowtype(wfid);
				String wfname=WorkflowComInfo.getWorkflowname(wfid);
				userlist = wfcreateinfo.get(wfid + "");																
																    for (int ii = 0; ii < userlist.size()-1; ii++) {
																		for (int j = userlist.size() - 1; j > ii; j--) {
																			if (userlist.get(j).equals(userlist.get(ii))) {
																						 userlist.remove(j);
																				}
																		}
																	}


                %>
				
				 <div class='itemdetail'>
				 <!--<span class="middlehelper"></span>-->
				 
				 <div class='centerItem'>
					<div class='fontItem'>

					 <img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png" style="vertical-align: middle;"/>
					 
					
                   	<%
																int importuser2 = userid;
													         if(userlist.size()>0){
															  int belongtouserid=0;
															  if(userlist.contains((""+userid))){  
																  %>
																  <a style="color:grey;margin-left:8px;margin-right:10px;vertical-align: middle;" href="javascript:onNewRequest(<%=wfid%>,0,0);">  <%=Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage())%>
																  </a> 		  
															<%  }else{
																for(int k=0;k<1;k++){
																 belongtouserid=Util.getIntValue((String)userlist.get(k),0);	
																 importuser2 = Util.getIntValue((String)userlist.get(k),0);
																}
																 %>	
																 <a style="color:grey;margin-left:8px;margin-right:10px;vertical-align: middle;" href="javascript:onNewRequest(<%=wfid%>,0,<%=belongtouserid%>);">  
																   <%=Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage())%>
																  </a>									
													<%	}
   }%>
				   

					</div>
					<div class='imageItem'>
						<% //流程是否可以导入
						if(isImportWf.equals("1")) 
						{ %>
							 <div class='imgspan import'>
								<img onclick="importWf('<%=wfid %>',this,'<%=importuser2%>');" class='opimg'   src='/images/ecology8/importwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(24270,user.getLanguage())%>" />
							 </div>
                        <%}%>
						<% //创建代理流程
					if(AgentWorkflows.indexOf(wfid)>-1 || (userlist.size()>1 && "1".equals(belongtoshow))) 
			    {%>
					<div class='imgspan agent'>
				      	<img  onclick="agentWf('<%=wfid %>',this);" class='opimg' src='/images/ecology8/mainsubwf_wev8.png' title="<%=SystemEnv.getHtmlLabelName(84522,user.getLanguage())%>" />
				    </div>
				<%}%>
				
				 <%
			       if(needall.equals("1")&&selectedworkflow.indexOf("W"+wfid+"|")==-1&&!offical.equals("1"))
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
				  <!--流程主次账号div-->
							<div  class='agentlistdata' style='display:none'>
                                                             <%
													         if(userlist.size()>1 && "1".equals(belongtoshow)){		 
                                                             	isagent=0;	
															    %>
																
																<div class='agenter' style="float:none"><%=SystemEnv.getHtmlLabelName(17747, user.getLanguage())%></div>
															    <%
																for(int k=0;k<userlist.size();k++){
																int belongtouserid=Util.getIntValue((String)userlist.get(k),0);
																if(belongtouserid!=userid){
																String username=ResourceComInfo.getResourcename((String)userlist.get(k));
																String ownDepid = ResourceComInfo.getDepartmentID((String)userlist.get(k));
																String depName = DepartmentComInfo.getDepartmentname(ownDepid);
																String jobName = jobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle((String)userlist.get(k)));
																 %>																		
																<div class='agenter' style="float:none">
                                                                   <a style="vertical-align: middle;color:#5b5b5b;cursor: pointer;"
																		onclick="javascript:onNewRequest2(<%=wfid%>,<%=isagent%>,<%=belongtouserid%>);">
																		<%=Util.toScreen(depName,user.getLanguage())%>/<%=Util.toScreen(jobName,user.getLanguage())%> </a>
                                                               </div>
                                                                   <%
																}
																	  }%>

																  <%}
																 %>
					
				
					<!--流程代理div-->
					<% //创建代理流程
					if(AgentWorkflows.indexOf(wfid)>-1) 
					{ 
						agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
						isagent=1;			 
					%>
					<div class='agenter' style="float:none">
					<%=SystemEnv.getHtmlLabelName(84523, user.getLanguage())%>
					</div>
					<%
						for(int k=0;k<agenterlist.size();k++){
							beagenter=Util.getIntValue((String)agenterlist.get(k),0);
							agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
							String ownDepid = ResourceComInfo.getDepartmentID((String)agenterlist.get(k));
							String depName = DepartmentComInfo.getDepartmentname(ownDepid);
							 %>
					<div class='agenter' style="float:none">
			       <a style="vertical-align: middle;color:#5b5b5b;cursor: pointer;"
						onclick="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
						<%=Util.toScreen(agentname,user.getLanguage())%>/<%=Util.toScreen(depName,user.getLanguage())%> </a>
					</div>
						<%}%>
					
					<%}%>
					</div>
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
					<%}%>
				</div>
               </div> 
                 
			  
			   <%
			   }
               %>
            
			 </div>  
		  <%
			itemcolorindex++;
		}
	   
 }
%>
                                    
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
      </div>
 </div>


			<input type="hidden" id="needall" name="needall" value="">
			<input type=hidden name="prjid" value="<%=prjid%>">
			<input type=hidden name="docid" value="<%=docid%>">
			<input type=hidden name="crmid" value="<%=crmid%>">
			<input type=hidden name="hrmid" value="<%=hrmid%>">
			<input type=hidden name="topage" value="<%=topage%>">
		</form>
	 
	  <script>
              jQuery(".centerItem").unbind("mouseover");
			 jQuery(".centerItem").mouseover(function (){
				jQuery(this).css("background-color","#fbfbfb");
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
					jQuery(this).find(".agent img").attr("src","/images/ecology8/mainsubwf_wev8.png");
				}
				if(imports!="none"&&jQuery(this).find(".importwf").length>0){
					jQuery(this).find(".import").addClass("imgdiv");
					if(jQuery(this).find(".importwf").find(".labelText").length>0){
					  jQuery(this).find(".importwf").css("height",76);
					}else{
					  jQuery(this).find(".importwf").css("height",(56+jQuery(".autocomplete-suggestions").height()));
					}
					jQuery(".autocomplete-suggestions").css("display","block");

				}
				else
                    jQuery(this).find(".import img").attr("src","/images/ecology8/importwf_wev8.png");


				jQuery(this).find(".imageItem").css("display","block");
			 })
				
			 jQuery(".centerItem").mouseleave(function (){
				jQuery(this).css("background-color","#ffffff");
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
					//jQuery(item).attr("src","/images/ecology8/importwf_wev8.png");
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
	 	<table width="100%" height="100%"><tr><td align="right" width="40px"><img src='/images/ecology8/addWorkflow_wev8.png'></img></td><td align="left"><label style="margin-left: 5px">ecology8.0开发顺利！</label></td></tr></table>
	 </div>

      <div  class='flowmenuitem'  style='position:fixed;bottom:20px;right:20px;_POSITION: absolute;'>

	      <!-- <div  class='menuitem freewf'>
		  <input type='hidden' name='overitem' value='/images/ecology8/request/freewfover_wev8.png'>
		  <input type='hidden' name='outitem' value='/images/ecology8/request/freewfout_wev8.png'>
		   <input type='hidden' name='itemname' value='freewf'>
		  <img src='/images/ecology8/request/freewfout_wev8.png' ></div>
		   -->
		  <input type="hidden" id="colnum4show" name="colnum4show" value="mulitcol">
		   <!-- 三栏模式 -->
		  <div  class='menuitem  mulitColumn'>
			  <input type='hidden' name='overitem' value='/images/ecology8/doc/doc1coloutover_wev8.png'>
			  <input type='hidden' name='outitem' value='/images/ecology8/doc/doc1colout_wev8.png'>
			  <input type='hidden' name='itemname' value='mulitcol'>
			  <img src='/images/ecology8/doc/doc1colout_wev8.png' style="cursor:pointer;z-index:999;" title="<%=SystemEnv.getHtmlLabelName(84525,user.getLanguage())%>">
		  </div>
		  <!-- 一栏模式 -->
		  <div  class='menuitem  oneColumn' style="display:none">
			  <input type='hidden' name='overitem' value='/images/ecology8/doc/docsimpleoutover_wev8.png'>
			  <input type='hidden' name='outitem' value='/images/ecology8/doc/docsimpleout_wev8.png'>
			  <input type='hidden' name='itemname' value='onecol'>
			  <img src='/images/ecology8/doc/docsimpleout_wev8.png' style="cursor:pointer;z-index:999;" title="<%=SystemEnv.getHtmlLabelName(84526,user.getLanguage())%>">
		  </div>
		  
		  <div  class='menuitem'>
			  <input type='hidden' name='overitem' value='/images/ecology8/request/wfsimpleover_wev8.png'>
			  <input type='hidden' name='outitem' value='/images/ecology8/request/wfsimpleout_wev8.png'>
			  <input type='hidden' name='itemname' value='simple'>
			  <img src='/images/ecology8/request/wfsimpleout_wev8.png' style="cursor:pointer;z-index:999;" title="<%=SystemEnv.getHtmlLabelName(84527,user.getLanguage())%>">
		  </div>
		  <div  class='menuitem' style='display:none'>
			  <input type='hidden' name='overitem' value='/images/ecology8/request/voiceover_wev8.png'>
			  <input type='hidden' name='outitem' value='/images/ecology8/request/voiceout_wev8.png'>
			  <input type='hidden' name='itemname' value='voice'>
			  <img src='/images/ecology8/request/voiceout_wev8.png' style="cursor:pointer;z-index:999;" title="<%=SystemEnv.getHtmlLabelName(84528,user.getLanguage())%>">
		  </div>

		  <div  class='menuitem'>
			  <input type='hidden' name='overitem' value='/images/ecology8/request/topover_wev8.png'>
			  <input type='hidden' name='outitem' value='/images/ecology8/request/topout_wev8.png'>
	          <input type='hidden' name='itemname' value='totop'>
			  <img src='/images/ecology8/request/topout_wev8.png' style="cursor:pointer;z-index:999;" title="<%=SystemEnv.getHtmlLabelName(84529,user.getLanguage())%>">
		  </div>
	  
	  </div>

      <script> 
	   
         <%
	     //如果无自由节点权限

	     if(!canFreeWfCreate)
		 {
	   %>    
            jQuery(".flowmenuitem  .freewf").hide();
		<%
		 }	   
		%>

	    jQuery(".menuitem").mouseover(function(){
			  jQuery(this).find("img").attr("src",jQuery(this).find("input[name='overitem']").val());
		});

        jQuery(".menuitem").mouseleave(function(){
			  jQuery(this).find("img").attr("src",jQuery(this).find("input[name='outitem']").val());
		});

		jQuery(".menuitem").click(function(){
		      var itemname=jQuery(this).find("input[name='itemname']").val();
			  if(itemname==='simple'){
                 //保存流程展示方式
                 $.ajax({
					  type: "POST",
					  url: "/workflow/request/RequestTypeShowStyle.jsp",
					  data: { showtype:0,userid:<%=userid%>},
					  success:function( msg ){
	               		if('success'===$.trim(msg)){
						  var iframe=jQuery(parent.document).find(".e8_box ").find("iframe");
						  var links=jQuery(parent.document).find(".tab_menu").find("a");
						  var url="/workflow/request/RequestTypeShow.jsp?offical=<%=offical%>&needPopupNewPage=true&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
						  var colnum4show = jQuery("#colnum4show").val();
						  $(links[0]).attr("href",url+"&dfdfid=a&needall=1&colnum4show="+colnum4show);
						  $(links[1]).attr("href",url+"&dfdfid=b&needall=0&colnum4show="+colnum4show)
	               
						  if('<%=needall %>'==='0')	{
						  	  iframe.attr("src",url+"&dfdfid=b&needall=0&colnum4show="+colnum4show);
						  }else	 {
						  	  iframe.attr("src",url+"&dfdfid=a&needall=1&colnum4show="+colnum4show);
						  }	
						}else{
						    alert(" <%=SystemEnv.getHtmlLabelName(84518,user.getLanguage())%>");
						}
					}
				});  
			  }else if(itemname==='totop'){
				  jQuery(window).scrollTop(0);
			  }else if(itemname==='freewf'){
                jQuery.post('AddWorkflowUseCount.jsp',{wfid:'<%=freewfid%>'});
			    
				openDialog("<%=SystemEnv.getHtmlLabelName(83284,user.getLanguage())%>", "/workflow/request/AddRequest.jsp?workflowid=<%=freewfid%>&isagent=0&beagenter=0&handdata=<%=freewfCreater%>");
		       
				//打开转发对话框

				function openDialog(title,url) {
				　　var dlg=new window.top.Dialog();//定义Dialog对象
					// dialog.currentWindow = window;
				　　dlg.Model=false;
				　　dlg.Width=952;//定义长度
				　　dlg.Height=530;
				　　dlg.URL=url;
				　　dlg.Title=title;
					dlg.maxiumnable=false;
				　　dlg.show();
					// 保留对话框对象

					window.top.windowdialog=dlg;
			　	}	  
 
			  }else if(itemname==="onecol"){
				  jQuery(".itemdetail").css("width","30%");
			  	  jQuery("#colnum4show").val("mulitcol");
			  	  jQuery(this).css("display","none");
			  	  jQuery("input[name='itemname'][value='mulitcol']").parent("div.menuitem").css("display","block");
			  	  parent.setcookie("wfnewCol","mulitcol");
			  }else if(itemname==="mulitcol"){
				  jQuery(".itemdetail").css("width","100%");
				  jQuery("#colnum4show").val("onecol");
				  jQuery(this).css("display","none");
				  jQuery("input[name='itemname'][value='onecol']").parent("div.menuitem").css("display","block");
				  parent.setcookie("wfnewCol","onecol");
			  }

		});
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

    showAlert("<%=SystemEnv.getHtmlLabelName(84524,user.getLanguage())%>");
}


/**
主次流程
**/
function MainAndSubWf(wfid,item)
{
	item.src="/images/ecology8/mainsubwf_wev8.png";

	var pitem=jQuery(item).parent();
	var offset=pitem.position();
//	console.dir(offset);
	pitem.addClass("imgdiv");
	
	var pagent=pitem.parent().parent();
	var agent=pagent.find(".agentlistdata");
	agent.css("display","block");
	agent.css("left",(pagent.width()-pitem.parent().width())+offset.left+pitem.width()-agent.width());
	agent.css("top",(pitem.height()+offset.top-30));

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


    function  showOrHideForMainsub(e)
   {
  
         var containera = jQuery(item).parent().parent().parent();

		var containerb = pitem.parent();

		if ((!containera.is(e.target) // if the target of the click isn't the container...
			&& containera.has(e.target).length === 0)  &&  (!containerb.is(e.target) && containerb.has(e.target).length === 0)) // ... nor a descendant of the container
		{
			jQuery(".imageItem").css("display","none");
			jQuery(".imgdiv").removeClass("imgdiv");
			jQuery(".agentlistdata").css("display","none");
			jQuery(item).attr("src","/images/ecology8/mainsubwf_wev8.png");
			$(document).unbind("mousedown",showOrHideForMainsub);
		}
	 
   }
    
    $(document).bind("mousedown",showOrHideForMainsub);


}


/**
流程代理
**/
function  agentWf(wfid,item)
{
	item.src="/images/ecology8/mainsubwf_wev8.png";

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
			jQuery(item).attr("src","/images/ecology8/mainsubwf_wev8.png");
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
function importWf(wfid,item,importuser)
{


       
        var pitem=jQuery(item).parent();
		var offset=pitem.position();
		pitem.addClass("imgdiv");
	
		jQuery(item).attr("src","/images/ecology8/importclick_wev8.png");
		var pagent=pitem.parent().parent();
		var flowimport=pagent.find(".importwf");
		flowimport.css("display","block");
		flowimport.css("left",(pagent.width()-pitem.parent().width())+offset.left+pitem.width()-flowimport.width());
		flowimport.css("top",(pitem.height()+offset.top+4));
		
		pagent.find(".agentlistdata").css("display","none");
		
        flowimport.find(".labelText").remove();

		jQuery(".autocomplete-suggestions").remove();


		flowimport.find(".importTxt").html("");
		flowimport.find(".importTxt").append("<input type='text' value=''>");
		flowimport.find("input").css("width","190px");
		flowimport.find("input").css("margin-top","5px");
		flowimport.find("input").css("margin-left","5px");
		flowimport.find("input").css("border","none");


		flowimport.css("height",120);

        generateLoading(flowimport);


 $.ajax({
  type: "POST",
  url: "/workflow/request/RequestImportJson.jsp?f_weaver_belongto_userid="+importuser+"&f_weaver_belongto_usertype=0",
  data: { workflowid: wfid, location: "Boston",importuser: importuser },
	success:function(msg){
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
		flowimport.find("input").bind("keyup",function(){
          	if($(this).val()==""){
           		importWf(wfid,item,importuser);
          	}
        });
	    flowimport.find("input").autocomplete({
			lookup: contentarray,
			autoSelectFirst:true,
			triggerSelectOnValidInput:false,//防止遇到第一个匹配项自动跳转，无法手动选择想要的流程,
			onSelect: function (suggestion) {
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
	
	//控制提示框展示的高度
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
  },
})
	
}
function showAlert(title){
	jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
	var scrollTop = 0;
	try {
		scrollTop = document.documentElement.scrollTop;
	} catch(e) {
		scrollTop = document.body.scrollTop;
	}
	jQuery("#warn").css("top",215+scrollTop);
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
	var li=jQuery(img).parent().parent().parent().parent();
	var size=li.parent().find(".itemdetail").length;
	 
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
	if(b){		//移除掉该条信息

		if(size==1){
			li.parent().remove();
		}else{
			li.remove();
		}
		showAlert("<%=SystemEnv.getHtmlLabelName(84521,user.getLanguage())%>"); 
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
	$G("subform").action = "/workflow/request/RequestType.jsp?offical=<%=offical%>";
	$G("subform").submit();
}

function onNewRequest(wfid,agent,beagenter){
	jQuery.post('AddWorkflowUseCount.jsp',{wfid:wfid});
<%
	if("true".equals(needPopupNewPage)){
%>
	    var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&beagenter="+beagenter+"&f_weaver_belongto_userid="<%=f_weaver_belongto_userid%>;
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



function onNewRequest2(wfid,agent,belongtouserid){
	jQuery.post('AddWorkflowUseCount.jsp',{wfid:wfid});
<%
	if("true".equals(needPopupNewPage)){
%>
	    var redirectUrl = "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&f_weaver_belongto_userid="+belongtouserid;
		var hiddenNames = "prjid,docid,crmid,hrmid,topage".split(",");
		for (var i = 0; i < hiddenNames.length; i++) {
			var hiddenName = hiddenNames[i];
			var hiddenVal = jQuery("input:hidden[name='"+hiddenName+"']").val();
			if (!!hiddenVal) {
				redirectUrl += "&" + hiddenName + "=" + hiddenVal;
			}
		}
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
	  //  document.getElementById("beagenter").value=beagenter;
		document.getElementById("f_weaver_belongto_userid").value=beagenter;
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