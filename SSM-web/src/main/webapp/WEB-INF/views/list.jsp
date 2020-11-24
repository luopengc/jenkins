<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="js/jquery-3.4.1.js"></script>
<script type="text/javascript" src="js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/serializeObject.js"></script>
<title>Insert title here</title>
</head>
<script type="text/javascript">
	$(function()
	{
		Add();
		query();
		cal();
		getdept();
		//首页
		 $("#first").click(function(){
			 query(1);
		 });
		
		//尾页
		 $("#last").click(function(){
			 //获取最后一页
		 	var count = $("#pageCount").val();
			 query(count);
		  });
		
		
		//上页
		 $("#up").click(function(){
			 var pageNo = $("#pageNo").val();
			 if(pageNo != "1")
			 {
				 //parseInt  10-1=9  
				 //10-1
		 		query(parseInt(pageNo) -1);
			 }
		 });
		
		//下页
		 $("#down").click(function(){
			 var pageNo = $("#pageNo").val();
			 var pageCount = $("#pageCount").val();
			 if(pageNo != pageCount)
			 {
			 	query(parseInt(pageNo) + 1);
			 }
		 });
		
		//改变每页显示多少条记录
		$("#ps").change(function(){
			var pageSize = $("#ps").val();//获取下拉框选中的值
			$("#pageSize").val(pageSize);
			query(1);
		});
		
	 
	//显示新增DIV
		$("#addEmp").click(function(){
			$("#Div").show();
			//cal();
			$("#update").hide();
			$("#add").show();
		});
	
		//隐藏新增DIV
		$("#calEmp").click(function(){
			$("#Div").hide();
			cal();
		});
		
		
		$("#update").click(function(){
			$("#Div").show();
			//cal();
		});
	});

	//新增----------------------------------
	function Add()
	{
		$("#add").click(function()
		{
			var formData = new FormData();//这里需要实例化一个FormData来进行文件上传
			if($("#head")[0].files[0] != null){
				formData.append("file",$("#head")[0].files[0]);
			}
			var employee = $("#fromAdd").serializeObject();
			Object.keys(employee).forEach((key) => {
				formData.append(key, employee[key]);
			});
		 $.ajax({
		    	type:"post",
		    	url:"add",
		    	dataType:"json",
		    	data:formData,
				processData: false,//默认true,会转换成字符串,因为我们需要提交流,所以不能使用true
                contentType: false,//这个必须有，不然会报错
		    	success:function(data)
		    	{
		    		
	    			$("#table").append("<tr><td>"+data.id+"</td><td>"+data.lastName+"</td><td><img alt='头像' width=90 height=120 src='download?headPath="+data.headPath+"'></td><td>"+data.email+"</td><td>"+(data.gender ==1 ?'男':'女') +"</td><td>"+data.birth+"</td><td>"+data.department+"</td><td><input type='button' value='修改' class='update' delid="+data.id+"></td><td><input type='button' value='删除' class='delete' delid="+data.id+"></td></tr>"); 	    		
		    		
	    			Delete();
	    			Update();
	    			query();
	    			$("#Div").hide();
	    			cal();
		    	},
		    	error:function(){
		    		alert("发生错误");
		    	}
		    });	 
		});
	}
	
	//删除----------------------------
	function Delete()
	{
		$(".delete").click(function()
		{
			if(confirm("您确定要删除？")){
			var httpurl = $(this).attr("href");
			var tr = $(this).parent().parent();
			$.ajax({
		    	type:"delete",//如果ajax直接发送delete或put请求，不能传参数
		    	url:httpurl,
		    	//data:{"_method":"DELETE"}
		    	dataType:"text",
		    	success:function(result)
		    	{
		    		tr.remove();
		    	},
		    	error:function(){
		    		alert("发生错误");
		    	}
		});
			return false;
			}
		});
	}
		
		//修改-------------------------
		function Update(){
			//数据回显
			$(".update").click(function(){
				$("#Div").show();
				$("#add").hide();
				$("#update").show();
				var id = $(this).attr("href");
				$.ajax({
					url:id,
					type:"get",
					dataType:"json",
					success:function(emp){
					
					$("#id").val(emp.id);
					$("#lastName").val(emp.lastName);
					$(":radio[value="+emp.gender+"]").prop("checked",true);
					$("#email").val(emp.email);
					$("#birth").val(emp.birth);
					//$("select option[value='"+emp.department.dpname+"']").prop("selected",true);
					$("select option[value='"+emp.department.id+"']").prop("selected",true);
					var path = "download?headPath="+emp.headPath;
					//alert(path);
					$("#bbb").attr('src',path);
					},
					error:function(){
						alert("错误");
					}
				});
				return false;
			});
			
		//修改数据
		$("#update").click(function(){
			var formData = new FormData();//这里需要实例化一个FormData来进行文件上传
			if($("#head")[0].files[0] != null){
				formData.append("head",$("#head")[0].files[0]);
			}
			//序列化表单不会序列化file字段.
			var employee = $("#fromAdd").serializeObject();
			//把json转换成formdate
			Object.keys(employee).forEach((key) => {
				formData.append(key, employee[key]);
			});
			formData.append("_method", "put");
			$.ajax({
					url:"emp",
					type:"post",
					dataType:"json",
					data:formData,
					processData: false,//默认true,会转换成字符串,因为我们需要提交流,所以不能使用True
	                contentType: false,//这个必须有，不然会报错
					success:function(up){
						//循环所有的TR里面的第一个TD
			    		$("#table tr").find("td:eq(0)").each(function(){
							
			    			//如果第一个TD的值正好是我们需要修改的ID值，就表示我们刚才修改的就是这行
							if($(this).text() == up.id)
							{
								$(this).parent().find("td:eq(1)").text(up.lastName);
								$(this).parent().find("td:eq(2)").html("<img alt='图片不存在' src='download?headPath="+up.headPath+" ' height='100px' width='100px' >");
								$(this).parent().find("td:eq(3)").text(up.email);
								$(this).parent().find("td:eq(4)").html((up.gender == 1?'男':'女'));
								$(this).parent().find("td:eq(5)").text(up.birth);
								$(this).parent().find("td:eq(6)").text(up.department.dpname);
							}
							
							cal();
							$("#Div").hide();
						});
					},
					error:function(){
						alert("错误");
					}
				});
		});
	}
		
		//查询-------------------------
		function query()
		{
			//cal();
			$.ajax({
		    	type:"get",
		    	url:"emps",
		    	dataType:"json",
		    	success:function(result)
		    	{
		    		$("#table").empty();
		    		$("#table").append("<tr><td>id</td><td>名字</td><td>头像</td><td>邮箱</td><td>性别</td><td>时间</td><td>部门</td><td>编辑</td><td>删除</td></tr>");
		    		for(var i=0; i<result.length; i++)
		    		{
		    			
		    			$("#table").append("<tr><td>"+result[i].id+"</td><td>"+result[i].lastName+"</td><td><img alt='头像' width=90 height=120 src='download?headPath="+result[i].headPath+"'></td><td>"+result[i].email+"</td><td>"+(result[i].gender ==1 ?'男':'女') +"</td><td>"+result[i].birth+"</td><td>"+result[i].department.dpname+"</td><td><a class='update' href='emp/"+ result[i].id +"'>修改</a></td><td><a class='delete' href='empde/"+ result[i].id +"'>删除</a></td></tr>"); 	    		
		    		}
		    		Delete();
		    		Update();
		    		$(".update").click(function(){
						$("#addDiv").hide();
					});
		    	},
		    	error:function(){
		    		alert("发生错误");
		    	}
					});
		}


		//二级联动
		 function getdept(){
			 
			 $("#department.id").empty();
			 $.ajax({
				 url:"dep",
				 dataType:"json",
				 success:function(dept){
					 for (var i = 0; i < dept.length; i++) {
						$("select[name='department.id']").append("<option value="+dept[i].id+">"+dept[i].dpname+"</option>");
					}
				 },
			 error:function(){
		    		alert("发生错误");
		    	}
			 });
		 }
		
		
		//清空新增框里值
		function cal()
		{
			$("#lastName").val("");
			$("#head").attr('src',"");
			$("#email").val("");
			$("input[type='radio'][name='gender']").each(function(){
				$(this).prop("checked",false);
			});
			$("#birth").val("");
			$("#department.id").val(" ");
		}
		
		
		function add0(m){return m<10?'0'+m:m }
		function format(shijianchuo)
		{
		//shijianchuo是整数，否则要parseInt转换
		var time = new Date(shijianchuo);
		var y = time.getFullYear();
		var m = time.getMonth()+1;
		var d = time.getDate();
		var h = time.getHours();
		var mm = time.getMinutes();
		var s = time.getSeconds();
		return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
		}
	
