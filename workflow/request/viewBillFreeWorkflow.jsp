
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.util.regex.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>


<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page"/>


<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<link rel="stylesheet" type="text/css" href="/kindeditor/skins/default_wev8.css" />
<script type="text/javascript" language="javascript" src="/kindeditor/kindeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/kindeditor/kindeditor-Lang_wev8.js"></script>

<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>



<script>

    var pdocument=jQuery(parent.document);

   //隐藏父菜单

    pdocument.find("#mainRequestFrame").show();
	pdocument.find(".highslide-container").next().css("right","-175px");
    pdocument.find(".highslide-container").next().css("left","inherit");

    

</script>


<!--自由流程样式-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/freeworkflow_wev8.css" />




<style>

table.ke-container {
    border-top: none !important;
	border-left: none !important;
	border-right: none !important;
}
.formtable {
margin-right: 220px;
padding: 10px 10px;
position: relative;
padding-bottom: 0;
background: #ffffff;
}

</style>

	<%

     int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
	 int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
	 int isremark = Util.getIntValue(request.getParameter("isremark"),-1);
	 int billid = Util.getIntValue(request.getParameter("billid"),-1);
	 int formid = Util.getIntValue(request.getParameter("formid"),-1);
	 int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
	 int creater = Util.getIntValue(request.getParameter("creater"),-1);
	 int creatertype = Util.getIntValue(request.getParameter("creatertype"),-1);
	 int isreject = Util.getIntValue(request.getParameter("isreject"),-1);
	 int isreopen = Util.getIntValue(request.getParameter("isreopen"),-1);

    String requestlevel=Util.null2String(request.getParameter("requestlevel"));

	String deleted=Util.null2String(request.getParameter("deleted"));

	String workflowtype=Util.null2String(request.getParameter("workflowtype"));
	String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));

    String nodetype=Util.null2String(request.getParameter("nodetype"));

	String currentdate=Util.null2String(request.getParameter("currentdate"));
	String docfileid=Util.null2String(request.getParameter("docfileid"));
	String newdocid=Util.null2String(request.getParameter("newdocid"));


	//对不同的模块来说,可以定义自己相关的工作流
	String prjid = Util.null2String(request.getParameter("prjid"));
	String docid = Util.null2String(request.getParameter("docid"));
	String crmid = Util.null2String(request.getParameter("crmid"));
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	//......
	String topage = Util.null2String(request.getParameter("topage"));
	
	String username = "";
    int userid=user.getUID();
	int usertype = Util.getIntValue(user.getLogintype(),-1);

	String backupName="";



	requestNodeFlow.setRequestid(requestid);
	requestNodeFlow.setNodeid(nodeid);
	requestNodeFlow.setNodetype(nodetype);
	requestNodeFlow.setWorkflowid(workflowid);
	requestNodeFlow.setUserid(userid);
	requestNodeFlow.setUsertype(usertype);
	requestNodeFlow.setCreaterid(creater);
	requestNodeFlow.setCreatertype(creatertype);

	requestNodeFlow.setFormid(formid);
	requestNodeFlow.setIsbill(1);
	requestNodeFlow.setBillid(billid);

	requestNodeFlow.setBilltablename("bill_FreeWorkflow");
	requestNodeFlow.setIsreject(isreject);
	requestNodeFlow.setIsreopen(isreopen);

   //创建人姓名
	username = Util.toScreen(ResourceComInfo.getResourcename(""+creater),user.getLanguage()) ;

    //归档人姓名
    backupName=Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;




     requestNodeFlow.setRecordSet(RecordSet);
	 
	 requestNodeFlow.getNextNodeOperator();
	 Hashtable<String,String> operas=requestNodeFlow.getOperators();



	 StringBuffer  sb=new StringBuffer("");

	 String rsdata="";
	
	 String[] splitvalues;

	 String tempstr="";

	 String[] ops=null;

	for(Map.Entry entry:operas.entrySet())
	{
		tempstr=entry.getValue()+"";

        ops=tempstr.split(",");

		for(String  itemstr:ops)
		{
			tempstr=itemstr.substring(1,itemstr.length()-1);
			splitvalues=tempstr.split("_");
			sb.append("<a href='javaScript:openhrm("+splitvalues[0]+");' onclick='pointerXY(event);'  class='acceptperson'>"+Util.toScreen(ResourceComInfo.getResourcename(splitvalues[0]),user.getLanguage())+"</a>").append(",");
		}
		
	}

	if(sb.length()>0)
		rsdata=sb.substring(0,sb.length()-1);

    if(rsdata.equals(""))
	{
	   rsdata="<a  href='javaScript:openhrm("+userid+");' onclick='pointerXY(event);'  class='acceptperson'>"+backupName+"</a>";
	}



    
	String sql="select  a.requestname,a.requestlevel  from workflow_requestbase a where a.requestid="+requestid;
    RecordSet.executeSql(sql);
	String rname="";
	String rlevel="";
    while(RecordSet.next())
	{
	  rname=RecordSet.getString("requestname");
      rlevel=RecordSet.getString("requestlevel");
	}
 
   String requestlevaltitle="";

   if("0".equals(rlevel))
   {
     requestlevaltitle=SystemEnv.getHtmlLabelName(1984,user.getLanguage());
   }else  if("1".equals(rlevel))
   {
     requestlevaltitle=SystemEnv.getHtmlLabelName(25397,user.getLanguage());
   }else  if("2".equals(rlevel))
   {
     requestlevaltitle=SystemEnv.getHtmlLabelName(2087,user.getLanguage());
   }


    int fc_billid=0;

    int fc_formmodeid=0;

    int fc_formid=0;

    String  remarkinfodata="";
    //获取正文内容
    sql="select  *  from bill_FreeWorkflow  where  requestid="+requestid;
    RecordSet.executeSql(sql);
    if(RecordSet.next())
	{
	  //正文
	  remarkinfodata=RecordSet.getString("remarkinfo");

	  String dest = "";

      if (remarkinfodata!=null  &&  !remarkinfodata.equals("")) {
 
            //去除回车，换行符，制表位
            Pattern p = Pattern.compile("\\t|\r|\n");

            Matcher m = p.matcher(remarkinfodata);

            dest = m.replaceAll("");

      }
  
      remarkinfodata=dest;
	  fc_formid=Util.getIntValue(RecordSet.getInt("tableformid")+"",0);
	  
	  fc_billid=Util.getIntValue(RecordSet.getInt("tablebillid")+"",0);
      
	  fc_formmodeid=Util.getIntValue(RecordSet.getInt("tablemodeid")+"",0);
    
	}
    

	%>

     <form name="frmmain" method="post" action="BillFreeWorkflowOperation.jsp">
      
	   <div  id="contaienr">

      <div class="formarea">

          <div class="formtable" style='margin-right:0px'>
               <table  style='width:100%'>

                   <col style="width: 20%">
                   <col style="width: 90%">

                    <tr>
				   
				     <td  colspan='2' style='font-size:16px;color:#000;text-align:center;font-weight: bold;'><%=rname%></td>
				   
				   </tr>
                    

                   <tr>

                       <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td><td class='tditem'><span class="titleinfo"><a  class='acceptperson'   href='javaScript:openhrm(<%=userid%>);' onclick='pointerXY(event);'><%=username%></a></span><span class="titleinfo"><%=requestlevaltitle%></span></td>

                   </tr>
                   <tr>

                     
                       <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td><td class='tditem'><span style='display:inline-block;width:85%;'>	
					     <%=rsdata%>
					   </span>
					   <!--
					   <span class='definewf'>
					   <span><img src='/images/wf/wf_freetoolset_wev8.png' style='margin-left: 3px;'></span><span style='display:inline-block;width: 64px;
                        text-align: center;'>设置流程</span></span></td>

						-->
						
                   </tr>
                   <tr>

                       <td  class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(24986,user.getLanguage())%></td><td class='tditem' style='padding-top: 5px;'><%=rname%></td>

                   </tr>
                   
                    <tr class=''  <%  if(fc_billid ==-1) {%> style='display:none;' <%}%>>
				   
				      <td colspan='2'  style="height:20px" >
					           
					  </td>

				    </tr>
                    
				    <tr class='formtrarea'  style='display:none;'>
				   
				      <td colspan='2'  class='formtdarea'  >
					          
					  </td>

				    </tr>


                   <tr class='contentareaonly'  <%  if(fc_billid!=0 &&  fc_billid!=-1) {%> style='display:none;' <%}%>>

                       <td  class='tdfirst tditem'>内容</td><td class='tditem' style='position:relative;padding-top: 0px;padding-left:0px;'>
                                <!--上传进度区域(非签章)-->
            <div class="fieldset flash" id="fsUploadProgressannexuploadSimple"  style='position: absolute;left:10px;width:300px;opacity: 1;'></div>
					             <textarea id='content' ></textarea>  
							   <input type='hidden' name='remarkinfo' id='remarkinfo'>
						     
						  </td>
                   </tr>
               </table>
               <script>
                     
					   var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist',
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable'
					    ];

						KE.init({
							id : 'content',
							height :292+'px',
							width:'100%',
							resizeMode:1,
							imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
							allowFileManager : false,
							newlineTag:'br',
							items : items,
							afterCreate : function(id) {
								KE.util.focus(id);
								//插入数据
								KE.insertHtml('content','<%=remarkinfodata%>');
							}
						});

                       KE.create('content');


			   </script>
          </div>

      </div>

     
	  <input type=hidden name="workflowid" value=<%=workflowid%>>
		<input type=hidden name="nodeid" value=<%=nodeid%>>
		<input type=hidden name="nodetype" value="0">
		<input type=hidden name="src">
		<input type=hidden name="formid" value=<%=formid%>>
		<input type="hidden" value="0" name="nodesnum">
		<input type=hidden name ="topage" value="<%=topage%>">
	    
		<input type=hidden name ="requestid" value="<%=requestid%>">
		<input type=hidden name ="requestlevel" value="<%=requestlevel%>">
	    
		<input name='needwfback' type='hidden'>
	    <input name='needcheck' type='hidden' value='0'>
	    <input name='inputcheck' type='hidden' value='0'>
	    <input name='src' type='hidden' >

		<input type=hidden name="requestlevel" value=<%=requestlevel%>>
		<input type=hidden name="creater" value=<%=creater%>>
		<input type=hidden name="creatertype" value=<%=creatertype%>>
		<input type=hidden name="deleted" value=<%=deleted%>>
		<input type=hidden name="billid" value=<%=billid%>>

		<input type=hidden name="workflowtype" value=<%=workflowtype%>>
		<input type=hidden name="isreject" value=<%=isreject%>>
	    <input type=hidden name="docfileid" value=<%=docfileid%>>
	    <input type=hidden name="newdocid" value=<%=newdocid%>>

     <script>

		//打开附件
		function opendoc1(showid,obj){
		   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=0");
		}

		//下载附件
		function downloads(files,obj){
		   //jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+files+"&download=1");
		   openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+files+"&download=1")
		}

		function openfreewin(arg)
		{
		  var a=jQuery(arg);
		  var href=a.attr("href");
		  openFullWindowHaveBar(href);
		
		}


	 </script>



  </div>
  <div  class='tableformcontent'>
  

  </div>


	  <%
	   if(fc_billid!=0  && fc_billid!=-1)
	   {
	  %>
          <script>
             var url="/formmode/worklfowinterface/addformForFreeWorkflow.jsp?modeId=<%=fc_formmodeid%>&formId=<%=fc_formid%>&type=0&billid=<%=fc_billid%>";      
               //表单添加页面
	         var iframeadd=jQuery("<iframe width='100%'  align='center' style='margin-top: 0px;'  id='freeformwin' name='freeformwin'  frameborder='0' scrolling='no' src='"+url+"'></iframe>");
             
			 jQuery(".formtdarea").html("");

             jQuery(".formtdarea").append(iframeadd);

			 jQuery(".formtdarea").parent().show();
			 
		  </script>
	  <%
	   }	 
	  %>

   </form>
   <br>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
   