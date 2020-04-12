<%--
  Created by IntelliJ IDEA.
  User: david
  Date: 2020/4/2
  Time: 下午5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>员工列表</title>
    <script src="static/jquery/js/jquery.min.js"></script>
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <link href="static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script>
        $(()=>{
            to_page(1)
            $("#emp_add_modal_btn")
                .click(()=>getDepts("#empAddModel select"))
            $("#emp_delete_btn")
                .click(()=>{
                    var empNames = ""
                    var empIds = ""
                    $.each($(".check_item:checked"),(index,item)=>{
                        // alert($(item).parents("tr").find("td:eq(2)").text())
                        empNames += $(item).parents("tr").find("td:eq(2)").text() + ","
                        empIds += $(item).parents("tr").find("td:eq(1)").text() + "-"
                    })
                    empNames = empNames.substring(0,empNames.length-1)
                    empIds = empIds.substring(0,empIds.length-1)
                    if (empNames != "")
                    if(confirm("确认删除"+empNames+"吗?")){
                        $.ajax({
                            url:"emp/" + empIds,
                            type:"DELETE",
                            success:(request)=>{
                                alert(request.msg)
                                to_page($("#pageNum").text())
                            }
                        })
                    }
                })
            $("#empAddForm_save_btn")
                .click(()=>{
                    // alert($("#empAddModel form").serialize())
                    var empNameFlag = showValidateMsg(
                        $("#empAddModel_isError_empName"),
                        validateEmpName($("#empName_add_input").val())
                    )
                    var empEmailFlag = showValidateMsg(
                        $("#empAddModel_isError_email"),
                        validateEmpEmail($("#empEmail_add_input").val())
                    )
                    if(empNameFlag && empEmailFlag){
                        $.ajax({
                            url:"checkEmp",
                            data:$("#empAddModel form").serialize(),
                            type:"POST",
                            success:(request)=>{
                                var isHas = false
                                $.each(request,(index,item)=>{
                                    if (item.code == 200){
                                        // alert(item.extend.error)
                                        isHas = true
                                        showValidateMsg($("#empAddModel_isHas_"+item.extend.error),false)
                                    }
                                })
                                if(!isHas){
                                    $.ajax({
                                        url:"emp",
                                        data:$("#empAddModel form").serialize(),
                                        type:"POST",
                                        success:(request)=>{
                                            if(request.code == 100){
                                                //后端校验成功
                                                $('#empAddModel').modal('hide')
                                                addEmpFormClear()
                                                to_page($("#pages").text()+1)
                                                alert(request.msg)
                                            }else{
                                                //后端校验失败
                                                for(var key in request.extend){
                                                    // alert(key)
                                                    if (request.msg == "isHas"){
                                                        showValidateMsg($("#empAddModel_isHas_"+key),false)
                                                    }else if(request.msg == "isError"){
                                                        showValidateMsg($("#empAddModel_isError_"+key),false)
                                                    }
                                                }

                                            }
                                        }
                                    })
                                }
                            }
                        })
                    }

                })
            $("#empUpdateForm_save_btn")
                .click(()=>{
                    //alert($("#empUpdateModel form").serialize())
                    //前端校验email是否符合规范
                    var empEmailFlag = showValidateMsg(
                        $("#empUpdateModel_isError_email"),
                        validateEmpEmail($("#empEmail_update_input").val())
                    )
                    //若email符合规范则进行后端校验,判断email是否已使用
                    if(empEmailFlag){
                        $.ajax({
                            url: "checkEmp",
                            data: $("#empUpdateModel form").serialize(),
                            type: "POST",
                            success: (request) => {
                                var isHas = false
                                $.each(request,(index,item)=>{
                                    if (item.code == 200 && $("#empEmail_update_input").val()!=$("#empEmail_update_input").attr("val")){
                                        isHas = true
                                        showValidateMsg($("#empUpdateModel_isHas_"+item.extend.error),false)
                                    }
                                })
                                if(!isHas ){
                                    $.ajax({
                                        url:"emp/"+$("#empUpdateForm_save_btn").attr("edit-id"),
                                        data:$("#empUpdateModel form").serialize(),
                                        type:"PUT",
                                        success:(request)=>{
                                            if(request.code == 100){
                                                //后端校验成功
                                                $('#empUpdateModel').modal('hide')
                                                updateEmpFormClear()
                                                to_page($("#pageNum").text())
                                                alert(request.msg)
                                            }else{
                                                //后端校验失败
                                                for(var key in request.extend){
                                                    // alert(key)
                                                    if (request.msg == "isHas"){
                                                        showValidateMsg($("#empUpdateModel_isHas_"+key),false)
                                                    }else if(request.msg == "isError"){
                                                        showValidateMsg($("#empUpdateModel_isError_"+key),false)
                                                    }
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
            $("#empAddForm_close_btn")
                .click(()=>addEmpFormClear())
            $("#empAddModel_close_btn")
                .click(()=>addEmpFormClear())
            $("#empUpdateModel_close_btn")
                .click(()=>updateEmpFormClear())
            $("#empUpdateForm_close_btn")
                .click(()=>updateEmpFormClear())
            $("#empName_add_input")
                .keyup(function (){
                    // alert("empName_add_input")
                    $("#empAddModel_isHas_empName").hide()
                    showValidateMsg(
                        $(this).next(),
                        validateEmpName($(this).val())
                    )
                })
            $("#empEmail_add_input")
                .keyup(function () {
                    // alert("empEmail_add_input")
                    $("#empAddModel_isHas_email").hide()
                    showValidateMsg(
                        $(this).next(),
                        validateEmpEmail($(this).val())
                    )
                })
            $("#empEmail_update_input")
                .keyup(function () {
                    // alert("empEmail_add_input")
                    $("#empUpdateModel_isHas_email").hide()
                    showValidateMsg(
                        $(this).next(),
                        validateEmpEmail($(this).val())
                    )
                })
            $("#check_all")
                .click(function () {
                    $(".check_item").prop("checked",$(this).prop("checked"))
                })

        })

        $(document).on("click",".edit_btn",function () {
            // alert("edit")
            getDepts("#empUpdateModel select")
            getEmp($(this).attr("edit-id"))
            $('#empUpdateModel').modal({
                backdrop:"static"
            })

        })
        $(document).on("click",".delete_btn",function () {
            // alert("delete")
            var empName = $(this).parents("tr").find("td:eq(2)").text()
            if(confirm("确认删除"+empName+"吗?")){
                $.ajax({
                    url:"emp/"+$(this).attr("edit-id"),
                    type:"DELETE",
                    success:(request)=>{
                        alert(request.msg)
                        to_page($("#pageNum").text())
                    }
                })
            }
        })

        $(document).on("click",".check_item",function () {
            // alert($(".check_item:checked").length )
            var flag = $(".check_item:checked").length == $(".check_item").length
            $("#check_all").prop("checked",flag)
        })
        function showValidateMsg($obj,flag) {
            // alert("showValidateMsg")
            $obj.parent().removeClass("has-success has-error")
            if (flag){
                //校验通过
                $obj
                    .hide()
                    .parent()
                    .addClass("has-success")

            }else {
                //校验不通过
                $obj
                    .show()
                    .parent()
                    .addClass("has-error")

            }
            return flag
        }

        function validateEmpName(empName) {
            // alert("validateEmpName")
            var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/
            return regName.test(empName)
        }

        function validateEmpEmail(empEmail) {
            // alert("validateEmpEmail")
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
            return regEmail.test(empEmail)
        }

        function addEmpFormClear(){
            // $("#empName_add_input").val("")
            // $("#empEmail_add_input").val("")
            // $("#empGender_add_radio_M").prop("checked",'checked')
            $("#empAddModel form")[0].reset()
            $("#empAddModel_isError_empName")
                .hide()
            .next()
                .hide()
            .parent()
                .removeClass("has-success has-error")
            $("#empAddModel_isError_email")
                .hide()
            .next()
                .hide()
            .parent()
                .removeClass("has-success has-error")
            // $("#empAddModel_isHas_empName").hide()
            // $("#empAddModel_isHas_email").hide()
        }
        function updateEmpFormClear(){
            $("#empUpdateModel_isError_email")
                .hide()
                .next()
                .hide()
                .parent()
                .removeClass("has-success has-error")
        }
        //根据ID查询员工信息
        function getEmp(id) {
            $.ajax({
                url:"emp/"+id,
                type:"GET",
                success:(request)=> {
                    // alert(request.extend.emp)
                    var emp = request.extend.emp
                    $("#empName_update_p").text(emp.empName)
                    $("#empEmail_update_input").val(emp.email)
                    $("#empUpdateModel input[name=gender]").val([emp.gender])
                    $("#empUpdateModel select").val([emp.dId])
                    $("#empUpdateForm_save_btn").attr("edit-id",emp.empId)
                    $("#empEmail_update_input").attr("val",emp.email)
                }
            })
        }

        //得到所有部门数据,并刷新部门列表
        function getDepts(ele) {
            $.ajax({
                url:"depts",
                type:"GET",
                success:(request)=>{
                    //解析显示部门列表
                    $(ele).empty()
                    $.each(request.extend.departments,(index,item)=>{
                        $(ele).append(
                                $("<option></option>")
                                    .append(item.deptName)
                                    .val(item.deptId)
                            )
                    })
                }
            })
        }

        function to_page(pn) {
            $.ajax({
                url:"emps",
                data:"pn="+pn,
                type:"GET",
                success:(request)=>{
                    //解析显示员工列表
                    build_emps_table(request)
                    //解析显示分页条
                    build_page_nav(request)
                    //解析显示分页信息
                    build_page_info(request)
                }
            })
        }
        //解析显示员工列表
        function build_emps_table(request) {
            $("#check_all").prop("checked",false)
            $("#emps_tbl tbody").empty()
            var emps = request.extend.pageInfo.list
            $.each(emps,(index,item)=> {
                var checkItem = $("<td><input type='checkbox' class='check_item'/></td>")
                var empId = $("<td></td>").append(item.empId)
                var empName = $("<td></td>").append(item.empName)
                var gender = $("<td></td>").append(item.gender=="M"?"男":"女")
                var email = $("<td></td>").append(item.email)
                var deptName = $("<td></td>").append(item.department.deptName)
                var btnTr = $("<td></td>").append(
                    $("<button></button>").append(
                        $("<span></span>").addClass("glyphicon glyphicon-pencil"),
                        "编辑"
                    ).addClass("btn btn-primary btn-sm edit_btn").attr("edit-id",item.empId),
                    " ",
                    $("<button></button>").append(
                        $("<span></span>").addClass("glyphicon glyphicon-trash"),
                        "删除"
                    ).addClass("btn btn-danger btn-sm delete_btn").attr("edit-id",item.empId)
                )
                $("<tr></tr>")
                    .append(checkItem)
                    .append(empId)
                    .append(empName)
                    .append(gender)
                    .append(email)
                    .append(deptName)
                    .append(btnTr)
                    .appendTo("#emps_tbl tbody")
            })
        }

        //解析显示分页信息
        function build_page_info(request) {
            //当前页数
            $("#pageNum").text(request.extend.pageInfo.pageNum)
            //总页数
            $("#pages").text(request.extend.pageInfo.pages)
            //总记录数
            $("#total").text(request.extend.pageInfo.total)
        }

        //解析显示分页条
        function build_page_nav(request) {
            var pageNums = request.extend.pageInfo.navigatepageNums
            //分页条 1-5
            $.each(pageNums,(index,item)=>{
                $("#PageLi_"+ index)
                    .removeClass("active")
                    .addClass(request.extend.pageInfo.pageNum == item?"active":"")
                .children("a")
                    .text(item)
                    .unbind("click")
                    .click(()=>to_page(item))
            })
            //分页条 首页 前一页
            if(request.extend.pageInfo.hasPreviousPage){
                $("#firstPageLi")
                    .removeClass("disabled")
                    .unbind("click")
                    .click(()=>to_page(1))
                $("#prePageLi")
                    .removeClass("disabled")
                    .unbind("click")
                    .click(()=>to_page(request.extend.pageInfo.pageNum - 1))
            }else{
                $("#firstPageLi")
                    .addClass("disabled")
                    .unbind("click")
                $("#prePageLi")
                    .addClass("disabled")
                    .unbind("click")
            }
            //分页条 末页 后一页
            if(request.extend.pageInfo.hasNextPage){
                $("#lastPageLi")
                    .removeClass("disabled")
                    .unbind("click")
                    .click(()=>to_page(request.extend.pageInfo.pages))
                $("#nextPageLi")
                    .removeClass("disabled")
                    .unbind("click")
                    .click(()=>to_page(request.extend.pageInfo.pageNum + 1))
            }else{
                $("#lastPageLi")
                    .addClass("disabled")
                    .unbind("click")
                $("#nextPageLi")
                    .addClass("disabled")
                    .unbind("click")
            }
        }
    </script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h3>SSM-CRUD</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button id="emp_add_modal_btn" class="btn btn-primary" data-toggle="modal" data-target="#empAddModel" data-backdrop="static">新增</button>
            <button id="emp_delete_btn" class="btn btn-danger">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id = "emps_tbl">
                <thead>
                    <tr>
                        <td><input type="checkbox" id="check_all"/></td>
                        <td>#</td>
                        <td>empName</td>
                        <td>gender</td>
                        <td>email</td>
                        <td>deptName</td>
                        <td>操作</td>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            当前第<code id="pageNum">1</code>页,总共<code id="pages">1</code>页,总共<code id="total">1</code>条记录
        </div>
        <%-- 分页条 --%>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <%-- 分页条 首页 上一页 --%>
                    <li id="firstPageLi">
                        <a>首页</a>
                    </li>
                    <li id="prePageLi">
                        <a aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <%-- 分页条 1-5 --%>
                    <li id="PageLi_0">
                        <a>1</a>
                    </li>
                    <li id="PageLi_1">
                        <a>2</a>
                    </li>
                    <li id="PageLi_2">
                        <a>3</a>
                    </li>
                    <li id="PageLi_3">
                        <a>4</a>
                    </li>
                    <li id="PageLi_4">
                        <a>5</a>
                    </li>
                    <%-- 分页条 末页 下一页 --%>
                    <li id="nextPageLi">
                        <a aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                    <li id="lastPageLi">
                        <a>末页</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>


<!-- empAddModel -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button id="empAddModel_close_btn" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="empAddModelLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="empName" id="empName_add_input" placeholder="empName">
                            <span id="empAddModel_isError_empName" class="help-block" style="display:none">用户名需为2-5位中文或者3-16位英文和数字的组合</span>
                            <span id="empAddModel_isHas_empName" class="help-block" style="display:none">用户名已被占用</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="empEmail_add_input" placeholder="email@163.com">
                            <span id="empAddModel_isError_email" class="help-block" style="display:none">邮箱格式不正确</span>
                            <span id="empAddModel_isHas_email" class="help-block" style="display:none">邮箱已被注册</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="empGender_add_radio_M" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="empGender_add_radio_F" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="empAddForm_close_btn" type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="empAddForm_save_btn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- empUpdateModel -->
<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button id="empUpdateModel_close_btn" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="empUpdateModelLabel">员工更新</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p id="empName_update_p" class="form-control-static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="empEmail_update_input" placeholder="email@163.com">
                            <span id="empUpdateModel_isError_email" class="help-block" style="display:none">邮箱格式不正确</span>
                            <span id="empUpdateModel_isHas_email" class="help-block" style="display:none">邮箱已被注册</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="empGender_update_radio_M" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="empGender_update_radio_F" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="empUpdateForm_close_btn" type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="empUpdateForm_save_btn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
