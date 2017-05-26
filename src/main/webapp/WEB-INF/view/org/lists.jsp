<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/5/2
  Time: 0:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/view/common/tagPage.jsp" %>
<%@ include file="/WEB-INF/view/common/static.jsp" %>
<body>
<div id="org_grid">

</div>

<div id="toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newOrg()">New Org</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editOrg()">Edit Org</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyOrg()">Remove Org</a>
</div>

<div id="dlg" class="easyui-dialog" style="width:400px"
     closed="true" buttons="#dlg-buttons">
    <form id="fm" method="post" novalidate style="margin:0;padding:20px 50px">
        <div style="margin-bottom:20px;font-size:14px;border-bottom:1px solid #ccc">Org Information</div>
            <input name="orgId" type="hidden">
        <div style="margin-bottom:10px">
            <input name="name" class="easyui-textbox" required="true" label="Name:" style="width:100%">
        </div>
        <div style="margin-bottom:10px">
            <input name="desc" class="easyui-textbox" required="true" label="Desc:" style="width:100%">
        </div>
    </form>
</div>
<div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveOrg()" style="width:90px">Save</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')" style="width:90px">Cancel</a>
</div>
<script type="text/javascript">
    var url;
    function newOrg(){
        var row = $('#org_grid').datagrid('getSelected');
        if(!row){
            $.messager.alert('Warning','Please choose an org node as the super node!');
            return;
        }
        $('#dlg').dialog('open').dialog('center').dialog('setTitle','New Org');
        $('#fm').form('clear').form('load',{orgId:row.orgId});
        url = '${webRoot}/orgController/addOrg';
    }
    function editOrg(){
        var row = $('#org_grid').datagrid('getSelected');
        if(!row){
            $.messager.alert('Warning','Please choose an org node to edit!');
            return;
        }
        if (row){
            $('#dlg').dialog('open').dialog('center').dialog('setTitle','Edit Org');
            $('#fm').form('clear').form('load',row);
            url = '${webRoot}/orgController/editOrg';
        }
    }
    function saveOrg(){
        $('#fm').form('submit',{
            url: url,
            onSubmit: function(){
                return $(this).form('validate');
            },
            success: function(result){
                var result = eval('('+result+')');
                if (result.errorMsg){
                    $.messager.show({
                        title: 'Error',
                        msg: result.errMsg
                    });
                } else {
                    $('#dlg').dialog('close');        // close the dialog
                    $('#org_grid').datagrid('reload');    // reload the user data
                }
            }
        });
    }

    function destroyOrg(){
        var row = $('#org_grid').datagrid('getSelected');
        if(!row){
            $.messager.alert('Warning','Please choose an org node!');
            return;
        }else{
            $.messager.confirm('Confirm','Are you sure you want to destroy this org?\n All the children and subnode will be deleted too!',function(r){
                if (r){
                    $.post('${webRoot}/orgController/delOrg',{orgId:row.orgId},function(result){
                        if (result.success){
                            $('#org_grid').datagrid('reload');    // reload the user data
                        } else {
                            $.messager.show({    // show error message
                                title: 'Error',
                                msg: result.errMsg
                            });
                        }
                    },'json');
                }
            });
        }
    }
    $(function(){
        $('#org_grid').datagrid({
            url:'${webRoot}/orgController/lists',
            toolbar:'#toolbar',
            singleSelect:true,
            idField:'orgId',
            rownumbers:'true',
            columns:[[
                {field:'orgId',title:'orgId',width:100, hidden:true},
                {field:'name',title:'Name',width:200,formatter: function(value,row,index){
                    var showName = value;
                    for(var i = 1; i<row.layer; i++){
                        showName = '|---'+showName;
                    }
                    return showName;
                }},
                {field:'layer',title:'level',width:100},
                {field:'desc',title:'desc',width:100,align:'right'}
            ]]
        });
    })
</script>
</body>