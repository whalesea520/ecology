
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCL" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />

<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="VerifyPowerToCustomers" class="weaver.crm.VerifyPowerToCustomers" scope="session" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<% /*取出页面上的选定的各元素的值*/
String types="";  //“类型”Sql的初始化
String CustomerTypes[]=request.getParameterValues("CustomerTypes");//Types是一个数组
CRMSearchComInfo.resetSearchInfo();//对CRMSearchComInfo.set~()初始化
if(CustomerTypes != null)
{
	for(int i=0;i<CustomerTypes.length;i++)
	{
		CRMSearchComInfo.addCustomerType(CustomerTypes[i]);//把“类型”值传入到CRMSearchComInfo
		if(!types.equals(""))
		types=types+","+CustomerTypes[i];
		else types+=CustomerTypes[i];
	}
}
String sector=Util.null2String(request.getParameter("CustomerSector"));
String desc=Util.null2String(request.getParameter("CustomerDesc"));
String status=Util.null2String(request.getParameter("CustomerStatus"));
String size=Util.null2String(request.getParameter("CustomerSize"));
//把值传入到CRMSearchComInfo
CRMSearchComInfo.setCustomerSector(sector);
CRMSearchComInfo.setCustomerDesc(desc);
CRMSearchComInfo.setCustomerStatus(status);
CRMSearchComInfo.setCustomerSize(size);


/*两次查询,第一次得城市id,为了得经纬度;第二次查每一城市满足查询条件下的类型及数量*/
String sqlwhere = "";//第一次sql中where条件语句初始化
String sqlResult="";//;第二次sql中where条件语句初始化

int ishead = 0;//ishead = 0表示前无条件，ishead = 1表前已有条件
if(!sector.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.sector = "+ sector + " ";
		sqlResult+= " where t1.sector = "+ sector + " ";
	}else{
		sqlwhere += " and t1.sector = "+ sector + " ";
		sqlResult+= " and t1.sector = "+ sector + " ";
		}
}
if(!desc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description = "+ desc + " ";
		sqlResult+= " where t1.description = "+ desc + " ";
	}else{
		sqlwhere += " and t1.description = "+ desc + " ";
		sqlResult+= " and t1.description = "+ desc + " ";
		}
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status = "+ status + " ";
		sqlResult += " where t1.status = "+ status + " ";
	}else{
		sqlwhere += " and t1.status = "+ status + " ";
		sqlResult += " and t1.status = "+ status + " ";
		}

}
if(!size.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.size_n = "+ size + " ";
		sqlResult += " where t1.size_n = "+ size + " ";
	}else{
		sqlwhere += " and t1.size_n = "+ size + " ";
		sqlResult += " and t1.size_n = "+ size + " ";
		}

}
if(!types.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.type in ("+ types + ") ";// “类型”值可为多个，故用in( )
		sqlResult= " where (t1.type<>'' and t1.type is not null) ";//这理是因为“类型”不为空时返回ishead = 1,故为后面的and 前面有一个where字符,所以加上where type<>''.(“类型”值在做第二次查是重得一遍)
	}
	else
		sqlwhere += " and t1.type in ("+ types + ") ";
}

if(ishead==0){
	//注意此处不要ishead=1
		sqlwhere += " where t1.city <>0 ";//排除city值为0的情况
	}
	else
		sqlwhere += " and t1.city <>0 ";

String TableName = VerifyPowerToCustomers.getTableName(request,response);

/*得出全句Sql,执行，得出一个满足条件的所有city集合Sql语句*/
String sqlstr = "select t1.city,t1.type,count(t1.id) as toutalcount from CRM_CustomerInfo  t1,"+TableName+"  t2  "+ sqlwhere +" and  t1.id=t2.id  and t1.deleted = 0 group by t1.city,t1.type order by t1.city";
RecordSet.executeSql(sqlstr);
ArrayList cityids = new ArrayList();
ArrayList dspstrings = new ArrayList();
int lastcity = 0;
int curcity = 0;
String strTemp = "";
while(RecordSet.next())
{
	if((curcity=Util.getIntValue(RecordSet.getString(1),0))==0)
		continue;
	if(curcity==lastcity)
	{
		strTemp += CustomerTypeComInfo.getCustomerTypename(RecordSet.getString(2))+":"+RecordSet.getString(3)+" ";
	}
	else
	{
		if(lastcity!=0)
		{
			cityids.add(""+lastcity);
			dspstrings.add(strTemp);
		}
		lastcity=curcity;
		strTemp = CustomerTypeComInfo.getCustomerTypename(RecordSet.getString(2))+":"+RecordSet.getString(3)+" ";
	}
}
if(lastcity!=0)
{
		cityids.add(""+lastcity);
		dspstrings.add(strTemp);
}

int nCount = cityids.size();
for(int i=0;i<nCount;i++)
{
	out.println(cityids.get(i)+"("+dspstrings.get(i)+")");
}

%></BODY>
</HTML>