</script>
<body>
	<input type="button" value="新增" id="addEmp">
	<select id="language">
		<option value="zh_CN">中文</option>
		<option value="en_US">English</option>
	</select>
	<table border="1" cellpadding="10" cellspacing="0" id="table">
		<tr>
			<td><fmt:message key="test.id"></fmt:message></td>
			<td><fmt:message key="test.lastName"></fmt:message></td>
			<td><fmt:message key="test.headPath"></fmt:message></td>
			<td><fmt:message key="test.email"></fmt:message></td>
			<td><fmt:message key="test.gender"></fmt:message></td>
			<td><fmt:message key="test.birth"></fmt:message></td>
			<td><fmt:message key="test.department"></fmt:message></td>333
			<td><fmt:message key="test.edit"></fmt:message></td>
			<td><fmt:message key="test.delete"></fmt:message></td>
		</tr>
	</table>
	<br>
	<br>
	<div id="Div" style="display: none;">
		<%--这个是为了把头像显示出来--%>
		<img width="90" height="120" alt="" src="" id="bbb">
		<form id="fromAdd">
			<input type="hidden" name="id" id="id"><br> 姓名:<input
				type="text" name="lastName" id="lastName"><br> <br>
			头像:<input type="file" id="head" name="head"><br> <br>
			邮箱:<input type="text" name="email" id="email"><br> <br>
			性别: <input type="radio" name="gender" value="1">男 <input
				type="radio" name="gender" value="0">女 <br> 
			生日:<input type="text" name="birth" id="birth" onClick="WdatePicker()"><br>
			部门:<select id="department.id" name="department.id">

			</select> <br> <br> <input type="button" value="新增" id="add">
			<input type="button" value="取消" id="calEmp"> <input
				type="button" value="修改" id="update">
		</form>
	</div>

</body>
</html>