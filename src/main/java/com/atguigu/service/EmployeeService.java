package com.atguigu.service;

import com.atguigu.bean.DepartmentExample;
import com.atguigu.bean.Employee;
import com.atguigu.bean.EmployeeExample;
import com.atguigu.bean.Msg;
import com.atguigu.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class EmployeeService {


    public void deleteBatch(List<Integer> ids) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }

    enum EmpType {
        empId, empName, email, gender, dId
    }

    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> getAll(){
        return employeeMapper.selectByExampleWithDept(null);
    }

    public Employee getEmp(Integer id) {
        return employeeMapper.selectByPrimaryKey(id);
    }

    public void saveEmp(Employee employee){
        employeeMapper.insertSelective(employee);
    }

    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    public List<Msg> checkEmp(Employee emp) {
        List<Msg> result =new ArrayList<Msg>();
        if(emp.getEmpName() != null){
            if (isNotHas(EmpType.empName,emp.getEmpName()))
                result.add(Msg.success());
            else
                result.add(Msg.fail().add("error",EmpType.empName.toString()));
        }
        if (emp.getEmail() != null){
            if (isNotHas(EmpType.email,emp.getEmail()))
                result.add(Msg.success());
            else
                result.add(Msg.fail().add("error",EmpType.email.toString()));
        }
        return result;
    }
    public boolean isNotHas(EmpType type,Object value){
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        switch (type) {
            case empId:
                criteria.andEmpIdEqualTo((Integer) value);
                break;
            case empName:
                criteria.andEmpNameEqualTo((String) value);
                break;
            case email:
                criteria.andEmailEqualTo((String) value);
                break;
            case gender:
                criteria.andGenderEqualTo((String) value);
                break;
            case dId:
                criteria.andDIdEqualTo((Integer) value);
                break;
        }
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }
}
