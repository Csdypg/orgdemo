package xyz.yanghailong.orgdemo.org.service;


import org.apache.ibatis.annotations.Param;
import xyz.yanghailong.orgdemo.org.pojo.VOrg;

import java.util.List;

public interface OrgService {
	VOrg getById(Integer id);

	/**
	 * 获取所有组织机构
	 * @return
	 */
	List<VOrg> findAll();

	/**
	 * 获取机构的下一级机构
	 * @param orgId
	 * @return
	 */
	public List<VOrg> findChilrenById(Integer orgId);

	/**
	 * 增加机构
	 * @param org
	 */
	public void addOrg(@Param("org") VOrg org);

	/**
	 * 删除机构
	 * @param orgId
	 */
	public void deleteOrg(Integer orgId);

	public void editOrg(VOrg org);
}
