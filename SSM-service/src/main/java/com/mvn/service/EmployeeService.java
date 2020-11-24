package com.mvn.service;

import com.mvn.dao.EmployeeDao;
import com.mvn.entity.Employee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class EmployeeService{

	@Autowired
	private EmployeeDao employeeDao;

	//查询所有
	@Transactional
	public List<Employee> getAlls() {
		return employeeDao.getAll();
	}

	//新增
	@Transactional
	public int adds(Employee employee) {
		employeeDao.add(employee);
		return employee.getId();
	}

	//删除
	@Transactional
	public void deletes(Integer id) {
		employeeDao.delete(id);
	}

	//根据ID查询
	public Employee getUpdateByIds(Integer id) {
		return employeeDao.getUpdateById(id);
	}

	//修改
	@Transactional
	public Employee updates(Employee employee) {
		return employeeDao.update(employee);
	}

	
}