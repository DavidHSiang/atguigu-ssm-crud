package com.atguigu.test;

import com.atguigu.bean.Department;
import com.atguigu.bean.Employee;
import com.atguigu.dao.DepartmentMapper;
import com.atguigu.dao.EmployeeMapper;
import com.atguigu.service.EmployeeService;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    private DepartmentMapper departmentMapper;
    @Autowired
    private EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;
    @Autowired
    EmployeeService employeeService;
    @Test
    public void testCRUD(){
//        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
//        DepartmentMapper departmentMapper = (DepartmentMapper) context.getBean("departmentMapper");
        System.out.println(departmentMapper);

//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));

        employeeMapper.insertSelective(new Employee(null,2,"Marry","F","Marry@atguigu.com"));
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for (int i = 1 ; i < 1000 ; i ++){
//            String uid = (i%2==0?"Tom":"Marry")+UUID.randomUUID().toString().substring(0,5);
//            mapper.insertSelective(new Employee(null,1,uid,i%2==0?"M":"F",uid+"@atguigu.com"));
//        }

    }
    @Test
    public void testFind(){
        List<Employee> employees = employeeService.getAll();
        for (Employee e :
                employees) {
            System.out.println(e);
        }
    }
}
