package xyz.yanghailong.orgdemo.org.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import xyz.yanghailong.orgdemo.org.pojo.VOrg;
import xyz.yanghailong.orgdemo.org.service.OrgService;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/orgController")
public class OrgController {
	
	private static final Logger LOG = LoggerFactory.getLogger(OrgController.class);
	
	@Resource
	private OrgService orgService;

	@RequestMapping("/showLists")
	public String showLists(){
		return "org/lists";
	}

	@RequestMapping("/lists")
	@ResponseBody
	public List<VOrg> findAllOrg(){
		return orgService.findAll();
	}

	@RequestMapping("/addOrg")
	@ResponseBody
	public Map addOrg(VOrg org){
		Map message = new HashMap();
		message.put("success", 0);
		orgService.addOrg(org);
		message.put("success", 1);
		message.put("errMsg", "Success!");
		return message;
	}
	@RequestMapping("/editOrg")
	@ResponseBody
	public Map editOrg(VOrg org){
		Map message = new HashMap();
		message.put("success", 0);
		orgService.editOrg(org);
		message.put("success", 1);
		message.put("errMsg", "Success!");
		return message;
	}
	@RequestMapping("/delOrg")
	@ResponseBody
	public Map delOrg(Integer orgId){
		Map message = new HashMap();
		message.put("success", 0);
		orgService.deleteOrg(orgId);
		message.put("success", 1);
		message.put("errMsg", "Success!");
		return message;
	}

}
