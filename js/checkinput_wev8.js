function ItemCount_KeyPress(e)
{
 if(!(((e.keyCode>=48) && (e.keyCode<=57)) || e.keyCode==46 || e.keyCode==45))
  {
     e.keyCode=0;
  }
}
function checknumber(objectname)
{	
	valuechar = document.getElementsByName(objectname)[0].value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") isnumber = true ;}
	if(isnumber) document.getElementsByName(objectname)[0].value = "" ;
}
