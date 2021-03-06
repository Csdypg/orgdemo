package xyz.yanghailong.orgdemo.org.mapper;

import xyz.yanghailong.orgdemo.org.pojo.VOrg;

import java.util.List;

public interface VOrgMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table v_org
     *
     * @mbggenerated
     */
    int insert(VOrg record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table v_org
     *
     * @mbggenerated
     */
    int insertSelective(VOrg record);

    public List<VOrg> findAll();

    public List<VOrg> findChilrenById(Integer orgId);
    public void addOrg(VOrg org);
    public void deleteOrg(Integer orgId);

    public void editOrg(VOrg org);
}