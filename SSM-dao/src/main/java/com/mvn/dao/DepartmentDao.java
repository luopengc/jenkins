package com.mvn.dao;

import com.mvn.entity.Department;
import com.mvn.mapper.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class DepartmentDao{

	@Autowired
	private EmployeeMapper employeeMapper;

	/**
	 * 查询
	 */
	public List<Department> getAll() {

		List<Department> deparList = employeeMapper.queryAlld();
		return deparList;
	}
}