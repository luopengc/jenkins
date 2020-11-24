package com.mvn.entity;

import java.util.HashSet;
import java.util.Set;

public class Department {

	private Integer id;
	private String dpname;
	
	private Set<Employee> emp=new HashSet<Employee>();
	
      Set<Employee> getEmp() {
		return emp;
	}

	
	public void setEmp(Set<Employee> emp) {
		this.emp = emp;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getDpname() {
		return dpname;
	}

	public void setDpname(String dpname) {
		this.dpname = dpname;
	}


	@Override
	public String toString() {
		return "Department [id=" + id + ", dpname=" + dpname + "]";
	}

	
}