package com.mvn.controller;

import com.mvn.entity.Department;
import com.mvn.entity.Employee;
import com.mvn.service.DepartmentService;
import com.mvn.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Controller
public class EmployeeHandler {

	@Autowired
	private EmployeeService employeeService;
	
	@Autowired
	private DepartmentService departmentService;


///////////////////////////////////////
	// 查询
	@ResponseBody
	@RequestMapping(value ="/emps", method = RequestMethod.GET)
	public List<Employee> list(Map<String, Object> map, Locale locale) {
		return employeeService.getAlls();
	}
/////////////////////////////////////////


	// 部门二级联动查询
		@ResponseBody
		@RequestMapping(value ="/dep", method = RequestMethod.GET)
		public List<Department> list1(Map<String, Object> map, Locale locale) {
			return departmentService.getAlls();
		}
	

	// 新增,上传
		@ResponseBody
		@RequestMapping(value = "/add", method = RequestMethod.POST)
		public String save(Employee employee,@RequestParam("file") MultipartFile abc) throws Exception {
			
			String filename = System.currentTimeMillis() + ".jpg";
			String headpath = "F:\\idea-work\\SSM\\SSM-web\\src\\main\\webapp\\fileUpload\\" + filename;

			// 输出流,保存文件的
			OutputStream out = new FileOutputStream(headpath); // 输入流，上传文件的
			InputStream inputStream = abc.getInputStream();
			byte b[] = new byte[1024 * 1024 * 1];
			int i = inputStream.read(b);
			while (i != -1) {
				out.write(b, 0, i);
				i = inputStream.read(b);
			}
			out.close();
			inputStream.close(); // 将文件名放入head
			employee.setHeadPath(filename);

			int id = employeeService.adds(employee);
			String jsonStr = "{\"id\":"+id+"}";  
			return jsonStr;
		}


	// 修改,上传
	@ResponseBody
	@RequestMapping(value = "/emp", method = RequestMethod.PUT)
	public Employee update(Employee employee, Map<String, Object> map, @RequestParam("head") MultipartFile file) {
		System.out.println(file.getOriginalFilename());
		// @ModelAttribute("employee")
		try {
			String filename = System.currentTimeMillis() + ".jpg";
			String path = "F:\\idea-work\\SSM\\SSM-web\\src\\main\\webapp\\fileUpload\\" + filename;
			// System.out.println(path);
			// String headName = prefix+"_"+file.getOr

			// 输出流,保存文件的
			OutputStream out = new FileOutputStream(path);
			// 输入流，上传文件的
			InputStream inputStream = file.getInputStream();
			byte b[] = new byte[1024 * 1024 * 1];
			int i = inputStream.read(b);
			while (i != -1) {
				out.write(b, 0, i);
				i = inputStream.read(b);
			}
			out.close();
			inputStream.close();
			// 将文件名放入head
			employee.setHeadPath(filename);
//			Department pp =departmentService.getDepById(employee.getDepartment().getId());
//			employee.setDepartment(pp);  
			employeeService.updates(employee);
			System.out.println(employee);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return employeeService.getUpdateByIds(employee.getId());
	}
	
	
	// 修改回显
	@ResponseBody
	@RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
	public Employee getEmployee(@PathVariable("id")Integer id){
		Employee emp = employeeService.getUpdateByIds(id);
		return emp;
	}
	
/////////////////////////////////////////////
	// 删除
	@RequestMapping(value = "/empde/{id}", method = RequestMethod.DELETE)
	@ResponseBody
	public String delete(@PathVariable("id") Integer id) {
		employeeService.deletes(id);
		return "删除成功";
	}
////////////////////////////////////////////

	// 文件下载第一种方法download
		@RequestMapping("/download")
		public ResponseEntity<byte[]> testResponseEntity(HttpSession session, @RequestParam("headPath") String headName)
				throws IOException {
			if (headName != null && !headName.equals("")) {
				String headPath = "F:\\idea-work\\SSM\\SSM-web\\src\\main\\webapp\\fileUpload\\" + headName;
				System.out.println(headPath);
				// System.out.println(headPath);
				byte[] body = null;
				ServletContext servletContext = session.getServletContext();
				// 获取当前项目的路径
				// InputStream in = servletContext.getResourceAsStream("/files/abc.txt");
				InputStream in = new FileInputStream(new File(headPath));

				body = new byte[in.available()];
				in.read(body);

				HttpHeaders headers = new HttpHeaders();
				headers.add("Content-Disposition", "attachment;filename=" + headName);

				HttpStatus statusCode = HttpStatus.OK;

				ResponseEntity<byte[]> response = new ResponseEntity<byte[]>(body, headers, statusCode);
				return response;
			} else {
				return null;
			}
		}
	// 国际化------------
	@Autowired
	private ResourceBundleMessageSource messageSource;

	@RequestMapping("/i18n")
	public String testI18n(Locale locale, Map<String, Object> map) {
		map.put("locale", locale.toString());
		// String val =messageSource.getMessage("test.name",new Object[]
		// {"lpclpc"},locale);
		// System.out.println(val);
		return "test1";
	}
}