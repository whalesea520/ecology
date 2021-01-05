<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SystemLogItemTypeComInfo" class="weaver.systeminfo.SystemLogItemTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
	String relatedname = java.net.URLDecoder.decode(Util.null2String(request.getParameter("relatedname")));
	String itemname = java.net.URLDecoder.decode(Util.null2String(request.getParameter("itemname")));
	String fromdate = Util.null2String(request.getParameter("fromdate")) ;
	String todate = Util.null2String(request.getParameter("todate")) ;
	String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
	if(doccreatedateselect.equals(""))doccreatedateselect="1";

	if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
		fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
		todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
	}
	
	String currentuser = Util.null2String(request.getParameter("currentuser"));
	//System.out.println("current::"+currentuser);
	if(currentuser.equals("")){
		currentuser = ""+user.getUID();
	}
	
	int operatesmalltype = Util.getIntValue(request.getParameter("operatesmalltype"),0);//0: 维护日志  1：操作日志
	
	String sqlWhere = " where sml.operateItem = sli.itemId and sli.itemid != 60 ";
	
	if(operatesmalltype==1){
		sqlWhere += " and sml.operatesmalltype=1 ";
	}else{
		sqlWhere += " and (sml.operatesmalltype!=1 or sml.operatesmalltype is null) ";
	}
	
	//System.out.println(relatedname);
	
	if(!relatedname.equals("")){
		sqlWhere += " and relatedName like '%"+relatedname+"%'";
	}		
	
	if(!itemname.equals("")){
		sqlWhere += " and itemdesc like '%"+itemname+"%'";
	}	
	
	if(!"-1".equals(currentuser)){
		sqlWhere += " and sml.operateuserid="+currentuser;
	}

	if(!"".equals(fromdate)){
		sqlWhere += " and sml.operatedate >= '"+fromdate+"'"; 
	}
	
	if(!"".equals(todate)){
		sqlWhere += " and sml.operatedate <= '"+todate+"'"; 
	}

 	String absentSql = "select COUNT(*) as total, sli.typeid from SysMaintenanceLog sml,SystemLogItem sli "+
				sqlWhere +
				"group by sli.typeid order by total desc";
    rs.executeSql(absentSql);
    //System.out.println("absentSql:"+absentSql);
    Map map=null;
    List list=new ArrayList();
    String name="";
    String typeid = "";
    int total = 0;
    while(rs.next()){
   		map= new HashMap();
   		typeid = Util.null2String(rs.getString("typeid"));
   		if(typeid.equals(""))continue;
   		total = rs.getInt("total");
   		if(total==0)continue;
    	map.put("name",SystemLogItemTypeComInfo.getSystemLogItemlabelname(typeid,""+user.getLanguage()+"+"+operatesmalltype));
    	map.put("data",new int[]{total});
    	list.add(map);
    }
    String absentJsonStr=JSONArray.fromObject(list).toString();
  
%>
<HTML>
  <HEAD>
	
  </HEAD>
  <BODY width=100% height=100%>
     <div id="AbsentDiv" style="margin: 5 auto;margin-top:10px; min-width: 400px; height: 210px;"></div>
 </BODY>
 <script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
 <script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	var isInternetExplorer = navigator.userAgent.indexOf('MSIE') != -1;	
	var jsonStr='<%=absentJsonStr%>';
 	var jsonData=eval('('+jsonStr+')');
 	if(isInternetExplorer){
		setTimeout('showAbsentDiv()',800);
	}else{
		setTimeout('showAbsentDiv()',10);
	}
function showAbsentDiv(){
	$('#AbsentDiv').highcharts({
          chart: {
              type: 'column',
              //borderColor: '#DADADA',
              borderWidth:0
          },
          title: {
              text: '',// 会议+缺席+次数+统计+排名',
              style: {
				color: '#000000',
				fontSize: '24px'
			}
          },
          tooltip:{
          		headerFormat: '<span style="font-size: 10px">{point.key}</span>',
			pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>'
          },
          plotOptions: {
		    column: {
		        pointWidth: 10
		    }
		  },
          xAxis: {
              categories: [' ']
          },
          yAxis: {
              min: 0,
              tickPixelInterval:30,
              title: {
                  text: ' '
              },
              allowDecimals:false
          },
          credits: {
              enabled: false
          },       
       lang: {
           noData: "<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage()) %>" //没有 + 数据
       },
       series:jsonData
      });
}
</SCRIPT>
</HTML>