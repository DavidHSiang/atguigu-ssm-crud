<%--
  Created by IntelliJ IDEA.
  User: david
  Date: 2020/4/2
  Time: 下午5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <%--
        一般情况下,static/xxx.js,表示相对于当前文件所在目录的路径,即./static/xxx.js
                /static/xxx.js 表示相对于服务器的路径,即localhost:8080/static/xxx.js
        但在SSM中,SpringMVC的前端控制器,拦截了所有请求
        因此static/xxx.js或/static/xxx.js都需要经过前端控制器进行解析,
        而xxx.js是静态资源,不可能通过Controller来配置
        若不进行相关的配置,static/xxx.js相对路径会报错 /static/xxx.js 绝对路径也无法访问
        因为SpringMVC的前端控制器把所有请求都拦截了,但不知道把它定向到哪
        可以在SpringMVC配置文件中加入配置:<mvc:default-servlet-handler/>
        将SpringMVC不能处理的请求交给Tomcat
        此时,客户端发送请求,先被SpringMVC的前端控制器拦截,若SpringMVC的前端控制器无法处理
        再把请求交给Tomcat,此时static/xxx.js并非相对路径
        因为请求不是直接访问的Tomcat,而是经过SpringMVC的转手后,转到Tomcat,
        在这过程中,SpringMVC会将 项目路径与请求路径 进行拼接,从而转到:项目路径+static/xxx.js
        即http://localhost:8080/atguigu_ssm_crud_war/static/xxx.css
        而对于/static/xxx.js,先经过SpringMVC,SpringMVC无法处理,再又SpringMVC交给Tomcat,SpringMVC判定他是绝对路径,
        因此将 服务器路径与请求路径 进行拼接,从而转到:服务器路径+static/xxx.js
        即http://localhost:8080/static/xxx.css

        总结:
            相对于: localhost:8080/atguigu_ssm_crud_war/index-old.jsp
            无SpringMVC拦截
                static/xxx.js
                    localhost:8080/atguigu_ssm_crud_war/static/xxx.js
                    访问成功
                /static/xxx.js
                    localhost:8080/static/xxx.js
                    找不到文件,报错
                /atguigu_ssm_crud_war/static/xxx.js
                    localhost:8080/atguigu_ssm_crud_war/static/xxx.js
                    访问成功
            有SpringMVC拦截
            无<mvc:default-servlet-handler/>
                static/xxx.js
                    被拦截,找不到对应的请求映射,报错
                /static/xxx.js
                    被拦截,找不到对应的请求映射,报错
                /atguigu_ssm_crud_war/static/xxx.js
                    被拦截,找不到对应的请求映射,报错
            有SpringMVC拦截
            有<mvc:default-servlet-handler/>
                static/xxx.js
                    localhost:8080/atguigu_ssm_crud_war/static/xxx.js
                    访问成功
                /static/xxx.js
                    localhost:8080/static/xxx.js
                    找不到文件,报错
                /atguigu_ssm_crud_war/static/xxx.js
                    localhost:8080/atguigu_ssm_crud_war/static/xxx.js
                    访问成功
    --%>
    <script src="static/jquery/js/jquery.min.js"></script>
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <link href="static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
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
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <td>#</td>
                    <td>empName</td>
                    <td>gender</td>
                    <td>email</td>
                    <td>deptName</td>
                    <td>操作</td>
                </tr>
                <c:forEach items="#{pageInfo.list}" var="employee" >
                    <tr>
                        <td>${employee.empId}</td>
                        <td>${employee.empName}</td>
                        <td>${employee.gender=="M"?"男":"女"}</td>
                        <td>${employee.email}</td>
                        <td>${employee.department.deptName}</td>
                        <td>
                            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>

            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            当前第${pageInfo.pageNum}页,总共${pageInfo.pages}页,总共${pageInfo.total}条记录
        </div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="emps">首页</a></li>

                    <c:if test="${!pageInfo.isFirstPage}">
                        <li>
                            <a href="emps?pn=${pageInfo.pageNum - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach items="${pageInfo.navigatepageNums}" var="pageNum">
                        <li class=${pageInfo.pageNum==pageNum?"active":""}><a href="emps?pn=${pageNum}">${pageNum}</a></li>
                    </c:forEach>
                    <c:if test="${!pageInfo.isLastPage}">
                        <li>
                            <a href="emps?pn=${pageInfo.pageNum + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="emps?pn=${pageInfo.pages}">末页</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>

</body>
</html>
