
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MatrixManager" class="weaver.matrix.MatrixManager" scope="page" />
<jsp:useBean id="MatrixUtil" class="weaver.matrix.MatrixUtil" scope="page" />

<%


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33926,user.getLanguage());
String needfav ="1";
String needhelp ="";


String userid = user.getUID()+"";

String name = Util.null2String(request.getParameter("name"));

//矩阵维护权限
boolean canmaint = HrmUserVarify.checkUserRight("Matrix:Maint",user);



//确认 部门 、分部 矩阵是否初始化
//RecordSet.executeSql("select * from matrixinit where id=0");
//String deptinit = "0";//部门是否初始化  0 表示没有
//String companyinit = "0";//分部是否初始化  0 表示没有
//while(RecordSet.next()){
	//deptinit = RecordSet.getString("deptinit");
	//companyinit = RecordSet.getString("companyinit");
//}

%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/matrixmanage/css/matrix_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
			jQuery('#weaver').submit();
}

var dialog = null;
function doAdd(){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>";
    dialog.URL = "/matrixmanage/pages/MatrixAdd.jsp";
	dialog.Width = 560;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

//部门 分部 初始化
function doInit(inittype){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(inittype=='1'){
	   dialog.Title = "<%=SystemEnv.getHtmlLabelName(83947,user.getLanguage())%>"+"(<%=SystemEnv.getHtmlLabelName(33635,user.getLanguage())%>-><%=SystemEnv.getHtmlLabelName(32470,user.getLanguage())%>)";
	}else{
	   dialog.Title = "<%=SystemEnv.getHtmlLabelName(83947,user.getLanguage())%>"+"(<%=SystemEnv.getHtmlLabelName(33635,user.getLanguage())%>-><%=SystemEnv.getHtmlLabelName(32470,user.getLanguage())%>)";
	}
	
    dialog.URL = "/matrixmanage/pages/MatrixAdd.jsp?inittype="+inittype;
	dialog.Width = 560;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}


function doDel(id){  
   window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
       document.weaver.method.value="delete";
	   document.weaver.matrixid.value=id;
	   document.weaver.action = "/matrixmanage/pages/MatrixOperation.jsp";
       document.weaver.submit();
   });
}

//edit操作
function doEdit(id){
   if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
　　　dialog.Model=true;
   dialog.maxiumnable=true;
　　　dialog.Width=600;//定义长度
　　　dialog.Height=250;
   dialog.URL="/matrixmanage/pages/MatrixEdit.jsp?id="+id;  
　　　dialog.Title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>";
　　　dialog.show();
}

//维护字段操作
function doFieldDataEdit(id,type,canedit,issystem){
   if(dialog==null){
		dialog = new window.top.Dialog();
	}
	 dialog.currentWindow = window;
　　　dialog.Model=true;
     dialog.maxiumnable=true;
　　　dialog.Width=1024;//定义长度
　　　dialog.Height=510;
     dialog.URL="/matrixmanage/pages/matrixdesign.jsp?matrixid="+id+"&showtype="+type+"&issystem="+issystem;  
　　　dialog.Title="<%=SystemEnv.getHtmlLabelName(33975,user.getLanguage())%>";
　　　dialog.show();
}

//人员维护
function doMaint(id){
   if(dialog==null){
		dialog = new window.top.Dialog();
	}
	 dialog.currentWindow = window;
　　　dialog.Model=true;
     dialog.maxiumnable=true;
　　　dialog.Width=700;//定义长度
　　　dialog.Height=450;
     dialog.URL="/matrixmanage/pages/MatrixMaint.jsp?matrixid="+id;  
　　　dialog.Title="<%=SystemEnv.getHtmlLabelName(19909,user.getLanguage())%>";
　　　dialog.show();
}
</script>
</HEAD>

<BODY >
<form action="" name="weaver" id="weaver">

<input type=hidden name=method value="delete">
<input type=hidden name=matrixid value="">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="30%"/>
		<col width="*"/>
	</colgroup>
	<tbody>
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
              <input type="text" id="searchInput" name="name" class="searchInput"  value="<%=name %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</tbody>
