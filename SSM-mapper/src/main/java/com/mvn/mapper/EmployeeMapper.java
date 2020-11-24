package com.mvn.mapper;

import com.mvn.entity.Department;
import com.mvn.entity.Employee;

import java.util.List;

public interface EmployeeMapper {

		// 查询员工信息
		public List<Employee> queryAll();

		// 查询部门信息
		public List<Department> queryAlld();
		
		// 添加
		public int addEmpy(Employee employee);

		// 删除
		public void delEmpy(int id);

		// 修改先根据id查询回显数据
		public Employee getEmpyId(int id);

		// 修改
		public void updateEmpy(Employee employee);
}
