
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsWordCount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpefc" class="weaver.homepage.cominfo.HomepageElementFieldCominfo" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"scope="page" />
<jsp:useBean id="ec" class="weaver.page.element.ElementUtil" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
boolean isSystemer=false;
if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;

String hpid = Util.null2String(request.getParameter("hpid"));	
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
String eid=Util.null2String(request.getParameter("eid"));		
String ebaseid=Util.null2String(request.getParameter("ebaseid"));	
String styleid=Util.null2String(request.getParameter("styleid"));

boolean hasRight =true;
	User loginuser = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	// 先取消权限判断
	if(loginuser != null)  {
		hasRight =  ec.isHasRight(eid,loginuser.getUID()+"",0,1);
	}
	if(!hasRight){
		response.sendRedirect("/page/element/noright.jsp");
	}

//得到是否是特殊处理
boolean isSpecial=false;	
isSpecial=Util.getIntValue(ebc.getType(ebaseid))==2?true:false;
String sppbMethod="";	

	Class tempClass=null;
	Method tempMethod=null;
	Constructor ct=null;
	//得到需要显示的字段
	ArrayList fieldIdList=new ArrayList();
	ArrayList fieldColumnList=new ArrayList();
	ArrayList fieldIsDate=new ArrayList();
	ArrayList fieldTransMethodList=new ArrayList();
	ArrayList fieldWidthList=new ArrayList();
	ArrayList linkurlList=new ArrayList();
	ArrayList valuecolumnList=new ArrayList();
	ArrayList isLimitLengthList=new ArrayList();

	String partBackfield="";
	int perpage=0;

	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	if(pc.getIsLocked(hpid).equals("1")) {
	   userid=Util.getIntValue(pc.getCreatorid(hpid));
	   usertype=Util.getIntValue(pc.getCreatortype(hpid));
	}

	
	String fields="";
	String linkmode="";

	String strsqlwhere=hpec.getStrsqlwhere(eid);
	String  strSql="select perpage,linkmode,showfield from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	

	rs.executeSql(strSql);
	if(rs.next()){
		fields=Util.null2String(rs.getString("showfield"));
		perpage=Util.getIntValue(rs.getString("perpage"));		
		linkmode=Util.null2String(rs.getString("linkmode"));
	} else {
		//用于元素独立显示判断，若个人配置不存在，读取管理员数据。
		if ("true".equals(Util.null2String(request.getParameter("indie"), "false"))) {
			strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid="+eid+" and usertype=3";
		}
		rs.executeSql(strSql);
		if (rs.next()) {
			fields = Util.null2String(rs.getString("showfield"));
			perpage = Util.getIntValue(rs.getString("perpage"));
			linkmode = Util.null2String(rs.getString("linkmode"));
		}
	}

	if (!"".equals(fields)){
		ArrayList tempFieldList=Util.TokenizerString(fields,",");
		for(int i=0;i<tempFieldList.size();i++){
			String tempId=(String)tempFieldList.get(i);
			fieldIdList.add(tempId);
			fieldColumnList.add(hpefc.getFieldcolumn(tempId));
			fieldIsDate.add(hpefc.getIsdate(tempId));
			fieldTransMethodList.add(hpefc.getTransmethod(tempId));
			fieldWidthList.add(hpefc.getFieldWidth(tempId));
			linkurlList.add(hpefc.getLinkurl(tempId));
			valuecolumnList.add(hpefc.getValuecolumn(tempId));
			isLimitLengthList.add(hpefc.getIsLimitLength(tempId));
		}
	}
	
				
	sppbMethod=Util.null2String(ebc.getViewMethod(ebaseid));
	//System.out.println("sppbMethod: "+sppbMethod);


	SplitPageParaBean sppb=new SplitPageParaBean();
	tempClass = Class.forName("weaver.page.element.compatible.PageSql");	
	tempMethod = tempClass.getMethod(sppbMethod, new Class[]{weaver.hrm.User.class,String.class});
    ct = tempClass.getConstructor(null);
	sppb=(SplitPageParaBean)tempMethod.invoke(ct.newInstance(null), new Object[] {user,strsqlwhere});

	
    spu.setSpp(sppb);
    spu.setRecordCount(perpage);
	rs=spu.getCurrentPageRs(1,perpage);	
%>
<TABLE  id='_contenttable_<%=eid%>' class="Econtent"  width="100%">
<TR>
    <TD width="1px"></TD>
    <TD width="*">      
    <TABLE width="100%" class="elementdatatable" style="table-layout: fixed;">          
     <%
           int rowcount=0;
           String imgSymbol="";
           if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
           int size=fieldIdList.size();
           while(rs.next()&&size>0){
           %>
            <TR >
                <TD width="8"><%=imgSymbol%></TD>
                <%
                    for(int i=0;i<size;i++){
                        String fieldId=(String)fieldIdList.get(i);
                        String columnName=(String)fieldColumnList.get(i);
                        String strIsDate=(String)fieldIsDate.get(i);
                        String fieldTransMethod=(String)fieldTransMethodList.get(i);
                        String fieldwidth=(String)fieldWidthList.get(i);
                        String linkurl=(String)linkurlList.get(i);
                        String valuecolumn=(String)valuecolumnList.get(i);
                        String isLimitLength=(String)isLimitLengthList.get(i);
                        String showValue="";                    
                        String cloumnValue=Util.null2String(rs.getString(columnName));
                        String urlValue=Util.null2String(rs.getString(valuecolumn));
                        String url=linkurl+urlValue;
                        String titleValue=cloumnValue;  

                        if("1".equals(isLimitLength)){
                        	
                        	//cloumnValue=pu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
                        	cloumnValue ="<font class='font'>"+cloumnValue+"</font>";
                        }
    					
                        if(!"".equals(linkurl)){
                        	cloumnValue ="<font class='font'>"+cloumnValue+"</font>";
                            if("1".equals(linkmode)){
                                showValue="<a class='ellipsis' href='"+url+"' target='_self'>"+cloumnValue+"</a>";
                            }else 
                                showValue="<a class='ellipsis' href=\"javascript:openFullWindowForXtable('"+url+"')\">"+cloumnValue+"</a>";
                        } else {                        
                            if(!"".equals(fieldTransMethod)){
                                tempClass = Class.forName("weaver.homepage.HomepageFiled");
        
                                tempMethod = tempClass.getMethod(fieldTransMethod, new Class[] {weaver.conn.RecordSet.class,weaver.hrm.User.class,String.class,String.class});
                                ct = tempClass.getConstructor(null);
                                
                                String  returnValue=(String)tempMethod.invoke(ct.newInstance(null), new Object[] {rs,user,cloumnValue,linkmode});
                                
                                showValue=returnValue;
                            } else {
                                
                                showValue=cloumnValue;                      
                            }
                            
                            showValue = showValue.replace("href"," class='ellipsis' href");
                            
                        }
						if("planendtime".equals(columnName)){//TD:39934
                        	rs1.executeSql("select MAX(enddate) as enddate from Prj_TaskProcess where prjid = "+urlValue);
                        	if(rs1.next())
                        		showValue = Util.null2String(rs1.getString("enddate"));
                        	
                        }
                        //System.out.println("columnName:"+columnName+";urlValue:"+urlValue+";showValue:"+showValue);
        %>
        
                    <TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><font class=font><%=showValue%></font></TD>
                <%}%>
            </TR>
            <%
            rowcount++;     
            if(rowcount<perpage){%>
               <TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=<%=size+1%>></td></TR>
            <%}%>
            
            <%}%>        
    </TABLE>
    </TD>
    <TD width="1px"></TD>
</TR>
</TABLE>