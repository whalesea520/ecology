
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

String operation=Util.null2String(request.getParameter("operation"));

String returnString="";

if(operation.equals("delete")){
    int orgGroupId=Util.getIntValue(request.getParameter("orgGroupId"),0);
    try {
		    //是否关联机构、部门
			String isRelatedString="";
            RecordSet.executeSql("select 1 from HrmOrgGroupRelated where orgGroupId=" + orgGroupId);
			if(RecordSet.next()){
				isRelatedString+="<br>"+SystemEnv.getHtmlLabelName(24682,user.getLanguage());
			}

			//是否被文档子目录的默认共享(与文档创建人无关)调用
			String docSecCategoryString="";

			int secCategoryIdIndex=0;

			int mainCategoryId=0;
			String mainCategoryName="";
			int subCategoryId=0;
			String subCategoryName="";
			int secCategoryId=0;
			String secCategoryName="";

            StringBuffer sb=new StringBuffer();
			sb.append(" select a.id as secCategoryId,a.categoryName as secCategoryName,b.id as subCategoryId,b.categoryName as subCategoryName,c.id as mainCategoryId,c.categoryName as mainCategoryName ")
			  .append("   from DocSecCategory a,DocSubCategory b,DocMainCategory c  ")
			  .append("  where a.subCategoryId = b.id ")
			  .append("    and b.mainCategoryId = c.id ")
			  .append("    and exists(select 1 from DocSecCategoryShare where shareType=6 and orgGroupId="+orgGroupId+" and a.id=DocSecCategoryShare.secCategoryId) ")
			  .append("    order by c.categoryOrder asc,b.subOrder asc,a.secOrder asc ")
             ;
			RecordSet.executeSql(sb.toString());
			int secCategoryIdNum=RecordSet.getCounts();
			while(RecordSet.next()&&secCategoryIdIndex<10){
				secCategoryIdIndex++;
				mainCategoryName=Util.null2String(RecordSet.getString("mainCategoryName"));
				subCategoryName=Util.null2String(RecordSet.getString("subCategoryName"));
				secCategoryName=Util.null2String(RecordSet.getString("secCategoryName"));

				docSecCategoryString+="<br>"+"/"+mainCategoryName+"/"+subCategoryName+"/"+secCategoryName;
			}
			if(secCategoryIdNum>10){
				docSecCategoryString+="<br>……"+SystemEnv.getHtmlLabelName(358,user.getLanguage())+secCategoryIdNum+SystemEnv.getHtmlLabelName(24683,user.getLanguage());
			}

			//判断该群组是否被文档共享调用
			String docString="";
			int docIdIndex=0;
			int docId=0;
			String docSubject=null;

			RecordSet.executeSql("select id,docSubject   from DocDetail where exists(select 1 from DocShare where shareType=6 and orgGroupId="+orgGroupId+" and docId=DocDetail.id) order by id desc   ");
			int docIdNum=RecordSet.getCounts();
			while(RecordSet.next()&&docIdIndex<10){
				docIdIndex++;
				docId = Util.getIntValue(RecordSet.getString("id"),0);
				docSubject = Util.null2String(RecordSet.getString("docSubject"));
				docString+="<br>"+docSubject+"（"+docId+"）";
			}

			if(docIdNum>10){
				docString+="<br>……"+SystemEnv.getHtmlLabelName(358,user.getLanguage())+docIdNum+SystemEnv.getHtmlLabelName(24683,user.getLanguage());
			}


			if(!isRelatedString.equals("")){
				returnString+="<br><br>"+isRelatedString;
			}

			if(!docSecCategoryString.equals("")){
				returnString+="<br><br>"+SystemEnv.getHtmlLabelName(24684,user.getLanguage())+"："+docSecCategoryString+"<br>"+SystemEnv.getHtmlLabelName(24685,user.getLanguage());
			}

			if(!docString.equals("")){
				returnString+="<br><br>"+SystemEnv.getHtmlLabelName(24686,user.getLanguage())+"："+docString+"<br>"+SystemEnv.getHtmlLabelName(24685,user.getLanguage());
			}

			if(!returnString.equals("")&&returnString.length()>8){
				returnString=returnString.substring(8);
			}


        } catch (Exception e) {
        }
%>
    <script language="javascript">
        window.parent.checkForDelete("<%=returnString%>");
    </script>
<%		
}
%>
