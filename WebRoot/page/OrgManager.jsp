<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@include file="CommonPage.jsp"%>
<!DOCTYPE HTML>
<html>
  <head>
    <title><s:text name="COMMON_TITLE"></s:text>-学院管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
    <table id="dg" class="easyui-datagrid"
            data-options="align:'center',pagination:true,fit:true,rownumbers:true,border:false,singleSelect:true,striped:true,
            url:'${pageContext.request.contextPath}/main/queryOrgDataGridByJson.do',method:'post',toolbar:'#dg-toolbar'">
        <thead>
            <tr>
                <th data-options="field:'name',width:250,align:'center'">学院名称</th>
            </tr>
        </thead>
    </table>
    <div id="dg-toolbar" style="padding:5px;height:auto">
        <div>
            <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="operation('add','${pageContext.request.contextPath}/main/doAddOrg.do')"><s:text name="BUTTON.ADD"></s:text></a>
            <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" onclick="operation('edit','${pageContext.request.contextPath}/main/doUpdateOrg.do')"><s:text name="BUTTON.EDIT"></s:text></a>
            <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'" onclick="operation('del','${pageContext.request.contextPath}/main/doDeleteOrg.do')"><s:text name="BUTTON.DEL"></s:text></a>
        </div>
        <div>
           	学院名称:
           		<input type="text" id="query_name" name="teacherVo.code" style="width:100px">
           	<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="query()"><s:text name="BUTTON.SEARCH"></s:text></a>
           	<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'" onclick="resetQuery()"><s:text name="BUTTON.RESET"></s:text></a>
        </div>
    </div>
    
    <div id="dlg" class="easyui-dialog" style="padding:10px" 
    	data-options="width:300, iconCls:'icon-base', buttons: '#dlg-buttons', modal:true, closed:true, closable:true">  
	    <form id="dlgFm" action="" method="post">
	    	<table style="border: 1">
          	 	<tr>  
	                <td align="right">学院名称<font class="ck">*</font>:</td>  
	                <td align="left">
	                	<input id="dlg_id" type="hidden" maxlength="256" style="width:150px;" name="orgVo.id" />
	                	<input id="dlg_name" type="text" maxlength="256" style="width:150px;" name="orgVo.name"/>
	                </td>  
	            </tr>  
           </table>
	    </form>
	</div>  
	<div id="dlg-buttons">  
   		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()">保存</a>  
   		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dlg').dialog('close')">关闭</a>  
 	</div>  
  </body>
  <script type="text/javascript">
  	var url;
	function operation(type,url) {
		this.url = url;
		clearForm("dlgFm");
		switch(type) {
		case "add" :
			$("#dlg_role").combobox("reload");
			openDialog("dlg","新增");
			break;
		case "edit" :
			var row = $("#dg").datagrid("getSelected");
			if(row) {
				$("#dlg_role").combobox("reload");
				loadForm(row);
				openDialog("dlg","修改");
			} else {
				alertMessageByCode("unSelect");
			}
			break;
		case "del" :
			var row = $("#dg").datagrid("getSelected");
			if(row) {
				$.messager.confirm("确认框","你确定要删除该行数据吗?", function(r) {
					if(r) {
						$.post(
							url,
							{"orgVo.id":row.id},
							function(code) {
								alertMessageByCode(code);
								reloadDataGrid("dg");
							},"json"
						); 
					}
				});
			} else {
				alertMessageByCode("unSelect");
			}
			break;
		}
	}
	
	/**
	 * 保存表单
	 */
	function save() {
		$("#dlgFm").form("submit", {
			url : url,
			onSubmit : function() {
				return $(this).form("validate");
			},
			success : function(code) {
				alertMessageByCode($.parseJSON(code));
				reloadDataGrid("dg");
				$("#dlg").dialog("close");
			}
		});
	}
	
	/**
	 * 为表单加载数据
	 * @param row
	 */
	function loadForm(row) {
		$("#dlg_name").val(row.name);
		$("#dlg_id").val(row.id);
	}
	
	/**
	 * 查询
	 */
	function query() {
		$("#dg").datagrid({
			pageNumber : 1,
			queryParams : {
				"form.name" : $("#query_name").val()
			}
		});
	}
  </script>
</html>
