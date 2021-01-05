<!-- begin include -->
<%@ include file="/manage/GetRequestHead.jsp" %>
<!-- end include -->

<script>
a=157
b=450
function aa()
{
if(a<800)
a=a+1
if(b>1)
b=b-1
Layer3.style.width=b
Layer3.style.left=a
if(a==800)
{a=300;b=450}
setTimeout("aa()",1)}
</script>



<div style="HEIGHT: 55px; LEFT: 300px; POSITION: absolute; TOP: 250px;  WIDTH: 450px;"><H1><I><B><FONT color=#1865ad face="Times New Roman" >该模块正在建设中！</FONT></B></I></H1></div>
<div id=Layer3 name=Layer3 style="HEIGHT: 55px; LEFT: 300px; POSITION: absolute; TOP: 250px;  WIDTH: 450px;background-color:#ffffff;"></div>

<script> aa() ; </script>

<!-- begin include -->
<%@ include file="/manage/GetRequestFoot.jsp" %>
<!-- end include -->