</table>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <%
	  if(false){

	
       		RCMenu += "{"+SystemEnv.getHtmlLabelName(33553,user.getLanguage())+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+",javascript:doInit(0),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;   
	
			RCMenu += "{"+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+",javascript:doInit(1),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
	  }

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

  <div class="matrix_content" >				
      <!--列表部分-->
   <%
       String sql = "select * from MatrixInfo where 1=1  ";
       int matrixcount = 1;
       String id = "";
       String matrixids = MatrixManager.getUserPermissionMatrixids(user);
       String matrixid[] = matrixids.split(",");
      // if(user.getUID() !=1&&canmaint){//非系统管理员
    	//   String matrixids = MatrixManager.getUserPermissionMatrixids(user);
         //  if(!"".equals(matrixids)){
        //	   sql += " and id in("+matrixids+")";
      //     }else{
        //	   sql += " and 1 != 1 ";
         //  }
      // }
       //System.out.println(sql+"===========");
       //名称搜索
       if(!"".equals(name)){
    	   sql += " and name like '%"+name+"%'";
       }
       //加上排序条件
       sql += " order by id asc ";
       
       RecordSet.execute(sql);
       if(RecordSet.getCounts() != 0){       
    	   
   %>
       <% if(canmaint || "1".equals(user.getUID())){ %>
           <div class="matrix_newaddlist" title="<%=SystemEnv.getHtmlLabelName(83948,user.getLanguage())%>" ></div> 
       <%} %>
   			<% 
   			List<Map<String,String>> isNotSystem = new ArrayList<Map<String,String>>();
   			while(RecordSet.next()){ 
   				boolean canedit = false;
   				id = RecordSet.getString("id") ;
   				String issystem = RecordSet.getString("issystem") ;
   				String createrid = RecordSet.getString("createrid") ;
   				if("".equals(issystem.trim())){
   					Map<String,String> thisMap = new HashMap<String,String>();
   					thisMap.put("id",id);
   					thisMap.put("issystem",issystem);
   					thisMap.put("createrid",createrid);
   					thisMap.put("name",RecordSet.getString("name"));
   					thisMap.put("descr",RecordSet.getString("descr"));
   					isNotSystem.add(thisMap);
   					continue;
   				}
   				boolean isManager = false;  //是否矩阵维护者
   				for(int i =0;i<matrixid.length;i++){
   					if(id.equals(matrixid[i])){
   						isManager=true;
   					}
   				}
   				
   			%>
           <div class="matrix_list" data="<%=id %>">
             <%if(!"".equals(issystem)){ %>
              <div style="background-color: #F4FBFF;float: left;height: 115px;width: 223px;margin: 3px 0 0 3px;">
             <%} %>
              <div class="leftnumicon">
                   <%=matrixcount %>
              </div>
              <div class="rightopicon" style="display:none;"> 
                    
                    <%
                    if(isManager||canmaint || "1".equals(user.getUID())){ 
                    	canedit = true;
                    %>
	                   <%if("".equals(issystem)){ %>
                        <div class="matrix_edit" title="<%=SystemEnv.getHtmlLabelName(83949,user.getLanguage())%>" edit="<%=id %>">   </div>
                        <%} %>
                    	<div class="matrix_maint" title="<%=SystemEnv.getHtmlLabelName(83950,user.getLanguage())%>" maint="<%=id %>"></div>
	                   <%if("".equals(issystem)){ %>
                    	<div class="matrix_field" title="<%=SystemEnv.getHtmlLabelName(33975,user.getLanguage())%>" field="<%=id %>"></div>
                    	<%if(MatrixUtil.matrixDelMark(id)){ %>
                    	    <div class="matrix_del" title="<%=SystemEnv.getHtmlLabelName(83951,user.getLanguage())%>" del="<%=id %>"></div>
                    	<%} %>
                    <%} }%>
                    
              </div>
              <div class="title" data="<%=id %>" canedit="<%=canedit %>" issystem="<%=issystem %>" style="<%=!"".equals(issystem)?"background-color: #F4FBFF;":"" %>"> <div style="float: left;height: 20px;"><%=SystemEnv.getHtmlLabelName(83953,user.getLanguage())%></div> <span><%= RecordSet.getString("name") %></span></div>
              <div class="descr" style="<%=!"".equals(issystem)?"background-color: #F4FBFF;":"" %>" title="<%= RecordSet.getString("descr")  %>"><%=SystemEnv.getHtmlLabelName(83954,user.getLanguage())%><%= RecordSet.getString("descr")  %></div>
              <%if(!"".equals(issystem)){ %>
               </div>
             <%} %>
           </div>
       
   <%
               matrixcount++;
   			}%>
   			<% for(int index =0;index<isNotSystem.size();index++){ 
   				Map<String,String> thisMap = isNotSystem.get(index);
   				boolean canedit = false;
   				String thisid = thisMap.get("id") ;
   				String issystem = thisMap.get("issystem") ;
   				String createrid = thisMap.get("createrid") ;
   				boolean isManager = false;  //是否矩阵维护者
   				for(int i =0;i<matrixid.length;i++){
   					if(thisid.equals(matrixid[i])){
   						isManager=true;
   					}
   				}
   				
   			%>
           <div class="matrix_list" data="<%=thisid %>">
             <%if(!"".equals(issystem)){ %>
              <div style="background-color: #F4FBFF;float: left;height: 115px;width: 223px;margin: 3px 0 0 3px;">
             <%} %>
              <div class="leftnumicon">
                   <%=matrixcount %>
              </div>
              <div class="rightopicon" style="display:none;"> 
                    
                    <%
                    if(isManager||canmaint || "1".equals(user.getUID())){ 
                    	canedit = true;
                    %>
                    	<%if("".equals(issystem)){ %>
                        <div class="matrix_edit" title="<%=SystemEnv.getHtmlLabelName(83949,user.getLanguage())%>" edit="<%=thisid %>">   </div>
                        <%} %>
                    	<div class="matrix_maint" title="<%=SystemEnv.getHtmlLabelName(83950,user.getLanguage())%>" maint="<%=thisid %>"></div>
	                   <%if("".equals(issystem)){ %>
                    	<div class="matrix_field" title="<%=SystemEnv.getHtmlLabelName(33975,user.getLanguage())%>" field="<%=thisid %>"></div>
                    	<%if(MatrixUtil.matrixDelMark(thisid)){ %>
                    	    <div class="matrix_del" title="<%=SystemEnv.getHtmlLabelName(83951,user.getLanguage())%>" del="<%=thisid %>"></div>
                    	<%} %>
                    <%} }%>
                    
              </div>
              <div class="title" data="<%=thisid %>" canedit="<%=canedit %>" issystem="<%=issystem %>" style="<%=!"".equals(issystem)?"background-color: #F4FBFF;":"" %>"> <div style="float: left;height: 20px;"><%=SystemEnv.getHtmlLabelName(83953,user.getLanguage())%></div> <span><%= thisMap.get("name") %></span></div>
              <div class="descr" style="<%=!"".equals(issystem)?"background-color: #F4FBFF;":"" %>" title="<%= thisMap.get("descr")  %>"><%=SystemEnv.getHtmlLabelName(83954,user.getLanguage())%><%= thisMap.get("descr")  %></div>
              <%if(!"".equals(issystem)){ %>
               </div>
             <%} %>
           </div>
       
   <%
               matrixcount++;
   			}%>
   			
   			
       <%}else{//无记录
   %>
      <% //if(canmaint){ %>
	       <div class="matrix_newadd" title="<%=SystemEnv.getHtmlLabelName(83948,user.getLanguage())%>" >
	             
	       </div>   
       <%//}else{ %>
           <!--<div class="matrix_infomation">
               <img src="/images/ecology8/noright_wev8.png" width="162px" height="162px">
                 <br><%=SystemEnv.getHtmlLabelName(83952,user.getLanguage())%> 
	       </div>  
       --><%//} %>
   <%} %>
     <div style='clear:both;height:10px;width:100%;'></div>
   </div>

							
