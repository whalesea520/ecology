
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean" %>
<%@ page import="weaver.homepage.HomepageSql" %>
<%@ page import="weaver.homepage.HomepageExtShow" %>
<%@ page import="weaver.homepage.cominfo.HomepageElementSqlCominfo" %>
<%@ page import="weaver.homepage.cominfo.HomepageElementExtCominfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsWordCount" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="hpbed" class="weaver.homepage.cominfo.HomepageBaseElementCominfo" scope="page"/>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpefc" class="weaver.homepage.cominfo.HomepageElementFieldCominfo" scope="page"/>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page" />

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/xloadtree/xtree4workflow_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4workflow_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>

<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;

	String hpid = Util.null2String(request.getParameter("hpid"));	
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String eid=Util.null2String(request.getParameter("eid"));		
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));	
	String styleid=Util.null2String(request.getParameter("styleid"));

	HomepageStyleBean hpsb=hpsu.getHpsb(styleid);
	//得到是否是特殊处理
	boolean isSpecial=false;	
	isSpecial=Util.getIntValue(hpbed.getElementtype(ebaseid))==2?true:false;
	HomepageElementExtCominfo hpexc=new HomepageElementExtCominfo();
	String sppbMethod=Util.null2String(hpexc.getExtshow(ebaseid));	
	//if(0==0) {
	//	out.println(!"".equals(sppbMethod));
	//	return;
	//}
	if(!"".equals(sppbMethod)) {
		if(isSpecial && sppbMethod.indexOf(".")!=-1){
			String url="/homepage/element/content/"+sppbMethod+"?hpid="+hpid+"&subCompanyId="+subCompanyId+"&eid="+eid+"&ebaseid="+ebaseid+"&styleid="+styleid;
			//out.println(url);
			response.sendRedirect(url);
			return;
		}
	}

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

	int userid=hpu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=hpu.getHpUserType(hpid,""+subCompanyId,user);
	if(hpc.getIsLocked(hpid).equals("1")) {
	   userid=Util.getIntValue(hpc.getCreatorid(hpid));
	   usertype=Util.getIntValue(hpc.getCreatortype(hpid));
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
	//如果是特殊的东西需特殊处理 其它的处理就不需要了
	if(isSpecial){	
		tempClass = Class.forName("weaver.homepage.HomepageExtShow");	
		tempMethod = tempClass.getMethod(sppbMethod, new Class[]{java.util.ArrayList.class,java.util.ArrayList.class,java.util.ArrayList.class,java.util.ArrayList.class,java.util.ArrayList.class,String.class,weaver.homepage.style.HomepageStyleBean.class,String.class,String.class,String.class,weaver.hrm.User.class,
		javax.servlet.http.HttpServletRequest.class,String.class,String.class});
		
		ct = tempClass.getConstructor(null);

		String tableStr=(String)tempMethod.invoke(ct.newInstance(null), new Object[] {fieldIdList,fieldColumnList,fieldIsDate,fieldWidthList,isLimitLengthList,strsqlwhere,hpsb,eid,linkmode,""+perpage,user,request,hpid,""+subCompanyId});
        tableStr="<TABLE  style=\"color:"+hpsb.getEcolor()+"\" id='_contenttable_"+eid+"' class=Econtent  width=100%"+
                 "  <TR>"+
                 "    <TD width=1px></TD>"+
                 "    <TD width='*'>"+ 
                 "        "+tableStr+
                 "    </TD>    "+
                 "    <TD width=1px></TD>"+
                 "  </TR>"+
                 "</TABLE>";
		out.println(tableStr);
        
		return ;
	}
	HomepageElementSqlCominfo hpesc=new HomepageElementSqlCominfo();			
	sppbMethod=Util.null2String(hpesc.getSppbMethod(ebaseid));
	//System.out.println("sppbMethod: "+sppbMethod);


	SplitPageParaBean sppb=new SplitPageParaBean();
	tempClass = Class.forName("weaver.homepage.HomepageSql");	
	tempMethod = tempClass.getMethod(sppbMethod, new Class[]{weaver.hrm.User.class,String.class});
    ct = tempClass.getConstructor(null);
	sppb=(SplitPageParaBean)tempMethod.invoke(ct.newInstance(null), new Object[] {user,strsqlwhere});

	
    spu.setSpp(sppb);
    spu.setRecordCount(perpage);
	rs=spu.getCurrentPageRs(1,perpage);	
%>
<TABLE  style="color:<%=hpsb.getEcolor()%>" id='_contenttable_<%=eid%>' class="Econtent"  width="100%">
<TR>
    <TD width="1px"></TD>
    <TD width="*">      
    <TABLE width="100%">          
     <%
           int rowcount=0;
           String imgSymbol="";
           if (!"".equals(hpsb.getEsymbol())) imgSymbol="<img name='esymbol' src='"+hpsb.getEsymbol()+"'>";
           while(rs.next()){
           %>
            <TR  height="18px">
                <TD width="8"><%=imgSymbol%></TD>
                <%
                    int size=fieldIdList.size();
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
                        if("1".equals(isLimitLength))   cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
    
                        if(!"".equals(linkurl)){
                            if("1".equals(linkmode))
                                showValue="<a href='"+url+"' target='_self'>"+cloumnValue+"</a>";
                            else 
                                showValue="<a href=\"javascript:openFullWindowForXtable('"+url+"')\">"+cloumnValue+"</a>";
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
                        }
        %>
                    <TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
                <%}%>
            </TR>
            <%
            rowcount++;     
            if(rowcount<perpage){%>
                <TR style="background:url('<%=hpsb.getEsparatorimg()%>')" style='height:1px' height=1px><td style="padding: 0px" colspan=<%=size+1%>></td></TR>
            <%}%>
            
            <%}%>        
    </TABLE>
    </TD>
    <TD width="1px"></TD>
</TR>
</TABLE>

