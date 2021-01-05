<%if(helpdocid!=0){%>
<script language="javascript">
function showHelp(){
    var operationPage = "/docs/docs/DocDsp.jsp?id=<%=helpdocid%>";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
</script>
<%}%>