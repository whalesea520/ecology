<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver.css" type='text/css' rel='STYLESHEET'>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<style type="text/css">
	div.rtop,div.rbottom {background: #FFF;height:2px;overflow:hidden;line-height:2px}}
	div.rtop div {overflow: hidden;line-height:1px}
	div.rbottom div {overflow: hidden;line-height:1px}
	div.r2{margin: 0 1px ;padding:0px}
	div.r3{margin: 0 0.5px;padding:0px}
	.labelTitle{width:auto;font:9px verdana, arial, sans-serif !important;text-align:center;vertical-align:middle;padding-left:3px;padding-right:3px;}
	.label{float:left;margin-right:5px;} 
</style>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

String uid = Util.null2String(request.getParameter("uid"));
if(uid.equals("")) uid=String.valueOf(user.getUID());
int userid=Util.getIntValue(uid);
// 查看类型
String type = Util.null2String(request.getParameter("type"));
//关注的或者直接参与的协作
String viewType = Util.null2String(request.getParameter("viewtype"));
//排序方式
String orderType = Util.null2String(request.getParameter("orderType"));
//是否是搜索操作
String isSearch = Util.null2String(request.getParameter("isSearch"));
//关键字
String name = Util.null2String(request.getParameter("name"));
//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));
//协作状态
String status = Util.null2String(request.getParameter("status"));
//参与类型
String jointype = Util.null2String(request.getParameter("jointype"));
// 创建者
String creater = Util.null2String(request.getParameter("creater"));
//负责人
String principal = Util.null2String(request.getParameter("principal"));
//开始时间
String startdate = Util.null2String(request.getParameter("startdate"));
// 结束时间
String enddate = Util.null2String(request.getParameter("enddate"));

String labelid=Util.null2String(request.getParameter("labelid"));

String projectid=Util.null2String(request.getParameter("projectid"));
String taskIds=Util.null2String(request.getParameter("taskIds"));

String paramsStr="type="+type+"&orderType="+orderType+"&isSearch="+isSearch+"&typeid="+typeid
+"&status="+status+"&jointype="+jointype+"&creater="+creater+"&principal="+principal+"&startdate="+startdate+"&enddate="+enddate+"&labelid="+labelid;

paramsStr+= "&projectid="+projectid+"&taskIds="+taskIds;

String searchStr="";
  if(isSearch.equals("true")){
	if(!name.equals("")){
		searchStr += " and name like '%"+name+"%' "; 
	}
	if(!typeid.equals("")){
		searchStr += "  and typeid='"+typeid+"'  ";
	}
	if(!status.equals("")){
		searchStr += " and status ="+status+"";
	}
	if(jointype.equals("")){        //参与 关注
		searchStr += " and jointype is not null";
	}else if(jointype.equals("1")){ //关注
		searchStr += " and jointype=1";
	}else if(jointype.equals("2")){ //参与
		searchStr += " and jointype=0";
	}
	if(!creater.equals("")){
		searchStr += " and creater='"+creater+"'  ";
	}
	if(!principal.equals("")){
		searchStr += " and principal='"+principal+"'  "; 
	}
	if(!startdate.equals("")){
		searchStr +=" and begindate >='"+startdate+"'  ";
	}
	if(!enddate.equals("")){
		searchStr +=" and enddate <='"+enddate+"'  ";
	}
  }else{
    searchStr += " and status =1";
  }
String sqlStr ="";

int departmentid = 0;
int subCompanyid = 0;
String seclevel= "";          //用于安全等级
ResourceComInfo resourcecominfo = new ResourceComInfo();
while(resourcecominfo.next()){
    String resourceid = resourcecominfo.getResourceid() ;
    if(Util.getIntValue(resourceid) == userid){
    	departmentid = Util.getIntValue(resourcecominfo.getDepartmentID()); // 用户所属部门
    	subCompanyid = Util.getIntValue(resourcecominfo.getSubCompanyID()); // 用户所属分部
    	seclevel = resourcecominfo.getSeclevel();  // 用于安全等级
    	break;
    }
}

//查询总数
sqlStr="select count(*) as total from ("+
		" select t1.id,t1.name,t1.status,t1.typeid,t1.creater,t1.principal,t1.begindate,t1.enddate,t1.remark,"+
		" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
		" case when  t4.coworkid is not null then 0 else 1 end as isnew,"+
		" case when  t5.coworkid is not null then 1 else 0 end as important,"+
		" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
		(type.equals("label")?" ,case when  t7.coworkid is not null then 1 else 0 end as islabel":"")+
		" from cowork_items  t1 left join "+
		//关注的协作
		" (select distinct cotypeid from  cotype_sharemanager where (sharetype=1 and sharevalue like '%,"+userid+",%' )"+
		" or (sharetype=2 and sharevalue like '%,"+departmentid+",%' and "+seclevel+">=seclevel) "+
		" or (sharetype=3 and sharevalue like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel)"+
		" or (sharetype=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and  sharevalue=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel)"+
		" or (sharetype=5 and "+seclevel+">=seclevel)"+
		" )  t2 on t1.typeid=t2.cotypeid left join "+
        //直接参与的协作
		" (select distinct sourceid from coworkshare where"+
		" (type=1 and  (content='"+userid+"' or content like '%,"+userid+",%') )"+
		" or (type=2 and content like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel) "+
		" or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel)"+
		" or (type=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and content=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel)"+
		" or (type=5 and "+seclevel+">=seclevel)"+
		" )  t3 on t3.sourceid=t1.id"+
        //阅读|重要|隐藏
		" left join (select distinct coworkid,userid from cowork_read where userid="+userid+")  t4 on t1.id=t4.coworkid"+       //阅读状态
		" left join (select distinct coworkid,userid from cowork_important where userid="+userid+" )  t5 on t1.id=t5.coworkid"+ //重要性
		" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
		(type.equals("label")?" left join (select distinct coworkid from cowork_item_label where labelid="+labelid+") t7 on t1.id=t7.coworkid":"")+ 
		" ) t where 1=1 and jointype is not null "+searchStr;

		if("unread".equals(type)){
			sqlStr=sqlStr+" and isnew=1 and ishidden<>1";
		}else if("important".equals(type)){
			sqlStr=sqlStr+" and important=1 and ishidden<>1";
		}else if("hidden".equals(type)){
			sqlStr=sqlStr+" and ishidden=1";
		}else if("all".equals(type)){
			sqlStr=sqlStr+" and ishidden<>1";
		}else if("coworkArea".equals(type)){
            sqlStr=sqlStr+" and ishidden<>1 and typeid="+typeid;
        }else if("label".equals(type))
        	sqlStr=sqlStr+" and ishidden<>1 and islabel=1";
       String total="0";
       ConnStatement statement=new ConnStatement();
       try{ 	
	   statement.setStatementSql(sqlStr);
	   statement.executeQuery();
	   if(statement.next())
	     total=statement.getString("total");
       }catch(Exception e){
    	 e.printStackTrace();  
       }finally{
    	 statement.close();
       }
%>
<script type="text/javascript">
var index=30;           //起始读取下标
var hght=0;             //初始化滚动条总长
var stop=0;              //初始化滚动条的当前位置
var preTop=0;           //滚动条前一个位置，向上滚动时不加载数据
var pagesize=30;        //每一次读取数据记录数
var total=<%=total%>;   //记录总数
var disdirect=true;    //是否显示直接参与默认显示
var disattention=true; //是否显示关注默认显示
var flag=false;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
$(document).ready(function(){//DOM的onload事件
    var paramStr="<%=paramsStr%>&CustomerID=<%=CustomerID%>";
    $.post("CoworkListInit.jsp?"+paramStr,{total:<%=total%>,"name":"<%=name%>",index:index,pagesize:index,disdirect:disdirect,disattention:disattention},function(data){//利用jquery的get方法得到table.html内容
		    $("#list_body").append(data);
		    $(".loading", window.parent.document).hide(); //隐藏加载图片
		    hght=0;//恢复滚动条总长，因为$("#mypage").scroll事件一触发，又会得到新值，不恢复的话可能会造成判断错误而再次加载……
		    stop=0;//原因同上。
		    flag=true;
	});
    
	$("#listdiv").scroll( function() {//定义滚动条位置改变时触发的事件。
	    hght=this.scrollHeight;//得到滚动条总长，赋给hght变量
	    stop=this.scrollTop;//得到滚动条当前值，赋给top变量
	});
	
	if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	     //左侧下拉框处理
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
	
});

var timeid; //定时器

if(total>index){ 
   timeid=setInterval("cando();",500);
}
function cando(){  
	if(stop>parseInt(hght/5)&&preTop<stop){//判断滚动条当前位置是否超过总长的1/3，parseInt为取整函数,向下滚动时才加载数据
	    show();
	}
    preTop=stop;//记录上一个位置
}

function show(){
    if(flag){
		index=index+pagesize;
		if(index>total){                    //当读取数量大于总数时
		   pagesize=total-(index-pagesize); 
		   index=total;                     //页面数据量等于数据总数
		   window.clearInterval(timeid);    //清除定时器
		}
		flag=false;
		var paramStr="<%=paramsStr%>"+"&CustomerID=<%=CustomerID%>";         
        $("#loadingdiv").show();         
	    $.post("CoworkListInit.jsp?"+paramStr,{"name":"<%=name%>",orderType:"<%=orderType%>",total:<%=total%>,index:index,pagesize:pagesize,disdirect:disdirect,disattention:disattention},function(data){
			    $("#list_body").append(data);
			    $("#loadingdiv").hide();
			    hght=0;
			    stop=0;
			    flag=true;
		});
	}
}
</script>

<div id="listdiv" style="width: 100%;height: 100%;overflow:auto">
  <table id='list' class="ListStyle" cellspacing="1" style="margin:0px;width:100%">
	 	<colgroup>
		<col width="5px">
		<col width="8px">
		<col width="*">
		</colgroup>
		<tbody id="list_body">
		
		</tbody>
  </table>
  <div id="loadingdiv" style="position:relative;width: 100%;height: 30px;margin-bottom: 15px;display: none">
      <div class='loading' style="position: absolute;top: 10px;left: 20%;">
         <img src='/images/loadingext.gif' align="absMiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
      </div>
  </div>		
</div>

