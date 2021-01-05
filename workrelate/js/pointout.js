function alertStyle(values){
   try{
       window.top.Dialog.alert(values);
   }catch(exception){
       Dialog.alert(values);
   }
}
function confirmStyle(values,func){
   try{
       window.top.Dialog.confirm(values,func);
   }catch(exception){
       Dialog.confirm(values,func);
   }
}
