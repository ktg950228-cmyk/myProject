package kr.co.ictb.ictb.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Alias("bcvo")
public class BoardCommVO {
	private int num;
	private int board_num;
	private String writer;
	private Date udate;
	private String comment_text;
}