<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script>
$.fn.serializeObject = function()
	  {
	     var o = {};
	     var a = this.serializeArray();
	     $.each(a, function() {
	         if (o[this.name]) {
	             if (!o[this.name].push) {
	                 o[this.name] = [o[this.name]];
	             }
	             o[this.name].push(this.value || '');
	         } else {
	             o[this.name] = this.value || '';
	         }
	     });
	     return o;
	  };
</script>
</head>
<body>

</body>
</html>