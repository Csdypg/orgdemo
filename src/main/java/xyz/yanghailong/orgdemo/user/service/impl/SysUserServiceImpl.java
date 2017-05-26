package xyz.yanghailong.orgdemo.user.service.impl;

import org.springframework.stereotype.Service;
import xyz.yanghailong.orgdemo.user.service.SysUserService;
import xyz.yanghailong.orgdemo.user.mapper.SysUserMapper;
import xyz.yanghailong.orgdemo.user.pojo.SysUser;

import javax.annotation.Resource;

@Service
public class SysUserServiceImpl implements SysUserService {
	
	@Resource
	private SysUserMapper sysUserMapper;


	public SysUser getById(Long id) {
		return sysUserMapper.selectByPrimaryKey(id);
	}
}