</FORM>
							
</BODY>
<script language=javascript>
jQuery(document).ready(function(){
	 $(".matrix_newadd").click( function () { 
	     doAdd();
     });
     $(".matrix_newaddlist").click( function () { 
	     doAdd();
     });
     //编辑
     $(".matrix_edit").click( function () { 
	     doEdit($(this).attr("edit"));
     });
     
     //人员维护
     $(".matrix_maint").click( function () { 
	     doMaint($(this).attr("maint"));
     });
     
     //字段维护
     $(".matrix_field").click( function () { 
	     doFieldDataEdit($(this).attr("field"),0,"true","");
     });
     
     //删除
     $(".matrix_del").click( function () { 
	     doDel($(this).attr("del"));
     });
     
     
     //字段维护
     $(".title").click( function () { 
	     doFieldDataEdit($(this).attr("data"),1,$(this).attr("canedit"),$(this).attr("issystem"));
     });
     
     
     $(".matrix_list").bind("mousemove",function(){
	    $(this).find(".leftnumicon").css("background","url(/matrixmanage/images/006_wev8.png) center no-repeat");
	    $(this).find(".leftnumicon").css("color","#ffffff");
	    //右上 图标展示
	    $(this).find(".rightopicon").css("display","");
	});
	
	$(".matrix_list").bind("mouseout",function(){
	    $(this).find(".leftnumicon").css("background","url(/matrixmanage/images/005_wev8.png) center no-repeat");
	    $(this).find(".leftnumicon").css("color","#ff7300");
	    //右上 图标隐藏
	    $(this).find(".rightopicon").css("display","none");
	});
});


function MainCallback(){
    dialog.close();
	window.location.reload();
}
</script>
	