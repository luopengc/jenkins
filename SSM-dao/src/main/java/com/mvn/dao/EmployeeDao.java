package com.mvn.dao;

import com.mvn.entity.Employee;
import com.mvn.mapper.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class EmployeeDao {
	
	@Autowired
	private EmployeeMapper employeeMapper;

	//查询所有
	public List<Employee> getAll() {
		List<Employee> deparList = employeeMapper.queryAll();
		return deparList;
	}

	//新增
	public int add(Employee employee) {
		employeeMapper.addEmpy(employee);		
		return employee.getId();
	}

	//删除
	public void delete(int id) {
		employeeMapper.delEmpy(id);
		
	}

	//根据id修改
	public Employee getUpdateById(int id) {
		Employee empy = new Employee();
		empy = employeeMapper.getEmpyId(id);
		return empy;
	}

	//修改
	public Employee update(Employee employee) {
		employeeMapper.updateEmpy(employee);
		return employee;
	}

}