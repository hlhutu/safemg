package cn.scihi.emer.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

import java.util.Date;

@Data
public class EmerTeam extends BaseBean {
    String id;
    String sys_id;
    String team_no;//队伍编号
    String team_name;//队伍名称
    String category;//队伍类型
    String address;//队伍地址
    String org_id;//所属机构
    String link_user;//联系人
    String link_phone;//联系电话
    String lon;//经度
    String lat;//维度
    String description;//简介
    Date created;//创建时间
}
