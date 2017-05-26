package xyz.yanghailong.orgdemo.org.service.impl;

import org.springframework.stereotype.Service;
import xyz.yanghailong.orgdemo.org.mapper.VOrgMapper;
import xyz.yanghailong.orgdemo.org.pojo.VOrg;
import xyz.yanghailong.orgdemo.org.service.OrgService;

import javax.annotation.Resource;
import java.util.List;

@Service
public class OrgServiceImpl implements OrgService {
	
	@Resource
	private VOrgMapper vOrgMapper;


	@Override
	public VOrg getById(Integer id) {
		return null;
	}

	@Override
	public List<VOrg> findAll() {
		return vOrgMapper.findAll();
	}

	@Override
	public List<VOrg> findChilrenById(Integer orgId) {
		return vOrgMapper.findChilrenById(orgId);
	}

	@Override
	public void addOrg(VOrg org) {
		vOrgMapper.addOrg(org);
	}

	@Override
	public void deleteOrg(Integer orgId) {
		vOrgMapper.deleteOrg(orgId);
	}

	@Override
	public void editOrg(VOrg org) {
		vOrgMapper.editOrg(org);
	}
}
