package com.atguigu.controller;

import com.atguigu.bean.Employee;
import com.atguigu.bean.Msg;
import com.atguigu.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    @Autowired
    private EmployeeService employeeService;

    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids){
        if (ids.contains("-")){
            List<Integer> idList = new ArrayList<Integer>();
            String[] str_ids = ids.split("-");
            for (String str_id :
                    str_ids) {
                idList.add(Integer.parseInt(str_id));
            }
            employeeService.deleteBatch(idList);
        }else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg updateEmp( @Valid Employee employee, BindingResult result){
        System.out.println("emp:"+employee.toString());
        employee.setEmpName(null);
        Map<String,Object> map = new HashMap<String, Object>();
        System.out.println(result.hasErrors());
        if(result.hasErrors()){
            //校验失败,不符合规范
            System.out.println("hasErrors");
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error :
                    errors) {
                map.put(error.getField(),"isError");
            }
            return Msg.fail().setExtend(map).setMsg("isError");
        }else {
            //校验成功,符合规范

            //判断更新的数据与数据库的数据是否有改变
            Employee empOld = employeeService.getEmp(employee.getEmpId());
            empOld.setEmpName(null);
            System.out.println("equal:"+empOld.toString().equals(employee.toString()));
            if (empOld.toString().equals(employee.toString())){
                //判断数据与数据库数据相同
                System.out.println("判断数据与数据库数据相同");
                return Msg.success();
            }else {
                //判断数据与数据库数据不同
                //判断是否有重复数据
                List<Msg> checkEmpMsgs= checkEmp(employee);
                boolean isHas = false;
                System.out.println("isHas"+employee.getEmail().equals(empOld.getEmail()));
                for (Msg msg:
                        checkEmpMsgs) {
                    if (msg.getCode() == 200 && !employee.getEmail().equals(empOld.getEmail())){
                        isHas = true;
                        map.put(msg.getExtend().get("error").toString(),"isHas");
                    }
                }
                if(isHas){
                    //有重复数据
                    return Msg.fail().setExtend(map).setMsg("isHas");
                }else {
                    //没有重复数据
                    employeeService.updateEmp(employee);
                    return Msg.success();
                }
            }

    }


//        employeeService.updateEmp(employee);
//        return null;
    }

    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        PageHelper.startPage(pn, 5);
        List<Employee> employees = employeeService.getAll();
        PageInfo pageInfo = new PageInfo(employees,5);
        List<Employee> employeesResult = pageInfo.getList();
        for (Employee e :
                employeesResult) {
            System.out.println(e);
        }
        return Msg.success().add("pageInfo",pageInfo);
    }

    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        Map<String,Object> map = new HashMap<String, Object>();
        if(result.hasErrors()){
            //校验失败,不符合规范
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error :
                    errors) {
                map.put(error.getField(),"isError");
            }
            return Msg.fail().setExtend(map).setMsg("isError");
        }else {
            //校验成功,符合规范
            List<Msg> checkEmpMsgs= checkEmp(employee);
            boolean isHas = false;
            for (Msg msg:
                 checkEmpMsgs) {
                if (msg.getCode() == 200){
                    isHas = true;
                    map.put(msg.getExtend().get("error").toString(),"isHas");
                }
            }
            if(isHas){
                //有重复数据
                return Msg.fail().setExtend(map).setMsg("isHas");
            }else {
                //没有重复数据
                employeeService.saveEmp(employee);
                return Msg.success();
            }
        }

    }
    @ResponseBody
    @RequestMapping("/checkEmp")
    public List<Msg> checkEmp(Employee emp){
        return employeeService.checkEmp(emp);
    }

//    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        PageHelper.startPage(pn, 5);
        List<Employee> employees = employeeService.getAll();
        PageInfo pageInfo = new PageInfo(employees,5);
        model.addAttribute("pageInfo",pageInfo);
        List<Employee> employeesResult = pageInfo.getList();
        for (Employee e :
                employeesResult) {
            System.out.println(e);
        }
        return "list";
    }
}
