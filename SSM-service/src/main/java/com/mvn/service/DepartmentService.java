package com.mvn.service;

import com.mvn.dao.DepartmentDao;
import com.mvn.entity.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService{
	@Autowired
	private DepartmentDao departmentDao;

	/**
	 * 查询所有部门
	 * 
	 * @return
	 */
	public List<Department> getAlls() {
		return departmentDao.getAll();
	}
}